
/''
 ' @requires console_v0.*
 ' @requires fault_v0.*
 ' @requires tester_v0.*
 ' @requires resource-container_v0.*
 ' @requires bst_v0.*
 ' @requires iterator_v0.*
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
 ' @member {any ptr} container
 ' @member {any ptr} mappings
 ' @member {any ptr} reverse
 '/

union Locator
	atIdx as long
	atPtr as any ptr
end union

type Mapping
	index as long
	identifier as ubyte ptr
	location as Locator
end type

/''
 ' Application main routine.
 ' @function startup
 ' @returns {short}
 '/
function startup cdecl () as short
	_console->logMessage("Starting map module")

	return true
end function

/''
 ' Application main routine.
 ' @function shutdown
 ' @returns {short}
 '/
function shutdown cdecl () as short
	_console->logMessage("Shutting down map module")

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

	mapPtr->container = _resourceContainer->construct()
	mapPtr->mappings = _bst->construct()
	mapPtr->reverse = _bst->construct()

	if mapPtr->container = NULL then
		destruct(mapPtr)
		' error
		return NULL
	end if

	if mapPtr->mappings = NULL then
		destruct(mapPtr)
		'_throwResContResourceAllocationError(__FILE__, __LINE__)
		return NULL
	end if

	if mapPtr->reverse = NULL then
		destruct(mapPtr)
		'_throwResContResourceAllocationError(__FILE__, __LINE__)
		return NULL
	end if

	if not _resourceContainer->initialize(mapPtr->container, sizeof(Mapping), 1024, 1024*1024) then
		destruct(mapPtr)
		' error
		return NULL
	end if

	_bst->setCompareHandler(mapPtr->mappings, @_compare)
	_bst->setCompareHandler(mapPtr->reverse, @_compareReverse)

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

	if mapPtr->container <> NULL then
		_resourceContainer->destruct(mapPtr->container)
		mapPtr->container = NULL
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
	dim as Locator location

	location.atIdx = resIdx

	return _assign(mapPtr, idPtr, @location)
end function

/''
 ' @function assignPtr
 ' @param {Instance ptr} mapPtr
 ' @param {ubyte ptr} idPtr
 ' @param {any ptr} resPtr
 ' @returns {short}
 '/
function assignPtr cdecl (mapPtr as Instance ptr, idPtr as ubyte ptr, resPtr as any ptr) as short
	dim as Locator location

	location.atPtr = resPtr

	return _assign(mapPtr, idPtr, @location)
end function

/''
 ' @function request
 ' @param {Instance ptr} mapPtr
 ' @param {ubyte ptr} idPtr
 ' @returns {long}
 '/
function request cdecl (mapPtr as Instance ptr, idPtr as ubyte ptr) as long
	dim as Bst.Node ptr nodePtr
	dim as Mapping criteria
	dim as Mapping ptr result

	if mapPtr = NULL then
		'_throwStateDestructNullReferenceError(__FILE__, __LINE__)
		return -1
	end if

	criteria.identifier = idPtr

	nodePtr = _bst->search(mapPtr->mappings, @criteria)
	if nodePtr = NULL then
		return -1
	end if

	result = nodePtr->element
	if result = NULL then
		'_throwStateDestructNullReferenceError(__FILE__, __LINE__)
		return -1
	end if

	return result->location.atIdx
end function

/''
 ' @function requestPtr
 ' @param {Instance ptr} mapPtr
 ' @param {ubyte ptr} idPtr
 ' @returns {any ptr}
 '/
function requestPtr cdecl (mapPtr as Instance ptr, idPtr as ubyte ptr) as any ptr
	dim as any ptr result = NULL

	if mapPtr = NULL then
		'_throwStateDestructNullReferenceError(__FILE__, __LINE__)
		return NULL
	end if

	return result
end function

/''
 ' @function requestRev
 ' @param {Instance ptr} mapPtr
 ' @param {long} resIdx
 ' @returns {ubyte ptr}
 '/
function requestRev cdecl (mapPtr as Instance ptr, resIdx as long) as ubyte ptr
	dim as ubyte ptr result = NULL

	if mapPtr = NULL then
		'_throwStateDestructNullReferenceError(__FILE__, __LINE__)
		return NULL
	end if

	return result
end function

/''
 ' @function requestRevPtr
 ' @param {Instance ptr} mapPtr
 ' @param {any ptr} resPtr
 ' @returns {ubyte ptr}
 '/
