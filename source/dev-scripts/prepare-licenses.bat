@echo off
@REM requirements: curl.
SET script_dir=%~dp0
SET project_dir=%script_dir%..\..
SET work_dir=%project_dir%\release\licenses

MKDIR %work_dir%
cd %work_dir%

call :download_license "Alcinoe" "https://raw.githubusercontent.com/MagicFoundation/Alcinoe/master/license.txt"
call :download_license "Kastri" "https://raw.githubusercontent.com/DelphiWorlds/Kastri/master/LICENSE"
call :download_license "zeoslib" "https://sourceforge.net/p/zeoslib/code-0/HEAD/tree/branches/8.0-patches/COPYING?format=raw"
call :download_license "HTMLp" "https://raw.githubusercontent.com/RomanYankovsky/HTMLp/modern/LICENSE"
call :download_license "htmlparser" "https://raw.githubusercontent.com/ying32/htmlparser/master/LICENSE"

echo https://www.sqlite.org/copyright.html>>"SQLite.license.txt"

EXIT /B 0

:download_license
    
    set name=%~1
    SET url=%~2
    SET filename=%name%.license.txt

    SET BORDER="-------------------------------------------------------------"
    echo %BORDER%
    echo "-- DOWNLOADING LICENSE OF %name%"
    echo %BORDER%
    echo ""

    curl %url% >> %filename%

EXIT /B 0