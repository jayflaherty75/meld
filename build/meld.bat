
@ECHO OFF

ECHO Starting Meld Core build...
ECHO.

type "src\fb\meld\lib\meld\meld.bas" | build\parse-fb meld > modules\definitions\meld.xml
call build\header meld

fbc -mt -c "./src/fb/meld/lib/module/module.bas"

IF %ERRORLEVEL% NEQ 0 (
	ECHO.
	ECHO Failed to compile module, build terminated
	EXIT /B 1
)
 
ECHO.

ECHO Building Meld Core...

fbc -mt -C "src/fb/meld.bas" -x "meld.exe" ^
	"src/fb/meld/lib/module/module.o"

IF %ERRORLEVEL% NEQ 0 (
	ECHO.
	ECHO Build failed
	EXIT /B 1
)
 
ECHO.
ECHO Build successful!
