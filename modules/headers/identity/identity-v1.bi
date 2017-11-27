
#include once "../constants/constants-v1.bi"
#include once "../meld/meld-v1.bi"

namespace Identity

type Instance
	id as integer
end type

type Interface
	load as function (meld as MeldInterface ptr) as integer
	construct as function () as Identity.Instance ptr
	destruct as sub (idPtr as Identity.Instance ptr)
	unload as sub ()
	request as function (idPtr as Identity.Instance ptr, byref identifier as zstring) as integer
end type

end namespace

type IdentityObj as Identity.Instance
