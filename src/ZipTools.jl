module ZipTools

export ZipArchive,
    ZipError,
    ZipFile

export zip_open,
    zip_discard,
    zip_compress_file!,
    zip_encrypt_file!,
    zip_default_password!,
    zip_get_file_info,
    zip_add_dir!

using Dates
using ..LibZip

const COMPRESSION_METHODS = Dict(
    LIBZIP_CM_DEFAULT        => "DEFAULT",
    LIBZIP_CM_STORE          => "STORE",
    LIBZIP_CM_SHRINK         => "SHRINK",
    LIBZIP_CM_REDUCE_1       => "REDUCE_1",
    LIBZIP_CM_REDUCE_2       => "REDUCE_2",
    LIBZIP_CM_REDUCE_3       => "REDUCE_3",
    LIBZIP_CM_REDUCE_4       => "REDUCE_4",
    LIBZIP_CM_IMPLODE        => "IMPLODE",
    LIBZIP_CM_DEFLATE        => "DEFLATE",
    LIBZIP_CM_DEFLATE64      => "DEFLATE64",
    LIBZIP_CM_PKWARE_IMPLODE => "PKWARE_IMPLODE",
    LIBZIP_CM_BZIP2          => "BZIP2",
    LIBZIP_CM_LZMA           => "LZMA",
    LIBZIP_CM_TERSE          => "TERSE",
    LIBZIP_CM_LZ77           => "LZ77",
    LIBZIP_CM_LZMA2          => "LZMA2",
    LIBZIP_CM_ZSTD           => "ZSTD",
    LIBZIP_CM_XZ             => "XZ",
    LIBZIP_CM_JPEG           => "JPEG",
    LIBZIP_CM_WAVPACK        => "WAVPACK",
    LIBZIP_CM_PPMD           => "PPMD",
)

const ENCRYPTION_METHODS = Dict(
    LIBZIP_EM_NONE        => "NONE",
    LIBZIP_EM_TRAD_PKWARE => "PKWARE",
    LIBZIP_EM_AES_128     => "AES_128",
    LIBZIP_EM_AES_192     => "AES_192",
    LIBZIP_EM_AES_256     => "AES_256",
    LIBZIP_EM_UNKNOWN     => "UNKNOWN",
)

struct ZipError <: Exception
    code::Int
    message::String

    function ZipError(err_ptr::Ptr{LibZipErrorT})
        code = libzip_error_code_zip(err_ptr)
        message = unsafe_string(libzip_error_strerror(err_ptr))
        return new(code, message)
    end

    function ZipError(code::Int)
        err = LibZipErrorT()
        err_ptr = Ptr{LibZipErrorT}(pointer_from_objref(err))
        libzip_error_init_with_code(err_ptr, code)
        return ZipError(err_ptr)
    end
end

Base.show(io::IO, e::ZipError) = print(io, "Error $(e.code): $(e.message)")

#__ File

"""
    ZipFile

Represents a file contained in an [`ZipArchive`](@ref).

## Fields

- `body::Vector{UInt8}`: Binary representation of file contents.
- `name::String`: File name.
- `index::Int64`: File index number (zero-based).
- `size::Int64`: File uncompressed size.
- `comp_size::Int64`: File compressed size.
- `time::DateTime`: File last modification time.
- `crc::Int64`: File CRC-32 checksum.
- `comp_method::Int64`: File compression method.
- `encryption_method::Int64`: File encryption method.
"""
struct ZipFile
    body::Vector{UInt8}
    name::String
    index::Int
    size::Int
    comp_size::Int
    time::DateTime
    crc::Int
    comp_method::Int
    encryption_method::Int

    function ZipFile(data::Vector{UInt8}, stat::LibZipStatT)
        name = unsafe_string(stat.name)
        index = stat.index
        size = stat.size
        comp_size = stat.comp_size
        time = DateTime(1970, 1, 1) + Second(stat.time)
        crc = stat.crc
        comp_method = stat.comp_method
        encryption_method = stat.encryption_method

        return new(
            data,
            name,
            index,
            size,
            comp_size,
            time,
            crc,
            comp_method,
            encryption_method,
        )
    end
