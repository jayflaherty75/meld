
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
 ' @namespace Identity
 '/
namespace Identity

/''
 ' @class Instance
 ' @member {ulong} autoinc
 '/

type StateType
	distMap(255) as ubyte
	revDistMap(255) as ubyte
end type

dim shared as StateType state

/''
 ' Application main routine.
 ' @function startup
 ' @returns {short}
 '/
function startup cdecl () as short
	_console->logMessage("Starting identity module")

	_generateBinDistMapping()

	return true
end function

/''
 ' Application main routine.
 ' @function shutdown
 ' @returns {short}
 '/
function shutdown cdecl () as short
	_console->logMessage("Shutting down identity module")

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

	result = result andalso describeFn ("The Identity module", @testCreate)

	return result
end function

/''
 ' @function construct
 ' @returns {Identity.Instance ptr}
 ' @throws {ResourceAllocationError}
 '/
function construct cdecl () as Instance ptr
	dim as Instance ptr idPtr = allocate (sizeof(Instance))

	if idPtr = NULL then
		_throwIdentityAllocationError(__FILE__, __LINE__)
		return NULL
	end if

	idPtr->autoinc = 0

	return idPtr
end function

/''
 ' @function destruct
 ' @param {Identity.Instance ptr} idPtr
 ' @throws {NullReferenceError}
 '/
sub destruct cdecl (idPtr as Instance ptr)
	if idPtr = NULL then
		_throwIdentityDestructNullReferenceError(__FILE__, __LINE__)
		exit sub
	end if

	deallocate (idPtr)
end sub

/''
 ' @function getAutoInc
 ' @param {Identity.Instance ptr} idPtr
 ' @returns {ulong}
 '/
function getAutoInc cdecl (idPtr as Identity.Instance ptr) as ulong
	return _nextId(idPtr)
end function

/''
 ' @function _nextId
 ' @param {Identity.Instance ptr} idPtr
 ' @returns {ulong}
 ' @private
 '/
function _nextId cdecl (idPtr as Identity.Instance ptr) as ulong
	idPtr->autoinc += 1

	return idPtr->autoinc
end function

/''
 ' Distributes generated values to be search-friendly.
 ' @function _generateBinDistMapping
 ' @private
 '/
sub _generateBinDistMapping cdecl ()
	dim as short start = 128
	dim as short length = 1
	dim as short index = 0
	dim as short increment
	dim as ubyte value
	dim as short x
	dim as short y

	for y = 0 to 7
		increment = start * 2
		value = start - 1

		for x = 0 to length - 1
			state.distMap(index) = value
			state.revDistMap(value) = index

			value += increment
			index += 1
		next

		start /= 2
		length *= 2
	next

	state.distMap(255) = 255
	state.revDistMap(255) = 255
end sub

/''
 ' @function _reverseByteOrder
 ' @param {ubyte ptr} dest
 ' @param {ubyte ptr} source
 ' @param {long} length
 ' @private
 '/
sub _reverseByteOrder cdecl (dest as ubyte ptr, source as ubyte ptr, length as long)
	dim as long index = 0

	do
		dest[index] = source[length]
		index += 1
		length -= 1
	loop while length >= 0
end sub

end namespace

