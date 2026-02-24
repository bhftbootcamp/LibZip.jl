# runtests

using LibZip
using Test

@testset "LibZip" verbose = true begin
    @testset "Test 1: ZipArchive open and write files" begin
        zip = ZipArchive(; flags = LIBZIP_CREATE)
        write(zip, "dir/new_file.json", read("data/spot_tickers.json"))
        zip_compress_file!(zip, "dir/new_file.json", LIBZIP_CM_DEFLATE; compression_level = 1)
        info = zip_get_file_info(zip, 0)
        @test unsafe_string(info.name) == "dir/new_file.json"
        @test info.comp_method == 0x0008

        csv = b"""
        "id","name","grade"
        1,"Fred",78.2
        2,"Benny",82.0
        """
        write(zip, "simple_csv.csv", csv)
        info = zip_get_file_info(zip, 1)
        @test unsafe_string(info.name) == "simple_csv.csv"

        zip_add_dir!(zip, "empty_dir/")
        @test length(zip) == 3
    end

    @testset "Test 2: Iterator ZipArchive" begin
        zip = zip_open("data/simple_archive.zip")
        @test zip.comment |> isempty
        @test length(collect(zip)) == 4
        close(zip)

        zip = ZipArchive(read("data/encrypted_archive.zip"))
        @test zip.comment == "password: 1234"
        zip_default_password!(zip, "1234")
        @test length(collect(zip)) == 4
    end

    @testset "Test 3: ZipError" begin
        @test_throws ZipError zip_open("data/simple_archive.zip"; flags = LIBZIP_EXCL)
        @test_throws ZipError ZipArchive(read("data/simple_archive.zip"); flags = LIBZIP_EXCL)
        zip = ZipArchive(; flags = LIBZIP_CREATE)
        write(zip, "test.json", read("data/spot_tickers.json"))
        @test_throws ZipError write(zip, "test.json", read("data/spot_tickers.json"); flags = LIBZIP_FL_ENC_GUESS)
        @test_throws ZipError zip_compress_file!(zip, 0, LIBZIP_CM_DEFLATE64)
        @test_throws ZipError zip_encrypt_file!(zip, 0, "1234"; method = UInt16(2))
        @test_throws ZipError read(zip, 1)
        @test_throws ZipError zip_get_file_info(zip, 1)
        close(zip)
        @test_throws AssertionError length(zip)
    end

    @testset "Test 4: ZipArchive to vector" begin
        zip1 = ZipArchive(; flags = LIBZIP_CREATE)
        write(zip1, "text.txt", b"text")
        buffer = read!(zip1)
        @test isopen(zip1)
        @test length(zip1) == 1
        @test_nowarn write(zip1, "text2.txt", b"text2")
        @test length(zip1) == 2
    end

    @testset "Test 5: Integer type compatibility" begin
        zip = ZipArchive(; flags = LIBZIP_CREATE)
        write(zip, "a.txt", b"aaa")
        write(zip, "b.txt", b"bbb")

        @test_nowarn zip_compress_file!(zip, Int64(0), Int32(LIBZIP_CM_DEFLATE); compression_level = Int32(1))
        @test_nowarn zip_compress_file!(zip, Int32(1), Int64(LIBZIP_CM_DEFLATE); compression_level = Int64(3))

        @test_nowarn zip_get_file_info(zip, Int64(0))
        @test_nowarn zip_get_file_info(zip, Int32(0))

        buffer = read!(zip)
        zip2 = ZipArchive(buffer)

        data_a = read(zip2, Int64(0))
        @test data_a == b"aaa"
        data_b = read(zip2, Int32(1))
        @test data_b == b"bbb"

        data_by_name = read(zip2, "a.txt")
        @test data_by_name == b"aaa"
    end

    @testset "Test 6: LibZipStatT field types" begin
        zip = ZipArchive(; flags = LIBZIP_CREATE)
        payload = rand(UInt8, 256)
        write(zip, "random.bin", payload)

        info = zip_get_file_info(zip, 0)
        @test unsafe_string(info.name) == "random.bin"
        @test info.size == 256
        @test info.index == 0
        @test info.valid != 0
        @test info.comp_method isa UInt16
        @test info.encryption_method isa UInt16
        @test info.crc isa UInt32
        @test info.flags isa UInt32
    end

    @testset "Test 7: ZipFile struct from iterator" begin
        zip = ZipArchive(; flags = LIBZIP_CREATE)
        write(zip, "hello.txt", b"Hello, World!")
        zip_compress_file!(zip, "hello.txt", LIBZIP_CM_DEFLATE)

        buffer = read!(zip)
        zip2 = ZipArchive(buffer)

        files = collect(zip2)
        @test length(files) == 1

        f = files[1]
        @test f isa ZipFile
        @test f.name == "hello.txt"
        @test f.body == b"Hello, World!"
        @test f.size == 13
        @test f.index == 0
        @test f.comp_method == Int(LIBZIP_CM_DEFLATE)
        @test f.encryption_method == Int(LIBZIP_EM_NONE)
    end

    @testset "Test 8: Multiple compression methods" begin
        zip = ZipArchive(; flags = LIBZIP_CREATE)
        data = Vector{UInt8}(codeunits("compress me " ^ 100))

        write(zip, "store.bin", data)
        zip_compress_file!(zip, "store.bin", LIBZIP_CM_STORE)

        write(zip, "deflate.bin", data)
        zip_compress_file!(zip, "deflate.bin", LIBZIP_CM_DEFLATE; compression_level = 9)

        write(zip, "zstd.bin", data)
        zip_compress_file!(zip, "zstd.bin", LIBZIP_CM_ZSTD)

        info_store = zip_get_file_info(zip, "store.bin")
        info_deflate = zip_get_file_info(zip, "deflate.bin")
        info_zstd = zip_get_file_info(zip, "zstd.bin")

        @test info_store.comp_method == UInt16(LIBZIP_CM_STORE)
        @test info_deflate.comp_method == UInt16(LIBZIP_CM_DEFLATE)
        @test info_zstd.comp_method == UInt16(LIBZIP_CM_ZSTD)

        buffer = read!(zip)
        zip2 = ZipArchive(buffer)
        @test read(zip2, "store.bin") == data
        @test read(zip2, "deflate.bin") == data
        @test read(zip2, "zstd.bin") == data
    end

    @testset "Test 9: Round-trip write and read" begin
        zip1 = ZipArchive(; flags = LIBZIP_CREATE)

        files = Dict(
            "empty.txt"   => UInt8[],
            "small.txt"   => b"x",
            "medium.txt"  => rand(UInt8, 1024),
            "large.txt"   => rand(UInt8, 100_000),
        )

        for (name, data) in files
            write(zip1, name, data)
        end
        @test length(zip1) == 4

        buffer = read!(zip1)
        @test !isempty(buffer)

        zip2 = ZipArchive(buffer)
        @test length(zip2) == 4

        for (name, expected) in files
            @test read(zip2, name) == expected
        end
    end

    @testset "Test 10: ZipError message" begin
        err = ZipError(LIBZIP_ER_NOENT)
        @test err.code == LIBZIP_ER_NOENT
        @test !isempty(err.message)
        @test occursin("No such file", err.message)

        err2 = ZipError(LIBZIP_ER_MEMORY)
        @test err2.code == LIBZIP_ER_MEMORY
        @test !isempty(err2.message)
    end

    @testset "Test 11: Compress by index after locate by name" begin
        zip = ZipArchive(; flags = LIBZIP_CREATE)
        write(zip, "greetings.txt", b"Hello, from LibZip!")
        zip_compress_file!(zip, "greetings.txt", LIBZIP_CM_DEFLATE; compression_level = 1)

        info = zip_get_file_info(zip, "greetings.txt")
        @test info.comp_method == UInt16(LIBZIP_CM_DEFLATE)

        buffer = read!(zip)
        zip2 = ZipArchive(buffer)
        @test read(zip2, "greetings.txt") == b"Hello, from LibZip!"
    end

    @testset "Test 12: Discard changes" begin
        zip = ZipArchive(; flags = LIBZIP_CREATE)
        write(zip, "temp.txt", b"data")
        @test length(zip) == 1
        zip_discard(zip)
        @test !isopen(zip)
    end

    @testset "Test 13: Encrypt and decrypt" begin
        zip = ZipArchive(; flags = LIBZIP_CREATE)
        secret = b"top secret data"
        write(zip, "secret.txt", secret)
        zip_encrypt_file!(zip, "secret.txt", "mypass"; method = LIBZIP_EM_AES_256)

        buffer = read!(zip)
        zip2 = ZipArchive(buffer)

        info = zip_get_file_info(zip2, "secret.txt")
        @test info.encryption_method == UInt16(LIBZIP_EM_AES_256)

        zip_default_password!(zip2, "mypass")
        @test read(zip2, "secret.txt") == secret
    end

    @testset "Test 14: Add directories" begin
        zip = ZipArchive(; flags = LIBZIP_CREATE)
        zip_add_dir!(zip, "dir1/")
        zip_add_dir!(zip, "dir1/subdir/")
        write(zip, "dir1/subdir/file.txt", b"nested")
        @test length(zip) == 3

        info = zip_get_file_info(zip, 0)
        @test unsafe_string(info.name) == "dir1/"
        info = zip_get_file_info(zip, 1)
        @test unsafe_string(info.name) == "dir1/subdir/"

        buffer = read!(zip)
        zip2 = ZipArchive(buffer)
        @test read(zip2, "dir1/subdir/file.txt") == b"nested"
    end

    @testset "Test 15: Flags as different integer types" begin
        @test_nowarn ZipArchive(; flags = Int32(LIBZIP_CREATE))
        @test_nowarn ZipArchive(; flags = Int64(LIBZIP_CREATE))

        zip = ZipArchive(; flags = LIBZIP_CREATE)
        write(zip, "f.txt", b"data")
        buffer = read!(zip)
        @test_nowarn ZipArchive(buffer; flags = Int32(LIBZIP_RDONLY))
        @test_nowarn ZipArchive(buffer; flags = Int64(LIBZIP_CREATE))
    end
end
