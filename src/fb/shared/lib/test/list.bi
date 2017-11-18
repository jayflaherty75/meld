
#include once "../list.bi"

' TODO: Test errors are thrown; requires interfaces/modules

declare function listTestModule (describe as describeCallback) as integer
declare function listTestCreate (it as itCallback) as integer
declare function listTestCreate1 () as integer
declare function listTestCreate2 () as integer
declare function listTestCreate3 () as integer
declare function listTestCreate4 () as integer
declare function listTestCreate5 () as integer
declare function listTestCreate6 () as integer
declare function listTestCreate7 () as integer
declare function listTestCreate8 () as integer
declare function listTestCreate9 () as integer
declare function listTestCreate10 () as integer
declare function listTestCreate11 () as integer
declare function listTestCreate12 () as integer
declare function listTestCreate13 () as integer
declare function listTestCreate14 () as integer
declare function listTestCreate15 () as integer
declare function listTestCreate16 () as integer
declare function listTestCreate17 () as integer
declare function listTestCreate18 () as integer
declare function listTestCreate19 () as integer

dim shared as integer testData(8-1) = { 1, 2, 3, 4, 5, 6, 7, 8 }
dim shared as integer testResult(5-1) = { 3, 5, 6 }
dim shared as List ptr listPtr
dim shared as ListNode ptr nodePtr

function listTestModule (describe as describeCallback) as integer
	dim as integer result = TRUE

	result = result ANDALSO describe ("The List library", @listTestCreate)

	return result
end function

function listTestCreate (it as itCallback) as integer
	dim as integer result = TRUE

	result = result ANDALSO it ("creates a new list instance", @listTestCreate1)
	result = result ANDALSO it ("inserts a set of nodes", @listTestCreate2)
	result = result ANDALSO it ("returns the correct list length", @listTestCreate3)
	result = result ANDALSO it ("successfully searches a node inside the list", @listTestCreate4)
	result = result ANDALSO it ("removes inside node", @listTestCreate5)
	result = result ANDALSO it ("successfully searches a node at the beginning of the list", @listTestCreate6)
	result = result ANDALSO it ("removes first node from search", @listTestCreate7)
	result = result ANDALSO it ("successfully searches a node at the end of the list", @listTestCreate8)
	result = result ANDALSO it ("removes last node from search", @listTestCreate9)
	result = result ANDALSO it ("returns null on search for non-existing value", @listTestCreate10)
	result = result ANDALSO it ("returns first node of list", @listTestCreate11)
	result = result ANDALSO it ("removes first node of list", @listTestCreate12)
	result = result ANDALSO it ("returns last node of list", @listTestCreate13)
	result = result ANDALSO it ("removes last node of list", @listTestCreate14)
	result = result ANDALSO it ("returns correct node for first step of iteration", @listTestCreate15)
	result = result ANDALSO it ("returns correct second node of of iteration", @listTestCreate16)
	result = result ANDALSO it ("returns correct third node of of iteration", @listTestCreate17)
	result = result ANDALSO it ("returns null at end of iteration", @listTestCreate18)
	result = result ANDALSO it ("releases remaining nodes when list deleted", @listTestCreate19)

	return result
end function

function listTestCreate1 () as integer
	listPtr = listNew()

	if listPtr = NULL then
		return FALSE
	end if

	return TRUE
end function

function listTestCreate2 () as integer
	dim as integer i
	dim as integer result = TRUE

	nodePtr = NULL

	for i = 0 to 7
		nodePtr = listInsert(listPtr, @testData(i), nodePtr)

		if nodePtr = NULL then
			result = FALSE
			exit for
		end if
	next

	return result
end function

function listTestCreate3 () as integer
	if listPtr->length <> 8 then
		return FALSE
	end if

	return TRUE
end function

function listTestCreate4 () as integer
	nodePtr = listSearch (listPtr, @testData(3), @listDefaultCompare)

	if nodePtr = NULL then
		return FALSE
	end if

	return TRUE
end function

function listTestCreate5 () as integer
	listRemove (listPtr, nodePtr)

	if listPtr->length <> 7 then
		return FALSE
	end if

	return TRUE
end function

function listTestCreate6 () as integer
	nodePtr = listSearch (listPtr, @testData(0), @listDefaultCompare)

	if nodePtr = NULL then
		return FALSE
	end if

	return TRUE
end function

function listTestCreate7 () as integer
	listRemove (listPtr, nodePtr)

	if listPtr->length <> 6 then
		return FALSE
	end if

	return TRUE
end function

function listTestCreate8 () as integer
	nodePtr = listSearch (listPtr, @testData(7), @listDefaultCompare)

	if nodePtr = NULL ORELSE *cptr(integer ptr, nodePtr->element) <> testData(7) then
		return FALSE
	end if

	return TRUE
end function

function listTestCreate9 () as integer
	listRemove (listPtr, nodePtr)

	if listPtr->length <> 5 then
		return FALSE
	end if

	return TRUE
end function

function listTestCreate10 () as integer
	dim as integer value = 1000

	nodePtr = listSearch (listPtr, @value, @listDefaultCompare)

	if nodePtr <> NULL then
		return FALSE
	end if

	return TRUE
end function

function listTestCreate11 () as integer
	nodePtr = listGetFirst (listPtr)

	if nodePtr = NULL ORELSE *cptr(integer ptr, nodePtr->element) <> testData(1) then
		return FALSE
	end if

	return TRUE
end function

function listTestCreate12 () as integer
	listRemove (listPtr, nodePtr)

	if listPtr->length <> 4 then
		return FALSE
	end if

	return TRUE
end function

function listTestCreate13 () as integer
	nodePtr = listGetLast (listPtr)

	if nodePtr = NULL ORELSE *cptr(integer ptr, nodePtr->element) <> testData(6) then
		return FALSE
	end if

	return TRUE
end function

function listTestCreate14 () as integer
	listRemove (listPtr, nodePtr)

	if listPtr->length <> 3 then
		return FALSE
	end if

	return TRUE
end function

function listTestCreate15 () as integer
	nodePtr = listGetFirst (listPtr)

	if nodePtr = NULL ORELSE *cptr(integer ptr, nodePtr->element) <> testResult(0) then
		return FALSE
	end if

	return TRUE
end function

function listTestCreate16 () as integer
	nodePtr = listGetNext (listPtr, nodePtr)

	if nodePtr = NULL ORELSE *cptr(integer ptr, nodePtr->element) <> testResult(1) then
		return FALSE
	end if

	return TRUE
end function

function listTestCreate17 () as integer
	nodePtr = listGetNext (listPtr, nodePtr)

	if nodePtr = NULL ORELSE *cptr(integer ptr, nodePtr->element) <> testResult(2) then
		return FALSE
	end if

	return TRUE
end function

function listTestCreate18 () as integer
	nodePtr = listGetNext (listPtr, nodePtr)

	if nodePtr <> NULL then
		return FALSE
	end if

	return TRUE
end function

function listTestCreate19 () as integer
	dim as integer length

	listDelete (listPtr)
	length = listPtr->length
	listPtr = NULL

	if length <> 0 then
		return FALSE
	end if

	return TRUE
end function
