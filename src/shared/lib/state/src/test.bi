
#include once "state.bi"

namespace State

dim shared as Instance ptr testPtr

declare function testCreate cdecl (it as Tester.itCallback) as short
declare sub test1 cdecl (done as Tester.doneFn)
declare sub test2 cdecl (done as Tester.doneFn)

function testCreate cdecl (it as Tester.itCallback) as short
	dim as short result = true

	result = result andalso it("constructs instance successfully", @test1)
	result = result andalso it("destroys instance successfully", @test2)

	return result
end function

sub test1 cdecl (done as Tester.doneFn)
	testPtr = _state->construct()

	_tester->expectPtrNot(testPtr, NULL, "Failed to construct State instance")
	done()
end sub

sub test2 cdecl (done as Tester.doneFn)
	_state->destruct(testPtr)
	testPtr = NULL

	done()
end sub

end namespace

