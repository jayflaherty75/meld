
/'
 ' Generated by Meld Framework, do not modify.  Any changes will be overwritten
 ' during the next build.
 '/

namespace State

type AllocatorFn as function cdecl (memPtr as any ptr, size as long) as any ptr

type ModifierFn as function cdecl (resourcePtr as any ptr, messagePtr as any ptr) as short

type SelectorFn as function cdecl (statePtr as any ptr, resPtr as any ptr, valuePtr as any ptr) as short

type SelectorAtFn as function cdecl (statePtr as any ptr, resPtr as any ptr, index as long) as long

type Instance
	mappings as any ptr
	resources as any ptr
	modifiers as any ptr
	messages as any ptr
	allocator as AllocatorFn
end type

type Interface
	startup as function cdecl () as short
	shutdown as function cdecl () as short
	construct as function cdecl () as Instance ptr
	destruct as sub cdecl (instancePtr as Instance ptr)
	update as function cdecl (instancePtr as any ptr) as short
	test as function cdecl (describeFn as any ptr) as short
	initialize as function cdecl (statePtr as Instance ptr, pageLength as long = 1024, warnLimit as long = 2147483647) as short
	setAllocator as sub cdecl (statePtr as Instance ptr, allocator as AllocatorFn)
	request as function cdecl (statePtr as Instance ptr, id as ubyte ptr) as long
	release as function cdecl (statePtr as Instance ptr, index as long) as short
	getRefCount as function cdecl (statePtr as Instance ptr, index as long) as short
	isReferenced as function cdecl (statePtr as Instance ptr, index as long) as short
	assign as function cdecl (statePtr as Instance ptr, index as long, size as long) as short
	assignFromContainer as function cdecl (statePtr as Instance ptr, index as long, contPtr as any ptr) as short
	unassign as function cdecl (statePtr as Instance ptr, index as long) as short
	isAssigned as function cdecl (statePtr as Instance ptr, index as long) as short
	setModifier as function cdecl (statePtr as Instance ptr, index as long, modifier as ModifierFn) as short
	unsetModifier as function cdecl (statePtr as Instance ptr, index as long) as short
	selectFrom as function cdecl (statePtr as Instance ptr, index as long, valuePtr as any ptr, selector as SelectorFn) as short
	selectAt as function cdecl (statePtr as Instance ptr, stateIdx as long, resIdx as long, selector as SelectorAtFn) as long
	dispatch as function cdecl (statePtr as Instance ptr, message as any ptr, isPrioritized as short = 0) as short
	_directDispatch as function cdecl (statePtr as Instance ptr, message as any ptr) as short
end type

end namespace
