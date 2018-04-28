
#include once "identity.bi"

namespace Identity

declare function testCreate cdecl (it as Tester.itCallback) as short
declare sub test1 cdecl (done as Tester.doneFn)
declare sub test2 cdecl (done as Tester.doneFn)
declare sub test3 cdecl (done as Tester.doneFn)
declare sub test4 cdecl (done as Tester.doneFn)
declare sub test5 cdecl (done as Tester.doneFn)
declare sub test6 cdecl (done as Tester.doneFn)
declare sub test7 cdecl (done as Tester.doneFn)

dim shared as Identity.Instance ptr idPtr

function testCreate cdecl (it as Tester.itCallback) as short
	dim as short result = true

	idPtr = construct()

	result = result andalso it("creates an Identity instance", @test1)
	result = result andalso it("generates auto-increment identifiers", @test2)
	result = result andalso it("correctly reverses a string of bytes", @test3)
	result = result andalso it("encodes and decodes binary identifiers to base64-like string", @test4)
	result = result andalso it("converts MAC address into a long integer", @test5)
	result = result andalso it("correctly converts hexidecimal characters", @test6)
	result = result andalso it("generates identitifers that can behave like strings", @test7)

	destruct(idPtr)

	return result
end function

sub test1 cdecl (done as Tester.doneFn)
	_tester->expectPtrNot(idPtr, NULL, "Constructor returned null")

	done()
end sub

sub test2 cdecl (done as Tester.doneFn)
	dim as string message = "Incorrect identifier returned"
	_tester->expect(getAutoInc(idPtr), 1, message)
	_tester->expect(getAutoInc(idPtr), 2, message)
	_tester->expect(getAutoInc(idPtr), 3, message)

	done()
end sub

sub test3 cdecl (done as Tester.doneFn)
	dim as zstring*50 source = "metsys tsacdaorb ycnegreme eht fo tset a si sihT"
	dim as zstring*50 result = "This is a test of the emergency broadcast system"
	dim as zstring*50 dest = "                                                "

	_reverseByteOrder(@dest, @source, len(source) - 1)

	_tester->expectStr(@dest, @result, "Result of reversal is incorrect")

	done()
end sub

sub test4 cdecl (done as Tester.doneFn)
	dim as string message = "Incorrect decoded value"
	dim as zstring*21 expected = "zSrRnPqhbMpxPJpBDGoR"
	dim as Unique binaryId
	dim as Unique result
	dim as Encoded id
	dim as short i

	for i = 0 to 14
		binaryId.v(i) = 255 - (i * 16 + 2)
	next

	encode(@binaryId, @id)
	decode(@id, @result)

	_tester->expectStr(@id, @expected, "Identifier encoded incorrectly")
	_tester->expect(result.v(0), binaryId.v(0), message)
	_tester->expect(result.v(1), binaryId.v(1), message)
	_tester->expect(result.v(2), binaryId.v(2), message)
	_tester->expect(result.v(3), binaryId.v(3), message)
	_tester->expect(result.v(4), binaryId.v(4), message)
	_tester->expect(result.v(5), binaryId.v(5), message)
	_tester->expect(result.v(6), binaryId.v(6), message)
	_tester->expect(result.v(7), binaryId.v(7), message)
	_tester->expect(result.v(8), binaryId.v(8), message)
	_tester->expect(result.v(9), binaryId.v(9), message)
	_tester->expect(result.v(10), binaryId.v(10), message)
	_tester->expect(result.v(11), binaryId.v(11), message)
	_tester->expect(result.v(12), binaryId.v(12), message)
	_tester->expect(result.v(13), binaryId.v(13), message)
	_tester->expect(result.v(14), binaryId.v(14), message)

	done()
end sub

sub test5 cdecl (done as Tester.doneFn)
	dim as zstring*18 addr = "64:80:99:72:89:44"
	dim as ulongint result = 4713768130630

	_tester->expect(_convertMacAddress(addr), result, "Failed to correctly convert MAC address")

	done()
end sub

sub test6 cdecl (done as Tester.doneFn)
	_tester->expect(_convertHex("0"), 0, "Failed to convert '0' character")
	_tester->expect(_convertHex("1"), 1, "Failed to convert '1' character")
	_tester->expect(_convertHex("2"), 2, "Failed to convert '2' character")
	_tester->expect(_convertHex("3"), 3, "Failed to convert '3' character")
	_tester->expect(_convertHex("4"), 4, "Failed to convert '4' character")
	_tester->expect(_convertHex("5"), 5, "Failed to convert '5' character")
	_tester->expect(_convertHex("6"), 6, "Failed to convert '6' character")
	_tester->expect(_convertHex("7"), 7, "Failed to convert '7' character")
	_tester->expect(_convertHex("8"), 8, "Failed to convert '8' character")
	_tester->expect(_convertHex("9"), 9, "Failed to convert '9' character")
	_tester->expect(_convertHex("A"), 10, "Failed to convert 'A' character")
	_tester->expect(_convertHex("B"), 11, "Failed to convert 'B' character")
	_tester->expect(_convertHex("C"), 12, "Failed to convert 'C' character")
	_tester->expect(_convertHex("D"), 13, "Failed to convert 'D' character")
	_tester->expect(_convertHex("E"), 14, "Failed to convert 'E' character")
	_tester->expect(_convertHex("F"), 15, "Failed to convert 'F' character")
	_tester->expect(_convertHex("a"), 10, "Failed to convert 'a' character")
	_tester->expect(_convertHex("b"), 11, "Failed to convert 'b' character")
	_tester->expect(_convertHex("c"), 12, "Failed to convert 'c' character")
	_tester->expect(_convertHex("d"), 13, "Failed to convert 'd' character")
	_tester->expect(_convertHex("e"), 14, "Failed to convert 'e' character")
	_tester->expect(_convertHex("f"), 15, "Failed to convert 'f' character")

	done()
end sub

sub test7 cdecl (done as Tester.doneFn)
	dim as Unique id = _identity->generate()
	dim as zstring ptr testStr = cptr(zstring ptr, @id)
	dim as zstring*25 encStr = ""

	_identity->encode(@id, @encStr)

	_tester->expect(len(testStr), 8, "Identifier 'string' length resulted in incorrect unicode length")
	_tester->expect(len(encStr), 20, "Encoded identifier string length resulted in incorrect length: " & encStr)

	done()
end sub

end namespace