end

function compression_str(num::Int)
    return get(COMPRESSION_METHODS, num, "UNKNOWN")
end

function encryption_str(num::Int)
    return get(ENCRYPTION_METHODS, num, "UNKNOWN")
end

function Base.show(io::IO, entry::ZipFile)
    println(io, "File: $(entry.name)")
    println(io, "  Index: $(entry.index)")
    println(io, "  Size: $(entry.size) bytes")
    println(io, "  Compressed Size: $(entry.comp_size) bytes")
    println(io, "  Last Modified: $(entry.time)")
    println(io, "  CRC32: $(entry.crc)")
    println(io, "  Compression: $(compression_str(entry.comp_method))")
    println(io, "  Encryption: $(encryption_str(entry.encryption_method))")
end

#__ Archive

"""
    ZipArchive

Type describing zip archive for reading and writing.

## Fields
- `archive_ptr::Ptr{LibZipT}`: The pointer to the C library zip structure.
- `source_ptr::Ptr{LibZipSourceT}`: The pointer to the C library source structure.
- `comment::String`: The archives's comment.
- `closed::Bool`: Flag indicating whether the archive is closed.
- `archive_data::Union{Nothing,Vector{UInt8}}`: The service field for preserving data in the archive.
- `data_refs::Union{Nothing,Vector{Ref}}`: The service field for preserving data being written.
"""
mutable struct ZipArchive
    archive_ptr::Ptr{LibZipT}
    source_ptr::Ptr{LibZipSourceT}
    comment::String
    closed::Bool
    archive_data::Union{Nothing,Vector{UInt8}}
    data_refs::Union{Nothing,Vector{Ref}}

    function ZipArchive(
        archive_ptr::Ptr{LibZipT}, 
        source_ptr::Ptr{LibZipSourceT} = C_NULL,
        data::Union{Nothing,Vector{UInt8}} = nothing
    )
        libzip_source_keep(source_ptr)
        comment = unsafe_string(libzip_get_archive_comment(archive_ptr, C_NULL, 0))
        zip = new(archive_ptr, source_ptr, comment, false, data, Ref[])
        finalizer(zip_discard, zip)
        return zip
    end
end

function init_source(data::AbstractVector{UInt8}, freep::Int = 0)
    err = LibZipErrorT()
    err_ptr = Ptr{LibZipErrorT}(pointer_from_objref(err))
    libzip_error_init(err_ptr)
    ptr = libzip_source_buffer_create(data, length(data), freep, err_ptr)
    ptr == C_NULL && throw(ZipError(err_ptr))
    zip_error_fini(err_ptr)
    return ptr
end

function init_source(path::AbstractString, start::Int = 0, len::Int = -1)
    err = LibZipErrorT()
    err_ptr = Ptr{LibZipErrorT}(pointer_from_objref(err))
    libzip_error_init(err_ptr)
    ptr = libzip_source_file_create(path, start, len, err_ptr)
    ptr == C_NULL && throw(ZipError(err_ptr))
    zip_error_fini(err_ptr)
    return ptr
end

"""
    ZipArchive(data::Vector{UInt8}; flags::Int = LIBZIP_RDONLY) -> ZipArchive
    ZipArchive(; flags::Int = LIBZIP_CREATE) -> ZipArchive

Construct an empty [`ZipArchive`](@ref) or an existing one from an in-memory byte buffer with specified `flags`.

See also [`Open flags`](@ref open_flags) section.

## Examples

```julia-repl
julia> ZipArchive(; flags = LIBZIP_CREATE | LIBZIP_CHECKCONS)
 ZipArchive:
    🔓 Archive is open and ready for use!
    📂 The archive is empty.
```

```julia-repl
julia> zip_file = read(".../secrets.zip");

julia> ZipArchive(zip_file)
 ZipArchive:
    🔓 Archive is open and ready for use!
    📁 Files in archive:
      📄 my_secret_1.txt/: 42 bytes
      [...]
```
"""
ZipArchive()

