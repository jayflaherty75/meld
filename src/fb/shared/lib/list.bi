
#include once "../../../../modules/headers/constants/constants-v1.bi"
#include once "iterator.bi"

' TODO: Write loader function and use iterator interface instead of direct include

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
declare function listGetLength (listPtr as List ptr) as integer
declare function listSearch (listPtr as List ptr, element as any ptr, compare as function(criteria as any ptr, current as any ptr) as integer) as ListNode ptr
declare function listDefaultCompare (criteria as any ptr, current as any ptr) as integer
declare function listIterator (listPtr as List ptr) as IteratorObj ptr
declare function _listIterationHandler (iter as IteratorObj ptr, target as any ptr) as integer

/''
 ' Creates a new list instance.
 ' @returns {List ptr}
 '/
function listNew() as List ptr
	dim as List ptr listPtr = allocate(sizeof(list))

	if listPtr <> NULL then
		listPtr->first = NULL
		listPtr->last = NULL
		listPtr->length = 0
	else
		' TODO: throw error
		print ("listNew: Failed to allocate list object")
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

		if listPtr->length <> 0 then
			' TODO: throw error
			print("listDelete: Failed to correctly release all resources")
		end if

		deallocate (listPtr)
	else
		' TODO: throw error
		print("listDelete: Invalid list")
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

	if listPtr = NULL then
		' TODO: throw error
		print("listInsert: Invalid list")
		exit function
	end if

	if element = NULL then
		' TODO: throw error
		print("listInsert: Invalid element")
		exit function
	end if

	nodePtr = allocate(sizeof(listNode))

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
		print("listInsert: Failed to allocate node")
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
		print("listRemove: Invalid list")
		exit sub
	end if

	if node = NULL then
		' TODO: throw error
		print("listRemove: Invalid node")
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
	deallocate(node)
end sub

/''
 ' Returns the first node of a list.
 ' @param {List ptr} listPtr
 ' @returns {ListNode ptr}
 '/
function listGetFirst (listPtr as List ptr) as ListNode ptr
	if listPtr = NULL then
		' TODO: throw error
		print("listGetFirst: Invalid list")
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
		print("listGetLast: Invalid list")
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
		print("listGetNext: Invalid list")
		return NULL
	end if

	if node <> NULL then
		return node->nextPtr
	else
		return NULL
	end if
end function

function listGetLength (listPtr as List ptr) as integer
	if listPtr = NULL then
		' TODO: throw error
		print("listGetNext: Invalid list")
		return NULL
	end if

	return listPtr->length
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
		print("listSearch: Invalid list")
		return NULL
	end if

	nodePtr = listGetFirst(listPtr)

	while (nodePtr <> NULL ANDALSO result = NULL)
		if compare(element, nodePtr->element) = true then
			result = nodePtr
		else
			nodePtr = listGetNext(listPtr, nodePtr)
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
		return true
	else
		return false
	end if
end function

/''
 ' Provides an Iterator instance that will return the element pointers of each
 ' node in the given list.
 ' @param {List ptr} listPtr
 ' @returns {IteratorObj ptr}
 '/
function listIterator (listPtr as List ptr) as IteratorObj ptr
	dim as IteratorObj ptr iter = Iterator.construct()

	if listPtr = NULL then
		' TODO: throw error
		print("listSearch: Invalid list")
		return NULL
	end if

	iter->handler = @_listIterationHandler

	Iterator.setDataSet(iter, listPtr)

	return iter
end function

/''
 ' Iteration handler for lists.
 ' @params {IteratorObj ptr} iter
 ' @params {any ptr} target
 ' @returns {integer}
 ' @private
 '/
function _listIterationHandler (iter as IteratorObj ptr, target as any ptr) as integer
	dim as List ptr listPtr = iter->dataSet
	dim as ListNode ptr current

	if target = NULL then
		iter->index = 0
		iter->length = listPtr->length
		iter->current = listPtr->first
	else
		if iter->index < iter->length then
			current = iter->current

			*cptr(any ptr ptr, target) = current->element

			iter->current = current->nextPtr
			iter->index += 1
		else
			return false
		end if
	end if

	return true
end function
