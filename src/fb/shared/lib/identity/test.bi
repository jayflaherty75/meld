
#include once "identity.bi"

namespace Identity

declare function testCreate (it as Tester.itCallback) as short
declare sub test1 (done as Tester.doneFn)
declare sub test2 (done as Tester.doneFn)
declare sub test3 (done as Tester.doneFn)
declare sub test4 (done as Tester.doneFn)
declare sub test5 (done as Tester.doneFn)

dim shared as Identity.Instance ptr idPtr

function testCreate (it as Tester.itCallback) as short
	dim as short result = true

	idPtr = construct()

	result = result andalso it("creates an Identity instance", @test1)
	result = result andalso it("generates auto-increment identifiers", @test2)
	result = result andalso it("correctly reverses a string of bytes", @test3)
	result = result andalso it("encodes and decodes binary identifiers to base64-like string", @test4)
	result = result andalso it("generates a timestamp", @test5)

	destruct(idPtr)

	return result
end function

sub test1 (done as Tester.doneFn)
	_tester->expectPtrNot(idPtr, NULL, "Constructor returned null")

	done()
end sub

sub test2 (done as Tester.doneFn)
	_tester->expect(getAutoInc(idPtr), 1, "Incorrect identifier returned")
	_tester->expect(getAutoInc(idPtr), 2, "Incorrect identifier returned")
	_tester->expect(getAutoInc(idPtr), 3, "Incorrect identifier returned")

	done()
end sub

sub test3 (done as Tester.doneFn)
	dim as zstring*50 source = "metsys tsacdaorb ycnegreme eht fo tset a si sihT"
	dim as zstring*50 result = "This is a test of the emergency broadcast system"
	dim as zstring*50 dest = "                                                "

	_reverseByteOrder(@dest, @source, len(source) - 1)

	_tester->expectStr(dest, result, "Result of reversal is incorrect")

	done()
end sub

sub test4 (done as Tester.doneFn)
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

	_tester->expectStr(id, expected, "Identifier encoded incorrectly")
	_tester->expect(result.v(0), binaryId.v(0), "Incorrect decoded value")
	_tester->expect(result.v(1), binaryId.v(1), "Incorrect decoded value")
	_tester->expect(result.v(2), binaryId.v(2), "Incorrect decoded value")
	_tester->expect(result.v(3), binaryId.v(3), "Incorrect decoded value")
	_tester->expect(result.v(4), binaryId.v(4), "Incorrect decoded value")
	_tester->expect(result.v(5), binaryId.v(5), "Incorrect decoded value")
	_tester->expect(result.v(6), binaryId.v(6), "Incorrect decoded value")
	_tester->expect(result.v(7), binaryId.v(7), "Incorrect decoded value")
	_tester->expect(result.v(8), binaryId.v(8), "Incorrect decoded value")
	_tester->expect(result.v(9), binaryId.v(9), "Incorrect decoded value")
	_tester->expect(result.v(10), binaryId.v(10), "Incorrect decoded value")
	_tester->expect(result.v(11), binaryId.v(11), "Incorrect decoded value")
	_tester->expect(result.v(12), binaryId.v(12), "Incorrect decoded value")
	_tester->expect(result.v(13), binaryId.v(13), "Incorrect decoded value")
	_tester->expect(result.v(14), binaryId.v(14), "Incorrect decoded value")

	done()
end sub

sub test5 (done as Tester.doneFn)
	dim as zstring*18 addr

	_sys->getMacAddress(addr)

	print(_sys->getTimestamp())
	print(addr)

	done()
end sub

end namespace

