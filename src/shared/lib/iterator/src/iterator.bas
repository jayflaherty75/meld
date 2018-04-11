
/''
 ' @requires console_v0.1.0
 ' @requires fault_v0.1.0
 ' @requires tester_v0.1.0
 '/

#include once "module.bi"
#include once "errors.bi"
#include once "test.bi"

/''
 ' @namespace Iterator
 ' @version 0.1.0
 '/
namespace Iterator

/''
 ' @typedef {Instance} InstanceAlias
 '/

/''
 ' @typedef {function} IteratorHandler
 ' @param {InstanceAlias ptr} result
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
 ' @param {any ptr} describeFn
 ' @returns {short}
 '/
function test cdecl (describeFn as any ptr) as short
	dim as Tester.describeCallback describePtr = describeFn
	dim as short result = true

	result = result andalso describePtr ("The Iterator module", @testCreate)

	return result
end function

/''
 ' @function construct
 ' @returns {Instance ptr}
 ' @throws {ResourceAllocationError}
 '/
function construct cdecl () as Instance ptr
	dim as Instance ptr iter = allocate (sizeof(Instance))

	if iter = NULL then
		_throwIteratorAllocationError(__FILE__, __LINE__)
		return NULL
	end if

	iter->index = 0
	iter->dataSet = NULL
	iter->length = 0
	iter->current = NULL
	iter->handler = @_defaultHandler

	return iter
end function

/''
 ' @function destruct
 ' @param {Instance ptr} iter
 ' @throws {NullReferenceError}
 '/
sub destruct cdecl (iter as Instance ptr)
	if iter = NULL then
		_throwIteratorDestructNullReferenceError(__FILE__, __LINE__)
		exit sub
	end if

	deallocate (iter)
end sub

/''
 ' 
 ' @function setHandler
 ' @param {Instance ptr} iter
 ' @param {IteratorHandler} cb
 ' @throws {NullReferenceError}
 ' @throws {InvalidArgumentError}
 '/
sub setHandler cdecl (iter as Instance ptr, cb as IteratorHandler)
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
 ' @param {Instance ptr} iter
 ' @param {any ptr} dataSet
 ' @param {long} [setLength=-1]
 ' @throws {NullReferenceError}
 '/
sub setData cdecl (iter as Instance ptr, dataSet as any ptr, setLength as long = -1)
	if iter = NULL then
		_throwIteratorSetDataNullReferenceError(__FILE__, __LINE__)
		exit sub
	end if

	iter->dataSet = dataSet
	iter->length = setLength

	reset(iter)
end sub

/''
 ' 
 ' @function length
 ' @param {Instance ptr} iter
 ' @returns {long}
 ' @throws {NullReferenceError}
 '/
function length cdecl (iter as Instance ptr) as long
	if iter = NULL then
		_throwIteratorGetNextNullReferenceError(__FILE__, __LINE__)
		return NULL
	end if

	return iter->length
end function

/''
 ' 
 ' @function getNext
 ' @param {Instance ptr} iter
 ' @param {any ptr} target
 ' @returns {short}
 ' @throws {NullReferenceError}
 ' @throws {InvalidArgumentError}
 '/
function getNext cdecl (iter as Instance ptr, target as any ptr) as short
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
 ' @param {Instance ptr} iter
 ' @throws {NullReferenceError}
 '/
sub reset cdecl (iter as Instance ptr)
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
 ' @param {Instance ptr} iter
 ' @param {any ptr} target
 ' @returns {short}
 ' @private
 '/
function _defaultHandler cdecl (iter as Instance ptr, target as any ptr) as short
	if target = NULL then
		iter->current = iter->dataSet
		iter->index = 0
	else
		if iter->index < iter->length then
			*cptr(long ptr, target) = cptr(long ptr, iter->dataSet)[iter->index]

			iter->index += 1
		else
			return false
		end if
	end if

	return true
end function

end namespace

