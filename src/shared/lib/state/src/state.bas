
/''
 ' @requires console_v0.*
 ' @requires fault_v0.*
 ' @requires tester_v0.*
 ' @requires resource-container_v0.*
 ' @requires map_v0.*
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
 ' @typedef {function} AllocatorFn
 ' @param {any ptr} memPtr
 ' @param {long} size
 ' @returns {any ptr}
 '/

/''
 ' @class Instance
 ' @member {any ptr} mappings - Map pointer
 ' @member {any ptr} resources - ResourceContainer pointer
 ' @member {AllocatorFn} allocator
 '/

type ResourceEntry
	typePtr as ResourceContainer.Instance ptr
	identifier as ubyte ptr
	index as long
	resIndex as long
	resourcePtr as any ptr
	references as long
end type

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
 ' @throws {AllocationError|ResourceAllocationError}
 '/
function construct cdecl () as Instance ptr
	dim as Instance ptr statePtr = allocate(sizeof(Instance))

	if statePtr = NULL then
		_throwStateAllocationError(__FILE__, __LINE__)
		return NULL
	end if

	statePtr->mappings = _map->construct()
	if statePtr->mappings = NULL then
		destruct(statePtr)
		_throwStateMapperAllocationError(__FILE__, __LINE__)
		return NULL
	end if

	statePtr->resources = _resourceContainer->construct()
	if statePtr->resources = NULL then
		destruct(statePtr)
		_throwStateContainerAllocationError(__FILE__, __LINE__)
		return NULL
	end if

	' Set to default allocator
	setAllocator(statePtr, NULL)

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

	if statePtr->mappings <> NULL then
		_map->destruct(statePtr->mappings)
		statePtr->mappings = NULL
	end if

	if statePtr->resources <> NULL then
		_resourceContainer->destruct(statePtr->resources)
		statePtr->resources = NULL
	end if

	deallocate(statePtr)
end sub

/''
 ' @function initialize
 ' @param {Instance ptr} statePtr
 ' @param {long} [pageLength=1024]
 ' @param {long} [warnLimit=2147483647] - By default, does not warn
 ' @returns {short}
 ' @throws {NullReferenceError|ResourceInitializationError}
 '/
function initialize cdecl (statePtr as Instance ptr, pageLength as long = 1024, warnLimit as long = 2147483647) as short
	if statePtr = NULL then
		_throwStateInitializeNullReferenceError(__FILE__, __LINE__)
		return false
	end if

	if not _resourceContainer->initialize(statePtr->resources, sizeof(ResourceEntry), 1024, 32768*32768) then
		_throwStateInitializeresourceInitializationError(__FILE__, __LINE__)
		return false
	end if

	return true
end function

/''
 ' @function setAllocator
 ' @param {Instance ptr} statePtr
 ' @param {AllocatorFn} allocator
 ' @throws {NullReferenceError}
 '/
sub setAllocator cdecl (statePtr as Instance ptr, allocator as AllocatorFn)
	if statePtr = NULL then
		_throwStateSetAllocatorNullReferenceError(__FILE__, __LINE__)
		exit sub
	end if

	if allocator = NULL then
		statePtr->allocator = @_defaultAllocator
	else
		statePtr->allocator = allocator
	end if
end sub

/''
 ' @function request
 ' @param {Instance ptr} statePtr
 ' @param {ubyte ptr} id
 ' @returns {long}
 ' @throws {NullReferenceError|ResourceInitializationError|ResourceMissingError}
 '/
function request cdecl (statePtr as Instance ptr, id as ubyte ptr) as long
	dim as long index = -1
	dim as ResourceEntry ptr resPtr

	if statePtr = NULL then
		_throwStateRequestNullReferenceError(__FILE__, __LINE__)
		return -1
	end if

	index = _map->request(statePtr->mappings, id)

	if index = -1 then
		index = _resourceContainer->request(statePtr->resources)

		if index = -1 then
			_throwStateRequestResourceInitializationError(__FILE__, __LINE__)
			return -1
		end if

		resPtr = _resourceContainer->getPtr(statePtr->resources, index)

		if resPtr = null orelse not _map->assign(statePtr->mappings, id, index) then
			_resourceContainer->release(statePtr->resources, index)

			_throwStateRequestMapInitializationError(__FILE__, __LINE__)
			return -1
		end if

		resPtr->typePtr = NULL
		resPtr->identifier = id
		resPtr->index = index
		resPtr->resIndex = -1
		resPtr->resourcePtr = NULL
	else
		resPtr = _resourceContainer->getPtr(statePtr->resources, index)

		if resPtr = null then
			_throwStateRequestResourceMissingError(__FILE__, __LINE__)
			return -1
		end if
	end if

	resPtr->references += 1

	return index
