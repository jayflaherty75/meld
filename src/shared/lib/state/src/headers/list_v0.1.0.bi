
/'
 ' Generated by Meld Framework, do not modify.  Any changes will be overwritten
 ' during the next build.
 '/

namespace List

type CompareFn as function cdecl (criteria as any ptr, current as any ptr) as short

type Node
	nextPtr as Node ptr
	prevPtr as Node ptr
	element as any ptr
end type

type Instance
	first as Node ptr
	last as Node ptr
	length as long
end type

type Interface
	startup as function cdecl () as short
	shutdown as function cdecl () as short
	construct as function cdecl () as Instance ptr
	destruct as sub cdecl (instancePtr as Instance ptr)
	update as any ptr
	test as function cdecl (describeFn as any ptr) as short
	insert as function cdecl (listPtr as Instance ptr, element as any ptr, prevPtr as Node ptr = 0) as Node ptr
	remove as sub cdecl (listPtr as Instance ptr, node as Node ptr)
	getFirst as function cdecl (listPtr as Instance ptr) as Node ptr
	getLast as function cdecl (listPtr as Instance ptr) as Node ptr
	getNext as function cdecl (listPtr as Instance ptr, node as Node ptr) as Node ptr
	getLength as function cdecl (listPtr as Instance ptr) as long
	search as function cdecl (listPtr as Instance ptr, element as any ptr, compare as CompareFn) as Node ptr
	defaultCompare as function cdecl (criteria as any ptr, current as any ptr) as short
	getIterator as function cdecl (listPtr as Instance ptr) as any ptr
	isValid as function cdecl (listPtr as Instance ptr) as short
end type

end namespace