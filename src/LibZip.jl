module LibZip

using libzip_jll

export LIBZIP_CREATE,
    LIBZIP_EXCL,
    LIBZIP_CHECKCONS,
    LIBZIP_TRUNCATE,
    LIBZIP_RDONLY

export LIBZIP_ER_OK,
    LIBZIP_ER_MULTIDISK,
    LIBZIP_ER_RENAME,
    LIBZIP_ER_CLOSE,
    LIBZIP_ER_SEEK,
    LIBZIP_ER_READ,
    LIBZIP_ER_WRITE,
    LIBZIP_ER_CRC,
    LIBZIP_ER_ZIPCLOSED,
    LIBZIP_ER_NOENT,
    LIBZIP_ER_EXISTS,
    LIBZIP_ER_OPEN,
    LIBZIP_ER_TMPOPEN,
    LIBZIP_ER_ZLIB,
    LIBZIP_ER_MEMORY,
    LIBZIP_ER_CHANGED,
    LIBZIP_ER_COMPNOTSUPP,
    LIBZIP_ER_EOF,
    LIBZIP_ER_INVAL,
    LIBZIP_ER_NOZIP,
    LIBZIP_ER_INTERNAL,
    LIBZIP_ER_INCONS,
    LIBZIP_ER_REMOVE,
    LIBZIP_ER_DELETED,
    LIBZIP_ER_ENCRNOTSUPP,
    LIBZIP_ER_RDONLY,
    LIBZIP_ER_NOPASSWD,
    LIBZIP_ER_WRONGPASSWD,
    LIBZIP_ER_OPNOTSUPP,
    LIBZIP_ER_INUSE,
    LIBZIP_ER_TELL,
    LIBZIP_ER_COMPRESSED_DATA,
    LIBZIP_ER_CANCELLED,
    LIBZIP_ER_DATA_LENGTH,
    LIBZIP_ER_NOT_ALLOWED,
    LIBZIP_ER_TRUNCATED_ZIP

export LIBZIP_FL_NOCASE,
    LIBZIP_FL_NODIR,
    LIBZIP_FL_COMPRESSED,
    LIBZIP_FL_UNCHANGED,
    LIBZIP_FL_ENCRYPTED,
    LIBZIP_FL_ENC_GUESS,
    LIBZIP_FL_ENC_RAW,
    LIBZIP_FL_ENC_STRICT,
    LIBZIP_FL_LOCAL,
    LIBZIP_FL_CENTRAL,
    LIBZIP_FL_ENC_UTF_8,
    LIBZIP_FL_ENC_CP437,
    LIBZIP_FL_OVERWRITE

export LIBZIP_CM_DEFAULT,
    LIBZIP_CM_STORE,
    LIBZIP_CM_SHRINK,
    LIBZIP_CM_REDUCE_1,
    LIBZIP_CM_REDUCE_2,
    LIBZIP_CM_REDUCE_3,
    LIBZIP_CM_REDUCE_4,
    LIBZIP_CM_IMPLODE,
    LIBZIP_CM_DEFLATE,
    LIBZIP_CM_DEFLATE64,
    LIBZIP_CM_PKWARE_IMPLODE,
    LIBZIP_CM_BZIP2,
    LIBZIP_CM_LZMA,
    LIBZIP_CM_TERSE,
    LIBZIP_CM_LZ77,
    LIBZIP_CM_LZMA2,
    LIBZIP_CM_ZSTD,
    LIBZIP_CM_XZ,
    LIBZIP_CM_JPEG,
    LIBZIP_CM_WAVPACK,
    LIBZIP_CM_PPMD

export LIBZIP_EM_NONE,
    LIBZIP_EM_TRAD_PKWARE,
    LIBZIP_EM_AES_128,
    LIBZIP_EM_AES_192,
    LIBZIP_EM_AES_256,
    LIBZIP_EM_UNKNOWN

