
#include once "iterator.bi"

namespace Iterator

declare function testCreate (it as Tester.itCallback) as short
declare sub test1 (expect as Tester.expectFn, done as Tester.doneFn)
declare sub test2 (expect as Tester.expectFn, done as Tester.doneFn)
declare sub test3 (expect as Tester.expectFn, done as Tester.doneFn)
declare sub test4 (expect as Tester.expectFn, done as Tester.doneFn)

dim shared as integer testData(8-1) = { 1, 2, 3, 4, 5, 6, 7, 8 }
dim shared as Instance ptr iter

function testCreate (it as Tester.itCallback) as short
	dim as short result = true

	result = result ANDALSO it ("creates an iterator instance", @test1)
	result = result ANDALSO it ("correctly iterates an array", @test2)
	result = result ANDALSO it ("correctly iterates after it has been reset", @test3)
	result = result ANDALSO it ("deletes the instance", @test4)

	return result
end function

sub test1 (expect as Tester.expectFn, done as Tester.doneFn)
	iter = construct(@testData(0), 8)

	expect(iter = NULL, false, "Failed to instantiate Iterator")

	done()
end sub

sub test2 (expect as Tester.expectFn, done as Tester.doneFn)
	dim as integer value

	expect(getNext(iter, @value), true, "Iteration ended prematurely at element 1")
	expect(value, 1, "Invalid result from getNext() at element 1")

	expect(getNext(iter, @value), true, "Iteration ended prematurely at element 2")
	expect(value, 2, "Invalid result from getNext() at element 2")

	expect(getNext(iter, @value), true, "Iteration ended prematurely at element 3")
	expect(value, 3, "Invalid result from getNext() at element 3")

	expect(getNext(iter, @value), true, "Iteration ended prematurely at element 4")
	expect(value, 4, "Invalid result from getNext() at element 4")

	expect(getNext(iter, @value), true, "Iteration ended prematurely at element 5")
	expect(value, 5, "Invalid result from getNext() at element 5")

	expect(getNext(iter, @value), true, "Iteration ended prematurely at element 6")
	expect(value, 6, "Invalid result from getNext() at element 6")

	expect(getNext(iter, @value), true, "Iteration ended prematurely at element 7")
	expect(value, 7, "Invalid result from getNext() at element 7")

	expect(getNext(iter, @value), true, "Iteration ended prematurely at element 8")
	expect(value, 8, "Invalid result from getNext() at element 8")

	done()
end sub

sub test3 (expect as Tester.expectFn, done as Tester.doneFn)
	dim as integer value

	reset(iter)

	expect(getNext(iter, @value), true, "Iteration ended prematurely at element 1")
	expect(value, 1, "Invalid result from getNext() at element 1")

	expect(getNext(iter, @value), true, "Iteration ended prematurely at element 2")
	expect(value, 2, "Invalid result from getNext() at element 2")

	expect(getNext(iter, @value), true, "Iteration ended prematurely at element 3")
	expect(value, 3, "Invalid result from getNext() at element 3")

	expect(getNext(iter, @value), true, "Iteration ended prematurely at element 4")
	expect(value, 4, "Invalid result from getNext() at element 4")

	expect(getNext(iter, @value), true, "Iteration ended prematurely at element 5")
	expect(value, 5, "Invalid result from getNext() at element 5")

	expect(getNext(iter, @value), true, "Iteration ended prematurely at element 6")
	expect(value, 6, "Invalid result from getNext() at element 6")

	expect(getNext(iter, @value), true, "Iteration ended prematurely at element 7")
	expect(value, 7, "Invalid result from getNext() at element 7")

	expect(getNext(iter, @value), true, "Iteration ended prematurely at element 8")
	expect(value, 8, "Invalid result from getNext() at element 8")

	done()
end sub

sub test4 (expect as Tester.expectFn, done as Tester.doneFn)
	destruct(iter)
	iter = NULL

	expect(iter = NULL, true, "Iterator instance not destroyed")

	done()
end sub

end namespace

