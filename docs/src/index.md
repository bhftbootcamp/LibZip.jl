# LibZip.jl

LibZip is a convenient wrapper around [libzip](https://github.com/nih-at/libzip) for reading, creating, and modifying ZIP and ZIP64 archives. It also supports file encryption and decryption.

## Installation

To install LibZip, simply use the Julia package manager:

```julia
] add LibZip
```

## Usage

### 🤐 Create a zip archive, compress a file, and encrypt it:

```julia
using LibZip

# Create a new zip archive
archive = ZipArchive(; flags = LIBZIP_CREATE)

# Add some text data to a file inside the archive and compress it
write(archive, "greetings.txt", b"Hello, from LibZip!")
zip_compress_file!(archive, "greetings.txt", LIBZIP_CM_DEFLATE; compression_level = 1)

# Encrypt the file inside the archive
zip_encrypt_file!(archive, "greetings.txt", "P@ssw0rd123!"; method = LIBZIP_EM_AES_128)

# Write the zip archive to a specified file path
write("secure_archive.zip", archive)

# Close the archive to finalize changes
close(archive)
```

### 🔓 Extract and decrypt files:

```julia
using LibZip

# Read the zip archive from disk
zip_data = read("secure_archive.zip")

# Open the archive for reading
archive = ZipArchive(zip_data; flags = LIBZIP_RDONLY)

# Extract and decrypt the file, providing the password
read(archive, "greetings.txt"; password = "P@ssw0rd123!")

# Set a default password for all files
julia> zip_default_password!(archive, "P@ssw0rd123!")
true

# Iterate through the archive and read files with the default password
# The file contents are decoded from bytes to a string for display
julia> for item in archive
           println((item.name, String(item.body)))
       end
("greetings.txt", "Hello, from LibZip!")
```

### 📂 Reading and Modifying an Existing Archive:

```julia
using LibZip

# Open an existing zip archive for reading and modification
archive = zip_open("secure_archive.zip"; flags = LIBZIP_CREATE)

# Add or modify files inside the archive
write(archive, "new_file.txt", b"More content!")
zip_compress_file!(archive, "new_file.txt", LIBZIP_CM_DEFLATE; compression_level = 1)

# Close the archive after modification
close(archive)
```
