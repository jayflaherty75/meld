
#include once "identity.bi"

namespace Identity

declare function testCreate (it as Tester.itCallback) as short
declare sub test1 (done as Tester.doneFn)
declare sub test2 (done as Tester.doneFn)
declare sub test3 (done as Tester.doneFn)

dim shared as Identity.Instance ptr idPtr

function testCreate (it as Tester.itCallback) as short
	dim as short result = true

	idPtr = construct()

	result = result andalso it("creates an Identity instance", @test1)
	result = result andalso it("generates auto-increment identifiers", @test2)
	result = result andalso it("correctly reverses a string of bytes", @test3)

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

end namespace

