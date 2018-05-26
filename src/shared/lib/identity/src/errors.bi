
namespace Identity

declare sub _throwIdentityAllocationError (byref filename as zstring, lineNum as integer)
declare sub _throwIdentityDestructNullReferenceError (byref filename as zstring, lineNum as integer)
declare sub _throwIdentityGetAutoIncNullReferenceError (byref filename as zstring, lineNum as integer)

sub _throwIdentityAllocationError (byref filename as zstring, lineNum as integer)
	_fault->throwErr(_
		errors.resourceAllocationError, _
		"IdentityAllocationError", "Failed to create Identity instance", _
		filename, lineNum _
	)
end sub

sub _throwIdentityDestructNullReferenceError (byref filename as zstring, lineNum as integer)
	_fault->throwErr(_
		errors.nullReferenceError, _
		"IdentityDestructNullReferenceError", "No pointer provided to destructor", _
		filename, lineNum _
	)
end sub

sub _throwIdentityGetAutoIncNullReferenceError (byref filename as zstring, lineNum as integer)
	_fault->throwErr(_
		errors.nullReferenceError, _
		"IdentityGetAutoIncNullReferenceError", "No pointer provided to getAutoInc()", _
		filename, lineNum _
	)
end sub

end namespace

