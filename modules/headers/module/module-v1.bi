
/'
' Generated by Meld Framework, do not modify.  Any changes will be overwritten
' during the next build.
'/

#include once "../constants/constants-v1.bi"

namespace Module

type LibraryEntry
	library as any ptr
	interfacePtr as any ptr
	moduleName as String
	fileName as String
end type

type ModuleWillLoadFn as function cdecl (entryPtr as any ptr) as short

type ModuleHasUnloadedFn as function cdecl (entryPtr as any ptr) as short

type Interface
	initialize as function cdecl (_argc as integer, _argv as any ptr) as short
	uninitialize as function cdecl () as short
	setModuleWillLoad as sub cdecl (handler as ModuleWillLoadFn)
	setModuleHasUnloaded as sub cdecl (handler as ModuleHasUnloadedFn)
	require as function cdecl (byref moduleName as zstring) as any ptr
	argv as function cdecl (index as ulong) as zstring ptr
	argc as function cdecl () as long
end type

end namespace
