V8 Engine JavaScript libraries
==============================
The purpose of this project is to deliver the V8 engine pre-compiled and pre-packaged for all supported platforms so
that it may be easily dropped into projects for immediate use. It will also come shipped with all the Makefiles used to
compile the libraries so that users may inspect the options used as well as re-compile the libraries if they see it
necessary.

Branching & Tagging
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
 * Linux (64bit)
 * MacOSX (ia32 static, x64 shared, x64 static)
 * Windows (ia32 shared, ia32 static, x64 shared, x64 static)

NOTES:
 * Unless jail-broken, IOS does not allow the creation of executable memory pages, on which V8 heavily relies. As such
   the V8 team does not directly support IOS and as a result we will not support IOS for the time being.
 * Similar to IOS, WindowsPhone does not allow the creation of executable memory pages so same result as above.
 * ia32 shared debug build is currently broken for MacOSX on all versions. Since we need both release debug and release
   ia32 shared build is ignored till this is fixed by the v8 team.

Licenses
--------
All original code and scripts within the project are subject to the [MIT license](LICENSE)

All dependencies and their compiled binary files are subject to their original respective licenses as found in their
respective repositories.