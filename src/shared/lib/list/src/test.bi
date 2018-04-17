
#include once "list.bi"

namespace List

declare function  testCreate cdecl (it as Tester.itCallback) as short
declare sub test1 cdecl (done as Tester.doneFn)
declare sub test2 cdecl (done as Tester.doneFn)
declare sub test3 cdecl (done as Tester.doneFn)
declare sub test3_1 cdecl (done as Tester.doneFn)
declare sub test4 cdecl (done as Tester.doneFn)
declare sub test5 cdecl (done as Tester.doneFn)
declare sub test6 cdecl (done as Tester.doneFn)
declare sub test7 cdecl (done as Tester.doneFn)
declare sub test8 cdecl (done as Tester.doneFn)
declare sub test9 cdecl (done as Tester.doneFn)
declare sub test9_1 cdecl (done as Tester.doneFn)
declare sub test10 cdecl (done as Tester.doneFn)
declare sub test11 cdecl (done as Tester.doneFn)
declare sub test12 cdecl (done as Tester.doneFn)
declare sub test13 cdecl (done as Tester.doneFn)
declare sub test14 cdecl (done as Tester.doneFn)
declare sub test15 cdecl (done as Tester.doneFn)
declare sub test16 cdecl (done as Tester.doneFn)
declare sub test17 cdecl (done as Tester.doneFn)
declare sub test18 cdecl (done as Tester.doneFn)
declare sub test19 cdecl (done as Tester.doneFn)

dim shared as integer testData(8-1) = { 1, 2, 3, 4, 5, 6, 7, 8 }
dim shared as integer testResult(5-1) = { 3, 5, 6 }
dim shared as Instance ptr listPtr
dim shared as Node ptr nodePtr

function  testCreate cdecl (it as Tester.itCallback) as short
	dim as short result = true

	result = result andalso it("creates a new list instance", @test1)
	result = result andalso it("inserts a set of nodes", @test2)
	result = result andalso it("returns the correct list length", @test3)
	result = result andalso it("creates a working iterator", @test3_1)
	result = result andalso it("successfully searches a node inside the list", @test4)
	result = result andalso it("removes inside node", @test5)
	result = result andalso it("successfully searches a node at the beginning of the list", @test6)
	result = result andalso it("removes first node from search", @test7)
	result = result andalso it("successfully searches a node at the end of the list", @test8)
	result = result andalso it("removes last node from search", @test9)
	result = result andalso it("creates a working iterator after nodes have been removed", @test9_1)
	result = result andalso it("returns null on search for non-existing value", @test10)
	result = result andalso it("returns first node of list", @test11)
	result = result andalso it("removes first node of list", @test12)
	result = result andalso it("returns last node of list", @test13)
	result = result andalso it("removes last node of list", @test14)
	result = result andalso it("returns correct node for first step of iteration", @test15)
	result = result andalso it("returns correct second node of of iteration", @test16)
	result = result andalso it("returns correct third node of of iteration", @test17)
	result = result andalso it("returns null at end of iteration", @test18)
	result = result andalso it("releases remaining nodes when list deleted", @test19)

	return result
end function

sub test1 cdecl (done as Tester.doneFn)
	listPtr = _list->construct()

	_tester->expectPtrNot(listPtr, NULL, "Constructor returned NULL")

	done()
end sub

sub test2 cdecl (done as Tester.doneFn)
	dim as integer i

	nodePtr = NULL

	for i = 3 to 0 step -1
		nodePtr = _list->insert(listPtr, @testData(i), NULL)
		_tester->expectPtrNot(nodePtr, NULL, "List insert returned NULL at index " & i)
		_tester->expect(_list->isValid(listPtr), true, "List validation at index " & i)
	next

	nodePtr = _list->getLast(listPtr)
	_tester->expectPtrNot(nodePtr, NULL, "Last node is NULL")

	for i = 4 to 7
		nodePtr = _list->insert(listPtr, @testData(i), nodePtr)
		_tester->expectPtrNot(nodePtr, NULL, "List insert returned NULL at index " & i)
		_tester->expect(_list->isValid(listPtr), true, "List validation at index " & i)
	next

	done()
end sub

sub test3 cdecl (done as Tester.doneFn)
	_tester->expect(_list->getLength(listPtr), 8, "Insertions resulted in an incorrect list length")
	done()
end sub

