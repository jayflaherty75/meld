
#include once "identity.bi"
#include once "module.bi"

namespace Identity

function construct() as IdentityObj ptr
	dim as IdentityObj ptr identityPtr = allocate(sizeof(IdentityObj))

	return identityPtr
end function

sub destruct(idPtr as IdentityObj ptr)
end sub

function request (idPtr as IdentityObj ptr, byref identifier as zstring) as integer
	return 0
end function

end namespace
