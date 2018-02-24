

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

/''
 ' @namespace Iterator
 '/
namespace Iterator

/''
 ' @typedef {function} IteratorHandler
 ' @param {Iterator.Instance ptr} result
 ' @param {any ptr} expected
 ' @returns {short}
 '/

/''
 ' @class Instance
 ' @member {any ptr} dataSet
 ' @member {long} index
 ' @member {long} length
 ' @member {any ptr} current
 ' @member {any ptr} handler
 '/

/''
 ' Application main routine.
 ' @function startup
 ' @returns {short}
 '/
function startup cdecl () as short
	' TODO: Initialize memory management

	return true
end function

/''
 ' Application main routine.
 ' @function shutdown
 ' @returns {short}
 '/
function shutdown cdecl () as short
	' TODO: Tear down memeory management

	return true
end function

/''
 ' Standard test runner for modules.
 ' @function test
 ' @param {any ptr} interfacePtr
 ' @param {Tester.describeCallback} describe
 ' @returns {short}
 '/
function test cdecl (interfacePtr as any ptr, describe as Tester.describeCallback) as short
	dim as short result = true

	result = result andalso describe ("The Iterator module", @testCreate)

	return result
end function

/''
 ' @function construct
 ' @param {any ptr} [dataSet=NULL]
 ' @param {long} [length=-1]
 ' @returns {Iterator.Instance ptr}
 ' @throws {ResourceAllocationError}
 '/
function construct cdecl (dataSet as any ptr = NULL, length as long = -1) as Iterator.Instance ptr
	dim as Iterator.Instance ptr iter = allocate (sizeof(Iterator.Instance))

	if iter = NULL then
		_throwIteratorAllocationError(__FILE__, __LINE__)
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

/''
 ' @function destruct
 ' @param {Iterator.Instance ptr} iter
 ' @throws {NullReferenceError}
 '/
sub destruct cdecl (iter as Iterator.Instance ptr)
	if iter = NULL then
		_throwIteratorDestructNullReferenceError(__FILE__, __LINE__)
		exit sub
	end if

	deallocate (iter)
end sub

/''
 ' 
 ' @function setHandler
 ' @param {Iterator.Instance ptr} iter
 ' @param {IteratorHandler} cb
 ' @throws {NullReferenceError}
 ' @throws {InvalidArgumentError}
 '/
sub setHandler cdecl (iter as Iterator.Instance ptr, cb as IteratorHandler)
	if iter = NULL then
		_throwIteratorSetHandlerNullReferenceError(__FILE__, __LINE__)
		exit sub
	end if

	if cb = NULL then
		_throwIteratorSetHandlerInvalidArgumentError(__FILE__, __LINE__)
		exit sub
	end if

	iter->handler = cb
end sub

/''
 ' 
 ' @function setData
 ' @param {Iterator.Instance ptr} iter
 ' @param {any ptr} dataSet
 ' @param {long} [length=-1]
 ' @throws {NullReferenceError}
 '/
sub setData cdecl (iter as Iterator.Instance ptr, dataSet as any ptr, length as long = -1)
	if iter = NULL then
		_throwIteratorSetDataNullReferenceError(__FILE__, __LINE__)
		exit sub
	end if

	iter->dataSet = dataSet
	iter->length = length

	reset(iter)
end sub

/''
 ' 
 ' @function getNext
 ' @param {Iterator.Instance ptr} iter
 ' @param {any ptr} target
 ' @returns {short}
 ' @throws {NullReferenceError}
 ' @throws {InvalidArgumentError}
 '/
function getNext cdecl (iter as Iterator.Instance ptr, target as any ptr) as short
	dim as IteratorHandler handler

	if iter = NULL then
		_throwIteratorGetNextNullReferenceError(__FILE__, __LINE__)
		return NULL
	end if

	if target = NULL then
		_throwIteratorGetNextInvalidArgumentError(__FILE__, __LINE__)
		return NULL
	end if

	handler = iter->handler

	return handler (iter, target)
end function

/''
 ' Standard test runner for modules.
 ' @function reset
 ' @param {Iterator.Instance ptr} iter
 ' @throws {NullReferenceError}
 '/
sub reset cdecl (iter as Iterator.Instance ptr)
	dim as IteratorHandler handler
	dim as integer result

	if iter = NULL then
		_throwIteratorResetNullReferenceError(__FILE__, __LINE__)
		exit sub
	end if

	handler = iter->handler

	result = handler (iter, NULL)
end sub

/''
 ' 
 ' @function _defaultHandler
 ' @param {Iterator.Instance ptr} iter
 ' @param {any ptr} target
 ' @returns {short}
 ' @private
 '/
function _defaultHandler cdecl (iter as Iterator.Instance ptr, target as any ptr) as short
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

