

/''
 ' @requires console
 ' @requires fault
 ' @requires error-handling
 ' @requires tester
 ' @requires paged-array
 '/

#include once "../../../../../modules/headers/constants/constants-v1.bi"
#include once "module.bi"
#include once "errors.bi"
#include once "test.bi"

/''
 ' @namespace ResourceContainer
 '/
namespace ResourceContainer

/''
 ' @class Instance
 ' @member {PagedArray.Instance ptr} resources
 ' @member {PagedArray.Instance ptr} stack
 '/

/''
 ' Application main routine.
 ' @function startup
 ' @returns {short}
 '/
function startup cdecl () as short
	_console->logMessage("Starting resource-container module")

	return true
end function

/''
 ' Application main routine.
 ' @function shutdown
 ' @returns {short}
 '/
function shutdown cdecl () as short
	_console->logMessage("Shutting down resource-container module")

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

	result = result andalso describeFn ("The ResourceContainer module", @testCreate)

	return result
end function

/''
 ' Creates a resource container that manages the creation and reuse of existing
 ' resource.
 ' @function construct
 ' @returns {Instance ptr}
 ' @throws {ResourceAllocationError}
 '/
function construct cdecl () as Instance ptr
	dim as Instance ptr contPtr = allocate(sizeof(Instance))

	if contPtr = NULL then
		_fault->throw(_
			errors.resourceAllocationError, _
			"ResContAllocationError", "Failed to allocate new ResourceContainer instance", _
			__FILE__, __LINE__ _
		)
		return NULL
	end if

	contPtr->resources = NULL
	contPtr->stack = NULL

	return contPtr
end function

/''
 ' @function destruct
 ' @param {Instance ptr} contPtr
 ' @throws {NullReferenceError}
 '/
sub destruct cdecl (contPtr as Instance ptr)
	if contPtr = NULL then
		_fault->throw(_
			errors.nullReferenceError, _
			"ResContDestructNullReferenceError", "Attempt to reference a NULL ResourceContainer", _
			__FILE__, __LINE__ _
		)
		exit sub
	end if

	if contPtr->resources <> NULL then
		_pagedArray->destruct(contPtr->resources)
		contPtr->resources = NULL
	end if

	if contPtr->stack <> NULL then
		_pagedArray->destruct(contPtr->stack)
		contPtr->stack = NULL
	end if
end sub

/''
 ' Creates a resource container that manages the creation and reuse of existing
 ' resource.
 ' @function initialize
 ' @param {Instance ptr} contPtr
 ' @param {short} size
 ' @param {long} pageLength
 ' @param {long} warnLimit
 ' @returns {short}
 ' @throws {NullReferenceError|ResourceAllocationError}
 '/
function initialize cdecl (contPtr as Instance ptr, size as short, pageLength as long, warnLimit as long) as short
	if contPtr = NULL then
		_fault->throw(_
			errors.nullReferenceError, _
			"ResContInvalidArgumentError", "Attempt to reference a NULL ResourceContainer", _
			__FILE__, __LINE__ _
		)
		return false
	end if

	contPtr->resources = _pagedArray->construct()

	if contPtr->resources = NULL then
		_fault->throw( _
			errors.resourceAllocationError, _
			"ResContResourceAllocationError", "Failed to create paged array", _
			__FILE__, __LINE__ _
		)
		return false
	end if

	contPtr->stack = _pagedArray->construct()

	if contPtr->stack = NULL then
		_fault->throw( _
			errors.resourceAllocationError, _
			"ResContStackAllocationError", "Failed to create paged array for stack", _
			__FILE__, __LINE__ _
		)
		return false
	end if

	_pagedArray->initialize(contPtr->resources, size, pageLength, warnLimit)
	_pagedArray->initialize(contPtr->stack, sizeof(integer), pageLength, warnLimit)

	return true
end function

/''
 ' Request the index of a newly created resource.
 ' @function request
 ' @param {Instance ptr} contPtr
 ' @returns {long}
 ' @throws {NullReferenceError|ResourceMissingError}
 '/
function request cdecl (contPtr as Instance ptr) as long
	dim as long resourceId
	dim as any ptr resource = NULL

	if contPtr = NULL then
		_fault->throw(_
			errors.nullReferenceError, _
			"ResContRequestNullReferenceError", "Attempt to reference a NULL ResourceContainer", _
			__FILE__, __LINE__ _
		)
		return -1
	end if

	if not _pagedArray->isEmpty(contPtr->stack) then
		if not _pagedArray->pop(contPtr->stack, @resourceId) then
			_fault->throw(_
				errors.resourceMissingError, _
				"ResContRequestResourceMissingError", "Failed to reuse resource from stack", _
				__FILE__, __LINE__ _
			)
			return -1
		end if
	end if

	resourceId = _pagedArray->createIndex(contPtr->resources)

	return resourceId
end function

/''
 ' Release the resource of the given index.
 ' @function release
 ' @param {Instance ptr} contPtr
 ' @param {long} resourceId
 ' @returns {short}
 ' @throws {NullReferenceError|InvalidArgumentError|ReleaseResourceError}
 '/
function release cdecl (contPtr as Instance ptr, resourceId as long) as short
	dim as long index
	dim as long ptr stackPtr

	if contPtr = NULL then
		_fault->throw(_
			errors.nullReferenceError, _
			"ResContReleaseNullReferenceError", "Attempt to reference a NULL ResourceContainer", _
			__FILE__, __LINE__ _
		)
		return -1
	end if

	if resourceId <= 0 then
		_fault->throw(_
			errors.invalidArgumentError, _
			"ResContReleaseInvalidArgumentError", "Invalid 2nd Argument: resourceId must be greater than zero", _
			__FILE__, __LINE__ _
		)
		return -1
	end if

	index = _pagedArray->createIndex(contPtr->stack)
	stackPtr = _pagedArray->getIndex(contPtr->stack, index)

	if stackPtr = NULL then
		_fault->throw(_
			errors.releaseResourceError, _
			"ResContReleaseResourceError", "Failed to release resource back to container", _
			__FILE__, __LINE__ _
		)
		return -1
	end if

	*stackPtr = resourceId

	return true
end function

/''
 ' Returns the point to the resource of the given index.
 ' @function getPtr
 ' @param {Instance ptr} contPtr
 ' @param {long} resourceId
 ' @returns {any ptr}
 ' @throws {NullReferenceError}
 '/
function getPtr cdecl (contPtr as Instance ptr, resourceId as long) as any ptr
	if contPtr = NULL then
		_fault->throw(_
			errors.nullReferenceError, _
			"ResContGetPtrNullReferenceError", "Attempt to reference a NULL ResourceContainer", _
			__FILE__, __LINE__ _
		)
		return NULL
	end if

	return _pagedArray->getIndex(contPtr->resources, resourceId)
end function

end namespace

