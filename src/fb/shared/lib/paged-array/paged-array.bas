
#include once "paged-array.bi"

namespace PagedArray

type Dependencies
	meld as MeldInterface ptr
end type

type StateType
	deps as Dependencies
	methods as Interface
end type

dim shared as StateType state

/''
 ' Loading lifecycle function called by Meld framework.
 ' @param {MeldInterface ptr} meld
 ' @returns {integer}
 '/
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
	state.methods.pop = @pop

	if not meld->register("paged-array", @state.methods) then
		return false
	end if

	state.deps.meld = meld

	return true
end function

/''
 ' Unload lifecycle function called by Meld framework.
 '/
sub unload()
end sub

/''
 ' Construct lifecycle function called by Meld framework.
 ' @param {zstring} id
 ' @param {integer} size
 ' @param {integer} pageLength
 ' @param {integer} warnLimit
 ' @returns {PagedArrayObj ptr}
 '/
function construct (byref id as zstring, size as integer, pageLength as integer, warnLimit as integer) as PagedArrayObj ptr
	dim as PagedArrayObj ptr arrayPtr

	if size <= 0 then
		' TODO: Throw error
		print ("PagedArray.construct: Element size must be greater than zero: " & id)
		return NULL
	end if

	if pageLength <= 0 then
		' TODO: Throw error
		print ("PagedArray.construct: Page length must be greater than zero: " & id)
		return NULL
	end if

	arrayPtr = allocate(sizeof(PagedArrayObj))

	if arrayPtr = NULL then
		' TODO: Throw error
		print ("PagedArray.construct: Failed to allocate PagedArray instance: " & id)
		return NULL
	end if

	arrayPtr->id = left(id, 32)
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
		print ("PagedArray.construct: Failed to allocate initial page index: " & id)
		return NULL
	end if

	if not _createPage(arrayPtr) then
		PagedArray.destruct(arrayPtr)
		' TODO: Throw error
		print ("PagedArray.construct: Failed to allocate initial page: " & id)
		return NULL
	end if

	return arrayPtr
end function

/''
 ' Destruct lifecycle function called by Meld framework.
 ' @param {PagedArrayObj ptr} arrayPtr
 '/
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
	arrayPtr->currentPageMax = 0
	arrayPtr->currentMax = 0
	arrayPtr->currentPage = 0

	deallocate(arrayPtr)
end sub

/''
 ' Creates and returns a new index available in the paged array.
 ' @param {PagedArrayObj ptr} arrayPtr
 ' @returns {integer}
 '/
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
			print ("PagedArray.createIndex: Failed to allocate page index: " & arrayPtr->id)
		end if
	end if

	return result
end function

/''
 ' Returns the data pointer for the given index of the paged array.
 ' @param {PagedArrayObj ptr} arrayPtr
 ' @param {uinteger} index
 ' @returns {any ptr}
 '/
function getIndex (arrayPtr as PagedArrayObj ptr, index as uinteger) as any ptr
	dim as byte ptr pagePtr
	dim as uinteger offset

	if arrayPtr = NULL then
		' TODO: Throw error
		print ("PagedArray.getIndex: Invalid PagedArray pointer")
		return NULL
	end if

	if index < arrayPtr->pageLength then
		' Optimize first page of all arrays and large single page arrays
		pagePtr = arrayPtr->pages[0]
		offset = index
	elseif index >= arrayPtr->currentIndex then
		' TODO: Throw warning
		print ("PagedArray.getIndex: Index (" & index & ") is greater than current array length (" & arrayPtr->currentIndex & "): " & arrayPtr->id)
		return NULL
	else
		pagePtr = arrayPtr->pages[index \ arrayPtr->pageLength]
		offset = index mod arrayPtr->pageLength
	end if

	return cptr(any ptr, pagePtr + (offset * arrayPtr->size))
end function

/''
 ' Pops and releases the last created index from the paged array and stores
 ' it at the given data pointer.
 ' @param {PagedArrayObj ptr} arrayPtr
 ' @returns {any ptr}
 '/
function pop (arrayPtr as PagedArrayObj ptr, dataPtr as any ptr) as integer
	dim as integer i
	dim as any ptr result
	dim as integer index

	if arrayPtr = NULL then
		' TODO: Throw error
		print ("PagedArray.pop: Invalid PagedArray pointer")
		return false
	end if

	if arrayPtr->currentIndex <= 0 then
		return false
	end if

	index = arrayPtr->currentIndex - 1

	result = PagedArray.getIndex(arrayPtr, index)

	'*cptr(integer ptr, dataPtr) = *cptr(integer ptr, result)
	for i = 0 to arrayPtr->size \ 4 - 1
		poke uinteger, cptr(uinteger ptr, dataPtr), *cptr(uinteger ptr, result)
	next

	arrayPtr->currentIndex = index

	return true
end function

function isEmpty (arrayPtr as PagedArrayObj ptr) as integer
	if arrayPtr = NULL then
		' TODO: Throw error
		print ("PagedArray.isEmpty: Invalid PagedArray pointer")
		return false
	end if

	if arrayPtr->currentIndex = 0 then
		return false
	end if

	return true
end function

/''
 ' Utility function to create a new page when the array runs out of available
 ' elements.
 ' @param {PagedArrayObj ptr} arrayPtr
 ' @returns {integer}
 ' @private
 '/
function _createPage (arrayPtr as PagedArrayObj ptr) as integer
	dim as any ptr page = allocate(arrayPtr->size * arrayPtr->pageLength)

	if page = NULL then
		return false
	end if

	arrayPtr->currentPageMax += arrayPtr->pageLength
	arrayPtr->pages[arrayPtr->currentPage] = page
	arrayPtr->currentPage += 1

	if arrayPtr->currentPage > arrayPtr->currentMax then
		if not _reallocatePageIndex(arrayPtr) then
			return false
		end if
	end if

	if arrayPtr->currentIndex > arrayPtr->warnLimit then
		' TODO: Throw warning
		print ("PagedArray._createPage: PagedArray warning limit has been surpassed: " & arrayPtr->id)
	end if

	return true
end function

/''
 ' Utility function to reallocate the page index, doubling it's size, when
 ' there are no more page pointer left.
 ' @param {PagedArrayObj ptr} arrayPtr
 ' @returns {integer}
 ' @private
 '/
function _reallocatePageIndex (arrayPtr as PagedArrayObj ptr) as integer
	dim as integer currentMax
	dim as any ptr ptr pageIndexPtr
	dim as integer pageIndex

	if arrayPtr->currentMax > 0 then
		currentMax = arrayPtr->currentMax * 2
		pageIndexPtr = allocate(sizeof(any ptr) * currentMax)

		if pageIndexPtr = NULL then
			' TODO: Throw warning
			print ("PagedArray._reallocatePageIndex: Failed to reallocate page index: " & arrayPtr->id)
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

end namespace
