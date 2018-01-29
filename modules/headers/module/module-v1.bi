
#include once "../constants/constants-v1.bi"
#include once "../core/core-v1.bi"

namespace Module

type Entry
	moduleName as string
	interfacePtr as any ptr
	library as any ptr
end type

type SetEntryFnc as function cdecl (byref moduleName as zstring, module as Entry ptr) as short

type GetEntryFnc as function cdecl (byref moduleName as zstring) as Entry ptr

type Interface
	load as function cdecl (corePtr as Core.Interface ptr) as integer
	unload as sub cdecl ()
	register as function () as integer
	unregister as sub ()
	initialize as sub cdecl ()
	exports as function cdecl (byref moduleName as zstring, interfacePtr as any ptr) as short
	require as function cdecl (byref moduleName as zstring) as any ptr
	setHandlers as sub cdecl (setEntry as SetEntryFnc = NULL, getEntry as GetEntryFnc)
	test as function cdecl (value as short) as short
end type

end namespace
