
namespace State

declare sub _throwStateAllocationError (byref filename as zstring, lineNum as integer)
declare sub _throwStateMapperAllocationError (byref filename as zstring, lineNum as integer)
declare sub _throwStateContainerAllocationError (byref filename as zstring, lineNum as integer)
declare sub _throwStateDestructNullReferenceError (byref filename as zstring, lineNum as integer)
declare sub _throwStateInitializeNullReferenceError (byref filename as zstring, lineNum as integer)
declare sub _throwStateInitializeresourceInitializationError (byref filename as zstring, lineNum as integer)
declare sub _throwStateSetAllocatorNullReferenceError (byref filename as zstring, lineNum as integer)
declare sub _throwStateRequestNullReferenceError (byref filename as zstring, lineNum as integer)
declare sub _throwStateRequestResourceInitializationError (byref filename as zstring, lineNum as integer)
declare sub _throwStateRequestMapInitializationError (byref filename as zstring, lineNum as integer)
declare sub _throwStateRequestResourceMissingError (byref filename as zstring, lineNum as integer)
declare sub _throwStateReleaseNullReferenceError (byref filename as zstring, lineNum as integer)
declare sub _throwStateReleaseResourceMissingError (byref filename as zstring, lineNum as integer)
declare sub _throwStateReleaseMapResourceError (byref filename as zstring, lineNum as integer)
declare sub _throwStateReleaseResourceError (byref filename as zstring, lineNum as integer)
declare sub _throwStateAssignNullReferenceError (byref filename as zstring, lineNum as integer)
declare sub _throwStateAssignResourceMissingError (byref filename as zstring, lineNum as integer)
declare sub _throwStateAssignContNullReferenceError (byref filename as zstring, lineNum as integer)
declare sub _throwStateAssignContResourceMissingError (byref filename as zstring, lineNum as integer)
declare sub _throwStateAssignContrAllocationError (byref filename as zstring, lineNum as integer)
declare sub _throwStateAssignContPointerMissingError (byref filename as zstring, lineNum as integer)
declare sub _throwStateUnassignNullReferenceError (byref filename as zstring, lineNum as integer)
declare sub _throwStateUnassignResourceMissingError (byref filename as zstring, lineNum as integer)

sub _throwStateAllocationError (byref filename as zstring, lineNum as integer)
	_fault->throw(_
		errors.allocationError, _
		"AllocationError", "Failed to allocate State instance", _
		filename, lineNum _
	)
end sub

sub _throwStateMapperAllocationError (byref filename as zstring, lineNum as integer)
	_fault->throw(_
		errors.resourceAllocationError, _
		"stateMapperAllocationError", "Failed to allocate State mapper", _
		filename, lineNum _
	)
end sub

sub _throwStateContainerAllocationError (byref filename as zstring, lineNum as integer)
	_fault->throw(_
		errors.resourceAllocationError, _
		"stateContainerAllocationError", "Failed to allocate State resource container", _
		filename, lineNum _
	)
end sub

sub _throwStateDestructNullReferenceError (byref filename as zstring, lineNum as integer)
	_fault->throw(_
		errors.nullReferenceError, _
		"NullReferenceError", "Attempt to call State destructor with NULL pointer", _
		filename, lineNum _
	)
end sub

sub _throwStateInitializeNullReferenceError (byref filename as zstring, lineNum as integer)
	_fault->throw(_
		errors.nullReferenceError, _
		"stateInitializeNullReferenceError", "Invalid state pointer passed", _
		filename, lineNum _
	)
end sub

sub _throwStateInitializeresourceInitializationError (byref filename as zstring, lineNum as integer)
	_fault->throw(_
		errors.resourceInitializationError, _
		"stateInitializeresourceInitializationError", "Failed to initialize resource container", _
		filename, lineNum _
	)
end sub

sub _throwStateSetAllocatorNullReferenceError (byref filename as zstring, lineNum as integer)
	_fault->throw(_
		errors.nullReferenceError, _
		"stateSetAllocatorNullReferenceError", "Invalid state pointer passed", _
		filename, lineNum _
	)
end sub

