V8 Engine JavaScript libraries
==============================
The purpose of this project is to deliver the V8 engine pre-compiled and pre-packaged for all supported platforms so
that it may be easily dropped into projects for immediate use. It will also come shipped with all the Makefiles used to
compile the libraries so that users may inspect the options used as well as re-compile the libraries if they see it
necessary.

Branches & Tags
---------------
This project will be tagged according to the V8 version that was compiled.

Compile options
---------------
For performance and immediate production use reasons, all libraries are compiled using the default release options
present in the V8 Makefiles.

Compression
-----------
Due to the GitHub file size limitations (100MB), the compiled static library files will be compressed using gzip and
archive will be split up into files no bigger than 50MB.

The headers however, due to their small size and text nature will remain uncompressed.

To decompress static library files, run:
```
make decompress
```

Platforms
---------
The following platforms are supported by this project and will be present within their respective build folder:
 * Android (arm)
 * IOS (arm)
 * Linux (64bit)
 * MacOSX (64bit)
 * Windows (ia32 shared, ia32 static, x64 shared, x64 static)

Licenses
--------
All original code and scripts within the project are subject to the [MIT license](LICENSE)

All dependencies and their compiled binary files are subject to their original respective licenses as found in their
respective repositories.