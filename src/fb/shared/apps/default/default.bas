
/''
 ' @requires constants
 ' @requires module
 ' @requires console
 ' @requires fault
 ' @requires error-handling
 ' @requires tester
 '/

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
 '/
function startup cdecl () as short
	errors.generalError = _fault->getCode("GeneralError")
	_console->logMessage("TEST")
	_throwDefaultGeneralError("99992v67nwte97vt6gwn47sergfniseg6", __FILE__, __LINE__)

	return true
end function

/''
 ' Application main routine.
 ' @function shutdown
 ' @returns {short}
 '/
function shutdown cdecl () as short
	_console->logMessage("Shutting down")

	return true
end function

/''
 ' Standard test runner for modules.
 ' @function test
 ' @param {any ptr} interfacePtr
 ' @param {Tester.describeCallback} describe
 ' @returns {short}
 '/
function test (interfacePtr as any ptr, describe as Tester.describeCallback) as short
	dim as short result = true

	result = result andalso describe ("The Default module", @create)

	return result
end function

end namespace
