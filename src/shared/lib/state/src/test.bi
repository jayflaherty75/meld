
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

type TestMessage
	typeId as long
	x as long
	y as long
end type

dim shared as Instance ptr testPtr
dim shared as ResourceContainer.Instance ptr testContPtr
dim shared as string testIDs(8)
dim shared as long testResources(8)

declare function testCreate cdecl (it as Tester.itCallback) as short
declare sub test1 cdecl (done as Tester.doneFn)
declare sub test2 cdecl (done as Tester.doneFn)
declare sub test3 cdecl (done as Tester.doneFn)
declare sub test4 cdecl (done as Tester.doneFn)
declare sub test5 cdecl (done as Tester.doneFn)
declare sub test6 cdecl (done as Tester.doneFn)
declare sub test7 cdecl (done as Tester.doneFn)
declare sub test7_3 cdecl (done as Tester.doneFn)
declare sub test7_5 cdecl (done as Tester.doneFn)
declare sub test8 cdecl (done as Tester.doneFn)
declare sub test9 cdecl (done as Tester.doneFn)
declare sub test28 cdecl (done as Tester.doneFn)
declare sub test29 cdecl (done as Tester.doneFn)
declare sub test30 cdecl (done as Tester.doneFn)

declare function modifier1 cdecl (dataPtr as any ptr, messagePtr as any ptr) as short
declare function modifier2 cdecl (dataPtr as any ptr, messagePtr as any ptr) as short
declare function modifierSet cdecl (dataPtr as any ptr, messagePtr as any ptr) as short
declare function selectX cdecl (statePtr as any ptr, resPtr as any ptr, valuePtr as any ptr) as short
declare function selectY cdecl (statePtr as any ptr, resPtr as any ptr, valuePtr as any ptr) as short
declare function selectZ cdecl (statePtr as any ptr, resPtr as any ptr, valuePtr as any ptr) as short
declare function selectIterator cdecl (statePtr as any ptr, resPtr as any ptr, valuePtr as any ptr) as short
declare function selectIndexAt cdecl (statePtr as any ptr, dataPtr as any ptr, index as long) as long

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
	result = result andalso it("assigns modifiers to resources", @test6)
	result = result andalso it("initializes resources with the correct state", @test7)
	result = result andalso it("accepts dispatched change event messages", @test7_3)
	result = result andalso it("successfuly detaches modifiers", @test7_5)
	result = result andalso it("accepts dispatched change event messages after detaching modifiers", @test8)
	result = result andalso it("provides access and iteration of resource sets", @test9)
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
	testResources(0) = _state->request(testPtr, cptr(ubyte ptr, strptr(testIDs(0))))
	testResources(1) = _state->request(testPtr, cptr(ubyte ptr, strptr(testIDs(1))))
	testResources(2) = _state->request(testPtr, cptr(ubyte ptr, strptr(testIDs(2))))
	testResources(3) = _state->request(testPtr, cptr(ubyte ptr, strptr(testIDs(3))))
	testResources(4) = _state->request(testPtr, cptr(ubyte ptr, strptr(testIDs(4))))
	testResources(5) = _state->request(testPtr, cptr(ubyte ptr, strptr(testIDs(5))))
	testResources(6) = _state->request(testPtr, cptr(ubyte ptr, strptr(testIDs(6))))
	testResources(7) = _state->request(testPtr, cptr(ubyte ptr, strptr(testIDs(7))))

	_tester->expectNot(testResources(0), -1, "Attempt #0 failed to return an index")
	_tester->expectNot(testResources(1), -1, "Attempt #1 failed to return an index")
	_tester->expectNot(testResources(2), -1, "Attempt #2 failed to return an index")
	_tester->expectNot(testResources(3), -1, "Attempt #3 failed to return an index")
	_tester->expectNot(testResources(4), -1, "Attempt #4 failed to return an index")
	_tester->expectNot(testResources(5), -1, "Attempt #5 failed to return an index")
	_tester->expectNot(testResources(6), -1, "Attempt #6 failed to return an index")
	_tester->expectNot(testResources(7), -1, "Attempt #7 failed to return an index")

	_tester->expect(_state->isReferenced(testPtr, testResources(0)), true, "Resource #0 not referenced")
	_tester->expect(_state->isReferenced(testPtr, testResources(1)), true, "Resource #1 not referenced")
	_tester->expect(_state->isReferenced(testPtr, testResources(2)), true, "Resource #2 not referenced")
	_tester->expect(_state->isReferenced(testPtr, testResources(3)), true, "Resource #3 not referenced")
	_tester->expect(_state->isReferenced(testPtr, testResources(4)), true, "Resource #4 not referenced")
	_tester->expect(_state->isReferenced(testPtr, testResources(5)), true, "Resource #5 not referenced")
	_tester->expect(_state->isReferenced(testPtr, testResources(6)), true, "Resource #6 not referenced")
	_tester->expect(_state->isReferenced(testPtr, testResources(7)), true, "Resource #7 not referenced")

	done()
