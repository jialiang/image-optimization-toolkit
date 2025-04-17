@echo off
setlocal enabledelayedexpansion

set Name=
set Extension=
set Format=%~1
set Quality=%~2
set Lossless=
set Score=

if "%~1" == "" (
  echo Argument 1 needs to be keyword avif, webp or jxl.
  echo Argument 2 needs to be keyword lossless or an integer from 0 to 100.
  echo Argument 3 can be the filename of a PNG/JPG image, otherwise the first PNG/JPG image found in current directory is used.
  goto end
)

if "%~2" == "" (
  echo Error: Argument 2 needs to be keyword "lossless" or an integer between 0 and 100.
  goto end
)

if "%~2" == "lossless" (
  set Quality=100
  
  if "%Format%" == "avif" ( set Lossless="--lossless" )
  if "%Format%" == "webp" ( set Lossless="-lossless" )
)

if not "%~3" == "" (
  if exist "%~3" (
    for %%F in ("%~3") do set Name=%%~nF
    
    if /I "%~x3" == ".png" (
      set Extension=png
      goto found
    )
    
    if /I "%~x3" == ".jpg" (
      set Extension=jpg
      goto found
    )
    
    echo Error: "%~3" does not have the extension .png or .jpg.
    goto end
  )
  
  echo Error: "%~3" not found.
  goto end
)

for %%F in (*.png) do (
  set Name=%%~nF
  set Extension=png
  goto found
)

for %%F in (*.jpg) do (
  set Name=%%~nF
  set Extension=jpg
  goto found
)

if not defined Name (
  echo Error: No PNG/JPG image found in current directory.
  goto end
)

:found

echo "%Name%.%Extension%" found, coverting to %Format%.

del "%Name%.%Format%" > nul 2>&1
del "%Name%.%Format%.%Extension%" > nul 2>&1

if "%Format%" == "avif" (
  avifenc -q %Quality% %Lossless% -s 0 --sharpyuv "%Name%.%Extension%" "%Name%.avif" > nul 2>&1
)

if "%Format%" == "webp" (
  cwebp -q %Quality% %Lossless% -m 6 -pass 10 -mt -sharp_yuv "%Name%.%Extension%" -o "%Name%.webp" > nul 2>&1
)

if "%Format%" == "jxl" (
  cjxl -q %Quality% -e 10 "%Name%.%Extension%" "%Name%.jxl" > nul 2>&1
)

if not exist "%Name%.%Format%" (
  echo Error: Failed to create "%Name%.%Format%".
  goto end
)

if "%Format%" == "avif" (
  avifdec "%Name%.avif" "%Name%.avif.png" > nul 2>&1
)

if "%Format%" == "webp" (
  dwebp "%Name%.webp" -o "%Name%.webp.png" > nul 2>&1
)

if "%Format%" == "jxl" (
  djxl "%Name%.jxl" "%Name%.jxl.png" > nul 2>&1
)

if not exist "%Name%.%Format%.png" (
  echo Error: Failed to create "%Name%.%Format%.png".
  goto end
)

for /f %%i in ('ssimulacra2\ssimulacra2.exe "%Name%.%Extension%" "%Name%.%Format%.png"') do (
  set Score=%%i
)

del "%Name%.%Format%.png" > nul

if not defined Score (
  echo Error: Failed to generate score for "%Name%.%Format%".
  goto end
)

echo "%Name%.%Format%" with quality %~2 has score %Score%.
echo.

:end
