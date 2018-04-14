
/'
 ' Generated by Meld Framework, do not modify.  Any changes will be overwritten
 ' during the next build.
 '/

namespace TypeMap

type DestructFn as sub cdecl (instPtr as any ptr)

type Entry
	id as ubyte ptr
	index as long
	size as long
	destruct as DestructFn
end type

type Interface
	startup as function cdecl () as short
	shutdown as function cdecl () as short
	construct as any ptr
	destruct as any ptr
	update as any ptr
	test as function cdecl (describeFn as any ptr) as short
	request as function cdecl (id as ubyte ptr) as long
	getEntry as function cdecl (index as long) as Entry ptr
	assign as function cdecl (entryPtr as Entry ptr, size as long, destructFnPtr as DestructFn) as short
	isAssigned as function cdecl (entryPtr as Entry ptr) as short
	getSize as function cdecl (entryPtr as Entry ptr) as long
	getDestructor as function cdecl (entryPtr as Entry ptr) as DestructFn
	destroy as function cdecl (entryPtr as Entry ptr, instancePtr as any ptr) as short
end type

end namespace