end sub

sub test3 cdecl (done as Tester.doneFn)
	_tester->expect(_state->request(testPtr, cptr(ubyte ptr, strptr(testIDs(4)))), testResources(4), "Return incorrect value at index #4")
	_tester->expect(_state->request(testPtr, cptr(ubyte ptr, strptr(testIDs(6)))), testResources(6), "Return incorrect value at index #6")
	_tester->expect(_state->request(testPtr, cptr(ubyte ptr, strptr(testIDs(2)))), testResources(2), "Return incorrect value at index #2")
	_tester->expect(_state->request(testPtr, cptr(ubyte ptr, strptr(testIDs(3)))), testResources(3), "Return incorrect value at index #3")
	_tester->expect(_state->request(testPtr, cptr(ubyte ptr, strptr(testIDs(7)))), testResources(7), "Return incorrect value at index #7")
	_tester->expect(_state->request(testPtr, cptr(ubyte ptr, strptr(testIDs(0)))), testResources(0), "Return incorrect value at index #0")
	_tester->expect(_state->request(testPtr, cptr(ubyte ptr, strptr(testIDs(1)))), testResources(1), "Return incorrect value at index #1")
	_tester->expect(_state->request(testPtr, cptr(ubyte ptr, strptr(testIDs(5)))), testResources(5), "Return incorrect value at index #5")

	done()
end sub

sub test4 cdecl (done as Tester.doneFn)
	_tester->expect(_state->assign(testPtr, testResources(0), sizeof(TestResource1)), true, "Failed to assign resource")
	_tester->expect(_state->isAssigned(testPtr, testResources(0)), true, "Resource not assigned")

	done()
end sub

sub test5 cdecl (done as Tester.doneFn)
	_tester->expect(_state->assignFromContainer(testPtr, testResources(1), testContPtr), true, "Failed to assign resource at index #1")
	_tester->expect(_state->assignFromContainer(testPtr, testResources(2), testContPtr), true, "Failed to assign resource at index #2")
	_tester->expect(_state->assignFromContainer(testPtr, testResources(3), testContPtr), true, "Failed to assign resource at index #3")
	_tester->expect(_state->assignFromContainer(testPtr, testResources(4), testContPtr), true, "Failed to assign resource at index #4")
	_tester->expect(_state->assignFromContainer(testPtr, testResources(5), testContPtr), true, "Failed to assign resource at index #5")
	_tester->expect(_state->assignFromContainer(testPtr, testResources(6), testContPtr), true, "Failed to assign resource at index #6")
	_tester->expect(_state->assignFromContainer(testPtr, testResources(7), testContPtr), true, "Failed to assign resource at index #7")

	_tester->expect(_state->isAssigned(testPtr, testResources(1)), true, "Resource #1 not assigned")
	_tester->expect(_state->isAssigned(testPtr, testResources(2)), true, "Resource #2 not assigned")
	_tester->expect(_state->isAssigned(testPtr, testResources(3)), true, "Resource #3 not assigned")
	_tester->expect(_state->isAssigned(testPtr, testResources(4)), true, "Resource #4 not assigned")
	_tester->expect(_state->isAssigned(testPtr, testResources(5)), true, "Resource #5 not assigned")
	_tester->expect(_state->isAssigned(testPtr, testResources(6)), true, "Resource #6 not assigned")
	_tester->expect(_state->isAssigned(testPtr, testResources(7)), true, "Resource #7 not assigned")

	done()
