var documenterSearchIndex = {"docs":
[{"location":"pages/constants/#Constants","page":"Constants","title":"Constants","text":"","category":"section"},{"location":"pages/constants/#compression_methods","page":"Constants","title":"Compression methods","text":"","category":"section"},{"location":"pages/constants/","page":"Constants","title":"Constants","text":"LIBZIP_CM_DEFAULT (-1): Similar to Deflate.\nLIBZIP_CM_STORE (0): Store the file uncompressed.\nLIBZIP_CM_SHRINK (1): Shrunk.\nLIBZIP_CM_REDUCE_1 (2): Reduced with factor 1.\nLIBZIP_CM_REDUCE_2 (3): Reduced with factor 2.\nLIBZIP_CM_REDUCE_3 (4): Reduced with factor 3.\nLIBZIP_CM_REDUCE_4 (5): Reduced with factor 4.\nLIBZIP_CM_IMPLODE (6): Imploded.\nLIBZIP_CM_DEFLATE (8): Deflated.\nLIBZIP_CM_DEFLATE64 (9): Deflate64.\nLIBZIP_CM_PKWARE_IMPLODE (10): PKWARE imploding.\nLIBZIP_CM_BZIP2 (12): Compressed using BZIP2 algorithm\nLIBZIP_CM_LZMA (14): LZMA (EFS).\nLIBZIP_CM_TERSE (18): Compressed using IBM TERSE (new).\nLIBZIP_CM_LZ77 (19): IBM LZ77 z Architecture (PFS).\nLIBZIP_CM_LZMA2 (33)\nLIBZIP_CM_ZSTD (93): ZSTD compressed data.\nLIBZIP_CM_XZ (95): XZ compressed data.\nLIBZIP_CM_JPEG (96): Compressed Jpeg data.\nLIBZIP_CM_WAVPACK (97): WavPack compressed data.\nLIBZIP_CM_PPMD (98): PPMd version I, Rev 1.","category":"page"},{"location":"pages/constants/#encryption_methods","page":"Constants","title":"Encryption methods","text":"","category":"section"},{"location":"pages/constants/","page":"Constants","title":"Constants","text":"LIBZIP_EM_NONE (0): Not encrypted LIBZIP_EM_TRAD_PKWARE (1): Traditional PKWARE encryption LIBZIP_EM_AES_128 (257): Winzip AES-128 encryption. LIBZIP_EM_AES_192 (258): Winzip AES-192 encryption. LIBZIP_EM_AES_256 (259): Winzip AES-256 encryption.","category":"page"},{"location":"pages/constants/#open_flags","page":"Constants","title":"Open flags","text":"","category":"section"},{"location":"pages/constants/","page":"Constants","title":"Constants","text":"LIBZIP_CREATE (1): Create the archive if it does not exist.\nLIBZIP_EXCL (2): Error if archive already exists.\nLIBZIP_CHECKCONS (4): Perform additional stricter consistency checks on the archive, and error if they fail.\nLIBZIP_TRUNCATE (8): If archive exists, ignore its current contents. In other words, handle it the same way as an empty archive.\nLIBZIP_RDONLY (16): Open archive in read-only mode.","category":"page"},{"location":"pages/constants/#file_info_flags","page":"Constants","title":"File info flags","text":"","category":"section"},{"location":"pages/constants/","page":"Constants","title":"Constants","text":"LIBZIP_FL_ENC_GUESS (0): Guess encoding of name (default). (Only CP-437 and UTF-8 are recognized).\nLIBZIP_FL_NOCASE (1): Ignore case distinctions. (Will only work well if the file names are ASCII.) With this flag, zipnamelocate() will be slow for archives with many files.\nLIBZIP_FL_NODIR (2): Ignore directory part of file name in archive. With this flag, zipnamelocate() will be slow for archives with many files.\nLIBZIP_FL_ENC_RAW (64): Compare fname against the unmodified names as they are in the ZIP archive, without converting them to UTF-8.\nLIBZIP_FL_ENC_STRICT (128): Follow the ZIP specification and expect CP-437 encoded names in the ZIP archive (except if they are explicitly marked as UTF-8). Convert them to UTF-8 before comparing.\nLIBZIP_FL_ENC_UTF_8 (2048): Interpret name as UTF-8.\nLIBZIP_FL_ENC_CP437 (4096): Interpret name as code page 437 (CP-437).","category":"page"},{"location":"pages/constants/#read_file_flags","page":"Constants","title":"Read file flags","text":"","category":"section"},{"location":"pages/constants/","page":"Constants","title":"Constants","text":"LIBZIP_FL_COMPRESSED (4): Read compressed data.\nLIBZIP_FL_UNCHANGED (8): Use original data, ignoring changes.","category":"page"},{"location":"pages/constants/#add_file_flags","page":"Constants","title":"Add file flags","text":"","category":"section"},{"location":"pages/constants/","page":"Constants","title":"Constants","text":"LIBZIP_FL_ENC_GUESS (0): Guess encoding of name (default). (Only CP-437 and UTF-8 are recognized).\nLIBZIP_FL_ENC_UTF_8 (2048): Interpret name as UTF-8.\nLIBZIP_FL_ENC_CP437 (4096): Interpret name as code page 437 (CP-437).\nLIBZIP_FL_OVERWRITE (8192): If file with name exists, overwrite (replace) it.","category":"page"},{"location":"#LibZip.jl","page":"Home","title":"LibZip.jl","text":"","category":"section"},{"location":"","page":"Home","title":"Home","text":"LibZip is a convenient wrapper around libzip for reading, creating, and modifying ZIP and ZIP64 archives. It also supports file encryption and decryption.","category":"page"},{"location":"#Installation","page":"Home","title":"Installation","text":"","category":"section"},{"location":"","page":"Home","title":"Home","text":"To install LibZip, simply use the Julia package manager:","category":"page"},{"location":"","page":"Home","title":"Home","text":"] add LibZip","category":"page"},{"location":"#Usage","page":"Home","title":"Usage","text":"","category":"section"},{"location":"#Create-a-zip-archive,-compress-a-file,-and-encrypt-it:","page":"Home","title":"🤐 Create a zip archive, compress a file, and encrypt it:","text":"","category":"section"},{"location":"","page":"Home","title":"Home","text":"using LibZip\n\n# Create a new zip archive\narchive = ZipArchive(; flags = LIBZIP_CREATE)\n\n# Add some text data to a file inside the archive and compress it\nwrite(archive, \"greetings.txt\", b\"Hello, from LibZip!\")\nzip_compress_file!(archive, \"greetings.txt\", LIBZIP_CM_DEFLATE; compression_level = 1)\n\n# Encrypt the file inside the archive\nzip_encrypt_file!(archive, \"greetings.txt\", \"P@ssw0rd123!\"; method = LIBZIP_EM_AES_128)\n\n# Write the zip archive to a specified file path\nwrite(\"secure_archive.zip\", archive)\n\n# Close the archive to finalize changes\nclose(archive)","category":"page"},{"location":"#Extract-and-decrypt-files:","page":"Home","title":"🔓 Extract and decrypt files:","text":"","category":"section"},{"location":"","page":"Home","title":"Home","text":"using LibZip\n\n# Read the zip archive from disk\nzip_data = read(\"secure_archive.zip\")\n\n# Open the archive for reading\narchive = ZipArchive(zip_data; flags = LIBZIP_RDONLY)\n\n# Extract and decrypt the file, providing the password\nread(archive, \"greetings.txt\"; password = \"P@ssw0rd123!\")\n\n# Set a default password for all files\njulia> zip_default_password!(archive, \"P@ssw0rd123!\")\ntrue\n\n# Iterate through the archive and read files with the default password\n# The file contents are decoded from bytes to a string for display\njulia> for item in archive\n           println((item.name, String(item.body)))\n       end\n(\"greetings.txt\", \"Hello, from LibZip!\")","category":"page"},{"location":"#Reading-and-Modifying-an-Existing-Archive:","page":"Home","title":"📂 Reading and Modifying an Existing Archive:","text":"","category":"section"},{"location":"","page":"Home","title":"Home","text":"using LibZip\n\n# Open an existing zip archive for reading and modification\narchive = zip_open(\"secure_archive.zip\"; flags = LIBZIP_CREATE)\n\n# Add or modify files inside the archive\nwrite(archive, \"new_file.txt\", b\"More content!\")\nzip_compress_file!(archive, \"new_file.txt\", LIBZIP_CM_DEFLATE; compression_level = 1)\n\n# Close the archive after modification\nclose(archive)","category":"page"},{"location":"pages/api_reference/#API-Reference","page":"API Reference","title":"API Reference","text":"","category":"section"},{"location":"pages/api_reference/#Types","page":"API Reference","title":"Types","text":"","category":"section"},{"location":"pages/api_reference/","page":"API Reference","title":"API Reference","text":"ZipFile\nZipArchive","category":"page"},{"location":"pages/api_reference/#LibZip.ZipTools.ZipFile","page":"API Reference","title":"LibZip.ZipTools.ZipFile","text":"ZipFile\n\nRepresents a file contained in an ZipArchive.\n\nFields\n\nbody::Vector{UInt8}: Binary representation of file contents.\nname::String: File name.\nindex::Int64: File index number (zero-based).\nsize::Int64: File uncompressed size.\ncomp_size::Int64: File compressed size.\ntime::DateTime: File last modification time.\ncrc::Int64: File CRC-32 checksum.\ncomp_method::Int64: File compression method.\nencryption_method::Int64: File encryption method.\n\n\n\n\n\n","category":"type"},{"location":"pages/api_reference/#LibZip.ZipTools.ZipArchive","page":"API Reference","title":"LibZip.ZipTools.ZipArchive","text":"ZipArchive\n\nType describing zip archive for reading and writing.\n\nFields\n\narchive_ptr::Ptr{LibZipT}: The pointer to the C library zip structure.\nsource_ptr::Ptr{LibZipSourceT}: The pointer to the C library source structure.\ncomment::String: The archive's comment.\nsource_data::Vector{Vector{UInt8}}: A container to hold in-memory source data buffers for the archive.\nclosed::Bool: Flag indicating whether the archive is closed.\n\n\n\n\n\n","category":"type"},{"location":"pages/api_reference/","page":"API Reference","title":"API Reference","text":"ZipArchive()","category":"page"},{"location":"pages/api_reference/#LibZip.ZipTools.ZipArchive-Tuple{}","page":"API Reference","title":"LibZip.ZipTools.ZipArchive","text":"ZipArchive(data::Vector{UInt8}; flags::Int = LIBZIP_RDONLY) -> ZipArchive\nZipArchive(; flags::Int = LIBZIP_CREATE) -> ZipArchive\n\nConstruct an empty ZipArchive or an existing one from an in-memory byte buffer with specified flags.\n\nSee also Open flags section.\n\nExamples\n\njulia> ZipArchive(; flags = LIBZIP_CREATE | LIBZIP_CHECKCONS)\n ZipArchive:\n    🔓 Archive is open and ready for use!\n    📂 The archive is empty.\n\njulia> zip_file = read(\".../secrets.zip\");\n\njulia> ZipArchive(zip_file)\n ZipArchive:\n    🔓 Archive is open and ready for use!\n    📁 Files in archive:\n      📄 my_secret_1.txt/: 42 bytes\n      [...]\n\n\n\n\n\n","category":"method"},{"location":"pages/api_reference/#IO","page":"API Reference","title":"IO","text":"","category":"section"},{"location":"pages/api_reference/","page":"API Reference","title":"API Reference","text":"zip_open\nBase.close\nBase.read\nBase.read!\nBase.write","category":"page"},{"location":"pages/api_reference/#LibZip.ZipTools.zip_open","page":"API Reference","title":"LibZip.ZipTools.zip_open","text":"zip_open(path::String; flags::Int = LIBZIP_RDONLY) -> ZipArchive\n\nOpen a zip archive file by its path with specified flags.\n\nSee also Open flags section.\n\n\n\n\n\n","category":"function"},{"location":"pages/api_reference/#Base.close","page":"API Reference","title":"Base.close","text":"close(zip::ZipArchive)\n\nCommit changes and close a zip archive instance.\n\n\n\n\n\n","category":"function"},{"location":"pages/api_reference/#Base.read","page":"API Reference","title":"Base.read","text":"read(zip::ZipArchive, index::Int; kw...) -> Vector{UInt8}\nread(zip::ZipArchive, filename::String; kw...) -> Vector{UInt8}\n\nRead the file contents of a zip archive by index or filename.\n\nKeyword arguments\n\nflags::UInt32: Mode for a reading and name lookup (by default LIBZIP_FL_ENC_GUESS).\npassword::Union{Nothing,AbstractString}: Password for an encrypted entry (by default nothing).\n\nSee also Read file flags section.\n\n\n\n\n\n","category":"function"},{"location":"pages/api_reference/#Base.read!","page":"API Reference","title":"Base.read!","text":"read!(zip::ZipArchive) -> Vector{UInt8}\n\nRead binary data and then close the zip archive.\n\n\n\n\n\n","category":"function"},{"location":"pages/api_reference/#Base.write","page":"API Reference","title":"Base.write","text":"write(zip::ZipArchive, filename::String, data::Vector{UInt8}; flags::UInt32 = LIBZIP_FL_OVERWRITE)\n\nWrite the binary data to a zip archive, which will be created if it does not exist yet or overwritten if it does exist.\n\nSee also Add file flags section.\n\n\n\n\n\nwrite(path::String, zip::ZipArchive)\n\nWrite the zip archive binary data as a file by path.\n\n\n\n\n\n","category":"function"},{"location":"pages/api_reference/#Tools","page":"API Reference","title":"Tools","text":"","category":"section"},{"location":"pages/api_reference/","page":"API Reference","title":"API Reference","text":"zip_discard\nzip_compress_file!\nzip_encrypt_file!\nzip_default_password!\nzip_add_dir!\nzip_get_file_info\nBase.length","category":"page"},{"location":"pages/api_reference/#LibZip.ZipTools.zip_discard","page":"API Reference","title":"LibZip.ZipTools.zip_discard","text":"zip_discard(zip::ZipArchive)\n\nClose a zip archive instance without saving changes.\n\n\n\n\n\n","category":"function"},{"location":"pages/api_reference/#LibZip.ZipTools.zip_compress_file!","page":"API Reference","title":"LibZip.ZipTools.zip_compress_file!","text":"zip_compress_file!(zip::ZipArchive, index::Int, method::Int = LIBZIP_CM_DEFAULT; compression_level::Int = 1)\nzip_compress_file!(zip::ZipArchive, filename::String, method::Int = LIBZIP_CM_DEFAULT; compression_level::Int = 1)\n\nSet the compression method for the file at position index or by filename in the zip archive. The compression_level argument defines the compression level.\n\nSee also Compression methods section.\n\n\n\n\n\n","category":"function"},{"location":"pages/api_reference/#LibZip.ZipTools.zip_encrypt_file!","page":"API Reference","title":"LibZip.ZipTools.zip_encrypt_file!","text":"zip_encrypt_file!(zip::ZipArchive, index::Int, password::String; method::UInt16 = LIBZIP_EM_AES_128)\nzip_encrypt_file!(zip::ZipArchive, filename::String, password::String; method::UInt16 = LIBZIP_EM_AES_128)\n\nSet the encryption method for the file at position index or by filename in the zip archive using the password.\n\nSee also encryption methods section.\n\n\n\n\n\n","category":"function"},{"location":"pages/api_reference/#LibZip.ZipTools.zip_default_password!","page":"API Reference","title":"LibZip.ZipTools.zip_default_password!","text":"zip_default_password!(zip::ZipArchive, password::String)\n\nSet the default password in the zip archive used when accessing encrypted files.\n\n\n\n\n\n","category":"function"},{"location":"pages/api_reference/#LibZip.ZipTools.zip_add_dir!","page":"API Reference","title":"LibZip.ZipTools.zip_add_dir!","text":"zip_add_dir!(zip::ZipArchive, dirname::String; flags::UInt32 = LIBZIP_FL_OVERWRITE)\n\nAdd a directory to a zip archive by the dirname, which will be created if it does not exist yet or overwritten if it does exist.\n\nSee also Add file flags section.\n\n\n\n\n\n","category":"function"},{"location":"pages/api_reference/#LibZip.ZipTools.zip_get_file_info","page":"API Reference","title":"LibZip.ZipTools.zip_get_file_info","text":"zip_get_file_info(zip::ZipArchive, filename::String; flags::UInt32 = LIBZIP_FL_ENC_GUESS)\nzip_get_file_info(zip::ZipArchive, index::Int; flags::UInt32 = LIBZIP_FL_ENC_GUESS)\n\nReturn information about the filename in a zip archive.\n\nSee also File info flags section.\n\n\n\n\n\n","category":"function"},{"location":"pages/api_reference/#Base.length","page":"API Reference","title":"Base.length","text":"length(zip::ZipArchive, flags::UInt32 = LIBZIP_FL_ENC_GUESS)\n\nReturn the number of files in zip archive.\n\nSee also Read file flags section.\n\n\n\n\n\n","category":"function"}]
}
