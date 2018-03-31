
/''
 ' @requires sys_v0.1.0
 ' @requires console_v0.1.0
 ' @requires fault_v0.1.0
 ' @requires error-handling_v0.1.0
 ' @requires tester_v0.1.0
 '/

#include once "module.bi"
#include once "errors.bi"
#include once "test.bi"

/''
 ' @namespace Default
 ' @version 0.1.0
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
	dim as Tester.Interface ptr _otherTester = _module->require("tester_v0.1.0")

	_console->logMessage("Loading versioned tester module... " & _otherTester)
	_throwDefaultGeneralError("99992v67nwte97vt6gwn47sergfniseg6", __FILE__, __LINE__)

	return true
end function

/''
 ' Standard test runner for modules.
 ' @function test
 ' @param {any ptr} describeFn
 ' @returns {short}
 '/
function test cdecl (describeFn as any ptr) as short
	dim as Tester.describeCallback describePtr = describeFn
	dim as short result = true

	result = result andalso describePtr ("The Default module", @Default.testCreate)

	return result
end function

end namespace