function requestRevPtr cdecl (mapPtr as Instance ptr, resPtr as any ptr) as ubyte ptr
	dim as ubyte ptr result = NULL

	if mapPtr = NULL then
		'_throwStateDestructNullReferenceError(__FILE__, __LINE__)
		return NULL
	end if

	return result
end function

/''
 ' @function unassign
 ' @param {Instance ptr} mapPtr
 ' @param {ubyte ptr} idPtr
 ' @returns {short}
 '/
function unassign cdecl (mapPtr as Instance ptr, idPtr as ubyte ptr) as short
	if mapPtr = NULL then
		'_throwStateDestructNullReferenceError(__FILE__, __LINE__)
		return false
	end if

	return true
end function

/''
 ' @function length
 ' @param {Instance ptr} mapPtr
 ' @returns {long}
 '/
function length cdecl (mapPtr as Instance ptr) as long
	if mapPtr = NULL then
		'_throwStateDestructNullReferenceError(__FILE__, __LINE__)
		return -1
	end if

	return _bst->getLength(mapPtr->mappings)
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
end sub

/''
 ' @function getIterator
 ' @param {Instance ptr} mapPtr
 ' @returns {any ptr}
 ' @throws {NullReferenceError|ResourceAllocationError}
 '/
function getIterator cdecl (mapPtr as Instance ptr) as any ptr
	dim as Iterator.Instance ptr iter

	if mapPtr = NULL then
		'_throwMapIteratorNullReferenceError(__FILE__, __LINE__)
		return NULL
	end if

'	iter = _iterator->construct()

'	if iter = NULL then
'		'_throwMapIteratorAllocationError(mapPtr, __FILE__, __LINE__)
'		return NULL
'	end if

'	iter->handler = @_iterationHandler

'	_iterator->setData(iter, mapPtr)

	return iter
end function

/''
 ' @function _assign
 ' @param {Instance ptr} mapPtr
 ' @param {ubyte ptr} idPtr
 ' @param {any ptr} locPtr
 ' @returns {short}
 ' @private
 '/
function _assign cdecl (mapPtr as Instance ptr, idPtr as ubyte ptr, locPtr as any ptr) as short
	dim as Locator location = *cptr(Locator ptr, locPtr)
	dim as long mappingIdx
	dim as Mapping ptr mappingPtr
	dim as Bst.Node ptr nodePtr
	dim as Bst.Node ptr revPtr

	if mapPtr = NULL then
		'_throwStateDestructNullReferenceError(__FILE__, __LINE__)
		return false
	end if

	mappingIdx = _resourceContainer->request(mapPtr->container)
	if mappingIdx = -1 then
		' error
		return false
	end if

	mappingPtr = _resourceContainer->getPtr(mapPtr->container, mappingIdx)
	mappingPtr->index = mappingIdx
	mappingPtr->identifier = idPtr
	mappingPtr->location = location

	nodePtr = _bst->insert(mapPtr->mappings, mappingPtr)
	revPtr = _bst->insert(mapPtr->reverse, mappingPtr)

	if nodePtr = NULL then
		_resourceContainer->release(mapPtr->container, mappingIdx)
		' error
		return false
	end if

	if revPtr = NULL then
		_resourceContainer->release(mapPtr->container, mappingIdx)
		_bst->remove(mapPtr->mappings, nodePtr)
		' error
		return false
	end if

	return true
end function

/''
 ' @function _compare
 ' @param {any ptr} criteria
 ' @param {any ptr} element
 ' @returns {short}
 ' @private
 '/
function _compare cdecl (criteria as any ptr, element as any ptr) as short
	if cptr(Mapping ptr, criteria)->identifier > cptr(Mapping ptr, element)->identifier then
		return 1
	elseif cptr(Mapping ptr, criteria)->identifier < cptr(Mapping ptr, element)->identifier then
		return -1
	end if

	return 0
end function

/''
 ' @function _compareReverse
 ' @param {any ptr} criteria
 ' @param {any ptr} element
 ' @returns {short}
 ' @private
 '/
function _compareReverse cdecl (criteria as any ptr, element as any ptr) as short
	if cptr(Mapping ptr, criteria)->location.atPtr > cptr(Mapping ptr, element)->location.atPtr then
		return 1
	elseif cptr(Mapping ptr, criteria)->location.atPtr < cptr(Mapping ptr, element)->location.atPtr then
		return -1
	end if

	return 0
end function

end namespace
