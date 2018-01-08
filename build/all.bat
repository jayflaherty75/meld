
@ECHO OFF

ECHO Starting Meld Core build...
ECHO.

fbc -mt -c "./src/fb/meld/lib/fault/fault.bas"

IF %ERRORLEVEL% NEQ 0 (
	ECHO.
	ECHO Failed to compile fault, build terminated
	EXIT /B 1
)
 
fbc -mt -c "./src/fb/shared/lib/bst/bst.bas"

IF %ERRORLEVEL% NEQ 0 (
	ECHO.
	ECHO Failed to compile bst, build terminated
	EXIT /B 1
)
 
fbc -mt -c "./src/fb/shared/lib/identity/identity.bas"

IF %ERRORLEVEL% NEQ 0 (
	ECHO.
	ECHO Failed to compile identity, build terminated
	EXIT /B 1
)
 
fbc -mt -c "./src/fb/shared/lib/iterator/iterator.bas"

IF %ERRORLEVEL% NEQ 0 (
	ECHO.
	ECHO Failed to compile iterator, build terminated
	EXIT /B 1
)
 
fbc -mt -c "./src/fb/shared/lib/list/list.bas"

IF %ERRORLEVEL% NEQ 0 (
	ECHO.
	ECHO Failed to compile list, build terminated
	EXIT /B 1
)
 
fbc -mt -c "./src/fb/shared/lib/paged-array/paged-array.bas"

IF %ERRORLEVEL% NEQ 0 (
	ECHO.
	ECHO Failed to compile paged-array, build terminated
	EXIT /B 1
)
 
fbc -mt -C "./src/fb/tester/tester.bas" -x "./tester.exe" ^
	"./src/fb/meld/lib/fault/fault.o" ^
	"./src/fb/shared/lib/bst/bst.o" ^
	"./src/fb/shared/lib/identity/identity.o" ^
	"./src/fb/shared/lib/iterator/iterator.o" ^
	"./src/fb/shared/lib/list/list.o" ^
	"./src/fb/shared/lib/paged-array/paged-array.o"

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

fbc -mt -C "./src/fb/meld/meld.bas" -x "./meld.exe" ^
	"./src/fb/meld/lib/fault/fault.o" ^
	"./src/fb/shared/lib/bst/bst.o" ^
	"./src/fb/shared/lib/identity/identity.o" ^
	"./src/fb/shared/lib/iterator/iterator.o" ^
	"./src/fb/shared/lib/list/list.o" ^
	"./src/fb/shared/lib/paged-array/paged-array.o"

IF %ERRORLEVEL% NEQ 0 (
	ECHO.
	ECHO Build failed
	EXIT /B 1
)
 
ECHO.
ECHO Build successful!