end sub

sub test6 cdecl (done as Tester.doneFn)
	_tester->expect(_state->setModifier(testPtr, testResources(0), @modifier1), true, "Resource #0 modifier not assigned")
	_tester->expect(_state->setModifier(testPtr, testResources(1), @modifier2), true, "Resource #1 modifier not assigned")
	_tester->expect(_state->setModifier(testPtr, testResources(2), @modifier2), true, "Resource #2 modifier not assigned")
	_tester->expect(_state->setModifier(testPtr, testResources(3), @modifier2), true, "Resource #3 modifier not assigned")
	_tester->expect(_state->setModifier(testPtr, testResources(4), @modifier2), true, "Resource #4 modifier not assigned")
	_tester->expect(_state->setModifier(testPtr, testResources(5), @modifier2), true, "Resource #5 modifier not assigned")
	_tester->expect(_state->setModifier(testPtr, testResources(6), @modifier2), true, "Resource #6 modifier not assigned")
	_tester->expect(_state->setModifier(testPtr, testResources(7), @modifier2), true, "Resource #7 modifier not assigned")

	done()
end sub

sub test7 cdecl (done as Tester.doneFn)
	dim as short i
	dim as long x, y, z

	_tester->expect(_state->selectFrom(testPtr, testResources(0), @x, @selectX), true, "Failed to retrieve value X from resource #0")
	_tester->expect(_state->selectFrom(testPtr, testResources(0), @y, @selectY), true, "Failed to retrieve value Y from resource #0")
	_tester->expect(x, 10000, "Incorrect value X returned from resource #0")
	_tester->expect(y, 20000, "Incorrect value Y returned from resource #0")

	for i = 1 to 7
		_tester->expect(_state->selectFrom(testPtr, testResources(i), @x, @selectX), true, "Failed to retrieve value X from resource #" & i)
		_tester->expect(_state->selectFrom(testPtr, testResources(i), @y, @selectY), true, "Failed to retrieve value Y from resource #" & i)
		_tester->expect(_state->selectFrom(testPtr, testResources(i), @z, @selectZ), true, "Failed to retrieve value Z from resource #" & i)
		_tester->expect(x, 30000, "Incorrect value X returned from resource #" & i)
		_tester->expect(y, 40000, "Incorrect value Y returned from resource #" & i)
		_tester->expect(z, 50000, "Incorrect value Z returned from resource #" & i)
	next

	done()
end sub

