
#include once "iterator.bi"

namespace Iterator

type Dependencies
	core as Core.Interface ptr
end type

type StateType
	deps as Dependencies
	methods as Interface
end type

dim shared as StateType state

declare function _defaultHandler (iter as IteratorObj ptr, target as any ptr) as integer

function load (corePtr as Core.Interface ptr) as integer
	if corePtr = NULL then
		' TODO: Throw error
		print ("Iterator.load: Invalid corePtr interface pointer")
		return false
	end if

	state.methods.load = @load
	state.methods.unload = @unload
	state.methods.construct = @construct
	state.methods.destruct = @destruct
	state.methods.setHandler = @setHandler
	state.methods.setData = @setData
	state.methods.getNext = @getNext
	state.methods.reset = @reset

	if not corePtr->register("interface", @state.methods) then
		return false
	end if

	state.deps.core = corePtr

	return true
end function

sub unload()
end sub

function construct(dataSet as any ptr = NULL, length as integer = -1) as IteratorObj ptr
	dim as IteratorObj ptr iter = allocate (sizeof(IteratorObj))

	if iter <> NULL then
		iter->index = 0
		iter->length = length
		iter->current = NULL
		iter->handler = @_defaultHandler

		if dataSet <> NULL then
			setData (iter, dataSet, length)
		else
			iter->dataSet = NULL
		end if
	else
		' TODO: throw error
		print ("iteratorNew: Failed to allocation error object")
	end if

	return iter
end function

sub destruct (iter as IteratorObj ptr)
	if iter <> NULL then
		deallocate (iter)
	else
		' TODO: throw error
		print ("iteratorDelete: Invalid iterator")
	end if
end sub

sub setHandler (iter as IteratorObj ptr, cb as IteratorHandler)
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

sub setData (iter as IteratorObj ptr, dataSet as any ptr, length as integer = -1)
	if iter = NULL then
		' TODO: throw error
		print ("iteratorSetDataSet: Invalid iterator")
		exit sub
	end if

	iter->dataSet = dataSet
	iter->length = length

	reset(iter)
end sub

function getNext (iter as IteratorObj ptr, target as any ptr) as integer
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

sub reset (iter as IteratorObj ptr)
	dim as integer result

	if iter = NULL then
		' TODO: throw error
		print ("iteratorNext: Invalid iterator")
		exit sub
	end if

	result = iter->handler (iter, NULL)
end sub

function _defaultHandler (iter as IteratorObj ptr, target as any ptr) as integer
	if target = NULL then
		iter->current = iter->dataSet
		iter->index = 0
	else
		if iter->index < iter->length then
			*cptr(integer ptr, target) = cptr(integer ptr, iter->dataSet)[iter->index]

			iter->index += 1
		else
			return false
		end if
	end if

	return true
end function

end namespace
