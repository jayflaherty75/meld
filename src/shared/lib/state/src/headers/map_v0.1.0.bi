
/'
 ' Generated by Meld Framework, do not modify.  Any changes will be overwritten
 ' during the next build.
 '/

namespace Map

type Instance
	container as any ptr
	mappings as any ptr
end type

type Interface
	startup as function cdecl () as short
	shutdown as function cdecl () as short
	construct as function cdecl () as Instance ptr
	destruct as sub cdecl (instancePtr as Instance ptr)
	update as any ptr
	test as function cdecl (describeFn as any ptr) as short
	assign as function cdecl (mapPtr as Instance ptr, idPtr as ubyte ptr, resIdx as long) as short
	assignPtr as function cdecl (mapPtr as Instance ptr, idPtr as ubyte ptr, resPtr as any ptr) as short
	request as function cdecl (mapPtr as Instance ptr, idPtr as ubyte ptr) as long
	requestPtr as function cdecl (mapPtr as Instance ptr, idPtr as ubyte ptr) as any ptr
	unassign as function cdecl (mapPtr as Instance ptr, idPtr as ubyte ptr) as short
	getLength as function cdecl (mapPtr as Instance ptr) as long
	purge as sub cdecl (mapPtr as Instance ptr)
	getIterator as function cdecl (mapPtr as Instance ptr) as any ptr
end type

end namespace