sub test7_3 cdecl (done as Tester.doneFn)
	dim as TestMessage msg
	dim as long x, y, z

	msg.typeId = 1
	msg.x = 5000
	msg.y = 10000

	_tester->expect(_state->dispatch(testPtr, @msg), true, "Encountered problem dispatching message of type #1")

	msg.typeId = 2
	_tester->expect(_state->dispatch(testPtr, @msg), true, "Encountered problem dispatching message of type #2")

	msg.typeId = 3
	_tester->expect(_state->dispatch(testPtr, @msg), true, "Encountered problem dispatching message of type #3")

	_tester->expect(_state->selectFrom(testPtr, testResources(1), @x, @selectX), true, "Failed to retrieve value X from resource #1")
	_tester->expect(_state->selectFrom(testPtr, testResources(1), @y, @selectY), true, "Failed to retrieve value Y from resource #1")
	_tester->expect(_state->selectFrom(testPtr, testResources(1), @z, @selectZ), true, "Failed to retrieve value Z from resource #1")
	_tester->expect(x, 25000, "Incorrect value X returned from resource #1")
	_tester->expect(y, 50000, "Incorrect value Y returned from resource #1")
	_tester->expect(z, 50000, "Incorrect value Z returned from resource #1")

	_tester->expect(_state->selectFrom(testPtr, testResources(2), @x, @selectX), true, "Failed to retrieve value X from resource #2")
	_tester->expect(_state->selectFrom(testPtr, testResources(2), @y, @selectY), true, "Failed to retrieve value Y from resource #2")
	_tester->expect(_state->selectFrom(testPtr, testResources(2), @z, @selectZ), true, "Failed to retrieve value Z from resource #2")
	_tester->expect(x, 25000, "Incorrect value X returned from resource #2")
	_tester->expect(y, 50000, "Incorrect value Y returned from resource #2")
	_tester->expect(z, 50000, "Incorrect value Z returned from resource #2")

	_tester->expect(_state->selectFrom(testPtr, testResources(3), @x, @selectX), true, "Failed to retrieve value X from resource #3")
	_tester->expect(_state->selectFrom(testPtr, testResources(3), @y, @selectY), true, "Failed to retrieve value Y from resource #3")
	_tester->expect(_state->selectFrom(testPtr, testResources(3), @z, @selectZ), true, "Failed to retrieve value Z from resource #3")
	_tester->expect(x, 25000, "Incorrect value X returned from resource #3")
	_tester->expect(y, 50000, "Incorrect value Y returned from resource #3")
	_tester->expect(z, 50000, "Incorrect value Z returned from resource #3")

	_tester->expect(_state->selectFrom(testPtr, testResources(4), @x, @selectX), true, "Failed to retrieve value X from resource #4")
	_tester->expect(_state->selectFrom(testPtr, testResources(4), @y, @selectY), true, "Failed to retrieve value Y from resource #4")
	_tester->expect(_state->selectFrom(testPtr, testResources(4), @z, @selectZ), true, "Failed to retrieve value Z from resource #4")
	_tester->expect(x, 25000, "Incorrect value X returned from resource #4")
	_tester->expect(y, 50000, "Incorrect value Y returned from resource #4")
	_tester->expect(z, 50000, "Incorrect value Z returned from resource #4")

	_tester->expect(_state->selectFrom(testPtr, testResources(5), @x, @selectX), true, "Failed to retrieve value X from resource #5")
	_tester->expect(_state->selectFrom(testPtr, testResources(5), @y, @selectY), true, "Failed to retrieve value Y from resource #5")
	_tester->expect(_state->selectFrom(testPtr, testResources(5), @z, @selectZ), true, "Failed to retrieve value Z from resource #5")
	_tester->expect(x, 25000, "Incorrect value X returned from resource #5")
	_tester->expect(y, 50000, "Incorrect value Y returned from resource #5")
	_tester->expect(z, 50000, "Incorrect value Z returned from resource #5")

	_tester->expect(_state->selectFrom(testPtr, testResources(6), @x, @selectX), true, "Failed to retrieve value X from resource #6")
	_tester->expect(_state->selectFrom(testPtr, testResources(6), @y, @selectY), true, "Failed to retrieve value Y from resource #6")
	_tester->expect(_state->selectFrom(testPtr, testResources(6), @z, @selectZ), true, "Failed to retrieve value Z from resource #6")
	_tester->expect(x, 25000, "Incorrect value X returned from resource #6")
	_tester->expect(y, 50000, "Incorrect value Y returned from resource #6")
	_tester->expect(z, 50000, "Incorrect value Z returned from resource #6")

	_tester->expect(_state->selectFrom(testPtr, testResources(7), @x, @selectX), true, "Failed to retrieve value X from resource #7")
	_tester->expect(_state->selectFrom(testPtr, testResources(7), @y, @selectY), true, "Failed to retrieve value Y from resource #7")
	_tester->expect(_state->selectFrom(testPtr, testResources(7), @z, @selectZ), true, "Failed to retrieve value Z from resource #7")
	_tester->expect(x, 25000, "Incorrect value X returned from resource #7")
	_tester->expect(y, 50000, "Incorrect value Y returned from resource #7")
	_tester->expect(z, 50000, "Incorrect value Z returned from resource #7")

	done()
end sub

sub test7_5 cdecl (done as Tester.doneFn)
	_tester->expect(_state->unsetModifier(testPtr, testResources(3)), true, "Failed to unassign modifier to resource #5")
	_tester->expect(_list->isValid(testPtr->modifiers), true, "List validation failed at index #5")

	_tester->expect(_state->unsetModifier(testPtr, testResources(6)), true, "Failed to unassign modifier to resource #6")
	_tester->expect(_list->isValid(testPtr->modifiers), true, "List validation failed at index #6")

	done()
end sub

