
@ECHO OFF

ECHO Starting Meld Core build...
ECHO.

fbc -mt -C "./src/fb/tester/tester.bas" -x "./tester.exe"

IF %ERRORLEVEL% NEQ 0 (
	ECHO.
	ECHO Test compilation failed, build terminated
	EXIT /B 1
)
 
ECHO.

tester

IF %ERRORLEVEL% NEQ 0 (
	ECHO.
	ECHO Test failed, build terminated
	EXIT /B 1
)
 
ECHO.
ECHO Building Meld Core...

fbc -mt -C "./src/fb/meld/meld.bas" -x "./meld.exe"

IF %ERRORLEVEL% NEQ 0 (
	ECHO.
	ECHO Build failed
	EXIT /B 1
)
 
ECHO.
ECHO Build successful!
