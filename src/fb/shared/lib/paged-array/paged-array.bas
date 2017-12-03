
#include once "paged-array.bi"

namespace PagedArray

type ErrorCodes
	resourceAllocationError as integer
	invalidArgumentError as integer
	nullReferenceError as integer
	outOfBoundsError as integer
	resourceLimitSurpassed as integer
	moduleLoadingError as integer

	uncaughtError as integer
	internalSystemError as integer
	fatalOperationalError as integer
	releaseResourceError as integer
	resourceMissingError as integer
end type

type StateType
	methods as Interface
end type

dim shared _core as Core.Interface ptr
dim shared _fault as Fault.Interface ptr

dim shared as StateType state

dim shared as ErrorCodes errors

/''
 ' Loading lifecycle function called by Meld framework.
 ' @param {MeldInterface ptr} corePtr
 ' @returns {integer}
 ' @throws {PagedArrayLoadingError}
 '/
function load (corePtr as Core.Interface ptr) as integer
	if corePtr = NULL then
		print ("**** PagedArray.load: Invalid corePtr interface pointer")
		return false
	end if

	state.methods.load = @load
	state.methods.construct = @construct
	state.methods.destruct = @destruct
	state.methods.unload = @unload
	state.methods.createIndex = @createIndex
	state.methods.getIndex = @getIndex
	state.methods.pop = @pop
	state.methods.isEmpty = @isEmpty

	if not corePtr->register("paged-array", @state.methods) then
		return false
	end if

	_core = corePtr->require("core")
	_fault = corePtr->require("fault")

	if _fault = NULL then
		print ("**** PagedArray.load: Missing Fault dependency")
		return false
	end if

	errors.resourceAllocationError = _fault->getCode("ResourceAllocationError")
	errors.nullReferenceError = _fault->getCode("NullReferenceError")
	errors.invalidArgumentError = _fault->getCode("InvalidArgumentError")
	errors.outOfBoundsError = _fault->getCode("OutOfBoundsError")
	errors.resourceLimitSurpassed = _fault->getCode("ResourceLimitSurpassed")
	errors.moduleLoadingError = _fault->getCode("ModuleLoadingError")

	if _core = NULL then
		_fault->throw(_
			errors.moduleLoadingError, _
			"PagedArrayLoadingError", "PagedArray module missing Core dependency", _
			__FILE__, __LINE__ _
		)
		return false
	end if

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
 ' @throws {PagedArrayInvalidArgumentError|PagedArrayAllocationError|PagedArrayPageAllocationError|PagedArrayInitPageAllocationError}
 '/
function construct (byref id as zstring, size as integer, pageLength as integer, warnLimit as integer) as PagedArrayObj ptr
	dim as PagedArrayObj ptr arrayPtr

	if size <= 0 then
		_fault->throw( _
			errors.invalidArgumentError, _
			"PagedArrayInvalidArgumentError", "Invalid 2nd Argument: element size must be greater than zero: " & id, _
			__FILE__, __LINE__ _
		)
		return NULL
	end if

	if pageLength <= 0 then
		_fault->throw( _
			errors.invalidArgumentError, _
			"PagedArrayInvalidArgumentError", "Invalid 3rd Argument: page length must be greater than zero: " & id, _
			__FILE__, __LINE__ _
		)
		return NULL
	end if

	arrayPtr = allocate(sizeof(PagedArrayObj))

	if arrayPtr = NULL then
		_fault->throw( _
			errors.resourceAllocationError, _
			"PagedArrayAllocationError", "Failed to allocate PagedArray instance: " & id, _
			__FILE__, __LINE__ _
		)
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
		destruct(arrayPtr)

		_fault->throw( _
			errors.resourceAllocationError, _
			"PagedArrayPageAllocationError", "Failed to allocate page index of PagedArray: " & id, _
			__FILE__, __LINE__ _
		)
		return NULL
	end if

	if not _createPage(arrayPtr) then
		destruct(arrayPtr)

		_fault->throw( _
			errors.resourceAllocationError, _
			"PagedArrayInitPageAllocationError", "Failed to allocate initial page for PagedArray: " & id, _
			__FILE__, __LINE__ _
		)
		return NULL
	end if

	return arrayPtr
end function

/''
 ' Destruct lifecycle function called by Meld framework.
 ' @param {PagedArrayObj ptr} arrayPtr
 ' @throws {PagedArrayDestructNullReferenceError}
 '/
