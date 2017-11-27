
#include once "list.bi"

' TODO: Test errors are thrown; requires interfaces/modules

namespace ListTest

declare function listTestModule (describe as describeCallback) as integer
declare function create (it as itCallback) as integer
declare function test1 () as integer
declare function test2 () as integer
declare function test3 () as integer
declare function test3_1 () as integer
declare function test4 () as integer
declare function test5 () as integer
declare function test6 () as integer
declare function test7 () as integer
declare function test8 () as integer
declare function test9 () as integer
declare function test10 () as integer
declare function test11 () as integer
declare function test12 () as integer
declare function test13 () as integer
declare function test14 () as integer
declare function test15 () as integer
declare function test16 () as integer
declare function test17 () as integer
declare function test18 () as integer
declare function test19 () as integer

dim shared as integer testData(8-1) = { 1, 2, 3, 4, 5, 6, 7, 8 }
dim shared as integer testResult(5-1) = { 3, 5, 6 }
dim shared as ListObj ptr listPtr
dim shared as List.Node ptr nodePtr

function listTestModule (describe as describeCallback) as integer
	dim as integer result = TRUE

	result = result ANDALSO describe ("The List library", @create)

	return result
end function

function create (it as itCallback) as integer
	dim as integer result = TRUE

	result = result ANDALSO it ("creates a new list instance", @test1)
	result = result ANDALSO it ("inserts a set of nodes", @test2)
	result = result ANDALSO it ("returns the correct list length", @test3)
	result = result ANDALSO it ("Creates a working iterator", @test3_1)
	result = result ANDALSO it ("successfully searches a node inside the list", @test4)
	result = result ANDALSO it ("removes inside node", @test5)
	result = result ANDALSO it ("successfully searches a node at the beginning of the list", @test6)
	result = result ANDALSO it ("removes first node from search", @test7)
	result = result ANDALSO it ("successfully searches a node at the end of the list", @test8)
	result = result ANDALSO it ("removes last node from search", @test9)
	result = result ANDALSO it ("returns null on search for non-existing value", @test10)
	result = result ANDALSO it ("returns first node of list", @test11)
	result = result ANDALSO it ("removes first node of list", @test12)
	result = result ANDALSO it ("returns last node of list", @test13)
	result = result ANDALSO it ("removes last node of list", @test14)
	result = result ANDALSO it ("returns correct node for first step of iteration", @test15)
	result = result ANDALSO it ("returns correct second node of of iteration", @test16)
	result = result ANDALSO it ("returns correct third node of of iteration", @test17)
	result = result ANDALSO it ("returns null at end of iteration", @test18)
	result = result ANDALSO it ("releases remaining nodes when list deleted", @test19)

	return result
end function

function test1 () as integer
	listPtr = List.construct()

	if listPtr = NULL then
		return FALSE
	end if

	return TRUE
end function

function test2 () as integer
	dim as integer i
	dim as integer result = TRUE

	nodePtr = NULL

	for i = 0 to 7
		nodePtr = List.insert(listPtr, @testData(i), nodePtr)

		if nodePtr = NULL then
			result = FALSE
			exit for
		end if
	next

	return result
end function

function test3 () as integer
	if List.getLength(listPtr) <> 8 then
		return FALSE
	end if

	return TRUE
end function

function test3_1 () as integer
	dim as IteratorObj ptr iter = List.getIterator(listPtr)
	dim as integer ptr valPtr
	dim as string result = ""

	if iter = NULL then
		return FALSE
	end if

	while (Iterator.getNext(iter, @valPtr))
		result = result & (*valPtr)
	wend

	if result <> "12345678" then
		return FALSE
	end if

	Iterator.destruct(iter)
	iter = NULL

	return TRUE
end function

function test4 () as integer
	nodePtr = List.search (listPtr, @testData(3), @List.defaultCompare)

	if nodePtr = NULL then
		return FALSE
	end if

	return TRUE
end function

function test5 () as integer
	List.remove (listPtr, nodePtr)

	if List.getLength(listPtr) <> 7 then
		return FALSE
	end if

	return TRUE
end function

function test6 () as integer
	nodePtr = List.search (listPtr, @testData(0), @List.defaultCompare)

	if nodePtr = NULL then
		return FALSE
	end if

	return TRUE
end function

function test7 () as integer
	List.remove (listPtr, nodePtr)

	if List.getLength(listPtr) <> 6 then
		return FALSE
	end if

	return TRUE
end function

function test8 () as integer
	nodePtr = List.search (listPtr, @testData(7), @List.defaultCompare)

	if nodePtr = NULL ORELSE *cptr(integer ptr, nodePtr->element) <> testData(7) then
		return FALSE
	end if

	return TRUE
end function

function test9 () as integer
	List.remove (listPtr, nodePtr)

	if List.getLength(listPtr) <> 5 then
		return FALSE
	end if

	return TRUE
end function

function test10 () as integer
	dim as integer value = 1000

	nodePtr = List.search (listPtr, @value, @List.defaultCompare)

	if nodePtr <> NULL then
		return FALSE
	end if

	return TRUE
end function

function test11 () as integer
	nodePtr = List.getFirst (listPtr)

	if nodePtr = NULL ORELSE *cptr(integer ptr, nodePtr->element) <> testData(1) then
		return FALSE
	end if

	return TRUE
end function

function test12 () as integer
	List.remove (listPtr, nodePtr)

	if List.getLength(listPtr) <> 4 then
		return FALSE
	end if

	return TRUE
end function

function test13 () as integer
	nodePtr = List.getLast (listPtr)

	if nodePtr = NULL ORELSE *cptr(integer ptr, nodePtr->element) <> testData(6) then
		return FALSE
	end if

	return TRUE
end function

function test14 () as integer
	List.remove (listPtr, nodePtr)

	if List.getLength(listPtr) <> 3 then
		return FALSE
	end if

	return TRUE
end function

function test15 () as integer
	nodePtr = List.getFirst (listPtr)

	if nodePtr = NULL ORELSE *cptr(integer ptr, nodePtr->element) <> testResult(0) then
		return FALSE
	end if

	return TRUE
end function

function test16 () as integer
	nodePtr = List.getNext (listPtr, nodePtr)

	if nodePtr = NULL ORELSE *cptr(integer ptr, nodePtr->element) <> testResult(1) then
		return FALSE
	end if

	return TRUE
end function

function test17 () as integer
	nodePtr = List.getNext (listPtr, nodePtr)

	if nodePtr = NULL ORELSE *cptr(integer ptr, nodePtr->element) <> testResult(2) then
		return FALSE
	end if

	return TRUE
end function

function test18 () as integer
	nodePtr = List.getNext (listPtr, nodePtr)

	if nodePtr <> NULL then
		return FALSE
	end if

	return TRUE
end function

function test19 () as integer
	dim as integer length

	List.destruct(listPtr)
	listPtr = NULL

	return TRUE
end function

end namespace
