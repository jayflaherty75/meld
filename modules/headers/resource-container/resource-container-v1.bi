
#include once "../constants/constants-v1.bi"
#include once "../core/core-v1.bi"
#include once "../paged-array/paged-array-v1.bi"

namespace ResourceContainer

type Instance
	id as zstring*32
	resources as PagedArrayObj ptr
	stack as PagedArrayObj ptr
end type

type Interface
	load as function cdecl (corePtr as Core.Interface ptr) as integer
	unload as sub cdecl ()
	register as function() as integer
	unregister as sub ()
	construct as function (byref id as zstring, size as integer, pageLength as integer, warnLimit as integer) as ResourceContainer.Instance ptr
	destruct as sub (idPtr as ResourceContainer.Instance ptr)
	request as function (contPtr as ResourceContainer.Instance ptr) as integer
	release as function (contPtr as ResourceContainer.Instance ptr, resourceId as integer) as integer
	getPtr as function (contPtr as ResourceContainer.Instance ptr, resourceId as integer) as any ptr
end type

end namespace

type ResourceContainerObj as ResourceContainer.Instance