end function

/''
 ' @function release
 ' @param {Instance ptr} statePtr
 ' @param {long} index
 ' @returns {short}
 ' @throws {NullReferenceError|ResourceMissingError|ReleaseResourceError}
 '/
function release cdecl (statePtr as Instance ptr, index as long) as short
	dim as ubyte ptr id
	dim as ResourceEntry ptr resPtr

	if statePtr = NULL then
		_throwStateReleaseNullReferenceError(__FILE__, __LINE__)
		return false
	end if

	resPtr = _resourceContainer->getPtr(statePtr->resources, index)
	if resPtr = NULL then
		_throwStateReleaseResourceMissingError(__FILE__, __LINE__)
		return false
	end if

	resPtr->references -= 1

	if not _map->unassign(statePtr->mappings, resPtr->identifier) then
		_throwStateReleaseMapResourceError(__FILE__, __LINE__)
	end if

	if not _resourceContainer->release(statePtr->resources, index) then
		_throwStateReleaseResourceError(__FILE__, __LINE__)
	end if
	
	return true
end function

/''
 ' @function assign
 ' @param {Instance ptr} statePtr
 ' @param {long} index
 ' @param {long} size
 ' @returns {short}
 ' @throws {NullReferenceError|ResourceMissingError}
 '/
function assign cdecl (statePtr as Instance ptr, index as long, size as long) as short
	dim as ResourceEntry ptr resPtr

	if statePtr = NULL then
		_throwStateAssignNullReferenceError(__FILE__, __LINE__)
		return false
	end if

	resPtr = _resourceContainer->getPtr(statePtr->resources, index)
	if resPtr = NULL then
		_throwStateAssignResourceMissingError(__FILE__, __LINE__)
		return false
	end if

	resPtr->typePtr = NULL
	resPtr->resourcePtr = statePtr->allocator(NULL, size)

	return true
end function

/''
 ' @function assignFromContainer
 ' @param {Instance ptr} statePtr
 ' @param {long} index
 ' @param {any ptr} contPtr
 ' @returns {short}
 ' @throws {NullReferenceError|ResourceMissingError|ResourceAllocationError}
 '/
function assignFromContainer cdecl (statePtr as Instance ptr, index as long, contPtr as any ptr) as short
	dim as long resIndex
	dim as ResourceEntry ptr resPtr

	if statePtr = NULL then
		_throwStateAssignContNullReferenceError(__FILE__, __LINE__)
		return false
	end if

	resPtr = _resourceContainer->getPtr(statePtr->resources, index)
	if resPtr = NULL then
		_throwStateAssignContResourceMissingError(__FILE__, __LINE__)
		return false
	end if

	resIndex = _resourceContainer->request(contPtr)
	if resIndex = -1 then
		_throwStateAssignContrAllocationError(__FILE__, __LINE__)
		return false
	end if

	resPtr->resourcePtr = _resourceContainer->getPtr(contPtr, resIndex)
	if resPtr->resourcePtr = NULL then
		_resourceContainer->release(contPtr, resIndex)

		_throwStateAssignContPointerMissingError(__FILE__, __LINE__)
		return false
	end if

	resPtr->typePtr = contPtr
	resPtr->resIndex = resIndex

	return true
end function

/''
 ' @function unassign
 ' @param {Instance ptr} statePtr
 ' @param {long} index
 ' @returns {short}
 ' @throws {NullReferenceError|ResourceMissingError}
 '/
function unassign cdecl (statePtr as Instance ptr, index as long) as short
	dim as ResourceEntry ptr resPtr

	if statePtr = NULL then
		_throwStateUnassignNullReferenceError(__FILE__, __LINE__)
		return false
	end if

	resPtr = _resourceContainer->getPtr(statePtr->resources, index)
	if resPtr = NULL then
		_throwStateUnassignResourceMissingError(__FILE__, __LINE__)
		return false
	end if

	if resPtr->typePtr = NULL then
		statePtr->allocator(resPtr->resourcePtr, 0)
	else
		_resourceContainer->release(resPtr->typePtr, index)
	end if

	resPtr->typePtr = NULL
	resPtr->resourcePtr = NULL
	resPtr->resIndex = -1

	return true
end function

/''
 ' @function _defaultAllocator
 ' @param {any ptr} memPtr
 ' @param {long} size
 ' @returns {any ptr}
 ' @private
 '/
function _defaultAllocator cdecl (memPtr as any ptr, size as long) as any ptr
	if size > 0 andalso memPtr = NULL then
		return allocate(size)
	elseif size <= 0 andalso memPtr <> NULL then
		deallocate(memPtr)
		return NULL
	elseif memPtr <> NULL then
		return reallocate(memPtr, size)
	end if

	return NULL
end function

end namespace

