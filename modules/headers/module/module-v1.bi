
#include once "../constants/constants-v1.bi"
#include once "../meld/meld-v1.bi"

namespace Module

type Entry
	moduleName as string
	interfacePtr as any ptr
	library as any ptr
end type

type SetEntryFnc as function cdecl (byref moduleName as zstring, module as Entry ptr) as short

type GetEntryFnc as function cdecl (byref moduleName as zstring) as Entry ptr

type Interface
	system as Meld.Interface
	initialize as sub cdecl ()
	exports as function cdecl (byref moduleName as zstring, interfacePtr as any ptr) as short
	require as function cdecl (byref moduleName as zstring) as any ptr
	setHandlers as sub cdecl (setEntry as SetEntryFnc = NULL, getEntry as GetEntryFnc)
	test as function cdecl (value as short) as short
end type

end namespace
