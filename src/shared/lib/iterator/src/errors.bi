
namespace Iterator

declare sub _throwIteratorAllocationError (byref filename as zstring, lineNum as integer)
declare sub _throwIteratorDestructNullReferenceError (byref filename as zstring, lineNum as integer)
declare sub _throwIteratorSetHandlerNullReferenceError (byref filename as zstring, lineNum as integer)
declare sub _throwIteratorSetHandlerInvalidArgumentError (byref filename as zstring, lineNum as integer)
declare sub _throwIteratorSetDataNullReferenceError (byref filename as zstring, lineNum as integer)
declare sub _throwIteratorGetNextNullReferenceError (byref filename as zstring, lineNum as integer)
declare sub _throwIteratorGetNextInvalidArgumentError (byref filename as zstring, lineNum as integer)
declare sub _throwIteratorResetNullReferenceError (byref filename as zstring, lineNum as integer)

sub _throwIteratorAllocationError (byref filename as zstring, lineNum as integer)
	_fault->throwErr(_
		errors.resourceAllocationError, _
		"IteratorAllocationError", "Failed to allocate Iterator instance", _
		filename, lineNum _
	)
end sub

sub _throwIteratorDestructNullReferenceError (byref filename as zstring, lineNum as integer)
	_fault->throwErr(_
		errors.nullReferenceError, _
		"IteratorDestructNullReferenceError", "Attempt to reference a NULL Iterator", _
		filename, lineNum _
	)
end sub

sub _throwIteratorSetHandlerNullReferenceError (byref filename as zstring, lineNum as integer)
	_fault->throwErr(_
		errors.nullReferenceError, _
		"IteratorSetHandlerNullReferenceError", "Attempt to reference a NULL Iterator", _
		filename, lineNum _
	)
end sub

sub _throwIteratorSetHandlerInvalidArgumentError (byref filename as zstring, lineNum as integer)
	_fault->throwErr(_
		errors.invalidArgumentError, _
		"IteratorSetHandlerInvalidArgumentError", "Invalid 2nd Argument: cb must be a function", _
		filename, lineNum _
	)
end sub

sub _throwIteratorSetDataNullReferenceError (byref filename as zstring, lineNum as integer)
	_fault->throwErr(_
		errors.nullReferenceError, _
		"IteratorSetDataNullReferenceError", "Attempt to reference a NULL Iterator", _
		filename, lineNum _
	)
end sub

sub _throwIteratorGetNextNullReferenceError (byref filename as zstring, lineNum as integer)
	_fault->throwErr(_
		errors.nullReferenceError, _
		"IteratorGetNextNullReferenceError", "Attempt to reference a NULL Iterator", _
		filename, lineNum _
	)
end sub

sub _throwIteratorGetNextInvalidArgumentError (byref filename as zstring, lineNum as integer)
	_fault->throwErr(_
		errors.invalidArgumentError, _
		"IteratorGetNextInvalidArgumentError", "Invalid 2nd Argument: target must not be NULL", _
		filename, lineNum _
	)
end sub

sub _throwIteratorResetNullReferenceError (byref filename as zstring, lineNum as integer)
	_fault->throwErr(_
		errors.nullReferenceError, _
		"IteratorResetNullReferenceError", "Attempt to reference a NULL Iterator", _
		filename, lineNum _
	)
end sub

end namespace

