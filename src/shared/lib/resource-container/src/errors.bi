
namespace ResourceContainer

declare sub _throwResContAllocationError (byref filename as zstring, lineNum as integer)
declare sub _throwResContDestructNullReferenceError (byref filename as zstring, lineNum as integer)
declare sub _throwResContInvalidArgumentError (byref filename as zstring, lineNum as integer)
declare sub _throwResContResourceAllocationError (byref filename as zstring, lineNum as integer)
declare sub _throwResContStackAllocationError (byref filename as zstring, lineNum as integer)
declare sub _throwResContRequestNullReferenceError (byref filename as zstring, lineNum as integer)
declare sub _throwResContRequestResourceMissingError (byref filename as zstring, lineNum as integer)
declare sub _throwResContReleaseNullReferenceError (byref filename as zstring, lineNum as integer)
declare sub _throwResContReleaseInvalidArgumentError (byref filename as zstring, lineNum as integer)
declare sub _throwResContReleaseResourceError (byref filename as zstring, lineNum as integer)
declare sub _throwResContGetPtrNullReferenceError (byref filename as zstring, lineNum as integer)

sub _throwResContAllocationError (byref filename as zstring, lineNum as integer)
	_fault->throw(_
		errors.resourceAllocationError, _
		"ResContAllocationError", "Failed to allocate new ResourceContainer instance", _
		filename, lineNum _
	)
end sub

sub _throwResContDestructNullReferenceError (byref filename as zstring, lineNum as integer)
	_fault->throw(_
		errors.nullReferenceError, _
		"ResContDestructNullReferenceError", "Attempt to reference a NULL ResourceContainer", _
		filename, lineNum _
	)
end sub

sub _throwResContInvalidArgumentError (byref filename as zstring, lineNum as integer)
	_fault->throw(_
		errors.nullReferenceError, _
		"ResContInvalidArgumentError", "Attempt to reference a NULL ResourceContainer", _
		filename, lineNum _
	)
end sub

sub _throwResContResourceAllocationError (byref filename as zstring, lineNum as integer)
	_fault->throw(_
		errors.resourceAllocationError, _
		"ResContResourceAllocationError", "Failed to create paged array", _
		filename, lineNum _
	)
end sub

sub _throwResContStackAllocationError (byref filename as zstring, lineNum as integer)
	_fault->throw(_
		errors.resourceAllocationError, _
		"ResContStackAllocationError", "Failed to create paged array for stack", _
		filename, lineNum _
	)
end sub

sub _throwResContRequestNullReferenceError (byref filename as zstring, lineNum as integer)
	_fault->throw(_
		errors.nullReferenceError, _
		"ResContRequestNullReferenceError", "Attempt to reference a NULL ResourceContainer", _
		filename, lineNum _
	)
end sub

sub _throwResContRequestResourceMissingError (byref filename as zstring, lineNum as integer)
	_fault->throw(_
		errors.resourceMissingError, _
		"ResContRequestResourceMissingError", "Failed to reuse resource from stack", _
		filename, lineNum _
	)
end sub

sub _throwResContReleaseNullReferenceError (byref filename as zstring, lineNum as integer)
	_fault->throw(_
		errors.nullReferenceError, _
		"ResContReleaseNullReferenceError", "Attempt to reference a NULL ResourceContainer", _
		filename, lineNum _
	)
end sub

sub _throwResContReleaseInvalidArgumentError (byref filename as zstring, lineNum as integer)
	_fault->throw(_
		errors.invalidArgumentError, _
		"ResContReleaseInvalidArgumentError", "Invalid 2nd Argument: resourceId must be greater than or equal zero", _
		filename, lineNum _
	)
end sub

sub _throwResContReleaseResourceError (byref filename as zstring, lineNum as integer)
	_fault->throw(_
		errors.releaseResourceError, _
		"ResContReleaseResourceError", "Failed to release resource back to container", _
		filename, lineNum _
	)
end sub

sub _throwResContGetPtrNullReferenceError (byref filename as zstring, lineNum as integer)
	_fault->throw(_
		errors.nullReferenceError, _
		"ResContGetPtrNullReferenceError", "Attempt to reference a NULL ResourceContainer", _
		filename, lineNum _
	)
end sub

end namespace