sub test3_1 cdecl (done as Tester.doneFn)
	dim as Iterator.Instance ptr iter = _list->getIterator(listPtr)
	dim as integer ptr valPtr
	dim as short result

	result = _iterator->getNext(iter, @valPtr)
	_tester->expect(result, true, "Iteration ended early")
	_tester->expect(*valPtr, 1, "Incorrect value returned from iteration as index 1")

	result = _iterator->getNext(iter, @valPtr)
	_tester->expect(result, true, "Iteration ended early")
	_tester->expect(*valPtr, 2, "Incorrect value returned from iteration as index 2")

	result = _iterator->getNext(iter, @valPtr)
	_tester->expect(result, true, "Iteration ended early")
	_tester->expect(*valPtr, 3, "Incorrect value returned from iteration as index 3")

	result = _iterator->getNext(iter, @valPtr)
	_tester->expect(result, true, "Iteration ended early")
	_tester->expect(*valPtr, 4, "Incorrect value returned from iteration as index 4")

	result = _iterator->getNext(iter, @valPtr)
	_tester->expect(result, true, "Iteration ended early")
	_tester->expect(*valPtr, 5, "Incorrect value returned from iteration as index 5")

	result = _iterator->getNext(iter, @valPtr)
	_tester->expect(result, true, "Iteration ended early")
	_tester->expect(*valPtr, 6, "Incorrect value returned from iteration as index 6")

	result = _iterator->getNext(iter, @valPtr)
	_tester->expect(result, true, "Iteration ended early")
	_tester->expect(*valPtr, 7, "Incorrect value returned from iteration as index 7")

	result = _iterator->getNext(iter, @valPtr)
	_tester->expect(result, true, "Iteration ended early")
	_tester->expect(*valPtr, 8, "Incorrect value returned from iteration as index 8")

	result = _iterator->getNext(iter, @valPtr)
	_tester->expect(result, false, "Iteration failed to end when expected")

	_iterator->destruct(iter)
	iter = NULL

	done()
end sub

sub test4 cdecl (done as Tester.doneFn)
	nodePtr = _list->search (listPtr, @testData(3), @defaultCompare)

	_tester->expectPtrNot(nodePtr, NULL, "List search returned NULL node pointer")

	if nodePtr <> NULL then
		_tester->expect(*cptr(integer ptr, nodePtr->element), testData(3), "List search returned incorrect value")
	end if

	done()
end sub

sub test5 cdecl (done as Tester.doneFn)
	_list->remove (listPtr, nodePtr)
	_tester->expect(_list->getLength(listPtr), 7, "Incorrect list length after node removal")
	_tester->expect(_list->isValid(listPtr), true, "List validation")

	done()
end sub

sub test6 cdecl (done as Tester.doneFn)
	nodePtr = _list->search (listPtr, @testData(0), @defaultCompare)

	_tester->expectPtrNot(nodePtr, NULL, "List search returned NULL node pointer")

	if nodePtr <> NULL then
		_tester->expect(*cptr(integer ptr, nodePtr->element), testData(0), "List search returned incorrect value")
	end if

	done()
end sub

sub test7 cdecl (done as Tester.doneFn)
	_list->remove (listPtr, nodePtr)
	_tester->expect(_list->getLength(listPtr), 6, "Incorrect list length after node removal")
	_tester->expect(_list->isValid(listPtr), true, "List validation")

	done()
end sub

sub test8 cdecl (done as Tester.doneFn)
	nodePtr = _list->search (listPtr, @testData(7), @defaultCompare)

	_tester->expectPtrNot(nodePtr, NULL, "List search returned NULL node pointer")

	if nodePtr <> NULL then
		_tester->expect(*cptr(integer ptr, nodePtr->element), testData(7), "List search returned incorrect value")
	end if

	done()
end sub

sub test9 cdecl (done as Tester.doneFn)
	_list->remove (listPtr, nodePtr)
	_tester->expect(_list->getLength(listPtr), 5, "Incorrect list length after node removal")
	_tester->expect(_list->isValid(listPtr), true, "List validation")

	done()
end sub

