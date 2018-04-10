
#include once "state.bi"

namespace State

type TestResource1
	x as long
	y as long
end type

type TestResource2
	x as long
	y as long
	z as long
end type

dim shared as Instance ptr testPtr
dim shared as ResourceContainer.Instance ptr testContPtr
dim shared as string testIDs(8)
dim shared as long testIndices(8)
dim shared as long testResources(8)

declare function testCreate cdecl (it as Tester.itCallback) as short
declare sub test1 cdecl (done as Tester.doneFn)
declare sub test2 cdecl (done as Tester.doneFn)
declare sub test3 cdecl (done as Tester.doneFn)
declare sub test4 cdecl (done as Tester.doneFn)
declare sub test5 cdecl (done as Tester.doneFn)
declare sub test28 cdecl (done as Tester.doneFn)
declare sub test29 cdecl (done as Tester.doneFn)
declare sub test30 cdecl (done as Tester.doneFn)

function testCreate cdecl (it as Tester.itCallback) as short
	dim as short result = true

	' Setup
	testIDs(0) = "zdfjychjmc"
	testIDs(1) = "893749a8uhdfh"
	testIDs(2) = "do9s8huw93z"
	testIDs(3) = "zds9gz8dll4kjrdfm"
	testIDs(4) = "dvbkuysm,snsemnb"
	testIDs(5) = "xufyyy ya348oyoreu87tyhzdkfj"
	testIDs(6) = "FOO_MODULE-THISLOOKS_LIKEAREALMESSAGEID"
	testIDs(7) = "38499ea97e8347uzer7gakm"

	testContPtr = _resourceContainer->construct()
	_resourceContainer->initialize(testContPtr, sizeof(TestResource2), 32, 100)

	' Run tests
	result = result andalso it("constructs instance successfully", @test1)
	result = result andalso it("requests mapped resource indices", @test2)
	result = result andalso it("returns the correct indices for existing identifiers", @test3)
	result = result andalso it("assigns singular resource", @test4)
	result = result andalso it("assigns multiple resources from container", @test5)
	result = result andalso it("unassigns all resources", @test28)
	result = result andalso it("releases and unmaps resource indices", @test29)
	result = result andalso it("destroys instance successfully", @test30)

	return result
end function

sub test1 cdecl (done as Tester.doneFn)
	testPtr = _state->construct()

	_tester->expectPtrNot(testPtr, NULL, "Failed to construct State instance")
	_tester->expect(_state->initialize(testPtr), true, "Failed to initialize State instance")

	done()
end sub

sub test2 cdecl (done as Tester.doneFn)
	testIndices(0) = _state->request(testPtr, cptr(ubyte ptr, strptr(testIDs(0))))
	testIndices(1) = _state->request(testPtr, cptr(ubyte ptr, strptr(testIDs(1))))
	testIndices(2) = _state->request(testPtr, cptr(ubyte ptr, strptr(testIDs(2))))
	testIndices(3) = _state->request(testPtr, cptr(ubyte ptr, strptr(testIDs(3))))
	testIndices(4) = _state->request(testPtr, cptr(ubyte ptr, strptr(testIDs(4))))
	testIndices(5) = _state->request(testPtr, cptr(ubyte ptr, strptr(testIDs(5))))
	testIndices(6) = _state->request(testPtr, cptr(ubyte ptr, strptr(testIDs(6))))
	testIndices(7) = _state->request(testPtr, cptr(ubyte ptr, strptr(testIDs(7))))

	_tester->expectNot(testIndices(0), -1, "Attempt #0 failed to return an index")
	_tester->expectNot(testIndices(1), -1, "Attempt #1 failed to return an index")
	_tester->expectNot(testIndices(2), -1, "Attempt #2 failed to return an index")
	_tester->expectNot(testIndices(3), -1, "Attempt #3 failed to return an index")
	_tester->expectNot(testIndices(4), -1, "Attempt #4 failed to return an index")
	_tester->expectNot(testIndices(5), -1, "Attempt #5 failed to return an index")
	_tester->expectNot(testIndices(6), -1, "Attempt #6 failed to return an index")
	_tester->expectNot(testIndices(7), -1, "Attempt #7 failed to return an index")

	done()
end sub

