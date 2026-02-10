@echo off
echo ================================
echo        ODIN HFT BUILD
echo ================================

set ODIN=odin
set PROJECT=OdinHFT
set OUTPUT=bin\%PROJECT%.exe

echo [1] Cleaning...
if exist bin\*.exe del bin\*.exe
if exist *.pdb del *.pdb
if exist *.ilk del *.ilk

echo [2] Compiling with optimizations...
%ODIN% build src ^
    -out:%OUTPUT% ^
    -opt:3 ^
    -microarch:native ^
    -target:windows_amd64 ^
    -disable-assert ^
    -debug:none ^
    -collection:shared=.\shared

if errorlevel 1 (
    echo  Build failed!
    pause
    exit /b 1
)

echo  Build successful: %OUTPUT%
dir bin\*.exe
pause