sub test8 cdecl (done as Tester.doneFn)
	dim as TestMessage msg
	dim as long x, y, z

	msg.typeId = 1
	msg.x = 5000
	msg.y = 10000

	_tester->expect(_state->dispatch(testPtr, @msg), true, "Encountered problem dispatching message of type #1")

	msg.typeId = 2
	_tester->expect(_state->dispatch(testPtr, @msg), true, "Encountered problem dispatching message of type #2")

	msg.typeId = 3
	_tester->expect(_state->dispatch(testPtr, @msg), true, "Encountered problem dispatching message of type #3")

	_tester->expect(_state->selectFrom(testPtr, testResources(1), @x, @selectX), true, "Failed to retrieve value X from resource #1")
	_tester->expect(_state->selectFrom(testPtr, testResources(1), @y, @selectY), true, "Failed to retrieve value Y from resource #1")
	_tester->expect(_state->selectFrom(testPtr, testResources(1), @z, @selectZ), true, "Failed to retrieve value Z from resource #1")
	_tester->expect(x, 20000, "Incorrect value X returned from resource #1")
	_tester->expect(y, 60000, "Incorrect value Y returned from resource #1")
	_tester->expect(z, 50000, "Incorrect value Z returned from resource #1")

	_tester->expect(_state->selectFrom(testPtr, testResources(2), @x, @selectX), true, "Failed to retrieve value X from resource #2")
	_tester->expect(_state->selectFrom(testPtr, testResources(2), @y, @selectY), true, "Failed to retrieve value Y from resource #2")
	_tester->expect(_state->selectFrom(testPtr, testResources(2), @z, @selectZ), true, "Failed to retrieve value Z from resource #2")
	_tester->expect(x, 20000, "Incorrect value X returned from resource #2")
	_tester->expect(y, 60000, "Incorrect value Y returned from resource #2")
	_tester->expect(z, 50000, "Incorrect value Z returned from resource #2")

	_tester->expect(_state->selectFrom(testPtr, testResources(3), @x, @selectX), true, "Failed to retrieve value X from resource #3")
	_tester->expect(_state->selectFrom(testPtr, testResources(3), @y, @selectY), true, "Failed to retrieve value Y from resource #3")
	_tester->expect(_state->selectFrom(testPtr, testResources(3), @z, @selectZ), true, "Failed to retrieve value Z from resource #3")
	_tester->expect(x, 25000, "Incorrect value X returned from resource #3")
	_tester->expect(y, 50000, "Incorrect value Y returned from resource #3")
	_tester->expect(z, 50000, "Incorrect value Z returned from resource #3")

	_tester->expect(_state->selectFrom(testPtr, testResources(4), @x, @selectX), true, "Failed to retrieve value X from resource #4")
	_tester->expect(_state->selectFrom(testPtr, testResources(4), @y, @selectY), true, "Failed to retrieve value Y from resource #4")
	_tester->expect(_state->selectFrom(testPtr, testResources(4), @z, @selectZ), true, "Failed to retrieve value Z from resource #4")
	_tester->expect(x, 20000, "Incorrect value X returned from resource #4")
	_tester->expect(y, 60000, "Incorrect value Y returned from resource #4")
	_tester->expect(z, 50000, "Incorrect value Z returned from resource #4")

	_tester->expect(_state->selectFrom(testPtr, testResources(5), @x, @selectX), true, "Failed to retrieve value X from resource #5")
	_tester->expect(_state->selectFrom(testPtr, testResources(5), @y, @selectY), true, "Failed to retrieve value Y from resource #5")
	_tester->expect(_state->selectFrom(testPtr, testResources(5), @z, @selectZ), true, "Failed to retrieve value Z from resource #5")
	_tester->expect(x, 20000, "Incorrect value X returned from resource #5")
	_tester->expect(y, 60000, "Incorrect value Y returned from resource #5")
	_tester->expect(z, 50000, "Incorrect value Z returned from resource #5")

	_tester->expect(_state->selectFrom(testPtr, testResources(6), @x, @selectX), true, "Failed to retrieve value X from resource #6")
	_tester->expect(_state->selectFrom(testPtr, testResources(6), @y, @selectY), true, "Failed to retrieve value Y from resource #6")
	_tester->expect(_state->selectFrom(testPtr, testResources(6), @z, @selectZ), true, "Failed to retrieve value Z from resource #6")
	_tester->expect(x, 25000, "Incorrect value X returned from resource #6")
	_tester->expect(y, 50000, "Incorrect value Y returned from resource #6")
	_tester->expect(z, 50000, "Incorrect value Z returned from resource #6")

	_tester->expect(_state->selectFrom(testPtr, testResources(7), @x, @selectX), true, "Failed to retrieve value X from resource #7")
	_tester->expect(_state->selectFrom(testPtr, testResources(7), @y, @selectY), true, "Failed to retrieve value Y from resource #7")
	_tester->expect(_state->selectFrom(testPtr, testResources(7), @z, @selectZ), true, "Failed to retrieve value Z from resource #7")
	_tester->expect(x, 20000, "Incorrect value X returned from resource #7")
	_tester->expect(y, 60000, "Incorrect value Y returned from resource #7")
	_tester->expect(z, 50000, "Incorrect value Z returned from resource #7")

	done()