export LIBZIP_OPSYS_DOS,
    LIBZIP_OPSYS_AMIGA,
    LIBZIP_OPSYS_OPENVMS,
    LIBZIP_OPSYS_UNIX,
    LIBZIP_OPSYS_VM_CMS,
    LIBZIP_OPSYS_ATARI_ST,
    LIBZIP_OPSYS_OS_2,
    LIBZIP_OPSYS_MACINTOSH,
    LIBZIP_OPSYS_Z_SYSTEM,
    LIBZIP_OPSYS_CPM,
    LIBZIP_OPSYS_WINDOWS_NTFS,
    LIBZIP_OPSYS_MVS,
    LIBZIP_OPSYS_VSE,
    LIBZIP_OPSYS_ACORN_RISC,
    LIBZIP_OPSYS_VFAT,
    LIBZIP_OPSYS_ALTERNATE_MVS,
    LIBZIP_OPSYS_BEOS,
    LIBZIP_OPSYS_TANDEM,
    LIBZIP_OPSYS_OS_400,
    LIBZIP_OPSYS_OS_X

export LIBZIP_AFL_RDONLY,
    LIBZIP_AFL_IS_TORRENTZIP,
    LIBZIP_AFL_WANT_TORRENTZIP,
    LIBZIP_AFL_CREATE_OR_KEEP_FILE_FOR_EMPTY_ARCHIVE

export LIBZIP_LENGTH_TO_END,
    LIBZIP_LENGTH_UNCHECKED

export LibZipT,
    LibZipSourceT,
    LibZipErrorT,
    LibZipFileT,
    LibZipStatT

export libzip_libzip_version

export libzip_open,
    libzip_open_from_source,
    libzip_close,
    libzip_discard

export libzip_source_buffer,
    libzip_source_buffer_create,
    libzip_source_file_create,
    libzip_source_keep,
    libzip_source_stat,
    libzip_source_open,
    libzip_source_read,
    libzip_source_close,
    libzip_source_free

export libzip_dir_add,
    libzip_file_add,
    libzip_file_replace,
    libzip_set_file_compression,
    libzip_file_set_encryption,
    libzip_file_set_comment,
    libzip_file_get_comment,
    libzip_file_set_dostime,
    libzip_file_set_mtime,
    libzip_file_set_external_attributes,
    libzip_file_get_external_attributes,
    libzip_rename,
    libzip_delete

export libzip_get_num_entries,
    libzip_set_default_password,
    libzip_get_name,
    libzip_stat_init,
    libzip_stat,
    libzip_stat_index,
    libzip_name_locate,
    libzip_set_archive_comment,
    libzip_get_archive_comment,
    libzip_set_archive_flag,
    libzip_get_archive_flag

export libzip_fopen,
    libzip_fopen_index,
    libzip_fopen_encrypted,
    libzip_fopen_index_encrypted,
    libzip_fread,
    libzip_fclose

export libzip_unchange,
    libzip_unchange_all,
    libzip_unchange_archive

export libzip_error_init,
    libzip_error_init_with_code,
    libzip_get_error,
    libzip_error_code_zip,
    libzip_error_code_system,
    libzip_error_strerror,
    libzip_strerror,
    libzip_source_error,
    zip_error_fini

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

const LIBZIP_CREATE    = 1
const LIBZIP_EXCL      = 2
const LIBZIP_CHECKCONS = 4
const LIBZIP_TRUNCATE  = 8
const LIBZIP_RDONLY    = 16

