@echo off

echo Release tag: %~1 

SET tag=%~1
SET script_dir=%~dp0
SET project_dir=%script_dir%..\..\
SET work_dir=%project_dir%\release
SET archivedir=%work_dir%\NsfwBox
SET tool="C:\Program Files\7-Zip\7zG.exe"

MKDIR %work_dir%
cd %work_dir%

CALL :pack Win32 ins32

EXIT /B 0

:pack
	MKDIR %archivedir%
	ROBOCOPY /S %project_dir%\assets\themes %archivedir%\themes
	COPY %project_dir%\%~1\Release\NsfwBox.exe %archivedir%
	COPY %project_dir%\LICENSE.md %archivedir%
	COPY %project_dir%\libs\%~1\*.dll %archivedir%
	SET filename=Kisspeace.NsfwBox-%~2.%tag%.exe
	%tool% a -sfx "%filename%" "%archivedir%"
	RD /S /Q %archivedir%
EXIT /B 0