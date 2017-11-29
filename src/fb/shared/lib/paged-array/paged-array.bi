
#include once "../../../../../modules/headers/paged-array/paged-array-v1.bi"

#ifndef PAGED_ARRAY_INITIAL_PAGING
#define PAGED_ARRAY_INITIAL_PAGING				32
#endif

namespace PagedArray

declare function load (meld as MeldInterface ptr) as integer
declare sub unload()
declare function construct (byref id as zstring, size as integer, pageLength as integer, warnLimit as integer) as PagedArrayObj ptr
declare sub destruct (arrayPtr as PagedArrayObj ptr)

declare function createIndex (arrayPtr as PagedArrayObj ptr) as integer
declare function getIndex (arrayPtr as PagedArrayObj ptr, index as uinteger) as any ptr
declare function pop (arrayPtr as PagedArrayObj ptr, dataPtr as any ptr) as integer
declare function isEmpty (arrayPtr as PagedArrayObj ptr) as integer

declare function _reallocatePageIndex (arrayPtr as PagedArrayObj ptr) as integer
declare function _createPage (arrayPtr as PagedArrayObj ptr) as integer

end namespace
