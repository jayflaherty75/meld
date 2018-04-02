
/''
 ' @requires console_v0.*
 ' @requires fault_v0.*
 ' @requires tester_v0.*
 ' @requires resource-container_v0.*
 '/

#include once "module.bi"
#include once "errors.bi"
#include once "test.bi"

/''
 ' @namespace State
 ' @version 0.1.0
 '/
namespace State

/''
 ' @class Instance
 ' @member {any ptr} temp
 '/

type GlobalType
	states as ResourceContainer.Instance ptr
end type

dim shared as GlobalType global

/''
 ' Application main routine.
 ' @function startup
 ' @returns {short}
 '/
function startup cdecl () as short
	_console->logMessage("Starting state module")

	return true
end function

/''
 ' Application main routine.
 ' @function shutdown
 ' @returns {short}
 '/
function shutdown cdecl () as short
	_console->logMessage("Shutting down state module")

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

	result = result andalso describePtr ("The State module", @testCreate)

	return result
end function

/''
 ' Constructor
 ' @function construct
 ' @returns {Instance ptr}
 ' @throws {AllocationError}
 '/
function construct cdecl () as Instance ptr
	dim as Instance ptr statePtr = allocate(sizeof(Instance))

	if statePtr = NULL then
		_throwStateAllocationError(__FILE__, __LINE__)
		return NULL
	end if

	statePtr->temp = NULL

	return statePtr
end function

/''
 ' Destructor
 ' @function destruct
 ' @param {Instance ptr} instancePtr
 ' @throws {NullReferenceError}
 '/
sub destruct cdecl (statePtr as Instance ptr)
	if statePtr = NULL then
		_throwStateDestructNullReferenceError(__FILE__, __LINE__)
		exit sub
	end if
end sub

end namespace

