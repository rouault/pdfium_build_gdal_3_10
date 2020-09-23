#!/usr/bin/env bash

set -eu

DEPOT_TOOLS_URL="https://chromium.googlesource.com/chromium/tools/depot_tools.git"
DEPOT_TOOLS_DIR="$PWD/depot_tools"
PDFIUM_URL="https://pdfium.googlesource.com/pdfium.git"
PDFIUM_DIR="$PWD/pdfium"
REV="chromium/3922"
PATCH_1="$PWD/code.patch"
PATCH_2="$PWD/build_linux.patch"
ARGS="$PWD/args_release_linux.gn"
BUILD_DIR="$PDFIUM_DIR/output/Release"
INSTALL_DIR="$PWD/install"

if [ ! -d "$DEPOT_TOOLS_DIR" ]; then
  git clone "$DEPOT_TOOLS_URL" "$DEPOT_TOOLS_DIR"
else 
  (cd "$DEPOT_TOOLS_DIR"; git checkout master; git pull)
fi
(cd "$DEPOT_TOOLS_DIR"; git checkout 8b95534d333ce22acd9e30d972d09d323950483c)
export PATH="$DEPOT_TOOLS_DIR:$PATH"

# Checkout sources
# From https://pdfium.googlesource.com/pdfium/
gclient config --unmanaged "$PDFIUM_URL"
gclient sync --revision="$REV"

cd "$PDFIUM_DIR"
git apply "$PATCH_1"
(cd build; git apply "$PATCH_2")

# Build
mkdir -p "$BUILD_DIR"
cp "$ARGS" "$BUILD_DIR/args.gn"
gn gen "$BUILD_DIR"
ninja -C "$BUILD_DIR" pdfium_all

# Install headers
INCLUDE_DIR="$INSTALL_DIR/include/pdfium"
mkdir -p "$INCLUDE_DIR"
cp -r public "$INCLUDE_DIR"
HEADER_SUBDIRS="build fpdfsdk core/fxge core/fxge/agg core/fxge/dib core/fpdfdoc core/fpdfapi/parser core/fpdfapi/page core/fpdfapi/render core/fxcrt third_party/agg23 third_party/base third_party/base/allocator/partition_allocator third_party/base/numerics"
for subdir in $HEADER_SUBDIRS; do
    mkdir -p "$INCLUDE_DIR/$subdir"
    cp "$subdir"/*.h "$INCLUDE_DIR/$subdir"
done
# Install library
mkdir -p "$INSTALL_DIR/lib"
cp "$BUILD_DIR/obj/libpdfium.a" "$INSTALL_DIR/lib"
