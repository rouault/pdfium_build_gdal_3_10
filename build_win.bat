REM Prerequiste: download https://storage.googleapis.com/chrome-infra/depot_tools.zip, and extract it 

set PATH=%CD%\depot_tools;%PATH%
set DEPOT_TOOLS_WIN_TOOLCHAIN=0
set DEPOT_TOOLS_URL=https://chromium.googlesource.com/chromium/tools/depot_tools.git
set PDFIUM_URL=https://pdfium.googlesource.com/pdfium.git
set REV=chromium/4627
set INSTALL_DIR=%CD%\install

REM Checkout
call gclient config --unmanaged "%PDFIUM_URL%"
call gclient sync --revision="%REV%"

REM Build
cd pdfium
call git apply --ignore-whitespace ..\code.patch
cd build
call git apply --ignore-whitespace ..\..\build_win.patch
cd ..
mkdir out
cd out
mkdir Release
cd ..
copy ..\args_release_win.gn out\Release\args.gn
call gn gen out\Release
call ninja -C out\Release pdfium

REM Install headers

mkdir %INSTALL_DIR%
mkdir %INSTALL_DIR%\include\pdfium
mkdir %INSTALL_DIR%\include\pdfium\public
xcopy /Y /R public %INSTALL_DIR%\include\pdfium\public
FOR %%X IN (build constants fpdfsdk core\fxge core\fxge\agg core\fxge\dib core\fpdfdoc core\fpdfapi\parser core\fpdfapi\page core\fpdfapi\render core\fxcrt third_party\agg23 third_party\base third_party\base\allocator\partition_allocator third_party\base\numerics) DO (
  mkdir %INSTALL_DIR%\include\pdfium\%%X
  copy %%X\*.h %INSTALL_DIR%\include\pdfium\%%X
)

REM Install library
mkdir %INSTALL_DIR%\lib
copy out\Release\obj\pdfium.lib %INSTALL_DIR%\lib

cd ..
