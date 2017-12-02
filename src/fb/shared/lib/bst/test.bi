
#include once "bst.bi"

namespace BstTest

declare function testModule (describe as describeCallback) as integer
declare function create (it as itCallback) as integer
declare function test1 () as integer
declare function test2 () as integer
declare function test3 () as integer
declare function test4 () as integer

declare function test30 () as integer

dim shared as integer testData(8-1) = { 5, 1, 6, 7, 2, 3, 4, 8 }
dim shared as BstObj ptr btreePtr

function testModule (describe as describeCallback) as integer
	dim as integer result = true

	result = result ANDALSO describe ("The BST module", @create)

	return result
end function

function create (it as itCallback) as integer
	dim as integer result = true

	result = result ANDALSO it ("creates a BST instance", @test1)
	result = result ANDALSO it ("inserts a set of nodes", @test2)
	result = result ANDALSO it ("returns the correct list length", @test3)
	result = result ANDALSO it ("successfully searches a node inside the list", @test4)

	result = result ANDALSO it ("releases remaining nodes when tree deleted", @test30)

	return result
end function

function test1 () as integer
	btreePtr = Bst.construct()

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

	if nodePtr = NULL ORELSE *cptr(integer ptr, nodePtr->element) <> testData(3) then
		return false
	end if

	return true
end function

function test30 () as integer
	dim as integer length

	Bst.destruct (btreePtr)
	btreePtr = NULL

	return true
end function

end namespace