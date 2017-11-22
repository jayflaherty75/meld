
#include once "../../../../modules/headers/constants/constants-v1.bi"

type Iterator
	dataSet as any ptr
	index as integer
	length as integer
	current as any ptr
	handler as function (iter as Iterator ptr, target as any ptr) as integer
end type

type IteratorHandler as function (iter as Iterator ptr, target as any ptr) as integer

declare function iteratorNew(dataSet as any ptr = NULL, length as integer = -1) as Iterator ptr
declare sub iteratorDelete (iter as Iterator ptr)
declare sub iteratorSetHandler (iter as Iterator ptr, cb as IteratorHandler)
declare sub iteratorSetDataSet (iter as Iterator ptr, dataSet as any ptr, length as integer = -1)
declare function iteratorNext (iter as Iterator ptr, target as any ptr) as integer
declare sub iteratorReset (iter as Iterator ptr)

declare function _iteratorDefaultHandler (iter as Iterator ptr, target as any ptr) as integer

function iteratorNew(dataSet as any ptr = NULL, length as integer = -1) as Iterator ptr
	dim as Iterator ptr iter = allocate (sizeof(Iterator))

	if iter <> NULL then
		iter->index = 0
		iter->length = length
		iter->current = NULL
		iter->handler = @_iteratorDefaultHandler

		if dataSet <> NULL then
			iteratorSetDataSet (iter, dataSet, length)
		else
			iter->dataSet = NULL
		end if
	else
		' TODO: throw error
		print ("iteratorNew: Failed to allocation error object")
	end if

	return iter
end function

sub iteratorDelete (iter as Iterator ptr)
	if iter <> NULL then
		deallocate (iter)
	else
		' TODO: throw error
		print ("iteratorDelete: Invalid iterator")
	end if
end sub

sub iteratorSetHandler (iter as Iterator ptr, cb as IteratorHandler)
	if iter = NULL then
		' TODO: throw error
		print ("iteratorSetHandler: Invalid iterator")
		exit sub
	end if

	if cb = NULL then
		' TODO: throw error
		print ("iteratorSetHandler: Invalid handler")
		exit sub
	end if

	iter->handler = cb
end sub

sub iteratorSetDataSet (iter as Iterator ptr, dataSet as any ptr, length as integer = -1)
	if iter = NULL then
		' TODO: throw error
		print ("iteratorSetDataSet: Invalid iterator")
		exit sub
	end if

	iter->dataSet = dataSet
	iter->length = length

	iteratorReset(iter)
end sub

function iteratorNext (iter as Iterator ptr, target as any ptr) as integer
	if iter = NULL then
		' TODO: throw error
		print ("iteratorNext: Invalid iterator")
		return NULL
	end if

	if target = NULL then
		' TODO: throw error
		print ("iteratorNext: Invalid target")
		return NULL
	end if

	return iter->handler (iter, target)
end function

sub iteratorReset (iter as Iterator ptr)
	dim as integer result

	if iter = NULL then
		' TODO: throw error
		print ("iteratorNext: Invalid iterator")
		exit sub
	end if

	result = iter->handler (iter, NULL)
end sub

function _iteratorDefaultHandler (iter as Iterator ptr, target as any ptr) as integer
	dim as integer ptr current

	if target = NULL then
		iter->current = iter->dataSet
		iter->index = 0
	else
		if iter->index <= iter->length then
			*cptr(integer ptr, target) = cptr(integer ptr, iter->dataSet)[iter->index]

			iter->index += 1
		end if
		
		if iter->index > iter->length then
			return false
		end if
	end if

	return true
end function