const LIBZIP_ER_OK              = 0    # N No error
const LIBZIP_ER_MULTIDISK       = 1    # N Multi-disk zip archives not supported
const LIBZIP_ER_RENAME          = 2    # S Renaming temporary file failed
const LIBZIP_ER_CLOSE           = 3    # S Closing zip archive failed
const LIBZIP_ER_SEEK            = 4    # S Seek error
const LIBZIP_ER_READ            = 5    # S Read error
const LIBZIP_ER_WRITE           = 6    # S Write error
const LIBZIP_ER_CRC             = 7    # N CRC error
const LIBZIP_ER_ZIPCLOSED       = 8    # N Containing zip archive was closed
const LIBZIP_ER_NOENT           = 9    # N No such file
const LIBZIP_ER_EXISTS          = 10   # N File already exists
const LIBZIP_ER_OPEN            = 11   # S Can't open file
const LIBZIP_ER_TMPOPEN         = 12   # S Failure to create temporary file
const LIBZIP_ER_ZLIB            = 13   # Z Zlib error
const LIBZIP_ER_MEMORY          = 14   # N Malloc failure
const LIBZIP_ER_CHANGED         = 15   # N Entry has been changed
const LIBZIP_ER_COMPNOTSUPP     = 16   # N Compression method not supported
const LIBZIP_ER_EOF             = 17   # N Premature end of file
const LIBZIP_ER_INVAL           = 18   # N Invalid argument
const LIBZIP_ER_NOZIP           = 19   # N Not a zip archive
const LIBZIP_ER_INTERNAL        = 20   # N Internal error
const LIBZIP_ER_INCONS          = 21   # L Zip archive inconsistent
const LIBZIP_ER_REMOVE          = 22   # S Can't remove file
const LIBZIP_ER_DELETED         = 23   # N Entry has been deleted
const LIBZIP_ER_ENCRNOTSUPP     = 24   # N Encryption method not supported
const LIBZIP_ER_RDONLY          = 25   # N Read-only archive
const LIBZIP_ER_NOPASSWD        = 26   # N No password provided
const LIBZIP_ER_WRONGPASSWD     = 27   # N Wrong password provided
const LIBZIP_ER_OPNOTSUPP       = 28   # N Operation not supported
const LIBZIP_ER_INUSE           = 29   # N Resource still in use
const LIBZIP_ER_TELL            = 30   # S Tell error
const LIBZIP_ER_COMPRESSED_DATA = 31   # N Compressed data invalid
const LIBZIP_ER_CANCELLED       = 32   # N Operation cancelled
const LIBZIP_ER_DATA_LENGTH     = 33   # N Unexpected length of data
const LIBZIP_ER_NOT_ALLOWED     = 34   # N Not allowed in torrentzip
const LIBZIP_ER_TRUNCATED_ZIP   = 35   # N Possibly truncated or corrupted zip archive

const LIBZIP_FL_NOCASE     = UInt32(1)     # ignore case on name lookup
const LIBZIP_FL_NODIR      = UInt32(2)     # ignore directory component
const LIBZIP_FL_COMPRESSED = UInt32(4)     # read compressed data
const LIBZIP_FL_UNCHANGED  = UInt32(8)     # use original data, ignoring changes
const LIBZIP_FL_ENCRYPTED  = UInt32(32)    # read encrypted data (implies LIBZIP_FL_COMPRESSED)
const LIBZIP_FL_ENC_GUESS  = UInt32(0)     # guess string encoding (is default)
const LIBZIP_FL_ENC_RAW    = UInt32(64)    # get unmodified string
const LIBZIP_FL_ENC_STRICT = UInt32(128)   # follow specification strictly
const LIBZIP_FL_LOCAL      = UInt32(256)   # in local header
const LIBZIP_FL_CENTRAL    = UInt32(512)   # in central directory
const LIBZIP_FL_ENC_UTF_8  = UInt32(2048)  # string is UTF-8 encoded
const LIBZIP_FL_ENC_CP437  = UInt32(4096)  # string is CP437 encoded
const LIBZIP_FL_OVERWRITE  = UInt32(8192)  # zip_file_add: if file with name exists, overwrite (replace) it

