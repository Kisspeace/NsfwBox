@echo off

SET script_dir=%~dp0
SET work_dir=%script_dir%..\..\libs
SET download_path=%work_dir%\"script-temp"

cd %work_dir%
MKDIR %download_path%

CALL :curl7z "https://www.sqlite.org/2022/sqlite-dll-win32-x86-3390400.zip" "win32"
CALL :curl7z "https://www.sqlite.org/2022/sqlite-dll-win64-x64-3390400.zip" "win64"

RD /S /Q %download_path%

:curl7z
	cd %download_path%
	curl %~1 --output "archive.zip" 		
	
	cd %work_dir%
	MKDIR %~2 && cd %~2
	7z e %download_path%\archive.zip 
	cd %work_dir%
EXIT /B 0


EXIT /B 0

