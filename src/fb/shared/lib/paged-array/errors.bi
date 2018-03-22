
namespace PagedArray

declare sub _throwPagedArrayAllocationError (byref filename as zstring, lineNum as integer)
declare sub _throwPagedArrayDestructNullReferenceError (byref filename as zstring, lineNum as integer)
declare sub _throwPagedArrayInitializeNullReferenceError (byref filename as zstring, lineNum as integer)
declare sub _throwPagedArrayIndexAllocationError (byref filename as zstring, lineNum as integer)
declare sub _throwPagedArrayInitPageAllocationError (byref filename as zstring, lineNum as integer)
declare sub _throwPagedArrayCreateIndexNullReferenceError (byref filename as zstring, lineNum as integer)
declare sub _throwPagedArrayCreateIndexAllocationError (byref filename as zstring, lineNum as integer)
declare sub _throwPagedArrayGetIndexNullReferenceError (byref filename as zstring, lineNum as integer)
declare sub _throwPagedArrayOutOfBoundsError (index as ulong, current as ulong, byref filename as zstring, lineNum as integer)
declare sub _throwPagedArrayPopNullReferenceError (byref filename as zstring, lineNum as integer)
declare sub _throwPagedArrayIsEmptyNullReferenceError (byref filename as zstring, lineNum as integer)
declare sub _throwPagedArrayLimitSurpassed (byref filename as zstring, lineNum as integer)

sub _throwPagedArrayAllocationError (byref filename as zstring, lineNum as integer)
	_fault->throw(_
		errors.resourceAllocationError, _
		"PagedArrayAllocationError", "Failed to allocate PagedArray instance", _
		filename, lineNum _
	)
end sub

sub _throwPagedArrayDestructNullReferenceError (byref filename as zstring, lineNum as integer)
	_fault->throw(_
		errors.nullReferenceError, _
		"PagedArrayDestructNullReferenceError", "Attempt to reference a NULL PagedArray", _
		filename, lineNum _
	)
end sub

sub _throwPagedArrayInitializeNullReferenceError (byref filename as zstring, lineNum as integer)
	_fault->throw(_
		errors.nullReferenceError, _
		"PagedArrayInitializeNullReferenceError", "Attempt to reference a NULL PagedArray", _
		filename, lineNum _
	)
end sub

sub _throwPagedArrayIndexAllocationError (byref filename as zstring, lineNum as integer)
	_fault->throw(_
		errors.resourceAllocationError, _
		"PagedArrayIndexAllocationError", "Failed to allocate page index", _
		filename, lineNum _
	)
end sub

sub _throwPagedArrayInitPageAllocationError (byref filename as zstring, lineNum as integer)
	_fault->throw(_
		errors.resourceAllocationError, _
		"PagedArrayInitPageAllocationError", "Failed to allocate initial page", _
		filename, lineNum _
	)
end sub

sub _throwPagedArrayCreateIndexNullReferenceError (byref filename as zstring, lineNum as integer)
	_fault->throw(_
		errors.nullReferenceError, _
		"PagedArrayCreateIndexNullReferenceError", "Attempt to reference a NULL PagedArray", _
		filename, lineNum _
	)
end sub

sub _throwPagedArrayCreateIndexAllocationError (byref filename as zstring, lineNum as integer)
	_fault->throw(_
		errors.resourceAllocationError, _
		"PagedArrayCreateIndexAllocationError", "Failed to allocate page index", _
		filename, lineNum _
	)
end sub

sub _throwPagedArrayGetIndexNullReferenceError (byref filename as zstring, lineNum as integer)
	_fault->throw(_
		errors.nullReferenceError, _
		"PagedArrayGetIndexNullReferenceError", "Attempt to reference a NULL PagedArray", _
		filename, lineNum _
	)
end sub

sub _throwPagedArrayOutOfBoundsError (index as ulong, current as ulong, byref filename as zstring, lineNum as integer)
	_fault->throw(_
		errors.outOfBoundsError, _
		"PagedArrayOutOfBoundsError", "Index (" & index & ") is greater than current array length (" & current & ")", _
		filename, lineNum _
	)
end sub

sub _throwPagedArrayPopNullReferenceError (byref filename as zstring, lineNum as integer)
	_fault->throw(_
		errors.nullReferenceError, _
		"PagedArrayPopNullReferenceError", "Attempt to reference a NULL PagedArray", _
		filename, lineNum _
	)
end sub

sub _throwPagedArrayIsEmptyNullReferenceError (byref filename as zstring, lineNum as integer)
	_fault->throw(_
		errors.nullReferenceError, _
		"PagedArrayIsEmptyNullReferenceError", "Attempt to reference a NULL PagedArray", _
		filename, lineNum _
	)
end sub

sub _throwPagedArrayLimitSurpassed (byref filename as zstring, lineNum as integer)
	_fault->throw(_
		errors.resourceLimitSurpassed, _
		"PagedArrayLimitSurpassed", "PagedArray warning limit has been surpassed", _
		filename, lineNum _
	)
end sub

end namespace

