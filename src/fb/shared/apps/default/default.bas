
/''
 ' @requires constants
 ' @requires module
 ' @requires console
 ' @requires fault
 '/

#include once "module.bi"
' #include once "errors.bi"

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
	_console->logMessage("TEST")

	return true
end function

end namespace
