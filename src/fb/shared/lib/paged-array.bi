
#include once "../../../../modules/headers/constants/constants-v1.bi"
#include once "../../../../modules/headers/paged-array/paged-array-v1.bi"

#define PAGED_ARRAY_INITIAL_PAGING				128

namespace PagedArray

type Dependencies
	meld as MeldInterface ptr
end type

type StateType
	deps as Dependencies
	methods as PagedArray.Interface
end type

dim shared as StateType state

declare function load (meld as MeldInterface ptr) as integer
declare function construct (size as integer, pageLength as integer, warnLimit as integer) as PagedArrayObj ptr
declare sub destruct (arrayPtr as PagedArrayObj ptr)
declare sub unload()

declare function createIndex (arrayPtr as PagedArrayObj ptr) as integer
declare function getIndex (arrayPtr as PagedArrayObj ptr, index as uinteger) as any ptr
declare sub push (arrayPtr as PagedArrayObj ptr, value as any ptr)
declare function pop (arrayPtr as PagedArrayObj ptr) as any ptr

declare function _reallocatePageIndex (arrayPtr as PagedArrayObj ptr) as integer
declare function _createPage (arrayPtr as PagedArrayObj ptr) as integer

function load (meld as MeldInterface ptr) as integer
	if meld = NULL then
		' TODO: Throw error
		print ("PagedArray.load: Invalid meld interface pointer")
		return false
	end if

	state.methods.load = @load
	state.methods.construct = @construct
	state.methods.destruct = @destruct
	state.methods.unload = @unload
	state.methods.createIndex = @createIndex
	state.methods.getIndex = @getIndex
	state.methods.push = @push
	state.methods.pop = @pop

	if not meld->register("paged-array", @state.methods) then
		return false
	end if

	state.deps.meld = meld

	return true
end function

function construct (size as integer, pageLength as integer, warnLimit as integer) as PagedArrayObj ptr
	dim as PagedArrayObj ptr arrayPtr

	if size <= 0 then
		' TODO: Throw error
		print ("PagedArray.construct: Element size must be greater than zero")
		return NULL
	end if

	if pageLength <= 0 then
		' TODO: Throw error
		print ("PagedArray.construct: Page length must be greater than zero")
		return NULL
	end if

	arrayPtr = allocate(sizeof(PagedArrayObj))

	if arrayPtr = NULL then
		' TODO: Throw error
		print ("PagedArray.construct: Failed to allocate PagedArray instance")
		return NULL
	end if

	arrayPtr->size = size
	arrayPtr->pageLength = pageLength
	arrayPtr->warnLimit = warnLimit
	arrayPtr->currentIndex = 0
	arrayPtr->currentPageMax = 0
	arrayPtr->currentMax = 0
	arrayPtr->currentPage = 0

	if not _reallocatePageIndex(arrayPtr) then
		PagedArray.destruct(arrayPtr)
		' TODO: Throw error
		print ("PagedArray.construct: Failed to allocate initial page index")
		return NULL
	end if

	if not _createPage(arrayPtr) then
		PagedArray.destruct(arrayPtr)
		' TODO: Throw error
		print ("PagedArray.construct: Failed to allocate initial page")
		return NULL
	end if

	return arrayPtr
end function

sub destruct (arrayPtr as PagedArrayObj ptr)
	dim as integer pageIndex

	if arrayPtr = NULL then
		' TODO: Throw error
		print ("PagedArray.destruct: Invalid PagedArray pointer")
		exit sub
	end if

	if arrayPtr->pages <> NULL then
		for pageIndex = 0 to arrayPtr->currentPage - 1
			if arrayPtr->pages[pageIndex] <> NULL then
				deallocate(arrayPtr->pages[pageIndex])
				arrayPtr->pages[pageIndex] = NULL
			end if
		next

		deallocate(arrayPtr->pages)
		arrayPtr->pages = NULL
	end if

	arrayPtr->size = 0
	arrayPtr->pageLength = 0
	arrayPtr->warnLimit = 0
	arrayPtr->currentIndex = 0
	arrayPtr->currentMax = 0
	arrayPtr->currentPage = 0

	deallocate(arrayPtr)
