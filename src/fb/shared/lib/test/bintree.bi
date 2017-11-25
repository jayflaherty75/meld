
#include once "../bintree.bi"

namespace binTreeTest

declare function binTreeTestModule (describe as describeCallback) as integer
declare function create (it as itCallback) as integer
declare function test1 () as integer
declare function test2 () as integer
declare function test3 () as integer
declare function test4 () as integer

declare function test30 () as integer

dim shared as integer testData(8-1) = { 5, 1, 6, 7, 2, 3, 4, 8 }
dim shared as BinTree ptr btreePtr

function binTreeTestModule (describe as describeCallback) as integer
	dim as integer result = true

	result = result ANDALSO describe ("The BinTree module", @create)

	return result
end function

function create (it as itCallback) as integer
	dim as integer result = true

	result = result ANDALSO it ("creates a BinTree instance", @test1)
	result = result ANDALSO it ("inserts a set of nodes", @test2)
	result = result ANDALSO it ("returns the correct list length", @test3)
	result = result ANDALSO it ("successfully searches a node inside the list", @test4)

	result = result ANDALSO it ("releases remaining nodes when tree deleted", @test30)

	return result
end function

function test1 () as integer
	btreePtr = bintreeNew()

	if btreePtr = NULL then
		return false
	end if

	return true
end function

function test2 () as integer
	dim as integer i
	dim as integer result = true
	dim as BinTreeNode ptr nodePtr = NULL

	for i = 0 to 7
		nodePtr = bintreeInsert(btreePtr, @testData(i))

		if nodePtr = NULL then
			result = false
			exit for
		end if
	next

	return result
end function

function test3 () as integer
	if bintreeGetLength(btreePtr) <> 8 then
		return false
	end if

	return true
end function

function test4() as integer
	dim as BinTreeNode ptr nodePtr = bintreeSearch (btreePtr, @testData(3))

	if nodePtr = NULL ORELSE *cptr(integer ptr, nodePtr->element) <> testData(3) then
		return false
	end if

	return true
end function

function test30 () as integer
	dim as integer length

	bintreeDelete (btreePtr)
	btreePtr = NULL

	return true
end function

end namespace
