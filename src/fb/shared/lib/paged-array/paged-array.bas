

/''
 ' @requires console
 ' @requires fault
 ' @requires error-handling
 ' @requires tester
 '/

#include once "../../../../../modules/headers/constants/constants-v1.bi"
#include once "module.bi"
#include once "errors.bi"
#include once "test.bi"

#define PAGED_ARRAY_INITIAL_PAGING				32

/''
 ' @namespace PagedArray
 '/
namespace PagedArray

/''
 ' @class Instance
 ' @member {ulong} size
 ' @member {ulong} pageLength
 ' @member {ulong} warnLimit
 ' @member {ulong} currentIndex
 ' @member {ulong} currentPageMax
 ' @member {ulong} currentMax
 ' @member {ulong} currentPage
 ' @member {any ptr ptr} pages
 '/

/''
 ' Application main routine.
 ' @function startup
 ' @returns {short}
 '/
function startup cdecl () as short
	_console->logMessage("Starting paged-array module")

	return true
end function

/''
 ' Application main routine.
 ' @function shutdown
 ' @returns {short}
 '/
function shutdown cdecl () as short
	_console->logMessage("Shutting down paged-array module")

	return true
end function

/''
 ' Standard test runner for modules.
 ' @function test
 ' @param {Tester.describeCallback} describeFn
 ' @returns {short}
 '/
function test cdecl (describeFn as Tester.describeCallback) as short
	dim as short result = true

	result = result andalso describeFn ("The PagedArray module", @testCreate)

	return result
end function

/''
 ' Construct lifecycle function called by Meld framework.
 ' @function construct
 ' @returns {Instance ptr}
 ' @throws {ResourceAllocationError}
 '/
function construct cdecl () as Instance ptr
	dim as Instance ptr arrayPtr = allocate(sizeof(Instance))

	if arrayPtr = NULL then
		_throwPagedArrayAllocationError(__FILE__, __LINE__)
		return NULL
	end if

	arrayPtr->size = 0
	arrayPtr->pageLength = 0
	arrayPtr->warnLimit = 0
	arrayPtr->currentIndex = 0
	arrayPtr->currentPageMax = 0
	arrayPtr->currentMax = 0
	arrayPtr->currentPage = 0

	return arrayPtr
end function

/''
 ' Destruct lifecycle function called by Meld framework.
 ' @function destruct
 ' @param {Instance ptr} arrayPtr
 ' @throws {NullReferenceError}
 '/
sub destruct cdecl (arrayPtr as Instance ptr)
	dim as integer pageIndex

	if arrayPtr = NULL then
		_throwPagedArrayDestructNullReferenceError(__FILE__, __LINE__)
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
 ' Initialize paged array.
 ' @function initialize
 ' @param {Instance ptr} arrayPtr
 ' @param {ulong} size
 ' @param {ulong} pageLength
 ' @param {ulong} warnLimit
 ' @returns {short}
 ' @throws {NullReferenceError|ResourceAllocationError}
 '/
function initialize cdecl (arrayPtr as Instance ptr, size as ulong, pageLength as ulong, warnLimit as ulong) as short
	if arrayPtr = NULL then
		_throwPagedArrayInitializeNullReferenceError(__FILE__, __LINE__)
		return false
	end if

	arrayPtr->size = size
	arrayPtr->pageLength = pageLength
	arrayPtr->warnLimit = warnLimit

	if not _reallocatePageIndex(arrayPtr) then
		_throwPagedArrayIndexAllocationError(__FILE__, __LINE__)
		return false
	end if

	if not _createPage(arrayPtr) then
		_throwPagedArrayInitPageAllocationError(__FILE__, __LINE__)
		return false
	end if

	return true
end function

/''
 ' Creates and returns a new index available in the paged array.
 ' @function createIndex
 ' @param {Instance ptr} arrayPtr
 ' @returns {ulong}
 ' @throws {NullReferenceError|ResourceAllocationError}
 '/
function createIndex cdecl (arrayPtr as Instance ptr) as ulong
	dim as integer result

	if arrayPtr = NULL then
		_throwPagedArrayCreateIndexNullReferenceError(__FILE__, __LINE__)
		return false
	end if

	result = arrayPtr->currentIndex
	arrayPtr->currentIndex += 1

	if arrayPtr->currentIndex > arrayPtr->currentPageMax then
		if not _createPage(arrayPtr) then
			_throwPagedArrayCreateIndexAllocationError(__FILE__, __LINE__)
		end if
	end if

	return result
end function

/''
 ' Returns the data pointer for the given index of the paged array.
 ' @function getIndex
 ' @param {Instance ptr} arrayPtr
 ' @param {ulong} index
 ' @returns {any ptr}
 ' @throws {NullReferenceError|OutOfBoundsError}
 '/
function getIndex cdecl (arrayPtr as Instance ptr, index as ulong) as any ptr
	dim as byte ptr pagePtr
	dim as ulong offset

	if arrayPtr = NULL then
		_throwPagedArrayGetIndexNullReferenceError(__FILE__, __LINE__)
		return NULL
	end if

	if index < arrayPtr->pageLength then
		' Optimize first page of all arrays and large single page arrays
		pagePtr = arrayPtr->pages[0]
		offset = index
	elseif index >= arrayPtr->currentIndex then
		_throwPagedArrayOutOfBoundsError(index, arrayPtr->currentIndex, __FILE__, __LINE__)
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
 ' @function pop
 ' @param {Instance ptr} arrayPtr
 ' @param {any ptr} dataPtr
 ' @returns {short}
 ' @throws {NullReferenceError}
 '/
function pop cdecl (arrayPtr as Instance ptr, dataPtr as any ptr) as short
	dim as integer i
	dim as any ptr result
	dim as integer index

	if arrayPtr = NULL then
		_throwPagedArrayPopNullReferenceError(__FILE__, __LINE__)
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

/''
 ' Returns true if the paged array is empty.
 ' @function isEmpty
 ' @param {Instance ptr} arrayPtr
 ' @returns {short}
 ' @throws {NullReferenceError}
 ' @private
 '/
function isEmpty cdecl (arrayPtr as Instance ptr) as short
	if arrayPtr = NULL then
		_throwPagedArrayIsEmptyNullReferenceError(__FILE__, __LINE__)
		return true
	end if

	if arrayPtr->currentIndex = 0 then
		return true
	end if

	return false
end function

/''
 ' Utility function to create a new page when the array runs out of available
 ' elements.
 ' @function _createPage
 ' @param {Instance ptr} arrayPtr
 ' @returns {short}
 ' @throws {ResourceLimitSurpassed}
 ' @private
 '/
function _createPage cdecl (arrayPtr as Instance ptr) as short
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
		_throwPagedArrayLimitSurpassed(__FILE__, __LINE__)
	end if

	return true
end function

/''
 ' Utility function to reallocate the page index, doubling it's size, when
 ' there are no more page pointer left.
 ' @function _reallocatePageIndex
 ' @param {Instance ptr} arrayPtr
 ' @returns {short}
 ' @private
 '/
function _reallocatePageIndex cdecl (arrayPtr as Instance ptr) as short
	dim as integer currentMax
	dim as any ptr ptr pageIndexPtr
	dim as integer pageIndex

	if arrayPtr->currentMax > 0 then
		currentMax = arrayPtr->currentMax * 2
		pageIndexPtr = allocate(sizeof(any ptr) * currentMax)

		if pageIndexPtr = NULL then
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