const LIBZIP_CM_DEFAULT        = -1    # better of deflate or store
const LIBZIP_CM_STORE          = 0     # stored (uncompressed)
const LIBZIP_CM_SHRINK         = 1     # shrunk
const LIBZIP_CM_REDUCE_1       = 2     # reduced with factor 1
const LIBZIP_CM_REDUCE_2       = 3     # reduced with factor 2
const LIBZIP_CM_REDUCE_3       = 4     # reduced with factor 3
const LIBZIP_CM_REDUCE_4       = 5     # reduced with factor 4
const LIBZIP_CM_IMPLODE        = 6     # imploded
const LIBZIP_CM_DEFLATE        = 8     # deflated
const LIBZIP_CM_DEFLATE64      = 9     # deflate64
const LIBZIP_CM_PKWARE_IMPLODE = 10    # PKWARE imploding
const LIBZIP_CM_BZIP2          = 12    # compressed using BZIP2 algorithm
const LIBZIP_CM_LZMA           = 14    # LZMA (EFS)
const LIBZIP_CM_TERSE          = 18    # compressed using IBM TERSE (new)
const LIBZIP_CM_LZ77           = 19    # IBM LZ77 z Architecture (PFS)
const LIBZIP_CM_LZMA2          = 33
const LIBZIP_CM_ZSTD           = 93    # Zstandard compressed data
const LIBZIP_CM_XZ             = 95    # XZ compressed data
const LIBZIP_CM_JPEG           = 96    # Compressed Jpeg data
const LIBZIP_CM_WAVPACK        = 97    # WavPack compressed data
const LIBZIP_CM_PPMD           = 98    # PPMd version I, Rev 1

const LIBZIP_EM_NONE        = UInt16(0)     # not encrypted
const LIBZIP_EM_TRAD_PKWARE = UInt16(1)     # traditional PKWARE encryption
const LIBZIP_EM_AES_128     = UInt16(257)   # Winzip AES encryption
const LIBZIP_EM_AES_192     = UInt16(258)
const LIBZIP_EM_AES_256     = UInt16(259)
const LIBZIP_EM_UNKNOWN     = UInt16(65535) # unknown algorithm

const LIBZIP_OPSYS_DOS           = UInt8(0x00)
const LIBZIP_OPSYS_AMIGA         = UInt8(0x01)
const LIBZIP_OPSYS_OPENVMS       = UInt8(0x02)
const LIBZIP_OPSYS_UNIX          = UInt8(0x03)
const LIBZIP_OPSYS_VM_CMS        = UInt8(0x04)
const LIBZIP_OPSYS_ATARI_ST      = UInt8(0x05)
const LIBZIP_OPSYS_OS_2          = UInt8(0x06)
const LIBZIP_OPSYS_MACINTOSH     = UInt8(0x07)
const LIBZIP_OPSYS_Z_SYSTEM      = UInt8(0x08)
const LIBZIP_OPSYS_CPM           = UInt8(0x09)
const LIBZIP_OPSYS_WINDOWS_NTFS  = UInt8(0x0a)
const LIBZIP_OPSYS_MVS           = UInt8(0x0b)
const LIBZIP_OPSYS_VSE           = UInt8(0x0c)
const LIBZIP_OPSYS_ACORN_RISC    = UInt8(0x0d)
const LIBZIP_OPSYS_VFAT          = UInt8(0x0e)
const LIBZIP_OPSYS_ALTERNATE_MVS = UInt8(0x0f)
const LIBZIP_OPSYS_BEOS          = UInt8(0x10)
const LIBZIP_OPSYS_TANDEM        = UInt8(0x11)
const LIBZIP_OPSYS_OS_400        = UInt8(0x12)
const LIBZIP_OPSYS_OS_X          = UInt8(0x13)

const LIBZIP_AFL_RDONLY                                = UInt32(2)  # read only -- cannot be cleared
const LIBZIP_AFL_IS_TORRENTZIP	                       = UInt32(4)  # current archive is torrentzipped
const LIBZIP_AFL_WANT_TORRENTZIP	                   = UInt32(8)  # write archive in torrentzip format
const LIBZIP_AFL_CREATE_OR_KEEP_FILE_FOR_EMPTY_ARCHIVE = UInt32(16) # don't remove file if archive is empty

const LIBZIP_LENGTH_TO_END    = 0
const LIBZIP_LENGTH_UNCHECKED = -2 # only supported by zip_source_file and its variants

# time_t: long on Unix, __time64_t (Int64) on Windows
const CTimeT = Sys.iswindows() ? Int64 : Clong

struct LibZipT end
struct LibZipSourceT end
struct LibZipFileT end

