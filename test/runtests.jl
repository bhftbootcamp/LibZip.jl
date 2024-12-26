# runtests

using LibZip
using Test

@testset "LibZip" verbose=true begin
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
        @test !isopen(zip1)

        zip2 = ZipArchive(buffer; flags = LIBZIP_CREATE)
        @test length(zip2) == 1
        @test_nowarn write(zip2, "text2.txt", b"text2")
        @test length(zip2) == 2
    end
end