sub destruct (arrayPtr as PagedArrayObj ptr)
	dim as integer pageIndex

	if arrayPtr = NULL then
		_fault->throw(_
			errors.nullReferenceError, _
			"PagedArrayDestructNullReferenceError", "Attempt to reference a NULL PagedArray", _
			__FILE__, __LINE__ _
		)
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
 ' @throws {PagedArrayCreateIndexNullReferenceError|PagedArrayAllocationError}
 '/
function createIndex (arrayPtr as PagedArrayObj ptr) as integer
	dim as integer result

	if arrayPtr = NULL then
		_fault->throw(_
			errors.nullReferenceError, _
			"PagedArrayCreateIndexNullReferenceError", "Attempt to reference a NULL PagedArray", _
			__FILE__, __LINE__ _
		)
		return false
	end if

	result = arrayPtr->currentIndex
	arrayPtr->currentIndex += 1

	if arrayPtr->currentIndex > arrayPtr->currentPageMax then
		if not _createPage(arrayPtr) then
			_fault->throw( _
				errors.resourceAllocationError, _
				"PagedArrayAllocationError", "Failed to allocate page index for PagedArray: " & arrayPtr->id, _
				__FILE__, __LINE__ _
			)
		end if
	end if

	return result
end function

/''
 ' Returns the data pointer for the given index of the paged array.
 ' @param {PagedArrayObj ptr} arrayPtr
 ' @param {uinteger} index
 ' @returns {any ptr}
 ' @throws {PagedArrayGetIndexNullReferenceError|PagedArrayOutOfBoundsError}
 '/
function getIndex (arrayPtr as PagedArrayObj ptr, index as uinteger) as any ptr
	dim as byte ptr pagePtr
	dim as uinteger offset

	if arrayPtr = NULL then
		_fault->throw(_
			errors.nullReferenceError, _
			"PagedArrayGetIndexNullReferenceError", "Attempt to reference a NULL PagedArray", _
			__FILE__, __LINE__ _
		)
		return NULL
	end if

	if index < arrayPtr->pageLength then
		' Optimize first page of all arrays and large single page arrays
		pagePtr = arrayPtr->pages[0]
		offset = index
	elseif index >= arrayPtr->currentIndex then
		_fault->throw(_
			errors.outOfBoundsError, _
			"PagedArrayOutOfBoundsError", "Index (" & index & ") is greater than current array length (" & arrayPtr->currentIndex & "): " & arrayPtr->id, _
			__FILE__, __LINE__ _
		)
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
 ' @throws {PagedArrayPopNullReferenceError}
 '/
function pop (arrayPtr as PagedArrayObj ptr, dataPtr as any ptr) as integer
	dim as integer i
	dim as any ptr result
	dim as integer index

	if arrayPtr = NULL then
		_fault->throw(_
			errors.nullReferenceError, _
			"PagedArrayPopNullReferenceError", "Attempt to reference a NULL PagedArray", _
			__FILE__, __LINE__ _
		)
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
 ' @param {PagedArrayObj ptr} arrayPtr
 ' @returns {integer}
 ' @private
 ' @throws {PagedArrayIsEmptyNullReferenceError}
 '/
function isEmpty (arrayPtr as PagedArrayObj ptr) as integer
	if arrayPtr = NULL then
		_fault->throw(_
			errors.nullReferenceError, _
			"PagedArrayIsEmptyNullReferenceError", "Attempt to reference a NULL PagedArray", _
			__FILE__, __LINE__ _
		)
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
 ' @param {PagedArrayObj ptr} arrayPtr
 ' @returns {integer}
 ' @private
 ' @throws {PagedArrayLimitSurpassed}
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
		_fault->throw( _
			errors.resourceLimitSurpassed, _
			"PagedArrayLimitSurpassed", "PagedArray warning limit has been surpassed: " & arrayPtr->id, _
			__FILE__, __LINE__ _
		)
	end if

	return true
end function

/''
 ' Utility function to reallocate the page index, doubling it's size, when
 ' there are no more page pointer left.
 ' @param {PagedArrayObj ptr} arrayPtr
 ' @returns {integer}
 ' @private
 ' @throws {PagedArrayIndexReAllocationError}
 '/
function _reallocatePageIndex (arrayPtr as PagedArrayObj ptr) as integer
	dim as integer currentMax
	dim as any ptr ptr pageIndexPtr
	dim as integer pageIndex

	if arrayPtr->currentMax > 0 then
		currentMax = arrayPtr->currentMax * 2
		pageIndexPtr = allocate(sizeof(any ptr) * currentMax)

		if pageIndexPtr = NULL then
			_fault->throw( _
				errors.resourceAllocationError, _
				"PagedArrayIndexReAllocationError", "Failed to reallocate page index for PagedArray: " & arrayPtr->id, _
				__FILE__, __LINE__ _
			)
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