mutable struct LibZipErrorT
    zip_err::Cint
    sys_err::Cint
    str::Ptr{UInt8}

    LibZipErrorT() = new(0, 0, Ptr{UInt8}())
end

mutable struct LibZipStatT
    valid::UInt64
    name::Ptr{UInt8}
    index::UInt64
    size::UInt64
    comp_size::UInt64
    time::CTimeT
    crc::UInt32
    comp_method::UInt16
    encryption_method::UInt16
    flags::UInt32

    LibZipStatT() = new(0, Ptr{UInt8}(), 0, 0, 0, 0, 0, 0, 0, 0)
end

function libzip_libzip_version()
    return ccall((:zip_libzip_version, libzip), Ptr{UInt8}, ())
end

#__ Open/Close Archive

function libzip_open(path, flags, errorp)
    return ccall((:zip_open, libzip), Ptr{LibZipT}, (Ptr{UInt8}, Cint, Ptr{Cint}), path, flags, errorp)
end

function libzip_open_from_source(zs, flags, ze)
    return ccall((:zip_open_from_source, libzip), Ptr{LibZipT}, (Ptr{LibZipSourceT}, Cint, Ptr{LibZipErrorT}), zs, flags, ze)
end

function libzip_close(archive)
    return ccall((:zip_close, libzip), Cint, (Ptr{LibZipT},), archive)
end

function libzip_discard(archive)
    return ccall((:zip_discard, libzip), Cvoid, (Ptr{LibZipT},), archive)
end

#__ Source

function libzip_source_buffer(archive, data, len, freep)
    return ccall((:zip_source_buffer, libzip), Ptr{LibZipSourceT}, (Ptr{LibZipT}, Ptr{Cvoid}, UInt64, Cint,), archive, data, len, freep)
end

function libzip_source_buffer_create(data, len, freep, error)
    return ccall((:zip_source_buffer_create, libzip), Ptr{LibZipSourceT}, (Ptr{UInt8}, UInt64, Cint, Ptr{LibZipErrorT}), data, len, freep, error)
end

function libzip_source_file_create(fname, start, len, error)
    return ccall((:zip_source_file_create, libzip), Ptr{LibZipSourceT}, (Ptr{UInt8}, UInt64, Int64, Ptr{LibZipErrorT}), fname, start, len, error)
end

function libzip_source_keep(source)
    return ccall((:zip_source_keep, libzip), Cvoid, (Ptr{LibZipSourceT},), source)
end

function libzip_source_stat(source, sb)
    return ccall((:zip_source_stat, libzip), Cint, (Ptr{LibZipSourceT}, Ptr{LibZipStatT}), source, sb)
end

function libzip_source_open(source)
    return ccall((:zip_source_open, libzip), Cint, (Ptr{LibZipSourceT},), source)
end

function libzip_source_read(source, data, len)
    return ccall((:zip_source_read, libzip), Int64, (Ptr{LibZipSourceT}, Ptr{UInt8}, UInt64), source, data, len)
end

function libzip_source_close(source)
    return ccall((:zip_source_close, libzip), Cint, (Ptr{LibZipSourceT},), source)
end

function libzip_source_free(source)
    return ccall((:zip_source_free, libzip), Cvoid, (Ptr{LibZipSourceT},), source)
end

#__ Add/Change Files and Directories

function libzip_dir_add(archive, name, flags)
    return ccall((:zip_dir_add, libzip), Int64, (Ptr{LibZipT}, Ptr{UInt8}, Cuint), archive, name, flags)
end

function libzip_file_add(archive, name, source, flags)
    return ccall((:zip_file_add, libzip), Int64, (Ptr{LibZipT}, Ptr{UInt8}, Ptr{LibZipSourceT}, Cuint), archive, name, source, flags)
end

function libzip_file_replace(archive, index, source, flags)
    return ccall((:zip_file_replace, libzip), Cint, (Ptr{LibZipT}, UInt64, Ptr{LibZipSourceT}, Cuint), archive, index, source, flags)
end