end sub

sub test9 cdecl (done as Tester.doneFn)
	dim as string setIdentity = "foo-bar-baz-bat"
	dim as ubyte ptr setIdentityPtr = strptr(setIdentity)
	dim as long setIndex
	dim as Iterator.Instance ptr iterPtr
	dim as long testResult

	setIndex = _state->request(testPtr, setIdentityPtr)
	_tester->expectNot(setIndex, -1, "Request for set index failed")

	_tester->expect(_state->assign(testPtr, setIndex, sizeof(long) * 7), true, "Failed to assign array set at index " & setIndex)
	_tester->expect(_state->setModifier(testPtr, setIndex, @modifierSet), true, "Failed to assign modifier to resource set")

	_tester->expect(_state->selectAt(testPtr, setIndex, 0, @selectIndexAt), 1, "Incorrect index returned from set at #0")
	_tester->expect(_state->selectAt(testPtr, setIndex, 1, @selectIndexAt), 2, "Incorrect index returned from set at #1")
	_tester->expect(_state->selectAt(testPtr, setIndex, 2, @selectIndexAt), 3, "Incorrect index returned from set at #2")
	_tester->expect(_state->selectAt(testPtr, setIndex, 3, @selectIndexAt), 4, "Incorrect index returned from set at #3")
	_tester->expect(_state->selectAt(testPtr, setIndex, 4, @selectIndexAt), 5, "Incorrect index returned from set at #4")
	_tester->expect(_state->selectAt(testPtr, setIndex, 5, @selectIndexAt), 6, "Incorrect index returned from set at #5")
	_tester->expect(_state->selectAt(testPtr, setIndex, 6, @selectIndexAt), 7, "Incorrect index returned from set at #6")

	_tester->expect(_state->selectFrom(testPtr, setIndex, @iterPtr, @selectIterator), true, "Failed to retrieve new iterator for resource set")
	_tester->expectPtrNot(iterPtr, NULL, "Selector returned NULL iterator")

	_tester->expect(_iterator->getNext(iterPtr, @testResult), true, "Iteration terminated early at #1")
	_tester->expect(testResult, 1, "Incorrect index returned from iterator at #1")

	_tester->expect(_iterator->getNext(iterPtr, @testResult), true, "Iteration terminated early at #2")
	_tester->expect(testResult, 2, "Incorrect index returned from iterator at #2")

	_tester->expect(_iterator->getNext(iterPtr, @testResult), true, "Iteration terminated early at #3")
	_tester->expect(testResult, 3, "Incorrect index returned from iterator at #3")

	_tester->expect(_iterator->getNext(iterPtr, @testResult), true, "Iteration terminated early at #4")
	_tester->expect(testResult, 4, "Incorrect index returned from iterator at #4")

	_tester->expect(_iterator->getNext(iterPtr, @testResult), true, "Iteration terminated early at #5")
	_tester->expect(testResult, 5, "Incorrect index returned from iterator at #5")

	_tester->expect(_iterator->getNext(iterPtr, @testResult), true, "Iteration terminated early at #6")
	_tester->expect(testResult, 6, "Incorrect index returned from iterator at #6")

	_tester->expect(_iterator->getNext(iterPtr, @testResult), true, "Iteration terminated early at #7")
	_tester->expect(testResult, 7, "Incorrect index returned from iterator at #7")

	_tester->expect(_iterator->getNext(iterPtr, @testResult), false, "Iteration Failed to terminate")
	_tester->expect(testResult, 7, "Incorrect index returned from iterator at #8")

	_iterator->destruct(iterPtr)

	_tester->expect(_state->unsetModifier(testPtr, setIndex), true, "Failed to unassign modifier to resource set at index " & setIndex)
	_tester->expect(_state->unassign(testPtr, setIndex), true, "Failed to unassign array set at index " & setIndex)
	_tester->expect(_state->release(testPtr, setIndex), true, "Failed to release set index")

	done()
