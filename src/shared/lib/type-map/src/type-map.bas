
/''
 ' @requires console_v0.*
 ' @requires fault_v0.*
 ' @requires error-handling_v0.*
 ' @requires map_v0.*
 ' @requires resource-container_v0.*
 ' @requires tester_v0.*
 '/

#include once "module.bi"
#include once "errors.bi"
#include once "test.bi"

/''
 ' Global registry of data types.  Once created, a type cannot be destroyed.
 ' Provides modules with the ability to take over responsibility for the
 ' construction (allocation) or destruction of a resource instance.
 ' @namespace TypeMap
 ' @version 0.1.0
 '/
namespace TypeMap

/''
 ' @typedef {function} DestructFn
 ' @param {any ptr} instPtr
 '/

/''
 ' @class Entry
 ' @member {ubyte ptr} id
 ' @member {long} index
 ' @member {long} size
 ' @member {DestructFn} destruct
 '/

dim shared as Map.Instance ptr mappings
dim shared as ResourceContainer.Instance ptr entries
dim shared as any ptr mutexPtr

/''
 ' Application main routine.
 ' @function startup
 ' @returns {short}
 ' @throws {ResourceAllocationError|ResourceInitializationError|ResourceMissingError}
 '/
function startup cdecl () as short
	_console->logMessage("Starting type-map module")

	mappings = _map->construct()
	if mappings = NULL then
		_throwTypeMapStartupMapAllocationError(__FILE__, __LINE__)
		return false
	end if

	entries = _resourceContainer->construct()
	if entries = NULL then
		_throwTypeMapStartupContAllocationError(__FILE__, __LINE__)
		return false
	end if

	if not _resourceContainer->initialize(entries, sizeof(Entry), 256, 2147483647) then
		_throwTypeMapStartupContInitializationError(__FILE__, __LINE__)
		return false
	end if

	mutexPtr = mutexCreate()
	if mutexPtr = NULL then
		' Warn multithreading not supported
		_throwTypeMapStartupResourceMissingError(__FILE__, __LINE__)
	end if

	return true
end function

/''
 ' Application main routine.
 ' @function shutdown
 ' @returns {short}
 '/
function shutdown cdecl () as short
	_console->logMessage("Shutting down type-map module")

	if mutexPtr <> NULL then
		mutexDestroy(mutexPtr)
	end if

	if mappings <> NULL then
		_map->destruct(mappings)
	end if

	if entries <> NULL then
		_resourceContainer->destruct(entries)
	end if

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

	result = result andalso describePtr ("The TypeMap module", @testCreate)

	return result
end function

/''
 ' @function request
 ' @param {ubyte ptr} id
 ' @returns {long}
 ' @throws {InvalidArgumentError|ResourceAllocationError|ResourceInitializationError}
 '/
function request cdecl (id as ubyte ptr) as long
	dim as long index = -1
	dim as Entry ptr entryPtr

	if id = NULL then
		_throwTypeMapRequestInvalidArgumentError(__FILE__, __LINE__)
		return -1
	end if

	if mutexPtr <> NULL then mutexLock(mutexPtr)

	index = _map->request(mappings, id)

	if index = -1 then
		index = _resourceContainer->request(entries)

		if index = -1 then
			_throwTypeMapRequestResourceAllocationError(__FILE__, __LINE__)
			return -1
		end if

		entryPtr = _resourceContainer->getPtr(entries, index)

		if entryPtr = null orelse not _map->assign(mappings, id, index) then
			_resourceContainer->release(entries, index)

			_throwTypeMapRequestResourceInitializationError(__FILE__, __LINE__)
			return -1
		end if

		entryPtr->id = id
		entryPtr->index = index
		entryPtr->size = -1
		entryPtr->destruct = NULL
	end if

	if mutexPtr <> NULL then mutexUnlock(mutexPtr)

	return index
end function

/''
 ' @function getEntry
 ' @param {long} index
 ' @returns {Entry ptr}
 '/
function getEntry cdecl (index as long) as Entry ptr
	dim as Entry ptr entryPtr

	if mutexPtr <> NULL then mutexLock(mutexPtr)

	entryPtr = _resourceContainer->getPtr(entries, index)

	if mutexPtr <> NULL then mutexUnlock(mutexPtr)

	return entryPtr
end function

/''
 ' @function assign
 ' @param {Entry ptr} entryPtr
 ' @param {long} size
 ' @param {DestructFn} destructFnPtr
 ' @returns {short}
 ' @throws {NullReferenceError|InvalidArgumentError}
 '/
function assign cdecl (entryPtr as Entry ptr, size as long, destructFnPtr as DestructFn = 0) as short
	if entryPtr = NULL then
		_throwTypeMapAssignNullReferenceError(__FILE__, __LINE__)
		return false
	end if

	if size <= 0 then
		_throwTypeMapAssignInvalidArgumentError(__FILE__, __LINE__)
		return false
	end if

	entryPtr->size = size
	entryPtr->destruct = destructFnPtr

	return true
end function

/''
 ' @function isAssigned
 ' @param {Entry ptr} entryPtr
 ' @returns {short}
 ' @throws {NullReferenceError}
 '/
function isAssigned cdecl (entryPtr as Entry ptr) as short
	if entryPtr = NULL then
		_throwTypeMapIsAssignedNullReferenceError(__FILE__, __LINE__)
		return false
	end if

	if entryPtr->size < 0 then
		return false
	end if

	return true
end function

/''
 ' @function getSize
 ' @param {Entry ptr} entryPtr
 ' @returns {long}
 ' @throws {NullReferenceError}
 '/
function getSize cdecl (entryPtr as Entry ptr) as long
	if entryPtr = NULL then
		_throwTypeMapGetSizeNullReferenceError(__FILE__, __LINE__)
		return false
	end if

	return entryPtr->size
end function

/''
 ' @function getDestructor
 ' @param {Entry ptr} entryPtr
 ' @returns {DestructFn}
 ' @throws {NullReferenceError}
 '/
function getDestructor cdecl (entryPtr as Entry ptr) as DestructFn
	if entryPtr = NULL then
		_throwTypeMapGetDestructorNullReferenceError(__FILE__, __LINE__)
		return false
	end if

	return entryPtr->destruct
end function

/''
 ' @function destroy
 ' @param {Entry ptr} entryPtr
 ' @param {any ptr} instancePtr
 ' @returns {short} - Returns false on error or if no destructor was assigned
 ' @throws {NullReferenceError}
 '/
function destroy cdecl (entryPtr as Entry ptr, instancePtr as any ptr) as short
	if entryPtr = NULL then
		_throwTypeMapDestroyNullReferenceError(__FILE__, __LINE__)
		return false
	end if

	if instancePtr = NULL then
		_throwTypeMapDestroyNullInstanceReferenceError(__FILE__, __LINE__)
		return false
	end if

	if entryPtr->destruct = NULL then
		return false
	end if

	entryPtr->destruct(instancePtr)

	return true
end function

end namespace

