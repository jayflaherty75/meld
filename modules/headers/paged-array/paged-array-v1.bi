
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
	arrName as zstring*32
end type

type Interface
	load as function (meld as MeldInterface ptr) as integer
	construct as function (byref arrName as zstring, size as integer, pageLength as integer, warnLimit as integer) as PagedArray.Instance ptr
	destruct as sub (arrayPtr as PagedArray.Instance ptr)
	unload as sub()
	createIndex as function (arrayPtr as PagedArray.Instance ptr) as integer
	getIndex as function (arrayPtr as PagedArray.Instance ptr, index as uinteger) as any ptr
	pop as function (arrayPtr as PagedArray.Instance ptr, dataPtr as any ptr) as integer
end type

end namespace

type PagedArrayObj as PagedArray.Instance
