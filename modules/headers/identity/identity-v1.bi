
#include once "../constants/constants-v1.bi"
#include once "../core/core-v1.bi"
#include once "../paged-array/paged-array-v1.bi"
#include once "../bst/bst-v1.bi"

namespace Identity

union resourceId
	idArray(8) as ubyte
	idPtr as any ptr
	idInt as uinteger
end union

type Instance
	idArray as PagedArrayObj ptr
	reference as BstObj ptr
end type

type Identifier
	permanent as zstring*36
	resource as resourceId
end type

type Interface
	load as function (corePtr as Core.Interface ptr) as integer
	unload as sub ()
	register as function () as integer
	unregister as sub ()
	construct as function () as Identity.Instance ptr
	destruct as sub (idPtr as Identity.Instance ptr)
	request as function (idPtr as Identity.Instance ptr, byref identifier as zstring) as integer
end type

end namespace

type IdentityObj as Identity.Instance