function ZipArchive(data::AbstractVector{UInt8}; flags::Int = LIBZIP_RDONLY)
    err = LibZipErrorT()
    err_ptr = Ptr{LibZipErrorT}(pointer_from_objref(err))
    libzip_error_init(err_ptr)
    source_ptr = init_source(data)
    archive_ptr = libzip_open_from_source(source_ptr, flags, err_ptr)
    archive_ptr == C_NULL && throw(ZipError(err_ptr))
    zip_error_fini(err_ptr)
    return ZipArchive(archive_ptr, source_ptr, data)
end

function ZipArchive(; flags::Int = LIBZIP_CREATE)
    source_ptr = libzip_source_buffer_create(C_NULL, 0, 0, C_NULL)
    archive_ptr = libzip_open_from_source(source_ptr, flags, C_NULL)
    return ZipArchive(archive_ptr, source_ptr)
end

#__ Utils

function check_closed(zip::ZipArchive)
    @assert isopen(zip) "zip archive was closed"
    return nothing
end

function locate_file(zip::ZipArchive, filename::AbstractString, flags::UInt32=UInt32(0))
    check_closed(zip)
    index = libzip_name_locate(zip.archive_ptr, filename, flags)
    index < 0 && throw(ZipError(LIBZIP_ER_NOENT))
    return index
end

function zip_error_code(zip::ZipArchive)
    error_ptr = libzip_get_error(zip.archive_ptr)
    return libzip_error_code_zip(error_ptr)
end

function source_error_code(zip::ZipArchive)
    error_ptr = libzip_source_error(zip.source_ptr)
    return libzip_error_code_zip(error_ptr)
end

#__ Tools

Base.isopen(zip::ZipArchive) = !zip.closed

"""
    zip_open(path::String; flags::Int = LIBZIP_RDONLY) -> ZipArchive

Open a zip archive file by its `path` with specified `flags`.

See also [`Open flags`](@ref open_flags) section.
"""
function zip_open(path::AbstractString; flags::Int = LIBZIP_RDONLY)
    err = LibZipErrorT()
    err_ptr = Ptr{LibZipErrorT}(pointer_from_objref(err))
    libzip_error_init(err_ptr)
    source_ptr = init_source(path)
    archive_ptr = libzip_open_from_source(source_ptr, flags, err_ptr)
    archive_ptr == C_NULL && throw(ZipError(err_ptr))
    zip_error_fini(err_ptr)
    return ZipArchive(archive_ptr, source_ptr)
end

"""
    close(zip::ZipArchive)

Commit cahnges and close a `zip` archive instance.
"""
function Base.close(zip::ZipArchive)
    if isopen(zip)
        status = libzip_close(zip.archive_ptr)
        iszero(status) || throw(ZipError(zip_error_code(zip)))
        zip.closed = true
    end
end

"""
    zip_discard(zip::ZipArchive)

Close a `zip` archive instance without saving changes.
"""
function zip_discard(zip::ZipArchive)
    if isopen(zip)
        libzip_source_free(zip.source_ptr)
        libzip_discard(zip.archive_ptr)
        zip.archive_data = nothing
        zip.data_refs = nothing
        zip.closed = true
    end
end

"""
    zip_compress_file!(zip::ZipArchive, index::Int, method::Int = LIBZIP_CM_DEFAULT; compression_level::Int = 1)
    zip_compress_file!(zip::ZipArchive, filename::String, method::Int = LIBZIP_CM_DEFAULT; compression_level::Int = 1)

Set the compression `method` for the file at position `index` or by `filename` in the `zip` archive.
The `compression_level` argument defines the compression level.

See also [`Compression methods`](@ref compression_methods) section.
"""
function zip_compress_file! end

function zip_compress_file!(
    zip::ZipArchive,
    index::Int,
    method::Int = LIBZIP_CM_DEFAULT;
    compression_level::Int = 1,
)
    check_closed(zip)
    status = libzip_set_file_compression(zip.archive_ptr, index, method, compression_level)
    iszero(status) || throw(ZipError(zip_error_code(zip)))
    return nothing
end

function zip_compress_file!(
    zip::ZipArchive,
    filename::AbstractString,
    method::Int = LIBZIP_CM_DEFAULT;
    kw...,
)
    return zip_compress_file!(zip, locate_file(zip, filename), method; kw...)
