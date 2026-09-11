@echo off
setlocal

set Input=
set InputAttributes=
set InputDirectory=
set InputExtension=

set PrefixLength=
set Remaining=
set Count=

set CurrentFile=
set ShortName=
set BeforeSize=
set AfterSize=
set BeforeKilobytes=
set AfterKilobytes=
set SavedBytes=

set "PATH=%PATH%;%~dp0encoders"

set "Input=%~1"

if "%Input%" == "" set "Input=%CD%"

for %%I in ("%Input%") do (
  set "InputAttributes=%%~aI"
  set "InputDirectory=%%~dpI"
  set "InputExtension=%%~xI"
)

if not defined InputAttributes (
  echo Error: "%Input%" not found.
  goto end
)

REM Find out how many leading characters to trim
REM Removes ancestor pathnames for nicer labels
set "Remaining=%InputDirectory%"
set "PrefixLength=0"

:measure_prefix

if not defined Remaining goto prefix_measured

set "Remaining=%Remaining:~1%"
set /a "PrefixLength+=1"

goto measure_prefix

:prefix_measured

if /i "%InputAttributes:~0,1%" == "d" goto folder

:file

if /i not "%InputExtension%" == ".png" (
  echo Error: "%Input%" is not a .png file.
  goto end
)

for %%F in ("%Input%") do set "CurrentFile=%%~fF"

call :optimize

goto end

:folder

set "Count=0"

for /r "%Input%" %%F in (*.png) do set /a "Count+=1"

echo Found %Count% .png file(s).

for /r "%Input%" %%F in (*.png) do (
  set "CurrentFile=%%~fF"
  call :optimize
)

goto end

:optimize

REM The file name arrives in CurrentFile rather than as an argument.
REM Call strips percent signs from pathnames because of second expansion.
REM Delayed expansion lets PrefixLength be used as a substring offset.
setlocal enabledelayedexpansion

set "ShortName=!CurrentFile:~%PrefixLength%!"

for %%F in ("!CurrentFile!") do set "BeforeSize=%%~zF"
set /a "BeforeKilobytes=(BeforeSize + 1023) / 1024"

echo.
echo Processing: "!ShortName!"
echo Before: !BeforeKilobytes!KB

oxipng -o max --zopfli --zi 500 --ziwi 20 --alpha --strip safe --preserve --quiet "!CurrentFile!"

if errorlevel 1 (
  echo Error: oxipng failed on "!ShortName!".
  endlocal
  goto :eof
)

ect -9 --pal_sort=10 --mt-deflate -keep -quiet "!CurrentFile!"

if errorlevel 1 (
  echo Error: ect failed on "!ShortName!".
  endlocal
  goto :eof
)

for %%F in ("!CurrentFile!") do set "AfterSize=%%~zF"
set /a "AfterKilobytes=(AfterSize + 1023) / 1024"
set /a "SavedBytes=BeforeSize - AfterSize"

echo After: !AfterKilobytes!KB (saved !SavedBytes! bytes)

endlocal

goto :eof

:end
