
/''
 ' @requires console_v0.*
 ' @requires fault_v0.*
 ' @requires tester_v0.*
 ' @requires resource-container_v0.*
 ' @requires bst_v0.*
 '/

#include once "module.bi"
#include once "errors.bi"
#include once "test.bi"

/''
 ' @namespace Map
 ' @version 0.1.0
 '/
namespace Map

/''
 ' @class Instance
 ' @member {any ptr} mappings
 ' @member {any ptr} reverse
 ' @member {long} length
 '/

union Locator
	atInt as long
	atPtr as any ptr
end union

type Mapping
	index as long
	identifier as ubyte ptr
	location as Locator
end type

dim shared as ResourceContainer.Instance ptr mappingContPtr

/''
 ' Application main routine.
 ' @function startup
 ' @returns {short}
 '/
function startup cdecl () as short
	_console->logMessage("Starting map module")

	mappingContPtr = _resourceContainer->construct()
	if mappingContPtr = NULL then
		' error
		return false
	end if

	if not _resourceContainer->initialize(mappingContPtr, sizeof(Mapping), 1024, 1024*1024) then
		' error
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
	_console->logMessage("Shutting down map module")

	_resourceContainer->destruct(mappingContPtr)
	mappingContPtr = NULL

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

	result = result andalso describePtr ("The Map module", @testCreate)

	return result
end function

/''
 ' Constructor
 ' @function construct
 ' @returns {Instance ptr}
 ' @throws {AllocationError}
 '/
function construct cdecl () as Instance ptr
	dim as Instance ptr mapPtr = allocate(sizeof(Instance))

	if mapPtr = NULL then
		'_throwStateAllocationError(__FILE__, __LINE__)
		return NULL
	end if

	mapPtr->mappings = _bst->construct()

	if mapPtr->mappings = NULL then
		'_throwResContResourceAllocationError(__FILE__, __LINE__)
		return false
	end if

	mapPtr->reverse = _bst->construct()

	if mapPtr->reverse = NULL then
		'_throwResContResourceAllocationError(__FILE__, __LINE__)
		return false
	end if

	return mapPtr
end function

/''
 ' Destructor
 ' @function destruct
 ' @param {Instance ptr} instancePtr
 ' @throws {NullReferenceError}
 '/
sub destruct cdecl (mapPtr as Instance ptr)
	if mapPtr = NULL then
		'_throwStateDestructNullReferenceError(__FILE__, __LINE__)
		exit sub
	end if

	if mapPtr->mappings <> NULL then
		_bst->destruct(mapPtr->mappings)
		mapPtr->mappings = NULL
	end if

	if mapPtr->reverse <> NULL then
		_bst->destruct(mapPtr->reverse)
		mapPtr->reverse = NULL
	end if

	deallocate(mapPtr)
end sub

/''
 ' @function assign
 ' @param {Instance ptr} mapPtr
 ' @param {ubyte ptr} idPtr
 ' @param {long} resIdx
 ' @returns {short}
 '/
function assign cdecl (mapPtr as Instance ptr, idPtr as ubyte ptr, resIdx as long) as short
	dim as Bst.Node ptr nodePtr

	return false
end function

/''
 ' @function assignPtr
 ' @param {Instance ptr} mapPtr
 ' @param {ubyte ptr} idPtr
 ' @param {any ptr} resPtr
 ' @returns {short}
 '/
function assignPtr cdecl (mapPtr as Instance ptr, idPtr as ubyte ptr, resPtr as any ptr) as short
	return false
end function

/''
 ' @function request
 ' @param {Instance ptr} mapPtr
 ' @param {ubyte ptr} idPtr
 ' @returns {long}
 '/
function request cdecl (mapPtr as Instance ptr, idPtr as ubyte ptr) as long
	return -1
end function

/''
 ' @function requestPtr
 ' @param {Instance ptr} mapPtr
 ' @param {ubyte ptr} idPtr
 ' @returns {any ptr}
 '/
function requestPtr cdecl (mapPtr as Instance ptr, idPtr as ubyte ptr) as any ptr
	return NULL
end function

/''
 ' @function requestRev
 ' @param {Instance ptr} mapPtr
 ' @param {long} resIdx
 ' @returns {ubyte ptr}
 '/
function requestRev cdecl (mapPtr as Instance ptr, resIdx as long) as ubyte ptr
	return NULL
end function

/''
 ' @function requestRevPtr
 ' @param {Instance ptr} mapPtr
 ' @param {any ptr} resPtr
 ' @returns {ubyte ptr}
 '/
function requestRevPtr cdecl (mapPtr as Instance ptr, resPtr as any ptr) as ubyte ptr
	return NULL
end function

/''
 ' @function unassign
 ' @param {Instance ptr} mapPtr
 ' @param {ubyte ptr} idPtr
 ' @returns {short}
 '/
function unassign cdecl (mapPtr as Instance ptr, idPtr as ubyte ptr) as short
	return false
end function

/''
 ' @function length
 ' @param {Instance ptr} mapPtr
 ' @returns {long}
 '/
function length cdecl (mapPtr as Instance ptr) as long
	return 0
end function

/''
 ' @function purge
 ' @param {Instance ptr} mapPtr
 '/
sub purge cdecl (mapPtr as Instance ptr)
	if mapPtr = NULL then
		'_throwStateDestructNullReferenceError(__FILE__, __LINE__)
		exit sub
	end if

	_bst->purge(mapPtr->mappings)
	_bst->purge(mapPtr->reverse)

	mapPtr->length = 0
end sub

/''
 ' @function _compare
 ' @param {any ptr} criteria
 ' @param {any ptr} element
 ' @returns {short}
 '/
function _compare cdecl (criteria as any ptr, element as any ptr) as short
	return sgn(*cptr(long ptr, element) - *cptr(long ptr, criteria))
end function

/''
 ' @function _compareReverse
 ' @param {any ptr} criteria
 ' @param {any ptr} element
 ' @returns {short}
 '/
function _compareReverse cdecl (criteria as any ptr, element as any ptr) as short
	if *cptr(zstring ptr, criteria) > *cptr(zstring ptr, element) then
		return 1
	elseif *cptr(zstring ptr, criteria) < *cptr(zstring ptr, element) then
		return -1
	end if

	return 0
end function

end namespace
