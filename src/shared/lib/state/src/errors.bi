
namespace State

sub _throwStateAllocationError (byref filename as zstring, lineNum as integer)
	_fault->throw(_
		errors.allocationError, _
		"StateAllocationError", "Failed to allocate State instance", _
		filename, lineNum _
	)
end sub

sub _throwStateMapperAllocationError (byref filename as zstring, lineNum as integer)
	_fault->throw(_
		errors.resourceAllocationError, _
		"StateMapperAllocationError", "Failed to allocate State mapper", _
		filename, lineNum _
	)
end sub

sub _throwStateContainerAllocationError (byref filename as zstring, lineNum as integer)
	_fault->throw(_
		errors.resourceAllocationError, _
		"StateContainerAllocationError", "Failed to allocate State resource container", _
		filename, lineNum _
	)
end sub

sub _throwStateDestructNullReferenceError (byref filename as zstring, lineNum as integer)
	_fault->throw(_
		errors.nullReferenceError, _
		"StateDestructNullReferenceError", "Attempt to call State destructor with NULL pointer", _
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
		"stateInitializeResourceInitializationError", "Failed to initialize resource container", _
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

sub _throwStateGetRefCountNullReferenceError (byref filename as zstring, lineNum as integer)
	_fault->throw(_
		errors.nullReferenceError, _
		"StateGetRefCountNullReferenceError", "Attempt to call State destructor with NULL pointer", _
		filename, lineNum _
	)
end sub

sub _throwStateGetRefCountResourceMissingError (byref filename as zstring, lineNum as integer)
	_fault->throw(_
		errors.resourceMissingError, _
		"StateGetRefCountResourceMissingError", "Resource pointer missing", _
		filename, lineNum _
	)
end sub

sub _throwStateIsAssignedNullReferenceError (byref filename as zstring, lineNum as integer)
	_fault->throw(_
		errors.nullReferenceError, _
		"StateIsAssignedNullReferenceError", "Attempt to call State destructor with NULL pointer", _
		filename, lineNum _
	)
end sub

sub _throwStateIsAssignedResourceMissingError (byref filename as zstring, lineNum as integer)
	_fault->throw(_
		errors.resourceMissingError, _
		"StateIsAssignedResourceMissingError", "Resource pointer missing", _
		filename, lineNum _
	)
end sub

sub _throwStateSetModNullReferenceError (byref filename as zstring, lineNum as integer)
	_fault->throw(_
		errors.nullReferenceError, _
		"StateSetModNullReferenceError", "Attempt to call State destructor with NULL pointer", _
		filename, lineNum _
	)
end sub

sub _throwStateSetModResourceMissingError (byref filename as zstring, lineNum as integer)
	_fault->throw(_
		errors.resourceMissingError, _
		"StateSetModResourceMissingError", "Resource pointer missing", _
		filename, lineNum _
	)
end sub

sub _throwStateSetModResourceInitializationError (byref filename as zstring, lineNum as integer)
	_fault->throw(_
		errors.resourceInitializationError, _
		"StateSetModResourceInitializationError", "Modifier failed to set initial state", _
		filename, lineNum _
	)
end sub

sub _throwStateModListAllocationError (byref filename as zstring, lineNum as integer)
	_fault->throw(_
		errors.resourceAllocationError, _
		"StateModListAllocationError", "Failed to State modifiers list", _
		filename, lineNum _
	)
end sub

sub _throwStateSelectFromNullReferenceError (byref filename as zstring, lineNum as integer)
	_fault->throw(_
		errors.nullReferenceError, _
		"StateSelectFromNullReferenceError", "Attempt to call State destructor with NULL pointer", _
		filename, lineNum _
	)
end sub

sub _throwStateSelectFromResourceMissingError (byref filename as zstring, lineNum as integer)
	_fault->throw(_
		errors.resourceMissingError, _
		"StateSelectFromResourceMissingError", "Resource pointer missing", _
		filename, lineNum _
	)
end sub

sub _throwStateSelectAtNullReferenceError (byref filename as zstring, lineNum as integer)
	_fault->throw(_
		errors.nullReferenceError, _
		"StateSelectAtNullReferenceError", "Attempt to call State destructor with NULL pointer", _
		filename, lineNum _
	)
end sub

sub _throwStateSelectAtResourceMissingError (byref filename as zstring, lineNum as integer)
	_fault->throw(_
		errors.resourceMissingError, _
		"StateSelectAtResourceMissingError", "Resource pointer missing", _
		filename, lineNum _
	)
end sub

end namespace

