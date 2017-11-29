
#include once "../constants/constants-v1.bi"
#include once "../meld/meld-v1.bi"

namespace PagedArray

type Instance
	id as zstring*64
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
	unload as sub()
	construct as function (byref id as zstring, size as integer, pageLength as integer, warnLimit as integer) as PagedArray.Instance ptr
	destruct as sub (arrayPtr as PagedArray.Instance ptr)
	createIndex as function (arrayPtr as PagedArray.Instance ptr) as integer
	getIndex as function (arrayPtr as PagedArray.Instance ptr, index as uinteger) as any ptr
	pop as function (arrayPtr as PagedArray.Instance ptr, dataPtr as any ptr) as integer
	isEmpty as function (arrayPtr as PagedArray.Instance ptr) as integer
end type

end namespace

type PagedArrayObj as PagedArray.Instance
