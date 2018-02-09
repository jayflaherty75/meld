
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
	dim as Interface ptr interfacePtr = exports()
	dim as Tester.testModule tests(1)

	tests(0) = @testModule

	errors.generalError = _fault->getCode("GeneralError")

	_console->logMessage("TEST")

	_throwDefaultGeneralError("99992v67nwte97vt6gwn47sergfniseg6", __FILE__, __LINE__)

	if not _tester->run(@tests(0), interfacePtr, 1) then
		print ("TEST FAILED!")
		return false
	end if

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

end namespace
