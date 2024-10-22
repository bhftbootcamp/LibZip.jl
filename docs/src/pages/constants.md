# Constants

## [Compression methods](@id compression_methods)

- `LIBZIP_CM_DEFAULT` (`-1`): Similar to `Deflate`.
- `LIBZIP_CM_STORE` (`0`): Store the file uncompressed.
- `LIBZIP_CM_SHRINK` (`1`): Shrunk.
- `LIBZIP_CM_REDUCE_1` (`2`): Reduced with factor `1`.
- `LIBZIP_CM_REDUCE_2` (`3`): Reduced with factor `2`.
- `LIBZIP_CM_REDUCE_3` (`4`): Reduced with factor `3`.
- `LIBZIP_CM_REDUCE_4` (`5`): Reduced with factor `4`.
- `LIBZIP_CM_IMPLODE` (`6`): Imploded.
- `LIBZIP_CM_DEFLATE` (`8`): Deflated.
- `LIBZIP_CM_DEFLATE64` (`9`): `Deflate64`.
- `LIBZIP_CM_PKWARE_IMPLODE` (`10`): `PKWARE` imploding.
- `LIBZIP_CM_BZIP2` (`12`): Compressed using `BZIP2` algorithm
- `LIBZIP_CM_LZMA` (`14`): `LZMA` (`EFS`).
- `LIBZIP_CM_TERSE` (`18`): Compressed using `IBM TERSE` (new).
- `LIBZIP_CM_LZ77` (`19`): IBM `LZ77` z Architecture (`PFS`).
- `LIBZIP_CM_LZMA2` (`33`)
- `LIBZIP_CM_ZSTD` (`93`): `ZSTD` compressed data.
- `LIBZIP_CM_XZ` (`95`): `XZ` compressed data.
- `LIBZIP_CM_JPEG` (`96`): Compressed `Jpeg` data.
- `LIBZIP_CM_WAVPACK` (`97`): `WavPack` compressed data.
- `LIBZIP_CM_PPMD` (`98`): `PPMd` version `I`, Rev `1`.

## [Encryption methods](@id encryption_methods)

`LIBZIP_EM_NONE` (`0`): Not encrypted
`LIBZIP_EM_TRAD_PKWARE` (`1`): Traditional `PKWARE` encryption
`LIBZIP_EM_AES_128` (`257`): Winzip `AES-128` encryption.
`LIBZIP_EM_AES_192` (`258`): Winzip `AES-192` encryption.
`LIBZIP_EM_AES_256` (`259`): Winzip `AES-256` encryption.

## [Open flags](@id open_flags)

- `LIBZIP_CREATE` (`1`): Create the archive if it does not exist.
- `LIBZIP_EXCL` (`2`): Error if archive already exists.
- `LIBZIP_CHECKCONS` (`4`): Perform additional stricter consistency checks on the archive, and error if they fail.
- `LIBZIP_TRUNCATE` (`8`): If archive exists, ignore its current contents. In other words, handle it the same way as an empty archive.
- `LIBZIP_RDONLY` (`16`): Open archive in read-only mode.

## [File info flags](@id file_info_flags)

- `LIBZIP_FL_ENC_GUESS` (`0`): Guess encoding of name (default). (Only `CP-437` and `UTF-8` are recognized).
- `LIBZIP_FL_NOCASE` (`1`): Ignore case distinctions. (Will only work well if the file names are ASCII.) With this flag, zip_name_locate() will be slow for archives with many files.
- `LIBZIP_FL_NODIR` (`2`): Ignore directory part of file name in archive. With this flag, zip_name_locate() will be slow for archives with many files.
- `LIBZIP_FL_ENC_RAW` (`64`): Compare fname against the unmodified names as they are in the ZIP archive, without converting them to `UTF-8`.
- `LIBZIP_FL_ENC_STRICT` (`128`): Follow the ZIP specification and expect `CP-437` encoded names in the ZIP archive (except if they are explicitly marked as `UTF-8`). Convert them to `UTF-8` before comparing.
- `LIBZIP_FL_ENC_UTF_8` (`2048`): Interpret name as `UTF-8`.
- `LIBZIP_FL_ENC_CP437` (`4096`): Interpret name as code page `437` (`CP-437`).

## [Read file flags](@id read_file_flags)

- `LIBZIP_FL_COMPRESSED` (`4`): Read compressed data.
- `LIBZIP_FL_UNCHANGED` (`8`): Use original data, ignoring changes.

## [Add file flags](@id add_file_flags)

- `LIBZIP_FL_ENC_GUESS` (`0`): Guess encoding of name (default). (Only `CP-437` and `UTF-8` are recognized).
- `LIBZIP_FL_ENC_UTF_8` (`2048`): Interpret name as `UTF-8`.
- `LIBZIP_FL_ENC_CP437` (`4096`): Interpret name as code page `437` (`CP-437`).
- `LIBZIP_FL_OVERWRITE` (`8192`): If file with name exists, overwrite (replace) it.
