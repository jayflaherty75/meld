
#include once "../../../../../modules/headers/tester/tester-v1.bi"
#include once "bst.bi"

namespace BstTest

declare function testModule (corePtr as Core.Interface ptr, describe as Tester.describeCallback) as integer
declare function create (it as Tester.itCallback) as integer
declare function test1 () as integer
declare function test2 () as integer
declare function test3 () as integer
declare function test4 () as integer
declare function test5 () as integer

declare function test30 () as integer

dim shared _core as Core.Interface ptr
dim shared _iterator as Iterator.Interface ptr

dim shared as integer testData(8-1) = { 5, 1, 8, 7, 4, 3, 2, 6 }
dim shared as BstObj ptr btreePtr

function testModule (corePtr as Core.Interface ptr, describe as Tester.describeCallback) as integer
	dim as integer result = true

	_core = corePtr
	_iterator = _core->require("iterator")

	result = result ANDALSO describe ("The BST module", @create)

	return result
end function

function create (it as Tester.itCallback) as integer
	dim as integer result = true

	result = result ANDALSO it ("creates a BST instance", @test1)
	result = result ANDALSO it ("inserts a set of nodes", @test2)
	result = result ANDALSO it ("returns the correct list length", @test3)
	result = result ANDALSO it ("successfully searches a node inside the list", @test4)
	result = result ANDALSO it ("creates a working iterator", @test5)

	result = result ANDALSO it ("releases remaining nodes when tree deleted", @test30)

	return result
end function

function test1 () as integer
	btreePtr = Bst.construct("TestBst")

	if btreePtr = NULL then
		return false
	end if

	return true
end function

function test2 () as integer
	dim as integer i
	dim as integer result = true
	dim as Bst.Node ptr nodePtr = NULL

	for i = 0 to 7
		nodePtr = Bst.insert(btreePtr, @testData(i))

		if nodePtr = NULL then
			result = false
			exit for
		end if
	next

	return result
end function

function test3 () as integer
	if Bst.getLength(btreePtr) <> 8 then
		return false
	end if

	return true
end function

function test4() as integer
	dim as Bst.Node ptr nodePtr = Bst.search (btreePtr, @testData(3))

	if nodePtr = NULL orelse *cptr(integer ptr, nodePtr->element) <> testData(3) then
		return false
	end if

	return true
end function

function test5 () as integer
	dim as IteratorObj ptr iter = Bst.getIterator(btreePtr)
	dim as integer ptr valPtr
	dim as string result = ""

	if iter = NULL then
		return false
	end if

	while (_iterator->getNext(iter, @valPtr))
		result = result & (*valPtr)
	wend

	if result <> "12345678" then
		return false
	end if

	_iterator->destruct(iter)
	iter = NULL

	return true
end function

function test30 () as integer
	dim as integer length

	Bst.destruct (btreePtr)
	btreePtr = NULL

	return true
end function

end namespace
