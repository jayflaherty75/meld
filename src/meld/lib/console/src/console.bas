
/''
 ' @requires console
 ' @requires fault
 ' @requires error-handling
 ' @requires tester
 '/

#include once "module.bi"
#include once "errors.bi"
#include once "test.bi"

/''
 ' @namespace Console
 '/
namespace Console

/''
 ' Application main routine.
 ' @function startup
 ' @returns {short}
 '/
function startup cdecl () as short
	_console->logMessage("Starting console module")

	return true
end function

/''
 ' Application main routine.
 ' @function shutdown
 ' @returns {short}
 '/
function shutdown cdecl () as short
	_console->logMessage("Shutting down console module")

	return true
end function

/''
 ' Standard test runner for modules.
 ' @function test
 ' @param {Tester.describeCallback} describeFn
 ' @returns {short}
 '/
function test cdecl (describeFn as Tester.describeCallback) as short
	dim as short result = true

	result = result andalso describeFn ("The Console module", @testCreate)

	return result
end function

end namespace

