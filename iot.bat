@echo off
setlocal enabledelayedexpansion

set InName=
set InType=
set OutType=

set Quality=
set Lossless=

set Size=
set Score=

set "PATH=%PATH%;%~dp0ssimulacra2;%~dp0encoders";

if "%~1" == "" (
  echo Argument 1 needs to be keyword "avif", "webp" or "jxl".
  echo Argument 2 needs to be keyword "lossless" or an integer from 0 to 100.
  echo Argument 3 can be the filename of a PNG/JPG image, otherwise the first PNG/JPG image in the current directory is used.
  goto end
)

set "OutType=%~1"

if "%~2" == "" (
  echo Error: Argument 2 needs to be keyword "lossless" or an integer from 0 to 100.
  goto end
)

set "Quality=%~2"

if "%~2" == "lossless" (
  set "Quality=100"
  
  if "%OutType%" == "avif" ( set "Lossless=--lossless" )
  if "%OutType%" == "webp" ( set "Lossless=-lossless" )
)

if not "%~3" == "" (
  if not exist "%~3" (
    echo Error: "%~3" not found.
    goto end
  )
  
  for %%F in ("%~3") do (
    set "InName=%%~nF"
    set "InType=%%~xF"
  )
  
  if /I "!InType!" == ".png" ( goto found )
  if /I "!InType!" == ".jpg" ( goto found )
  
  echo Error: "%~3" does not have the extension .png or .jpg.
  goto end
)

for %%F in (*.png *.jpg) do (
  set "InName=%%~nF"
  set "InType=%%~xF"
  goto found
)

echo Error: No PNG/JPG image found in current directory.
goto end

:found

set "Input=%InName%%InType%"
set "Output=%InName%.%OutType%"

echo "%Input%" found, coverting to %OutType%.

if not exist "history" ( mkdir "history" )

if not exist "history" (
  echo Error: Unable to create history folder
  goto end
)

del "%Output%" > nul 2>&1
del "%Output%.png" > nul 2>&1

if "%OutType%" == "avif" (
  avifenc -q %Quality% %Lossless% -s 0 --sharpyuv "%Input%" "%Output%" > nul 2>&1
  avifdec "%Output%" "%InName%.%OutType%.png" > nul 2>&1
)

if "%OutType%" == "webp" (
  cwebp -q %Quality% %Lossless% -m 6 -pass 10 -mt -sharp_yuv "%Input%" -o "%Output%" > nul 2>&1
  dwebp "%Output%" -o "%Output%.png" > nul 2>&1
)

if "%OutType%" == "jxl" (
  cjxl -q %Quality% -e 10 "%Input%" "%Output%" > nul 2>&1
  djxl "%Output%" "%Output%.png" > nul 2>&1
)

if not exist "%Output%" (
  echo Error: Failed to create "%Output%".
  goto end
)

if not exist "%Output%.png" (
  echo Error: Failed to create "%Output%.png".
  goto end
)

for /f %%F in ('ssimulacra2 "%Input%" "%Output%.png"') do ( set "Score=%%F" )

del "%Output%.png" > nul

if not defined Score (
  echo Error: Failed to generate score for "%Output%".
  goto end
)

set "Score=!Score:~0,6!"

for %%F in ("%Output%") do ( set "Size=%%~zF" )

set /a Size=(Size + 1023) / 1024

if %Size% LSS 1 set Size=1

copy "%InName%.%OutType%" "./history/%InName%_(Q=%~2)(S=%Score%).%OutType%" /Y > nul 2>&1

if not exist "./history/%InName%_(Q=%~2)(S=%Score%).%OutType%" (
  echo "Warning: Unable to write to history folder."
)

echo "%Output%" with quality %~2 and size %Size%KB has score %Score%.
echo.

:end
