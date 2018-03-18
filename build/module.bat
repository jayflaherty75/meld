@echo off

set moduleName=%1
set moduleType=%2
set moduleSystem=%3

if "%2"=="" (
    SET moduleType=lib
)

if "%3"=="" (
    SET moduleSystem=shared
)

type "src\fb\%moduleSystem%\%moduleType%\%moduleName%\%moduleName%.bas" | build\parse-fb %moduleName% > modules\definitions\%moduleName%.xml

call build\header %moduleName%

rem TODO: Generate dependency scripts

xsltproc -o src\fb\%moduleSystem%\%moduleType%\%moduleName%\%moduleName%.bi build\templates\module-fb.xslt modules\definitions\%moduleName%.xml

xsltproc -o src\fb\%moduleSystem%\%moduleType%\%moduleName%\%moduleName%.bi build\templates\include-fb.xslt modules\definitions\%moduleName%.xml

fbc -mt -s console -dylib -export "src\fb\%moduleSystem%\%moduleType%\%moduleName%\%moduleName%.bas" -x "modules\%moduleName%.dll"

IF %ERRORLEVEL% NEQ 0 (
	ECHO.
	ECHO Failed to compile %moduleName% module, build terminated
	EXIT /B 1
)
 
rem TODO: Call dependency scripts
