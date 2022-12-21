@echo off

SET script_dir=%~dp0
SET project_dir=%script_dir%..\..

ECHO WIndows 32
MKDIR %project_dir%\Win32\Release
ROBOCOPY /S %project_dir%\assets\themes %project_dir%\Win32\Release\themes
COPY %project_dir%\libs\win32\*.dll %project_dir%\Win32\Release\

ECHO WIndows 64
MKDIR %project_dir%\Win64\Release
ROBOCOPY /S %project_dir%\assets\themes %project_dir%\Win64\Release\themes
COPY %project_dir%\libs\win64\*.dll %project_dir%\Win64\Release\

ECHO WIndows 64 debug
MKDIR %project_dir%\Win64\Debug
ROBOCOPY /S %project_dir%\assets\themes %project_dir%\Win64\Debug\themes
COPY %project_dir%\libs\win64\*.dll %project_dir%\Win64\Debug\