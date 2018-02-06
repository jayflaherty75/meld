
/''
 ' @requires constants
 ' @requires module
 ' @requires console
 ' @requires fault
 ' @requires error-handling
 '/

#include once "module.bi"
#include once "errors.bi"

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

end namespace
