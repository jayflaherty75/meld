
namespace Identity

/'
declare sub _throwDefaultGeneralError (byref id as zstring, byref filename as zstring, lineNum as integer)

sub _throwDefaultGeneralError (byref id as zstring, byref filename as zstring, lineNum as integer)
	_fault->throw(_
		errors.generalError, _
		"DefaultGeneralError", "Testing errors: " & id, _
		filename, lineNum _
	)
end sub
'/

declare sub _throwIdentityAllocationError (byref filename as zstring, lineNum as integer)
declare sub _throwIdentityDestructNullReferenceError (byref filename as zstring, lineNum as integer)

sub _throwIdentityAllocationError (byref filename as zstring, lineNum as integer)
	_fault->throw(_
		errors.resourceAllocationError, _
		"IdentityAllocationError", "Failed to create Identity instance", _
		filename, lineNum _
	)
end sub

sub _throwIdentityDestructNullReferenceError (byref filename as zstring, lineNum as integer)
	_fault->throw(_
		errors.nullReferenceError, _
		"IdentityDestructNullReferenceError", "No pointer provided to destructor", _
		filename, lineNum _
	)
end sub

end namespace
