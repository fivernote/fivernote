@echo off

cd..
set SCRIPTPATH=%cd%

: top src directory
set fivernotePath="%SCRIPTPATH%\bin\src\github.com\fivernote"

if not exist "%fivernotePath%" mkdir "%fivernotePath%"

: create software link
if exist "%fivernotePath%\fivernote" del /Q "%fivernotePath%\fivernote"
mklink /D "%fivernotePath%\fivernote"  %SCRIPTPATH%

: set GOPATH
set GOPATH="%SCRIPTPATH%\bin"

: run
if %processor_architecture%==x86 (
	"%SCRIPTPATH%\bin\fivernote-windows-386.exe" -importPath github.com/fivernote/fivernote
) else (
	"%SCRIPTPATH%\bin\fivernote-windows-amd64.exe" -importPath github.com/fivernote/fivernote
)