sub _throwStateRequestNullReferenceError (byref filename as zstring, lineNum as integer)
	_fault->throw(_
		errors.nullReferenceError, _
		"stateRequestNullReferenceError", "Invalid state pointer passed", _
		filename, lineNum _
	)
end sub

sub _throwStateRequestResourceInitializationError (byref filename as zstring, lineNum as integer)
	_fault->throw(_
		errors.resourceInitializationError, _
		"stateRequestResourceInitializationError", "Failed to create resource", _
		filename, lineNum _
	)
end sub

sub _throwStateRequestMapInitializationError (byref filename as zstring, lineNum as integer)
	_fault->throw(_
		errors.resourceInitializationError, _
		"stateRequestMapInitializationError", "Failed to map identifier to resource", _
		filename, lineNum _
	)
end sub

sub _throwStateRequestResourceMissingError (byref filename as zstring, lineNum as integer)
	_fault->throw(_
		errors.resourceMissingError, _
		"stateRequestResourceMissingError", "Resource pointer missing", _
		filename, lineNum _
	)
end sub

sub _throwStateReleaseNullReferenceError (byref filename as zstring, lineNum as integer)
	_fault->throw(_
		errors.nullReferenceError, _
		"stateReleaseNullReferenceError", "Invalid state pointer passed", _
		filename, lineNum _
	)
end sub

sub _throwStateReleaseResourceMissingError (byref filename as zstring, lineNum as integer)
	_fault->throw(_
		errors.resourceMissingError, _
		"stateReleaseResourceMissingError", "Resource not found", _
		filename, lineNum _
	)
end sub

sub _throwStateReleaseMapResourceError (byref filename as zstring, lineNum as integer)
	_fault->throw(_
		errors.releaseResourceError, _
		"stateReleaseMapResourceError", "Failed to unassign mapping", _
		filename, lineNum _
	)
end sub

sub _throwStateReleaseResourceError (byref filename as zstring, lineNum as integer)
	_fault->throw(_
		errors.releaseResourceError, _
		"stateReleaseResourceError", "Failed to unassign resource", _
		filename, lineNum _
	)
end sub

sub _throwStateAssignNullReferenceError (byref filename as zstring, lineNum as integer)
	_fault->throw(_
		errors.nullReferenceError, _
		"stateAssignNullReferenceError", "Invalid state pointer passed", _
		filename, lineNum _
	)
end sub

sub _throwStateAssignResourceMissingError (byref filename as zstring, lineNum as integer)
	_fault->throw(_
		errors.resourceMissingError, _
		"stateAssignResourceMissingError", "Resource not found", _
		filename, lineNum _
	)
end sub

sub _throwStateAssignContNullReferenceError (byref filename as zstring, lineNum as integer)
	_fault->throw(_
		errors.nullReferenceError, _
		"stateAssignContNullReferenceError", "Invalid state pointer passed", _
		filename, lineNum _
	)
end sub

sub _throwStateAssignContResourceMissingError (byref filename as zstring, lineNum as integer)
	_fault->throw(_
		errors.resourceMissingError, _
		"stateAssignContResourceMissingError", "Resource not found", _
		filename, lineNum _
	)
end sub

sub _throwStateAssignContrAllocationError (byref filename as zstring, lineNum as integer)
	_fault->throw(_
		errors.resourceAllocationError, _
		"stateAssignContrAllocationError", "Request to provided resource container failed", _
		filename, lineNum _
	)
end sub

sub _throwStateAssignContPointerMissingError (byref filename as zstring, lineNum as integer)
	_fault->throw(_
		errors.resourceMissingError, _
		"stateAssignContPointerMissingError", "Missing resource pointer", _
		filename, lineNum _
	)
end sub

sub _throwStateUnassignNullReferenceError (byref filename as zstring, lineNum as integer)
	_fault->throw(_
		errors.nullReferenceError, _
		"stateUnassignNullReferenceError", "Invalid state pointer passed", _
		filename, lineNum _
	)
end sub

sub _throwStateUnassignResourceMissingError (byref filename as zstring, lineNum as integer)
	_fault->throw(_
		errors.resourceMissingError, _
		"stateUnassignResourceMissingError", "Resource not found", _
		filename, lineNum _
	)
end sub

end namespace

