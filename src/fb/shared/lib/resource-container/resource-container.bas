
#include once "resource-container.bi"
#include once "module.bi"

namespace ResourceContainer

/''
 ' Creates a resource container that manages the creation and reuse of existing
 ' resource.
 ' @param {zstring} id
 ' @param {integer} size
 ' @param {integer} pageLength
 ' @param {integer} warnLimit
 ' @returns {ResourceContainerObj ptr}
 ' @throws {ResContInvalidArgumentError|ResourceContainerGeneralError}
 '/
function construct (byref id as zstring, size as integer, pageLength as integer, warnLimit as integer) as ResourceContainerObj ptr
	dim as ResourceContainerObj ptr contPtr = allocate(sizeof(ResourceContainerObj))
	dim as PagedArrayObj ptr resources
	dim as PagedArrayObj ptr stack

	if size <= 0 then
		_fault->throw(_
			errors.invalidArgumentError, _
			"ResContInvalidArgumentError", "Invalid 2nd Argument: size must be greater than zero: " & id, _
			__FILE__, __LINE__ _
		)
		return NULL
	end if

	resources = _pagedArray->construct(id & "_resources", size, pageLength, warnLimit)

	if resources = NULL then
		_fault->throw( _
			errors.resourceAllocationError, _
			"ResourceContainerGeneralError", "Failed to create paged array" & id, _
			__FILE__, __LINE__ _
		)
		return NULL
	end if

	stack = _pagedArray->construct(id & "_stack", sizeof(integer), pageLength, warnLimit)

	if stack = NULL then
		_fault->throw( _
			errors.generalError, _
			"ResourceContainerGeneralError", "Failed to create paged array for stack" & id, _
			__FILE__, __LINE__ _
		)
		return NULL
	end if

	contPtr->id = left(id, 32)
	contPtr->resources = resources
	contPtr->stack = stack

	return contPtr
end function

/''
 ' @param {ResourceContainerObj ptr} contPtr
 ' @throws {ResContDestructNullReferenceError}
 '/
sub destruct (contPtr as ResourceContainerObj ptr)
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
 ' Request the index of a newly created resource.
 ' @param {ResourceContainerObj ptr} contPtr
 ' @returns {integer}
 ' @throws {ResContRequestNullReferenceError|ResContResourceMissingError}
 '/
function request (contPtr as ResourceContainerObj ptr) as integer
	dim as integer resourceId
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
				"ResContResourceMissingError", "Failed to reuse resource from stack: " & contPtr->id, _
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
 ' @param {ResourceContainerObj ptr} contPtr
 ' @param {integer} resourceId
 ' @returns {integer}
 ' @throws {ResContReleaseNullReferenceError|ResContReleaseInvalidArgumentError|ResContReleaseError}
 '/
function release (contPtr as ResourceContainerObj ptr, resourceId as integer) as integer
	dim as integer index
	dim as integer ptr stackPtr

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
			"ResContReleaseInvalidArgumentError", "Invalid 2nd Argument: resourceId must be greater than zero" & contPtr->id, _
			__FILE__, __LINE__ _
		)
		return -1
	end if

	index = _pagedArray->createIndex(contPtr->stack)
	stackPtr = _pagedArray->getIndex(contPtr->stack, index)

	if stackPtr = NULL then
		_fault->throw(_
			errors.releaseResourceError, _
			"ResContReleaseError", "Failed to release resource back to container: " & contPtr->id, _
			__FILE__, __LINE__ _
		)
		return -1
	end if

	*stackPtr = resourceId

	return true
end function

/''
 ' Returns the point to the resource of the given index.
 ' @param {ResourceContainerObj ptr} contPtr
 ' @param {integer} resourceId
 ' @returns {any ptr}
 ' @throws {ResContGetPtrNullReferenceError}
 '/
function getPtr (contPtr as ResourceContainerObj ptr, resourceId as integer) as any ptr
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