function libzip_set_file_compression(archive, index, comp, comp_flags)
    return ccall((:zip_set_file_compression, libzip), Cint, (Ptr{LibZipT}, UInt64, Cint, Cuint), archive, index, comp, comp_flags)
end

function libzip_file_set_encryption(archive, index, method, password)
    return ccall((:zip_file_set_encryption, libzip), Cint, (Ptr{LibZipT}, UInt64, Cushort, Ptr{UInt8}), archive, index, method, password)
end

function libzip_file_set_comment(archive, index, comment, len, flags)
    return ccall((:zip_file_set_comment, libzip), Cint, (Ptr{LibZipT}, UInt64, Ptr{UInt8}, Cushort, Cuint), archive, index, comment, len, flags)
end

function libzip_file_get_comment(archive, index, lenp, flags)
    return ccall((:zip_file_get_comment, libzip), Ptr{UInt8}, (Ptr{LibZipT}, UInt64, Ptr{UInt32}, UInt32), archive, index, lenp, flags)
end

function libzip_file_set_dostime(archive, index, dostime, dosdate, flags)
    return ccall((:zip_file_set_dostime, libzip), Cint, (Ptr{LibZipT}, UInt64, Cushort, Cushort, Cuint), archive, index, dostime, dosdate, flags)
end

function libzip_file_set_mtime(archive, index, mtime, flags)
    return ccall((:zip_file_set_mtime, libzip), Cint, (Ptr{LibZipT}, UInt64, CTimeT, Cuint), archive, index, mtime, flags)
end

function libzip_file_set_external_attributes(archive, index, flags, opsys, attributes)
    return ccall((:zip_file_set_external_attributes, libzip), Cint, (Ptr{LibZipT}, UInt64, Cuint, Cuchar, Cuint), archive, index, flags, opsys, attributes)
end

function libzip_file_get_external_attributes(archive, index, flags, opsys, attributes)
    return ccall((:zip_file_get_external_attributes, libzip), Cint, (Ptr{LibZipT}, UInt64, Cuint, Ptr{Cuchar}, Ptr{Cuint}), archive, index, flags, opsys, attributes)
end

function libzip_rename(archive, index, name)
    return ccall((:zip_rename, libzip), Cint, (Ptr{LibZipT}, UInt64, Ptr{UInt8}), archive, index, name)
end

function libzip_delete(archive, index)
    return ccall((:zip_delete, libzip), Cint, (Ptr{LibZipT}, UInt64), archive, index)
end

#__ Miscellaneous

function libzip_get_num_entries(archive, flags)
    return ccall((:zip_get_num_entries, libzip), Int64, (Ptr{LibZipT}, Cuint), archive, flags)
end

function libzip_set_default_password(archive, password)
    return ccall((:zip_set_default_password, libzip), Cint, (Ptr{LibZipT}, Ptr{UInt8}), archive, password)
end

function libzip_get_name(archive, index, flags)
    return ccall((:zip_get_name, libzip), Ptr{UInt8}, (Ptr{LibZipT}, UInt64, Cuint), archive, index, flags)
end

function libzip_stat_init(sb)
    return ccall((:zip_stat_init, libzip), Cvoid, (Ptr{LibZipStatT},), sb)
end

function libzip_stat(archive, fname, flags, sb)
    return ccall((:zip_stat, libzip), Cint, (Ptr{LibZipT}, Ptr{UInt8}, Cuint, Ptr{LibZipStatT}), archive, fname, flags, sb)
end

function libzip_stat_index(archive, index, flags, sb)
    return ccall((:zip_stat_index, libzip), Cint, (Ptr{LibZipT}, UInt64, Cuint, Ptr{LibZipStatT}), archive, index, flags, sb)
end

function libzip_name_locate(archive, fname, flags)
    return ccall((:zip_name_locate, libzip), Int64, (Ptr{LibZipT}, Ptr{UInt8}, Cuint), archive, fname, flags)
end

function libzip_set_archive_comment(archive, comment, len)
    return ccall((:zip_set_archive_comment, libzip), Cint, (Ptr{LibZipT}, Ptr{UInt8}, Cushort), archive, comment, len)
end