end

"""
    zip_encrypt_file!(zip::ZipArchive, index::Int, password::String; method::UInt16 = LIBZIP_EM_AES_128)
    zip_encrypt_file!(zip::ZipArchive, filename::String, password::String; method::UInt16 = LIBZIP_EM_AES_128)

Set the encryption `method` for the file at position `index` or by `filename` in the `zip` archive using the `password`.

See also [`encryption methods`](@ref encryption_methods) section.
"""
function zip_encrypt_file! end

function zip_encrypt_file!(
    zip::ZipArchive,
    index::Int,
    password::AbstractString;
    method::UInt16 = LIBZIP_EM_AES_128,
)
    check_closed(zip)
    status = libzip_file_set_encryption(zip.archive_ptr, index, method, password)
    iszero(status) || throw(ZipError(zip_error_code(zip)))
    return nothing
end

function zip_encrypt_file!(
    zip::ZipArchive,
    filename::AbstractString,
    password::AbstractString;
    kw...,
)
    return zip_encrypt_file!(zip, locate_file(zip, filename), password; kw...)
end

"""
    zip_default_password!(zip::ZipArchive, password::String)

Set the default `password` in the `zip` archive used when accessing encrypted files.
"""
function zip_default_password!(zip::ZipArchive, password::AbstractString)
    check_closed(zip)
    status = libzip_set_default_password(zip.archive_ptr, password)
    status >= 0 || throw(ZipError(zip_error_code(zip)))
    return nothing
end

"""
    zip_add_dir!(zip::ZipArchive, dirname::String; flags::UInt32 = LIBZIP_FL_OVERWRITE)

Add a directory to a `zip` archive by the `dirname`, which will be created if it does not exist yet or overwritten if it does exist.

See also [`Add file flags`](@ref add_file_flags) section.
"""
function zip_add_dir!(zip::ZipArchive, dirname::AbstractString; flags::UInt32 = LIBZIP_FL_OVERWRITE)
    status = libzip_dir_add(zip.archive_ptr, dirname, flags)
    status >= 0 || throw(ZipError(zip_error_code(zip)))
    return nothing
end

"""
    zip_get_file_info(zip::ZipArchive, filename::String; flags::UInt32 = LIBZIP_FL_ENC_GUESS)
    zip_get_file_info(zip::ZipArchive, index::Int; flags::UInt32 = LIBZIP_FL_ENC_GUESS)

Return information about the `filename` in a `zip` archive.

See also [`File info flags`](@ref file_info_flags) section.
"""
function zip_get_file_info end

function zip_get_file_info(zip::ZipArchive, index::Int; flags::UInt32 = LIBZIP_FL_ENC_GUESS)
    check_closed(zip)
    info = LibZipStatT()
    info_ptr = pointer_from_objref(info)
    libzip_stat_init(info_ptr)
    status = libzip_stat_index(zip.archive_ptr, index, flags, info_ptr)
    iszero(status) || throw(ZipError(zip_error_code(zip)))
    return info
end

function zip_get_file_info(
    zip::ZipArchive,
    filename::AbstractString;
    flags::UInt32 = LIBZIP_FL_ENC_GUESS,
)
    return zip_get_file_info(zip, locate_file(zip, filename); flags)
end

#__ Iterate

Base.IteratorSize(::Type{ZipArchive}) = Base.HasLength()
Base.IteratorEltype(::Type{ZipArchive}) = Base.HasEltype()
Base.eltype(::Type{ZipArchive}) = ZipFile

"""
    length(zip::ZipArchive, flags::UInt32 = LIBZIP_FL_ENC_GUESS)

Return the number of files in `zip` archive.

See also [`Read file flags`](@ref read_file_flags) section.
"""
function Base.length(zip::ZipArchive, flags::UInt32 = LIBZIP_FL_ENC_GUESS)
    check_closed(zip)
    return libzip_get_num_entries(zip.archive_ptr, flags)
end

function Base.iterate(zip::ZipArchive, state::Int = 0)
    state >= length(zip) && return nothing
    entry = ZipFile(read(zip, state), zip_get_file_info(zip, state))
    return (entry, state + 1)