sub test3 cdecl (done as Tester.doneFn)
	_tester->expect(_state->request(testPtr, cptr(ubyte ptr, strptr(testIDs(4)))), testIndices(4), "Return incorrect value at index #4")
	_tester->expect(_state->request(testPtr, cptr(ubyte ptr, strptr(testIDs(6)))), testIndices(6), "Return incorrect value at index #6")
	_tester->expect(_state->request(testPtr, cptr(ubyte ptr, strptr(testIDs(2)))), testIndices(2), "Return incorrect value at index #2")
	_tester->expect(_state->request(testPtr, cptr(ubyte ptr, strptr(testIDs(3)))), testIndices(3), "Return incorrect value at index #3")
	_tester->expect(_state->request(testPtr, cptr(ubyte ptr, strptr(testIDs(7)))), testIndices(7), "Return incorrect value at index #7")
	_tester->expect(_state->request(testPtr, cptr(ubyte ptr, strptr(testIDs(0)))), testIndices(0), "Return incorrect value at index #0")
	_tester->expect(_state->request(testPtr, cptr(ubyte ptr, strptr(testIDs(1)))), testIndices(1), "Return incorrect value at index #1")
	_tester->expect(_state->request(testPtr, cptr(ubyte ptr, strptr(testIDs(5)))), testIndices(5), "Return incorrect value at index #5")

	done()
end sub

sub test4 cdecl (done as Tester.doneFn)
	_tester->expect(_state->assign(testPtr, testIndices(0), sizeof(TestResource1)), true, "Failed to assign resource")

	done()
end sub

sub test5 cdecl (done as Tester.doneFn)
	_tester->expect(_state->assignFromContainer(testPtr, testIndices(1), testContPtr), true, "Failed to assign resource at index #1")
	_tester->expect(_state->assignFromContainer(testPtr, testIndices(2), testContPtr), true, "Failed to assign resource at index #2")
	_tester->expect(_state->assignFromContainer(testPtr, testIndices(3), testContPtr), true, "Failed to assign resource at index #3")
	_tester->expect(_state->assignFromContainer(testPtr, testIndices(4), testContPtr), true, "Failed to assign resource at index #4")
	_tester->expect(_state->assignFromContainer(testPtr, testIndices(5), testContPtr), true, "Failed to assign resource at index #5")
	_tester->expect(_state->assignFromContainer(testPtr, testIndices(6), testContPtr), true, "Failed to assign resource at index #6")
	_tester->expect(_state->assignFromContainer(testPtr, testIndices(7), testContPtr), true, "Failed to assign resource at index #7")

	done()
end sub

sub test29 cdecl (done as Tester.doneFn)
	_tester->expect(_state->unassign(testPtr, testIndices(0)), true, "Failed to unassign singular resource")
	_tester->expect(_state->unassign(testPtr, testIndices(1)), true, "Failed to unassign resource at index #1")
	_tester->expect(_state->unassign(testPtr, testIndices(2)), true, "Failed to unassign resource at index #2")
	_tester->expect(_state->unassign(testPtr, testIndices(3)), true, "Failed to unassign resource at index #3")
	_tester->expect(_state->unassign(testPtr, testIndices(4)), true, "Failed to unassign resource at index #4")
	_tester->expect(_state->unassign(testPtr, testIndices(5)), true, "Failed to unassign resource at index #5")
	_tester->expect(_state->unassign(testPtr, testIndices(6)), true, "Failed to unassign resource at index #6")
	_tester->expect(_state->unassign(testPtr, testIndices(7)), true, "Failed to unassign resource at index #7")

	done()
end sub

sub test28 cdecl (done as Tester.doneFn)
	_tester->expect(_state->release(testPtr, testIndices(0)), true, "Failed to release index #0")
	_tester->expect(_state->release(testPtr, testIndices(1)), true, "Failed to release index #1")
	_tester->expect(_state->release(testPtr, testIndices(2)), true, "Failed to release index #2")
	_tester->expect(_state->release(testPtr, testIndices(3)), true, "Failed to release index #3")
	_tester->expect(_state->release(testPtr, testIndices(4)), true, "Failed to release index #4")
	_tester->expect(_state->release(testPtr, testIndices(5)), true, "Failed to release index #5")
	_tester->expect(_state->release(testPtr, testIndices(6)), true, "Failed to release index #6")
	_tester->expect(_state->release(testPtr, testIndices(7)), true, "Failed to release index #7")

	done()
end sub

sub test30 cdecl (done as Tester.doneFn)
	_state->destruct(testPtr)
	testPtr = NULL

	done()
end sub

end namespace

