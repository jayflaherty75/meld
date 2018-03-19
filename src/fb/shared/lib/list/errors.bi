
namespace List

declare sub _throwListAllocationError (byref filename as zstring, lineNum as integer)
declare sub _throwListDestructNullReferenceError (byref filename as zstring, lineNum as integer)
declare sub _throwListReleaseError (byref filename as zstring, lineNum as integer)
declare sub _throwListInsertNullReferenceError (byref filename as zstring, lineNum as integer)
declare sub _throwListInsertInvalidArgumentError (byref filename as zstring, lineNum as integer)
declare sub _throwListNodeAllocationError (byref filename as zstring, lineNum as integer)
declare sub _throwListRemoveNullReferenceError (byref filename as zstring, lineNum as integer)
declare sub _throwListRemoveInvalidArgumentError (byref filename as zstring, lineNum as integer)
declare sub _throwListGetFirstNullReferenceError (byref filename as zstring, lineNum as integer)
declare sub _throwListGetLastNullReferenceError (byref filename as zstring, lineNum as integer)
declare sub _throwListGetNextNullReferenceError (byref filename as zstring, lineNum as integer)
declare sub _throwListGetLengthNullReferenceError (byref filename as zstring, lineNum as integer)
declare sub _throwListSearchNullReferenceError (byref filename as zstring, lineNum as integer)
declare sub _throwListSearchInvalidArgumentError (byref filename as zstring, lineNum as integer)
declare sub _throwListGetIteratorNullReferenceError (byref filename as zstring, lineNum as integer)

sub _throwListAllocationError (byref filename as zstring, lineNum as integer)
	_fault->throw(_
		errors.resourceAllocationError, _
		"ListAllocationError", "Failed to allocate List instance", _
		filename, lineNum _
	)
end sub

sub _throwListDestructNullReferenceError (byref filename as zstring, lineNum as integer)
	_fault->throw(_
		errors.nullReferenceError, _
		"ListDestructNullReferenceError", "Attempt to reference a NULL List", _
		filename, lineNum _
	)
end sub

sub _throwListReleaseError (byref filename as zstring, lineNum as integer)
	_fault->throw(_
		errors.releaseResourceError, _
		"ReleaseListError", "Failed to correctly release all resources from List", _
		filename, lineNum _
	)
end sub

sub _throwListInsertNullReferenceError (byref filename as zstring, lineNum as integer)
	_fault->throw(_
		errors.nullReferenceError, _
		"ListInsertNullReferenceError", "Attempt to reference a NULL List", _
		filename, lineNum _
	)
end sub

sub _throwListInsertInvalidArgumentError (byref filename as zstring, lineNum as integer)
	_fault->throw(_
		errors.invalidArgumentError, _
		"ListInsertInvalidArgumentError", "Invalid 2nd Argument: element must not be NULL", _
		filename, lineNum _
	)
end sub

sub _throwListNodeAllocationError (byref filename as zstring, lineNum as integer)
	_fault->throw(_
		errors.resourceAllocationError, _
		"ListNodeAllocationError", "Failed to allocate List node", _
		filename, lineNum _
	)
end sub

sub _throwListRemoveNullReferenceError (byref filename as zstring, lineNum as integer)
	_fault->throw(_
		errors.nullReferenceError, _
		"ListRemoveNullReferenceError", "Attempt to reference a NULL List", _
		filename, lineNum _
	)
end sub

sub _throwListRemoveInvalidArgumentError (byref filename as zstring, lineNum as integer)
	_fault->throw(_
		errors.invalidArgumentError, _
		"ListRemoveInvalidArgumentError", "Invalid 2nd Argument: node must not be NULL", _
		filename, lineNum _
	)
end sub

sub _throwListGetFirstNullReferenceError (byref filename as zstring, lineNum as integer)
	_fault->throw(_
		errors.nullReferenceError, _
		"ListGetFirstNullReferenceError", "Attempt to reference a NULL List", _
		filename, lineNum _
	)
end sub

sub _throwListGetLastNullReferenceError (byref filename as zstring, lineNum as integer)
	_fault->throw(_
		errors.nullReferenceError, _
		"ListGetLastNullReferenceError", "Attempt to reference a NULL List", _
		filename, lineNum _
	)
end sub

sub _throwListGetNextNullReferenceError (byref filename as zstring, lineNum as integer)
	_fault->throw(_
		errors.nullReferenceError, _
		"ListGetNextNullReferenceError", "Attempt to reference a NULL List", _
		filename, lineNum _
	)
end sub

sub _throwListGetLengthNullReferenceError (byref filename as zstring, lineNum as integer)
	_fault->throw(_
		errors.nullReferenceError, _
		"ListGetLengthNullReferenceError", "Attempt to reference a NULL List", _
		filename, lineNum _
	)
end sub

sub _throwListSearchNullReferenceError (byref filename as zstring, lineNum as integer)
	_fault->throw(_
		errors.nullReferenceError, _
		"ListSearchNullReferenceError", "Attempt to reference a NULL List", _
		filename, lineNum _
	)
end sub

sub _throwListSearchInvalidArgumentError (byref filename as zstring, lineNum as integer)
	_fault->throw(_
		errors.invalidArgumentError, _
		"ListSearchInvalidArgumentError", "Invalid 2nd Argument: element must not be NULL", _
		filename, lineNum _
	)
end sub

sub _throwListGetIteratorNullReferenceError (byref filename as zstring, lineNum as integer)
	_fault->throw(_
		errors.nullReferenceError, _
		"ListGetIteratorNullReferenceError", "Attempt to reference a NULL List", _
		filename, lineNum _
	)
end sub

end namespace

