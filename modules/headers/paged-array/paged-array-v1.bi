
namespace PagedArray

type Instance
	size as integer
	pageLength as integer
	warnLimit as integer
	currentIndex as integer
	currentPageMax as integer
	currentMax as integer
	currentPage as integer
	pages as any ptr ptr
end type


type Interface
	load as function (meld as MeldInterface ptr) as integer
	construct as function (size as integer, pageLength as integer, warnLimit as integer) as PagedArray.Instance ptr
	destruct as sub (arrayPtr as PagedArray.Instance ptr)
	unload as sub()
	createIndex as function (arrayPtr as PagedArray.Instance ptr) as integer
	getIndex as function (arrayPtr as PagedArray.Instance ptr, index as uinteger) as any ptr
	push as sub (arrayPtr as PagedArray.Instance ptr, value as any ptr)
	pop as function (arrayPtr as PagedArray.Instance ptr) as any ptr
end type

end namespace

type PagedArrayObj as PagedArray.Instance
