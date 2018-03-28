
#include once "iterator.bi"

namespace Iterator

declare function testCreate cdecl (it as Tester.itCallback) as short
declare sub test1 cdecl (done as Tester.doneFn)
declare sub test2 cdecl (done as Tester.doneFn)
declare sub test3 cdecl (done as Tester.doneFn)
declare sub test4 cdecl (done as Tester.doneFn)
declare sub test5 cdecl (done as Tester.doneFn)

dim shared as integer testData(8-1) = { 1, 2, 3, 4, 5, 6, 7, 8 }
dim shared as Instance ptr iter

function testCreate cdecl (it as Tester.itCallback) as short
	dim as short result = true

	result = result ANDALSO it ("creates an iterator instance", @test1)
	result = result ANDALSO it ("initializes iterator data", @test2)
	result = result ANDALSO it ("correctly iterates an array", @test3)
	result = result ANDALSO it ("correctly iterates after it has been reset", @test4)
	result = result ANDALSO it ("deletes the instance", @test5)

	return result
end function

sub test1 cdecl (done as Tester.doneFn)
	iter = construct()

	_tester->expectPtrNot(iter, NULL, "Failed to instantiate Iterator")

	done()
end sub

sub test2 cdecl (done as Tester.doneFn)
	setData(iter, @testData(0), 8)

	_tester->expect(length(iter), 8, "Iterator returned incorrect length")

	done()
end sub

sub test3 cdecl (done as Tester.doneFn)
	dim as integer value

	_tester->expect(getNext(iter, @value), true, "Iteration ended prematurely at element 1")
	_tester->expect(value, 1, "Invalid result from getNext() at element 1")

	_tester->expect(getNext(iter, @value), true, "Iteration ended prematurely at element 2")
	_tester->expect(value, 2, "Invalid result from getNext() at element 2")

	_tester->expect(getNext(iter, @value), true, "Iteration ended prematurely at element 3")
	_tester->expect(value, 3, "Invalid result from getNext() at element 3")

	_tester->expect(getNext(iter, @value), true, "Iteration ended prematurely at element 4")
	_tester->expect(value, 4, "Invalid result from getNext() at element 4")

	_tester->expect(getNext(iter, @value), true, "Iteration ended prematurely at element 5")
	_tester->expect(value, 5, "Invalid result from getNext() at element 5")

	_tester->expect(getNext(iter, @value), true, "Iteration ended prematurely at element 6")
	_tester->expect(value, 6, "Invalid result from getNext() at element 6")

	_tester->expect(getNext(iter, @value), true, "Iteration ended prematurely at element 7")
	_tester->expect(value, 7, "Invalid result from getNext() at element 7")

	_tester->expect(getNext(iter, @value), true, "Iteration ended prematurely at element 8")
	_tester->expect(value, 8, "Invalid result from getNext() at element 8")

	done()
end sub

sub test4 cdecl (done as Tester.doneFn)
	dim as integer value

	reset(iter)

	_tester->expect(getNext(iter, @value), true, "Iteration ended prematurely at element 1")
	_tester->expect(value, 1, "Invalid result from getNext() at element 1")

	_tester->expect(getNext(iter, @value), true, "Iteration ended prematurely at element 2")
	_tester->expect(value, 2, "Invalid result from getNext() at element 2")

	_tester->expect(getNext(iter, @value), true, "Iteration ended prematurely at element 3")
	_tester->expect(value, 3, "Invalid result from getNext() at element 3")

	_tester->expect(getNext(iter, @value), true, "Iteration ended prematurely at element 4")
	_tester->expect(value, 4, "Invalid result from getNext() at element 4")

	_tester->expect(getNext(iter, @value), true, "Iteration ended prematurely at element 5")
	_tester->expect(value, 5, "Invalid result from getNext() at element 5")

	_tester->expect(getNext(iter, @value), true, "Iteration ended prematurely at element 6")
	_tester->expect(value, 6, "Invalid result from getNext() at element 6")

	_tester->expect(getNext(iter, @value), true, "Iteration ended prematurely at element 7")
	_tester->expect(value, 7, "Invalid result from getNext() at element 7")

	_tester->expect(getNext(iter, @value), true, "Iteration ended prematurely at element 8")
	_tester->expect(value, 8, "Invalid result from getNext() at element 8")

	done()
end sub

sub test5 cdecl (done as Tester.doneFn)
	destruct(iter)
	iter = NULL

	_tester->expectPtr(iter, NULL, "Iterator instance not destroyed")

	done()
end sub

end namespace

