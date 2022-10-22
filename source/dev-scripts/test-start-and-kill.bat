@echo off

SET script_dir=%~dp0
SET project_dir=%script_dir%..\..

SET target=%project_dir%\Win32\Release\NsfwBox.exe

:TEST
	START %target%
	timeout 2
	taskkill /im NsfwBox.exe
GOTO TEST