end sub

sub test28 cdecl (done as Tester.doneFn)
	_tester->expect(_state->unassign(testPtr, testResources(0)), true, "Failed to unassign singular resource")
	_tester->expect(_state->unassign(testPtr, testResources(1)), true, "Failed to unassign resource at index #1")
	_tester->expect(_state->unassign(testPtr, testResources(2)), true, "Failed to unassign resource at index #2")
	_tester->expect(_state->unassign(testPtr, testResources(3)), true, "Failed to unassign resource at index #3")
	_tester->expect(_state->unassign(testPtr, testResources(4)), true, "Failed to unassign resource at index #4")
	_tester->expect(_state->unassign(testPtr, testResources(5)), true, "Failed to unassign resource at index #5")
	_tester->expect(_state->unassign(testPtr, testResources(6)), true, "Failed to unassign resource at index #6")
	_tester->expect(_state->unassign(testPtr, testResources(7)), true, "Failed to unassign resource at index #7")

	done()
end sub

sub test29 cdecl (done as Tester.doneFn)
	_tester->expect(_state->release(testPtr, testResources(0)), true, "Failed to dereference index #0")
	_tester->expect(_state->release(testPtr, testResources(1)), true, "Failed to dereference index #1")
	_tester->expect(_state->release(testPtr, testResources(2)), true, "Failed to dereference index #2")
	_tester->expect(_state->release(testPtr, testResources(3)), true, "Failed to dereference index #3")
	_tester->expect(_state->release(testPtr, testResources(4)), true, "Failed to dereference index #4")
	_tester->expect(_state->release(testPtr, testResources(5)), true, "Failed to dereference index #5")
	_tester->expect(_state->release(testPtr, testResources(6)), true, "Failed to dereference index #6")
	_tester->expect(_state->release(testPtr, testResources(7)), true, "Failed to dereference index #7")

	_tester->expect(_state->isReferenced(testPtr, testResources(0)), true, "Resource #0 prematurely released")
	_tester->expect(_state->isReferenced(testPtr, testResources(1)), true, "Resource #1 prematurely released")
	_tester->expect(_state->isReferenced(testPtr, testResources(2)), true, "Resource #2 prematurely released")
	_tester->expect(_state->isReferenced(testPtr, testResources(3)), true, "Resource #3 prematurely released")
	_tester->expect(_state->isReferenced(testPtr, testResources(4)), true, "Resource #4 prematurely released")
	_tester->expect(_state->isReferenced(testPtr, testResources(5)), true, "Resource #5 prematurely released")
	_tester->expect(_state->isReferenced(testPtr, testResources(6)), true, "Resource #6 prematurely released")
	_tester->expect(_state->isReferenced(testPtr, testResources(7)), true, "Resource #7 prematurely released")

	_tester->expect(_state->release(testPtr, testResources(0)), true, "Failed to release index #0")
	_tester->expect(_state->release(testPtr, testResources(1)), true, "Failed to release index #1")
	_tester->expect(_state->release(testPtr, testResources(2)), true, "Failed to release index #2")
	_tester->expect(_state->release(testPtr, testResources(3)), true, "Failed to release index #3")
	_tester->expect(_state->release(testPtr, testResources(4)), true, "Failed to release index #4")
	_tester->expect(_state->release(testPtr, testResources(5)), true, "Failed to release index #5")
	_tester->expect(_state->release(testPtr, testResources(6)), true, "Failed to release index #6")
	_tester->expect(_state->release(testPtr, testResources(7)), true, "Failed to release index #7")

	_tester->expect(_state->isReferenced(testPtr, testResources(0)), false, "Resource #0 still shows as referenced")
	_tester->expect(_state->isReferenced(testPtr, testResources(1)), false, "Resource #1 still shows as referenced")
	_tester->expect(_state->isReferenced(testPtr, testResources(2)), false, "Resource #2 still shows as referenced")
	_tester->expect(_state->isReferenced(testPtr, testResources(3)), false, "Resource #3 still shows as referenced")
	_tester->expect(_state->isReferenced(testPtr, testResources(4)), false, "Resource #4 still shows as referenced")
	_tester->expect(_state->isReferenced(testPtr, testResources(5)), false, "Resource #5 still shows as referenced")
	_tester->expect(_state->isReferenced(testPtr, testResources(6)), false, "Resource #6 still shows as referenced")
	_tester->expect(_state->isReferenced(testPtr, testResources(7)), false, "Resource #7 still shows as referenced")

	done()
