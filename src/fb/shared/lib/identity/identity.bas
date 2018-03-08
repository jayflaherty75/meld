
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
 ' Library for generating simple auto-incement IDs or unique identifiers.
 ' @namespace Identity
 '/
namespace Identity

/''
 ' Standard library instance.
 ' @class Instance
 ' @member {ulong} autoinc
 '/

/''
 ' Represents a binary, non-serialized unique identifier.
 ' @class Unique
 ' @member {ubyte} v(15-1)
 '/

/''
 ' Represents a serialized unique identifier.
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
 ' Module startup routine.
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
 ' Module shutdown routine.
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
 ' Simple auto-increment ID generator for local resources.
 ' @function getAutoInc
 ' @param {Identity.Instance ptr} idPtr
 ' @returns {ulong}
 '/
function getAutoInc cdecl (idPtr as Identity.Instance ptr) as ulong
	if idPtr = NULL then
		_throwIdentityGetAutoIncNullReferenceError(__FILE__, __LINE__)
		return 0
	end if

	return _nextId(idPtr)
end function

/''
 ' Unique ID generator providing binary representation of application resources
 ' designed to be efficiently searched using binary search trees.
 ' @function generate
 ' @param {Identity.Instance ptr} idPtr
 ' @returns {Unique}
 '/
function generate cdecl (idPtr as Identity.Instance ptr) as Unique
	dim as zstring*18 strMacAddress
	dim as ulongint idMacAddress
	dim as ulongint idTime = _sys->getTimeStamp()
	dim as ulong idAutoinc = _nextId(idPtr)
	dim as ubyte ptr dataPtr
	dim as short index
	dim as Unique result

	if idPtr = NULL then
		_throwIdentityGenerateNullReferenceError(__FILE__, __LINE__)
		return result
	end if

	idAutoinc = _nextId(idPtr)
	idTime = _sys->getTimeStamp()

	_sys->getMacAddress(strMacAddress)
	idMacAddress = _convertMacAddress(strMacAddress)

	_copy(cptr(ubyte ptr, @idAutoinc), @result.v(0), 4)
	_copy(cptr(ubyte ptr, @idTime), @result.v(4), 5)
	_copy(cptr(ubyte ptr, @idMacAddress), @result.v(9), 6)

	for index = 0 to 15
		result.v(index) = state.distMap(result.v(index))
	next

	return result
end function

/''
 ' Serializes a binary unique identifier into a 20-character ID.
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
 ' Deserializes a 20-character identifier into a binary unique ID.
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
 ' Shared internal function to produce auto-increment IDs.
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
 ' Intended for use on big-endian systems to ensure that the first bytes of an
 ' identifier are the most frequently changing.
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
 ' Saves mapping values for base64 encoding.
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
 ' Generate mappings for encoding and decoding base64.
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

/''
 ' Converts a network MAC address into a number value.  Used for determining
 ' the "space" portion of the unique identifier.
 ' @function _convertMacAddress
 ' @param {byref zstring} source
 ' @returns {ulongint}
 ' @private
 '/
function _convertMacAddress cdecl (byref source as zstring) as ulongint
	dim as ulongint result = 0
	dim as ulongint multiplier = 1
	dim as short index
	dim as ubyte char

	for index = 0 to 16
		char = _convertHex(mid(source, index + 1, 1))

		if char > 0 then
			result += multiplier * char
			multiplier *= 16
		end if
	next

	return result
end function

/''
 ' Returns a 0-15 value for a single hexidecimal character.
 ' @function _convertHex
 ' @param {byref zstring} char
 ' @returns {ubyte}
 ' @private
 '/
function _convertHex cdecl (byref char as zstring) as ubyte
	dim as ubyte ascii = asc(left(char, 1))

	if ascii >= 97 andalso ascii < 103 then
		return ascii - 87
	elseif ascii >= 65 andalso ascii < 71 then
		return ascii - 55
	elseif ascii >= 48 andalso ascii < 58 then
		return ascii - 48
	end if

	return 0
end function

/''
 ' Simple copy function to move generated values into resulting identifiers.
 ' @function _copy
 ' @param {ubyte ptr} source
 ' @param {ubyte ptr} dest
 ' @param {long} length
 ' @private
 '/
sub _copy cdecl (source as ubyte ptr, dest as ubyte ptr, length as long)
	dim as long index

	for index = 0 to length - 1
		print(source[index])
		dest[index] = source[index]
	next
end sub

end namespace
