
#include once "identity.bi"

namespace Identity

declare function testCreate (it as Tester.itCallback) as short
declare sub test1 (done as Tester.doneFn)
declare sub test2 (done as Tester.doneFn)

dim shared as Identity.Instance ptr idPtr

function testCreate (it as Tester.itCallback) as short
	dim as short result = true

	result = result andalso it("creates an Identity instance", @test1)
	result = result andalso it("generates auto-increment identifiers", @test2)

	return result
end function

sub test1 (done as Tester.doneFn)
	idPtr = construct()

	_tester->expectPtrNot(idPtr, NULL, "Constructor returned null")

	done()
end sub

sub test2 (done as Tester.doneFn)
	_tester->expect(getAutoInc(idPtr), 10, "Incorrect identifier returned")
	_tester->expect(getAutoInc(idPtr), 20, "Incorrect identifier returned")
	_tester->expect(getAutoInc(idPtr), 3, "Incorrect identifier returned")

	done()
end sub

end namespace