end sub

sub unload()
end sub

function createIndex (arrayPtr as PagedArrayObj ptr) as integer
	dim as integer result

	if arrayPtr = NULL then
		' TODO: Throw error
		print ("PagedArray.createIndex: Invalid PagedArray pointer")
		return false
	end if

	result = arrayPtr->currentIndex
	arrayPtr->currentIndex += 1

	if arrayPtr->currentIndex > arrayPtr->currentPageMax then
		if not _createPage(arrayPtr) then
			' TODO: Throw warning
			print ("PagedArray.createIndex: Failed to allocate page index")
		end if
	end if

	return result
end function

function getIndex (arrayPtr as PagedArrayObj ptr, index as uinteger) as any ptr
	dim as byte ptr pagePtr
	dim as integer offset

	if arrayPtr = NULL then
		' TODO: Throw error
		print ("PagedArray.getIndex: Invalid PagedArray pointer")
		return NULL
	end if

	if index < arrayPtr->pageLength then
		pagePtr = arrayPtr->pages[0]
		offset = index
	elseif index >= arrayPtr->currentIndex then
		' TODO: Throw warning
		print ("PagedArray.getIndex: Index (" & index & ") is greater than current array length (" & arrayPtr->currentIndex & ")")
		return NULL
	end if

	return cptr(any ptr, pagePtr + (offset * arrayPtr->size))
end function

sub push (arrayPtr as PagedArrayObj ptr, dataPtr as any ptr)
	dim as integer index
	dim as any ptr ptr elementPtr

	if arrayPtr = NULL then
		' TODO: Throw error
		print ("PagedArray.push: Invalid PagedArray pointer")
		exit sub
	end if

	index = PagedArray.createIndex(arrayPtr)
	elementPtr = getIndex(arrayPtr, index)
	*elementPtr = dataPtr
end sub

function pop (arrayPtr as PagedArrayObj ptr) as any ptr
	dim as any ptr result
	dim as integer index

	if arrayPtr = NULL then
		' TODO: Throw error
		print ("PagedArray.pop: Invalid PagedArray pointer")
		return NULL
	end if

	if arrayPtr->currentIndex <= 0 then
		return NULL
	end if

	index = arrayPtr->currentIndex - 1
	result = PagedArray.getIndex(arrayPtr, index)
	arrayPtr->currentIndex = index

	return result
end function

function _reallocatePageIndex (arrayPtr as PagedArrayObj ptr) as integer
	dim as integer currentMax
	dim as any ptr ptr pageIndexPtr
	dim as integer pageIndex

	if arrayPtr->currentMax > 0 then
		currentMax = arrayPtr->currentMax * 2
		pageIndexPtr = allocate(sizeof(any ptr) * currentMax)

		if pageIndexPtr = NULL then
			' TODO: Throw warning
			print ("PagedArray._reallocatePageIndex: Failed to reallocate page index")
			return false
		end if

		for pageIndex = 0 to arrayPtr->currentPage
			pageIndexPtr[pageIndex] = arrayPtr->pages[pageIndex]
		next

		deallocate(arrayPtr->pages)
		arrayPtr->pages = NULL
	else
		currentMax = PAGED_ARRAY_INITIAL_PAGING
		pageIndexPtr = allocate(sizeof(any ptr) * PAGED_ARRAY_INITIAL_PAGING)
	end if

	if pageIndexPtr = NULL then
		return false
	end if

	arrayPtr->currentMax = currentMax
	arrayPtr->pages = pageIndexPtr

	return true
end function

function _createPage (arrayPtr as PagedArrayObj ptr) as integer
	dim as any ptr page = allocate(arrayPtr->size * arrayPtr->pageLength)

	if page = NULL then
		return false
	end if

	arrayPtr->currentPage += 1
	arrayPtr->currentPageMax += arrayPtr->pageLength
	arrayPtr->pages[arrayPtr->currentPage] = page

	if arrayPtr->currentPage > arrayPtr->currentMax then
		return _reallocatePageIndex(arrayPtr)
	end if

	return true
end function

end namespace
