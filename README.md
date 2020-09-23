Build scripts for PDFium
========================

PDFium is an open-source PDF rendering engine: https://pdfium.googlesource.com/pdfium/

This repository contains build scripts for Linux and Windows, to build a custom
patched version of PDFium that can be used with the GDAL PDF driver.
This is a slightly modified version of the PDFium sources, for GDAL needs.

# Linux

Tested with Ubuntu 16.04 x86_64 with development packages for zlib, libjpeg, libpng,
and other development tools (git)

Run ./build_linux.sh.

It will generate the install/ directory with the end products: header files
and libpdfium.a needed to build the GDAL PDF driver

# Windows

Tested with Windows 10, with Visual Studio 2017 community edition, x86_64 build.
The "Debugging Tools for Windows SDK 10" must also be installed.

Run "git clone https://chromium.googlesource.com/chromium/tools/depot_tools.git"
from this repository, which will create a depot_tools subdirectory.

Then run "git checkout 8b95534d333ce22acd9e30d972d09d323950483c" in that
subdirectory.

Run build_win.bat from cmd.exe with the environment variables set for the compiler
you use (VS 2017 or 2019) (or from the "x64 Native tools Command Prompt for VS2017" entry)

It will generate the install/ directory with the end products: header files
and pdfium.lib needed to build the GDAL PDF driver.

# Pre-build binaries

Pre-build binaries may be found at https://github.com/rouault/pdfium_build_gdal_3_1/releases
