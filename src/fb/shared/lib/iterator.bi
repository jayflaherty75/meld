
type IteratorHandler as function(iPtr as Iterator ptr, target as any ptr ptr) as BOOLEAN

type Iterator
	dataSet as any ptr
	index as integer
	current as any ptr
	handler as IteratorHandler
end type

declare function iteratorNew(dataSet as any ptr = NULL) as Iterator ptr
declare sub iteratorDelete (iPtr as Iterator ptr)
declare sub iteratorSetHandler (iPtr as Iterator ptr, cb as function(iPtr as Iterator ptr) as any ptr)
declare sub iteratorSetDataSet (iPtr as Iterator ptr, dataSet as any ptr)
declare sub iteratorSetCurrent (iPtr as Iterator ptr, current as any ptr)
declare function iteratorNext (iPtr as Iterator ptr, target as any ptr ptr) as BOOLEAN

function iteratorNew(dataSet as any ptr = NULL) as Iterator ptr
	dim as iPtr = allocate (sizeof(Iterator))

	if iPtr <> NULL then
		iPtr->dataSet = dataSet
		iPtr->index = 0
		iPtr->current = NULL
	else
		' TODO: throw error
	end if

	return iPtr
end function

sub iteratorDelete (iPtr as Iterator ptr)
	if iPtr <> NULL then
		deallocate (iPtr)
	else
		' TODO: throw error
	end if
end sub

sub iteratorSetHandler (iPtr as Iterator ptr, cb as IteratorHandler)
	if iPtr = NULL then
		' TODO: throw error
		return NULL
	end if

	if cb = NULL then
		' TODO: throw error
		return NULL
	end if

	iPtr->handler = cb
end sub

sub iteratorSetDataSet (iPtr as Iterator ptr, dataSet as any ptr)
	if iPtr = NULL then
		' TODO: throw error
		return NULL
	end if

	iPtr->dataSet = dataSet
end sub

sub iteratorSetCurrent (iPtr as Iterator ptr, current as any ptr)
	if iPtr = NULL then
		' TODO: throw error
		return NULL
	end if

	iPtr->current = current
end sub

function iteratorNext (iPtr as Iterator ptr, target as any ptr ptr) as BOOLEAN
	if iPtr = NULL then
		' TODO: throw error
		return NULL
	end if

	if target = NULL then
		' TODO: throw error
		return NULL
	end if

	return iPtr->handler (iPtr, target)
end function
