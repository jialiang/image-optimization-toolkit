@echo off
setlocal enabledelayedexpansion

set InName=
set InType=
set OutType=%~1

set Quality=%~2
set Lossless=

set Size=
set Score=

set PATH=%PATH%;%~dp0ssimulacra2;%~dp0encoders;

if "%~1" == "" (
  echo Argument 1 needs to be keyword avif, webp or jxl.
  echo Argument 2 needs to be keyword lossless or an integer from 0 to 100.
  echo Argument 3 can be the filename of a PNG/JPG image, otherwise the first PNG/JPG image found in current directory is used.
  goto end
)

if "%~2" == "" (
  echo Error: Argument 2 needs to be keyword "lossless" or an integer from 0 to 100.
  goto end
)

if "%~2" == "lossless" (
  set Quality=100
  
  if "%OutType%" == "avif" ( set Lossless="--lossless" )
  if "%OutType%" == "webp" ( set Lossless="-lossless" )
)

if not "%~3" == "" (
  if exist "%~3" (
    for %%F in ("%~3") do set InName=%%~nF
    
    if /I "%~x3" == ".png" (
      set InType=png
      goto found
    )
    
    if /I "%~x3" == ".jpg" (
      set InType=jpg
      goto found
    )
    
    echo Error: "%~3" does not have the extension .png or .jpg.
    goto end
  )
  
  echo Error: "%~3" not found.
  goto end
)

for %%F in (*.png) do (
  set InName=%%~nF
  set InType=png
  goto found
)

for %%F in (*.jpg) do (
  set InName=%%~nF
  set InType=jpg
  goto found
)

if not defined InName (
  echo Error: No PNG/JPG image found in current directory.
  goto end
)

:found

echo "%InName%.%InType%" found, coverting to %OutType%.

if not exist "history" ( mkdir "history" )

if not exist "history" (
  echo Error: Unable to create history folder
  goto end
)

del "%InName%.%OutType%" > nul 2>&1
del "%InName%.%OutType%.png" > nul 2>&1

if "%OutType%" == "avif" (
  avifenc -q %Quality% %Lossless% -s 0 --sharpyuv "%InName%.%InType%" "%InName%.avif" > nul 2>&1
)

if "%OutType%" == "webp" (
  cwebp -q %Quality% %Lossless% -m 6 -pass 10 -mt -sharp_yuv "%InName%.%InType%" -o "%InName%.webp" > nul 2>&1
)

if "%OutType%" == "jxl" (
  cjxl -q %Quality% -e 10 "%InName%.%InType%" "%InName%.jxl" > nul 2>&1
)

if not exist "%InName%.%OutType%" (
  echo Error: Failed to create "%InName%.%OutType%".
  goto end
)

if "%OutType%" == "avif" (
  avifdec "%InName%.%OutType%" "%InName%.%OutType%.png" > nul 2>&1
)

if "%OutType%" == "webp" (
  dwebp "%InName%.%OutType%" -o "%InName%.%OutType%.png" > nul 2>&1
)

if "%OutType%" == "jxl" (
  djxl "%InName%.%OutType%" "%InName%.%OutType%.png" > nul 2>&1
)

if not exist "%InName%.%OutType%.png" (
  echo Error: Failed to create "%InName%.%OutType%.png".
  goto end
)

for /f %%i in ('ssimulacra2 "%InName%.%InType%" "%InName%.%OutType%.png"') do (
  set Score=%%i
)

del "%InName%.%OutType%.png" > nul

if not defined Score (
  echo Error: Failed to generate score for "%InName%.%OutType%".
  goto end
)

set "Score=!Score:~0,6!"

for %%I in ("%InName%.%OutType%") do set "Size=%%~zI"

set /a Size=(Size + 1023) / 1024

if %Size% LSS 1 set Size=1

copy "%InName%.%OutType%" "./history/%InName%_(Q=%~2)(S=%Score%).%OutType%" /Y > nul 2>&1

if not exist "./history/%InName%_(Q=%~2)(S=%Score%).%OutType%" (
  echo "Warning: Unable to write to history folder."
)

echo "%InName%.%OutType%" with quality %~2 and size %Size%KB has score %Score%.
echo.

:end
