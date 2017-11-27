
#include once "identity.bi"

namespace Identity

function load (meld as MeldInterface ptr) as integer
	return true
end function

sub unload()
end sub

function construct() as IdentityObj ptr
	return NULL
end function

sub destruct(idPtr as IdentityObj ptr)
end sub

function request (idPtr as IdentityObj ptr, byref identifier as zstring) as integer
	return 0
end function

end namespace