end sub

sub test30 cdecl (done as Tester.doneFn)
	_state->destruct(testPtr)
	testPtr = NULL

	done()
end sub

function modifier1 cdecl (dataPtr as any ptr, messagePtr as any ptr) as short
	dim as TestResource1 ptr resPtr = dataPtr

	if messagePtr = NULL then
		resPtr->x = 10000
		resPtr->y = 20000
	end if

	return true
end function

function modifier2 cdecl (dataPtr as any ptr, messagePtr as any ptr) as short
	dim as TestResource2 ptr resPtr = dataPtr
	dim as TestMessage ptr msg = messagePtr

	if msg = NULL then
		resPtr->x = 30000
		resPtr->y = 40000
		resPtr->z = 50000
	else
		select case msg->typeId
			case 1:
				resPtr->x += msg->x
				resPtr->y += msg->y
			case 2:
				resPtr->x -= msg->x
				resPtr->y -= msg->y
			case 3:
				resPtr->x -= msg->x
				resPtr->y += msg->y
		end select
	end if

	return true
end function

function modifierSet cdecl (dataPtr as any ptr, messagePtr as any ptr) as short
	dim as long ptr resPtr = dataPtr

	if dataPtr = NULL then return false

	if messagePtr = NULL then
		resPtr[0] = testResources(1)
		resPtr[1] = testResources(2)
		resPtr[2] = testResources(3)
		resPtr[3] = testResources(4)
		resPtr[4] = testResources(5)
		resPtr[5] = testResources(6)
		resPtr[6] = testResources(7)
	end if

	return true
end function

function selectX cdecl (statePtr as any ptr, resPtr as any ptr, valuePtr as any ptr) as short
	if resPtr = NULL orelse valuePtr = NULL then return false

	*cptr(long ptr, valuePtr) = cptr(TestResource1 ptr, resPtr)->x

	return true
end function

function selectY cdecl (statePtr as any ptr, resPtr as any ptr, valuePtr as any ptr) as short
	if resPtr = NULL orelse valuePtr = NULL then return false

	*cptr(long ptr, valuePtr) = cptr(TestResource1 ptr, resPtr)->y

	return true
end function

function selectZ cdecl (statePtr as any ptr, resPtr as any ptr, valuePtr as any ptr) as short
	if resPtr = NULL orelse valuePtr = NULL then return false

	*cptr(long ptr, valuePtr) = cptr(TestResource2 ptr, resPtr)->z

	return true
end function

function selectIterator cdecl (statePtr as any ptr, resPtr as any ptr, valuePtr as any ptr) as short
	dim as Iterator.Instance ptr ptr iterPtrPtr = valuePtr

	if resPtr = NULL orelse valuePtr = NULL then return false

	*iterPtrPtr = _iterator->construct()

	if *iterPtrPtr = NULL then return false

	_iterator->setData(*iterPtrPtr, resPtr, 7)

	return true
end function

function selectIndexAt cdecl (statePtr as any ptr, dataPtr as any ptr, index as long) as long
	dim as long ptr resPtr = dataPtr

	if resPtr = NULL orelse index < 0 then return -1

	return resPtr[index]
end function

end namespace

