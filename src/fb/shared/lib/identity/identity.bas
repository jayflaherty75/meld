

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
 ' @namespace Identity
 '/
namespace Identity

/''
 ' @class Instance
 ' @member {ulong} autoinc
 '/

/''
 ' Application main routine.
 ' @function startup
 ' @returns {short}
 '/
function startup cdecl () as short
	_console->logMessage("Starting identity module")

	return true
end function

/''
 ' Application main routine.
 ' @function shutdown
 ' @returns {short}
 '/
function shutdown cdecl () as short
	_console->logMessage("Shutting down identity module")

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

	result = result andalso describeFn ("The Identity module", @testCreate)

	return result
end function

/''
 ' @function construct
 ' @returns {Identity.Instance ptr}
 ' @throws {ResourceAllocationError}
 '/
function construct cdecl () as Instance ptr
	dim as Instance ptr idPtr = allocate (sizeof(Instance))

	if idPtr = NULL then
		_throwIdentityAllocationError(__FILE__, __LINE__)
		return NULL
	end if

	idPtr->autoinc = 0

	return idPtr
end function

/''
 ' @function destruct
 ' @param {Identity.Instance ptr} idPtr
 ' @throws {NullReferenceError}
 '/
sub destruct cdecl (idPtr as Instance ptr)
	if idPtr = NULL then
		_throwIdentityDestructNullReferenceError(__FILE__, __LINE__)
		exit sub
	end if

	deallocate (idPtr)
end sub

/''
 ' Standard test runner for modules.
 ' @function getAutoInc
 ' @param {Identity.Instance ptr} idPtr
 ' @returns {ulong}
 '/
function getAutoInc cdecl (idPtr as Identity.Instance ptr) as ulong
	return _nextId(idPtr)
end function

/''
 ' Standard test runner for modules.
 ' @function _nextId
 ' @param {Identity.Instance ptr} idPtr
 ' @returns {ulong}
 ' @private
 '/
function _nextId cdecl (idPtr as Identity.Instance ptr) as ulong
	idPtr->autoinc += 1

	return idPtr->autoinc
end function

end namespace