sub test9_1 cdecl (done as Tester.doneFn)
	dim as Iterator.Instance ptr iter = _list->getIterator(listPtr)
	dim as integer ptr valPtr
	dim as short result

	result = _iterator->getNext(iter, @valPtr)
	_tester->expect(result, true, "Iteration ended early")
	_tester->expect(*valPtr, 2, "Incorrect value returned from iteration as index 2")

	result = _iterator->getNext(iter, @valPtr)
	_tester->expect(result, true, "Iteration ended early")
	_tester->expect(*valPtr, 3, "Incorrect value returned from iteration as index 3")

	result = _iterator->getNext(iter, @valPtr)
	_tester->expect(result, true, "Iteration ended early")
	_tester->expect(*valPtr, 5, "Incorrect value returned from iteration as index 5")

	result = _iterator->getNext(iter, @valPtr)
	_tester->expect(result, true, "Iteration ended early")
	_tester->expect(*valPtr, 6, "Incorrect value returned from iteration as index 6")

	result = _iterator->getNext(iter, @valPtr)
	_tester->expect(result, true, "Iteration ended early")
	_tester->expect(*valPtr, 7, "Incorrect value returned from iteration as index 7")

	result = _iterator->getNext(iter, @valPtr)
	_tester->expect(result, false, "Iteration failed to end when expected")

	_iterator->destruct(iter)
	iter = NULL

	done()
end sub

sub test10 cdecl (done as Tester.doneFn)
	dim as integer value = 1000

	nodePtr = _list->search (listPtr, @value, @defaultCompare)
	_tester->expectPtr(nodePtr, NULL, "List search returned result for non-existing value")

	done()
end sub

sub test11 cdecl (done as Tester.doneFn)
	nodePtr = _list->getFirst (listPtr)

	_tester->expectPtrNot(nodePtr, NULL, "List getFirst returned NULL node pointer")

	if nodePtr <> NULL then
		_tester->expect(*cptr(integer ptr, nodePtr->element), testData(1), "List getFirst returned incorrect value")
	end if

	done()
end sub

sub test12 cdecl (done as Tester.doneFn)
	_list->remove (listPtr, nodePtr)
	_tester->expect(_list->getLength(listPtr), 4, "Incorrect list length after node removal")
	_tester->expect(_list->isValid(listPtr), true, "List validation")

	done()
end sub

sub test13 cdecl (done as Tester.doneFn)
	nodePtr = _list->getLast (listPtr)

	_tester->expectPtrNot(nodePtr, NULL, "List getLast returned NULL node pointer")

	if nodePtr <> NULL then
		_tester->expect(*cptr(integer ptr, nodePtr->element), testData(6), "List getLast returned incorrect value")
	end if

	done()
end sub

sub test14 cdecl (done as Tester.doneFn)
	_list->remove (listPtr, nodePtr)
	_tester->expect(_list->getLength(listPtr), 3, "Incorrect list length after node removal")
	_tester->expect(_list->isValid(listPtr), true, "List validation")

	done()
end sub

sub test15 cdecl (done as Tester.doneFn)
	nodePtr = _list->getFirst (listPtr)

	_tester->expectPtrNot(nodePtr, NULL, "List getFirst returned NULL node pointer")

	if nodePtr <> NULL then
		_tester->expect(*cptr(integer ptr, nodePtr->element), testResult(0), "List getFirst returned incorrect value")
	end if

	done()
end sub

sub test16 cdecl (done as Tester.doneFn)
	nodePtr = _list->getNext (listPtr, nodePtr)

	_tester->expectPtrNot(nodePtr, NULL, "List getNext returned NULL node pointer")

	if nodePtr <> NULL then
		_tester->expect(*cptr(integer ptr, nodePtr->element), testResult(1), "List getNext returned incorrect value")
	end if

	done()
end sub

sub test17 cdecl (done as Tester.doneFn)
	nodePtr = _list->getNext (listPtr, nodePtr)

	_tester->expectPtrNot(nodePtr, NULL, "List getNext returned NULL node pointer")

	if nodePtr <> NULL then
		_tester->expect(*cptr(integer ptr, nodePtr->element), testResult(2), "List getNext returned incorrect value")
	end if

	done()
end sub

sub test18 cdecl (done as Tester.doneFn)
	nodePtr = _list->getNext (listPtr, nodePtr)

	_tester->expectPtr(nodePtr, NULL, "List getNext returned non-NULL pointer after end of list")

	done()
end sub

sub test19 cdecl (done as Tester.doneFn)
	dim as integer length

	_list->destruct(listPtr)
	listPtr = NULL

	done()
end sub

end namespace

