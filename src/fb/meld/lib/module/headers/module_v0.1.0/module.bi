
/'
' Generated by Meld Framework, do not modify.  Any changes will be overwritten
' during the next build.
'/

namespace Module

type ModuleWillLoadFn as function cdecl (entryPtr as any ptr) as short

type ModuleHasUnloadedFn as function cdecl (entryPtr as any ptr) as short

type LibraryEntry
	library as any ptr
	interfacePtr as any ptr
	moduleId as String
	moduleName as String
	moduleFullName as String
	moduleVersion as String
	fileName as String
	unload as ModuleHasUnloadedFn
end type

type Interface
	startup as function cdecl () as short
	shutdown as function cdecl () as short
	construct as any ptr
	destruct as any ptr
	update as any ptr
	test as any ptr
	initialize as function cdecl (_argc as integer, _argv as any ptr) as short
	uninitialize as function cdecl () as short
	setModuleWillLoad as sub cdecl (handler as ModuleWillLoadFn)
	setModuleHasUnloaded as sub cdecl (handler as ModuleHasUnloadedFn)
	require as function cdecl (byref moduleName as zstring) as any ptr
	unload as function cdecl (byref moduleName as zstring) as short
	testModule as function cdecl (byref moduleName as zstring) as short
	argv as function cdecl (index as ulong) as zstring ptr
	argc as function cdecl () as long
end type

end namespace
