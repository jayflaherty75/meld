
/''
 ' @requires console
 ' @requires fault
 ' @requires error-handling
 ' @requires tester
 '/

#include once "../../../../../modules/headers/constants/constants-v1.bi"
#include once "module.bi"
#include once "errors.bi"
#include once "test.bi"

/''
 ' @namespace Default
 '/
namespace Default

/''
 ' Application main routine.
 ' @function startup
 ' @returns {short}
 ' @throws {GeneralError}
 '/
function startup cdecl () as short
	_console->logMessage("Starting default module")

	return true
end function

/''
 ' Application main routine.
 ' @function shutdown
 ' @returns {short}
 '/
function shutdown cdecl () as short
	_console->logMessage("Shutting down default module")

	return true
end function

/''
 ' Run or update an instance or pass NULL to run statically.
 ' @function update
 ' @param {any ptr} instancePtr
 ' @returns {short}
 '/
function update cdecl (instancePtr as any ptr) as short
	_console->logMessage("Updating...")
	_throwDefaultGeneralError("99992v67nwte97vt6gwn47sergfniseg6", __FILE__, __LINE__)

	return true
end function

/''
 ' Standard test runner for modules.
 ' @function test
 ' @param {Tester.describeCallback} describe
 ' @returns {short}
 '/
function test cdecl (describe as Tester.describeCallback) as short
	dim as short result = true

	result = result andalso describe ("The Default module", @Default.testCreate)

	return result
end function

end namespace
