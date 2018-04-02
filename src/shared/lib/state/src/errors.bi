
namespace State

declare sub _throwStateAllocationError (byref filename as zstring, lineNum as integer)
declare sub _throwStateDestructNullReferenceError (byref filename as zstring, lineNum as integer)

sub _throwStateAllocationError (byref filename as zstring, lineNum as integer)
	_fault->throw(_
		errors.allocationError, _
		"AllocationError", "Failed to allocate State instance", _
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

end namespace

