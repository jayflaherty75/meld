
/''
 ' @requires console
 ' @requires fault
 ' @requires error-handling
 ' @requires tester
 ' @requires sys
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

/''
 ' @class Unique
 ' @member {ubyte} v(15-1)
 '/

/''
 ' @typedef {zstring*21} Encoded
 '/

type StateType
	encodeMap(63) as ubyte
	decodeMap(127) as ubyte
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

	_generateEncodeMapping()
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
 ' @function encode
 ' @param {Unique ptr} id
 ' @param {Encoded ptr} dest
 '/
sub encode cdecl (id as Unique ptr, dest as Encoded ptr)
	dim as short i
	dim as short indexTo

	for i = 0 to 12 step 3
		dest[indexTo] = state.encodeMap((id->v(i) and &b11111100) shr 2)
		dest[indexTo + 1] = state.encodeMap(((id->v(i) and &b00000011) shl 4) or ((id->v(i + 1) and &b11110000) shr 4))
		dest[indexTo + 2] = state.encodeMap(((id->v(i + 1) and &b00001111) shl 2) or ((id->v(i + 2) and &b11000000) shr 6))
		dest[indexTo + 3] = state.encodeMap((id->v(i + 2) and &b00111111))

		indexTo += 4
	next
end sub

/''
 ' @function decode
 ' @param {Encoded ptr} source
 ' @param {Unique ptr} id
 '/
sub decode cdecl (source as Encoded ptr, id as Unique ptr)
	dim as short i
	dim as short indexTo
	dim as ubyte s1, s2, s3, s4

	for i = 0 to 16 step 4
		s1 = state.decodeMap(source[i])
		s2 = state.decodeMap(source[i + 1])
		s3 = state.decodeMap(source[i + 2])
		s4 = state.decodeMap(source[i + 3])

		id->v(indexTo) = (s1 shl 2) or ((s2 and &b00110000) shr 4)
		id->v(indexTo + 1) = ((s2 and &b00001111) shl 4) or ((s3 and &b00111100) shr 2)
		id->v(indexTo + 2) = ((s3 and &b00000011) shl 6) or s4

		indexTo += 3
	next
end sub

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

/''
 ' @function _mapEncoding
 ' @param {ubyte} index
 ' @param {ubyte} ascii
 ' @private
 '/
sub _mapEncoding cdecl (index as ubyte, ascii as ubyte)
	state.encodeMap(index) = ascii 
	state.decodeMap(ascii) = index
end sub

/''
 ' Distributes generated values to be search-friendly.
 ' @function _generateEncodeMapping
 ' @private
 '/
sub _generateEncodeMapping cdecl ()
	dim as short index = 2
	dim as ubyte ascii

	_mapEncoding(0, asc("_"))
	_mapEncoding(1, asc("-"))

	for ascii = asc("0") to asc("9")
		_mapEncoding(index, ascii)
		index += 1
	next

	for ascii = asc("A") to asc("Z")
		_mapEncoding(index, ascii)
		index += 1
	next

	for ascii = asc("a") to asc("z")
		_mapEncoding(index, ascii)
		index += 1
	next
end sub

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

end namespace

