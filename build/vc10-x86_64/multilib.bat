@echo off
if "%VS100COMNTOOLS%" == "" (
  msg "%username%" "Visual Studio 10 not detected"
  exit 1
)

@mkdir 10bit
@mkdir 8bit

@cd 10bit
if not exist x265.sln (
  cmake  -G "Visual Studio 10 Win64" ../../../source -DHIGH_BIT_DEPTH=ON -DEXPORT_C_API=OFF -DENABLE_SHARED=OFF -DENABLE_CLI=OFF
)
if exist x265.sln (
  call "%VS100COMNTOOLS%\..\..\VC\vcvarsall.bat"
  MSBuild /property:Configuration="Release" x265.sln
  copy/y Release\x265-static.lib ..\8bit\x265-static-main10.lib
)
@cd ..

@cd 8bit
if not exist x265-static-main10.lib (
  msg "%username%" "10bit build failured"
  exit 1
)
if not exist x265.sln (
  cmake  -G "Visual Studio 10 Win64" ../../../source -DHIGH_BIT_DEPTH=OFF -DEXPORT_C_API=OFF -DENABLE_SHARED=OFF -DENABLE_CLI=ON -DEXTRA_LIB=x265-static-main10.lib -DEXTRA_LINK_FLAGS="/FORCE:MULTIPLE"
)
if exist x265.sln (
  call "%VS100COMNTOOLS%\..\..\VC\vcvarsall.bat"
  MSBuild /property:Configuration="Release" x265.sln
  copy/y Release\x265.exe ..
)
@cd ..
