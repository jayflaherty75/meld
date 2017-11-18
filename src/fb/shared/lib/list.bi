
#include once "../../../../modules/headers/constants/v1.bi"

type ListNode
	nextPtr as ListNode ptr
	prevPtr as ListNode ptr
	element as any ptr
end type

type List
	first as ListNode ptr
	last as ListNode ptr
	length as integer
end type

declare function listNew() as List ptr
declare sub listDelete (listPtr as List ptr)
declare function listInsert (listPtr as List ptr, element as any ptr, nodePtr as ListNode ptr = NULL) as ListNode ptr
declare sub listRemove (listPtr as List ptr, node as ListNode ptr)
declare function listGetFirst (listPtr as List ptr) as ListNode ptr
declare function listGetLast (listPtr as List ptr) as ListNode ptr
declare function listGetNext (listPtr as List ptr, node as ListNode ptr) as ListNode ptr
declare function listSearch (listPtr as List ptr, element as any ptr, compare as function(criteria as any ptr, current as any ptr) as integer) as ListNode ptr
declare function listDefaultCompare (criteria as any ptr, current as any ptr) as integer

/''
 ' Creates a new list instance.
 ' @returns {List ptr}
 '/
function listNew() as List ptr
	dim as List ptr listPtr = allocate (sizeof(list))

	if listPtr <> NULL then
		listPtr->first = NULL
		listPtr->last = NULL
		listPtr->length = 0
	else
		' TODO: throw error
	end if

	return listPtr
end function

/''
 ' Deletes a previously created list instance.
 ' @param {List ptr} listPtr
 '/
sub listDelete (listPtr as List ptr)
	dim as listNode ptr nodePtr
	dim as listNode ptr nextPtr

	if listPtr <> NULL then
		nodePtr = listGetFirst(listPtr)

		while (nodePtr <> NULL)
			nextPtr = listGetNext(listPtr, nodePtr)
			listRemove (listPtr, nodePtr)
			nodePtr = nextPtr
		wend

		deallocate (listPtr)
	else
		' TODO: throw error
	end if
end sub

/''
 ' Inserts a node after the prevPtr node.  If prevPtr is not supplied or null,
 ' the new node is inserted as the first element.
 ' @param {List ptr} listPtr
 ' @param {any ptr} element
 ' @param {ListNode ptr} prevPtr
 '/
function listInsert (listPtr as List ptr, element as any ptr, prevPtr as ListNode ptr = NULL) as ListNode ptr
	dim as ListNode ptr nodePtr = NULL

	if element = NULL then
		' TODO: throw error
		exit function
	end if

	if listPtr = NULL then
		' TODO: throw error
		exit function
	end if

	nodePtr = allocate (sizeof(listNode))

	if nodePtr <> NULL then
		nodePtr->element = element

		if prevPtr = NULL then
			nodePtr->prevPtr = NULL
			nodePtr->nextPtr = listPtr->first
			listPtr->first = nodePtr
		else
			if prevPtr->nextPtr = NULL then
				listPtr->last = nodePtr
			else
				prevPtr->nextPtr->prevPtr = nodePtr
			end if

			nodePtr->prevPtr = prevPtr
			nodePtr->nextPtr = prevPtr->nextPtr
			prevPtr->nextPtr = nodePtr
		end if

		listPtr->length += 1
	else
		' TODO: throw error
	end if

	return nodePtr
end function

/''
 ' Removes a node from the list.
 ' @param {List ptr} listPtr
 ' @param {ListNode ptr} node
 '/
sub listRemove (listPtr as List ptr, node as ListNode ptr)
	dim as ListNode ptr nextPtr
	dim as ListNode ptr prevPtr

	if listPtr = NULL then
		' TODO: throw error
		exit sub
	end if

	if node = NULL then
		' TODO: throw error
		exit sub
	end if

	nextPtr = node->nextPtr
	prevPtr = node->prevPtr

	if nextPtr <> NULL then
		nextPtr->prevPtr = prevPtr
	else
		listPtr->last = prevPtr
	end if

	if prevPtr <> NULL then
		prevPtr->nextPtr = nextPtr
	else
		listPtr->first = nextPtr
	end if

	listPtr->length -= 1
	deallocate (node)
end sub

/''
 ' Returns the first node of a list.
 ' @param {List ptr} listPtr
 ' @returns {ListNode ptr}
 '/
function listGetFirst (listPtr as List ptr) as ListNode ptr
	if listPtr = NULL then
		' TODO: throw error
		return NULL
	end if

	return listPtr->first
end function

/''
 ' Returns the last node of a list.
 ' @param {List ptr} listPtr
 ' @returns {ListNode ptr}
 '/
function listGetLast (listPtr as List ptr) as ListNode ptr
	if listPtr = NULL then
		' TODO: throw error
		return NULL
	end if

	return listPtr->last
end function

/''
 ' Returns the node after the given node.
 ' @param {List ptr} listPtr
 ' @param {ListNode ptr} node
 ' @returns {ListNode ptr}
 '/
function listGetNext (listPtr as List ptr, node as ListNode ptr) as ListNode ptr
	if listPtr = NULL then
		' TODO: throw error
		return NULL
	end if

	if node <> NULL then
		return node->nextPtr
	else
		return NULL
	end if
end function

/''
 ' Search for an element in the list using the given compare function.  If
 ' searching for integer values, just pass listDefaultCompare.
 ' @param {List ptr} listPtr
 ' @param {any ptr} element
 ' @param {function} compare
 ' @returns {ListNode ptr}
 '/
function listSearch (listPtr as List ptr, element as any ptr, compare as function(criteria as any ptr, current as any ptr) as integer) as ListNode ptr
	dim as ListNode ptr nodePtr = NULL
	dim as ListNode ptr result = NULL

	if listPtr = NULL then
		' TODO: throw error
		return NULL
	end if

	nodePtr = listGetFirst(listPtr)

	while (nodePtr <> NULL ANDALSO result = NULL)
		if compare (element, nodePtr->element) = FALSE then
			nodePtr = listGetNext(listPtr, nodePtr)
		else
			result = nodePtr
		end if
	wend

	return result
end function

/''
 ' Integer search function used as default since system will be using indexed
 ' identifiers for deterministic references.
 ' @param {any ptr} criteria
 ' @param {any ptr} current
 ' @returns {integer}
 '/
function listDefaultCompare (criteria as any ptr, current as any ptr) as integer
	if *cptr(integer ptr, criteria) = *cptr(integer ptr, current) then
		return TRUE
	else
		return FALSE
	end if
end function
