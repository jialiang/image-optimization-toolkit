@echo off
setlocal

set InName=
set InType=
set OutType=

set Quality=
set Lossless=

set Size=
set Score=

set "PATH=%PATH%;%~dp0ssimulacra2;%~dp0encoders";

if "%~1" == "" (
  echo Argument 1 needs to be keyword "avif", "webp", "jxl", "jpg" or "jpeg".
  echo Argument 2 needs to be keyword "lossless" or an integer from 0 to 100.
  echo JPEG has no lossless mode, so "jpg" only accepts an integer from 1 to 100.
  echo Argument 3 can be the filename of a PNG/JPG image, otherwise the first PNG/JPG image in the current directory is used.
  goto end
)

set "OutType=%~1"

if "%OutType%" == "jpeg" ( set "OutType=jpg" )

set "IsSupportedType="

if "%OutType%" == "avif" ( set "IsSupportedType=1" )
if "%OutType%" == "webp" ( set "IsSupportedType=1" )
if "%OutType%" == "jxl" ( set "IsSupportedType=1" )
if "%OutType%" == "jpg" ( set "IsSupportedType=1" )

if not defined IsSupportedType (
  echo Error: Argument 1 needs to be keyword "avif", "webp", "jxl", "jpg" or "jpeg".
  goto end
)

if "%~2" == "" (
  echo Error: Argument 2 needs to be keyword "lossless" or an integer from 0 to 100.
  goto end
)

set "Quality=%~2"

if "%~2" == "lossless" (
  if "%OutType%" == "jpg" (
    echo Error: JPEG has no lossless mode. Argument 2 needs to be an integer from 1 to 100.
    goto end
  )

  set "Quality=100"

  if "%OutType%" == "avif" ( set "Lossless=--lossless" )
  if "%OutType%" == "webp" ( set "Lossless=-lossless" )
) else (
  set "InvalidNumber="

  for /f "delims=0123456789" %%A in ("%Quality%") do set "InvalidNumber=%%A"

  if defined InvalidNumber (
    echo Error: Argument 2 needs to be keyword "lossless" or an integer from 0 to 100.
    goto end
  )
  if %Quality% LSS 0 (
    echo Error: Argument 2 needs to be keyword "lossless" or an integer from 0 to 100.
    goto end
  )
  if %Quality% GTR 100 (
    echo Error: Argument 2 needs to be keyword "lossless" or an integer from 0 to 100.
    goto end
  )

  if "%OutType%" == "jpg" (
    if %Quality% LSS 1 (
      echo Error: cjpegli rejects quality 0. Argument 2 needs to be an integer from 1 to 100.
      goto end
    )
  )
)

if "%~3" == "" ( goto search_folder )

if not exist "%~3" (
  echo Error: "%~3" not found.
  goto end
)

for %%F in ("%~3") do (
  set "InName=%%~nF"
  set "InType=%%~xF"
)

if /I "%InType%" == ".png" ( goto found )
if /I "%InType%" == ".jpg" ( goto found )
if /I "%InType%" == ".jpeg" ( goto found )

echo Error: "%~3" does not have the extension .png, .jpg or .jpeg.
goto end

:search_folder

for %%F in (*.png *.jpg *.jpeg) do (
  set "InName=%%~nF"
  set "InType=%%~xF"
  goto found
)

echo Error: No PNG/JPG image found in current directory.
goto end

:found

set "Input=%InName%%InType%"
set "Output=%InName%.%OutType%"

if /I "%Input%" == "%Output%" (
  echo Error: "%Input%" is already a %OutType% file, converting it would overwrite the input.
  goto end
)

REM SSIMULACRA 2 supports JPG, so the jpg output is scored as-is.
set "Scored=%Output%.png"

if "%OutType%" == "jpg" ( set "Scored=%Output%" )

echo "%Input%" found, converting to %OutType%.

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

if "%OutType%" == "jpg" (
  cjpegli "%Input%" "%Output%" -q %Quality% -p 2 > nul 2>&1
)

if not exist "%Output%" (
  echo Error: Failed to create "%Output%".
  goto end
)

if not exist "%Scored%" (
  echo Error: Failed to create "%Scored%".
  goto end
)

for /f %%F in ('ssimulacra2 "%Input%" "%Scored%"') do ( set "Score=%%F" )

if not "%Scored%" == "%Output%" ( del "%Scored%" > nul )

if not defined Score (
  echo Error: Failed to generate score for "%Output%".
  goto end
)

set "Score=%Score:~0,6%"

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
