@echo off
setlocal enabledelayedexpansion

set Name=
set Format=%1
set Quality=%2

for %%F in (*.png) do (
    if not defined Name (
        set Name=%%~nF
        goto choose_format
    )
)

echo No PNG image found.
goto end

:choose_format

echo PNG image found: %Name%.png

if "%Format%"=="avif" goto avif
if "%Format%"=="webp" goto webp
if "%Format%"=="jxl" goto jxl

echo Invalid format: %Format%
goto end

:avif

avifenc -q %Quality% -s 0 --sharpyuv "%Name%.png" "%Name%.avif" > nul
avifdec "%Name%.avif" output.png > nul
goto compare

:webp

cwebp -q %Quality% -m 6 -pass 10 -mt -sharp_yuv "%Name%.png" -o "%Name%.webp" > nul
dwebp "%Name%.webp" -o output.png > nul
goto compare

:jxl

cjxl -q %Quality% -e 10 "%Name%.png" "%Name%.jxl" > nul
djxl "%Name%.jxl" output.png > nul
goto compare

:compare

echo.
echo Score for %Format% with quality %Quality%:
"./ssimulacra2/ssimulacra2.exe" "%Name%.png" output.png
del output.png
goto end

:end