function libzip_get_archive_comment(archive, lenp, flags)
    return ccall((:zip_get_archive_comment, libzip), Ptr{UInt8}, (Ptr{LibZipT}, Ptr{Cint}, Cuint), archive, lenp, flags)
end

function libzip_set_archive_flag(archive, flag, value)
    return ccall((:zip_set_archive_flag, libzip), Cint, (Ptr{LibZipT}, Cuint, Cint), archive, flag, value)
end

function libzip_get_archive_flag(archive, flag, flags)
    return ccall((:zip_get_archive_flag, libzip), Cint, (Ptr{LibZipT}, Cuint, Cuint), archive, flag, flags)
end

#__ Read Files

function libzip_fopen(archive, fname, flags)
    return ccall((:zip_fopen, libzip), Ptr{LibZipFileT}, (Ptr{LibZipT}, Ptr{UInt8}, Cuint), archive, fname, flags)
end

function libzip_fopen_index(archive, index, flags)
    return ccall((:zip_fopen_index, libzip), Ptr{LibZipFileT}, (Ptr{LibZipT}, UInt64, Cuint), archive, index, flags)
end

function libzip_fopen_encrypted(archive, fname, flags, password)
    return ccall((:zip_fopen_encrypted, libzip), Ptr{LibZipFileT}, (Ptr{LibZipT}, Ptr{UInt8}, Cuint, Ptr{UInt8}), archive, fname, flags, password)
end

function libzip_fopen_index_encrypted(archive, index, flags, password)
    return ccall((:zip_fopen_index_encrypted, libzip), Ptr{LibZipFileT}, (Ptr{LibZipT}, UInt64, Cuint, Ptr{UInt8}), archive, index, flags, password)
end

function libzip_fread(file, buf, nbytes)
    return ccall((:zip_fread, libzip), Int64, (Ptr{LibZipFileT}, Ptr{Cvoid}, UInt64), file, buf, nbytes)
end

function libzip_fclose(file)
    return ccall((:zip_fclose, libzip), Cint, (Ptr{LibZipFileT},), file)
end

#__ Revert Changes

function libzip_unchange(archive, index)
    return ccall((:zip_unchange, libzip), Cint, (Ptr{LibZipT}, UInt64), archive, index)
end

function libzip_unchange_all(archive)
    return ccall((:zip_unchange_all, libzip), Cint, (Ptr{LibZipT},), archive)
end

function libzip_unchange_archive(archive)
    return ccall((:zip_unchange_archive, libzip), Cint, (Ptr{LibZipT},), archive)
end

#__ Error Handling

function libzip_error_init(error)
    return ccall((:zip_error_init, libzip), Cvoid, (Ptr{LibZipErrorT},), error)
end

function libzip_error_init_with_code(error, ze)
    return ccall((:zip_error_init_with_code, libzip), Cvoid, (Ptr{LibZipErrorT}, Cint), error, ze)
end

function libzip_get_error(archive)
    return ccall((:zip_get_error, libzip), Ptr{LibZipErrorT}, (Ptr{LibZipT},), archive)
end

function libzip_error_code_zip(ze)
    return ccall((:zip_error_code_zip, libzip), Cint, (Ptr{LibZipErrorT},), ze)
end

function libzip_error_code_system(ze)
    return ccall((:zip_error_code_system, libzip), Cint, (Ptr{LibZipErrorT},), ze)
end

function libzip_error_strerror(ze)
    return ccall((:zip_error_strerror, libzip), Ptr{UInt8}, (Ptr{LibZipErrorT},), ze)
end

function libzip_strerror(archive)
    return ccall((:zip_strerror, libzip), Ptr{UInt8}, (Ptr{LibZipT},), archive)
end

function libzip_source_error(source)
    return ccall((:zip_source_error, libzip), Ptr{LibZipErrorT}, (Ptr{LibZipSourceT},), source)
end

function zip_error_fini(ze)
    return ccall((:zip_error_fini, libzip), Cvoid, (Ptr{LibZipErrorT},), ze)
end

include("ZipTools.jl")
using .ZipTools

end