end

#__ IO

"""
    read(zip::ZipArchive, index::Int; kw...) -> Vector{UInt8}
    read(zip::ZipArchive, filename::String; kw...) -> Vector{UInt8}

Read the file contents of a `zip` archive by `index` or `filename`.

## Keyword arguments
- `flags::UInt32`: Mode for a reading and name lookup (by default `LIBZIP_FL_ENC_GUESS`).
- `password::Union{Nothing,AbstractString}`: Password for an encrypted entry (by default `nothing`).

See also [`Read file flags`](@ref read_file_flags) section.
"""
function Base.read(
    zip::ZipArchive,
    index::Int;
    flags::UInt32 = LIBZIP_FL_ENC_GUESS,
    password::Union{Nothing,AbstractString} = nothing,
)
    check_closed(zip)
    file_ptr = if password === nothing
        libzip_fopen_index(zip.archive_ptr, index, flags)
    else
        libzip_fopen_index_encrypted(zip.archive_ptr, index, flags, password)
    end
    file_ptr == C_NULL && throw(ZipError(zip_error_code(zip)))
    info = zip_get_file_info(zip, index)
    buffer = Vector{UInt8}(undef, info.size)
    status = libzip_fread(file_ptr, buffer, info.size)
    status >= 0 || throw(ZipError(zip_error_code(zip)))
    return buffer
end

function Base.read(zip::ZipArchive, filename::AbstractString; kw...)
    return read(zip, locate_file(zip, filename); kw...)
end

"""
    read!(zip::ZipArchive) -> Vector{UInt8}

Read binary data and then close the `zip` archive.
"""
function Base.read!(zip::ZipArchive)
    check_closed(zip)
    close(zip)
    info = LibZipStatT()
    info_ptr = pointer_from_objref(info)
    libzip_stat_init(info_ptr)
    libzip_source_stat(zip.source_ptr, info_ptr) < 0 && throw(ZipError(source_error_code(zip)))
    libzip_source_open(zip.source_ptr) < 0 && throw(ZipError(source_error_code(zip)))
    len = info.size
    buffer = Vector{UInt8}(undef, len)
    libzip_source_read(zip.source_ptr, buffer, len) < 0 && throw(ZipError(source_error_code(zip)))
    libzip_source_close(zip.source_ptr)
    return buffer
end

"""
    write(zip::ZipArchive, filename::String, data::Vector{UInt8}; flags::UInt32 = LIBZIP_FL_OVERWRITE)

Write the binary `data` to a `zip` archive, which will be created if it does not exist yet or overwritten if it does exist.

See also [`Add file flags`](@ref add_file_flags) section.
"""
function Base.write(
    zip::ZipArchive,
    filename::AbstractString,
    data::AbstractVector{UInt8};
    flags::UInt32 = LIBZIP_FL_OVERWRITE,
)
    check_closed(zip)
    push!(zip.data_refs, Ref(data))
    status = libzip_file_add(zip.archive_ptr, filename, init_source(data), flags)
    status >= 0 || throw(ZipError(zip_error_code(zip)))
    return nothing
end

"""
    write(path::String, zip::ZipArchive)

Write the `zip` archive binary data as a file by `path`.
"""
function Base.write(path::AbstractString, zip::ZipArchive)
    check_closed(zip)
    return write(path, read!(zip))
end

#__ Show

function Base.show(io::IO, zip::ZipArchive)
    println(io, " ZipArchive:")
    if !isempty(zip.comment)
        println(io, "    Comment: \"$(zip.comment)\"")
    end
    if zip.closed
        println(io, "    🔒 Archive is closed — access is restricted.")
    else
        println(io, "    🔓 Archive is open and ready for use!")
    end
    if !zip.closed
        if length(zip) == 0
            println(io, "    📂 The archive is empty.")
        else
            println(io, "    📁 Files in archive:")
            for i in 0:length(zip)-1
                file_info = zip_get_file_info(zip, i)
                println(io, "      📄 $(unsafe_string(file_info.name)): $(file_info.size) bytes")
            end
        end
    else
        println(io, "    Cannot display contents of a closed archive.")
    end
end

end
