

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
 ' @namespace PagedArray
 '/
namespace PagedArray

/''
 ' Application main routine.
 ' @function startup
 ' @returns {short}
 '/
function startup cdecl () as short
	_console->logMessage("Starting paged-array module")

	return true
end function

/''
 ' Application main routine.
 ' @function shutdown
 ' @returns {short}
 '/
function shutdown cdecl () as short
	_console->logMessage("Shutting down paged-array module")

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

	result = result andalso describeFn ("The PagedArray module", @testCreate)

	return result
end function

end namespace

