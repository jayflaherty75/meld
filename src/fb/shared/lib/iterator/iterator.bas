
#include once "iterator.bi"

namespace Iterator

type ErrorCodes
	resourceAllocationError as integer
	nullReferenceError as integer
	invalidArgumentError as integer
	moduleLoadingError as integer
end type

type StateType
	methods as Interface
end type

dim shared as StateType state

dim shared _core as Core.Interface ptr
dim shared _fault as Fault.Interface ptr

dim shared as ErrorCodes errors

declare function _defaultHandler (iter as IteratorObj ptr, target as any ptr) as integer

function load (corePtr as Core.Interface ptr) as integer
	if corePtr = NULL then
		print ("**** Iterator.load: Invalid corePtr interface pointer")
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

	if not corePtr->register("iterator", @state.methods) then
		return false
	end if

	_core = corePtr->require("core")
	_fault = corePtr->require("fault")

	if _fault = NULL then
		print ("**** Iterator.load: Missing Fault dependency")
		return false
	end if

	errors.resourceAllocationError = _fault->getCode("ResourceAllocationError")
	errors.nullReferenceError = _fault->getCode("NullReferenceError")
	errors.invalidArgumentError = _fault->getCode("InvalidArgumentError")
	errors.moduleLoadingError = _fault->getCode("ModuleLoadingError")

	if _core = NULL then
		_fault->throw(_
			errors.moduleLoadingError, _
			"iteratorLoadingError", "Iterator module missing Core dependency", _
			__FILE__, __LINE__ _
		)
		return false
	end if

	return true
end function

sub unload()
end sub

function construct(dataSet as any ptr = NULL, length as integer = -1) as IteratorObj ptr
	dim as IteratorObj ptr iter = allocate (sizeof(IteratorObj))

	if iter = NULL then
		_fault->throw(_
			errors.resourceAllocationError, _
			"IteratorAllocationError", "Failed to allocate Iterator instance", _
			__FILE__, __LINE__ _
		)
	end if

	iter->index = 0
	iter->length = length
	iter->current = NULL
	iter->handler = @_defaultHandler

	if dataSet <> NULL then
		setData (iter, dataSet, length)
	else
		iter->dataSet = NULL
	end if

	return iter
end function

sub destruct (iter as IteratorObj ptr)
	if iter = NULL then
		_fault->throw(_
			errors.nullReferenceError, _
			"IteratorDestructNullReferenceError", "Attempt to reference a NULL Iterator", _
			__FILE__, __LINE__ _
		)
		exit sub
	end if

	deallocate (iter)
end sub

sub setHandler (iter as IteratorObj ptr, cb as IteratorHandler)
	if iter = NULL then
		_fault->throw(_
			errors.nullReferenceError, _
			"IteratorSetHandlerNullReferenceError", "Attempt to reference a NULL Iterator", _
			__FILE__, __LINE__ _
		)
		exit sub
	end if

	if cb = NULL then
		_fault->throw(_
			errors.invalidArgumentError, _
			"IteratorSetHandlerInvalidArgumentError", "Invalid 2nd Argument: cb must be a function", _
			__FILE__, __LINE__ _
		)
		exit sub
	end if

	iter->handler = cb
end sub

sub setData (iter as IteratorObj ptr, dataSet as any ptr, length as integer = -1)
	if iter = NULL then
		_fault->throw(_
			errors.nullReferenceError, _
			"IteratorSetDataNullReferenceError", "Attempt to reference a NULL Iterator", _
			__FILE__, __LINE__ _
		)
		exit sub
	end if

	iter->dataSet = dataSet
	iter->length = length

	reset(iter)
end sub

function getNext (iter as IteratorObj ptr, target as any ptr) as integer
	if iter = NULL then
		_fault->throw(_
			errors.nullReferenceError, _
			"IteratorGetNextNullReferenceError", "Attempt to reference a NULL Iterator", _
			__FILE__, __LINE__ _
		)
		return NULL
	end if

	if target = NULL then
		_fault->throw(_
			errors.invalidArgumentError, _
			"IteratorGetNextInvalidArgumentError", "Invalid 2nd Argument: target must not be NULL", _
			__FILE__, __LINE__ _
		)
		return NULL
	end if

	return iter->handler (iter, target)
end function

sub reset (iter as IteratorObj ptr)
	dim as integer result

	if iter = NULL then
		_fault->throw(_
			errors.nullReferenceError, _
			"IteratorResetNullReferenceError", "Attempt to reference a NULL Iterator", _
			__FILE__, __LINE__ _
		)
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
