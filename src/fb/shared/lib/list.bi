
type ListNode
	nextPtr as ListNode ptr
	prevPtr as ListNode ptr
	element as any ptr
end type

type List
	first as ListNode ptr
	last as ListNode ptr
end type

declare function listNew() as List ptr
declare sub listDelete (listPtr as List ptr)
declare sub listInsert (listPtr as List ptr, element as any ptr, nodePtr as ListNode ptr = NULL)
declare sub listRemove (listPtr as List ptr, element as any ptr)
declare function listGetFirst (listPtr as List ptr) as ListNode ptr
declare function listGetLast (listPtr as List ptr) as ListNode ptr
declare function listGetNext (listPtr as List ptr, node as ListNode ptr) as ListNode ptr

/''
 ' Creates a new list instance.
 ' @returns {List ptr}
 '/
function listNew() as List ptr
	dim as List ptr listPtr = allocate (sizeof(list))

	if listPtr <> NULL then
		listPtr->first = NULL
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
	if listPtr <> NULL then
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
sub listInsert (listPtr as List ptr, element as any ptr, prevPtr as ListNode ptr = NULL)
	dim as ListNode ptr nodePtr

	if element = NULL then
		' TODO: throw error
		return
	end if

	if listPtr = NULL then
		' TODO: throw error
		return
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
	else
		' TODO: throw error
	end if
end sub

/''
 ' Removes a node from the list.
 ' @param {List ptr} listPtr
 ' @param {ListNode ptr} node
 '/
sub listRemove (listPtr as List ptr, node as ListNode ptr)
	dim as ListNode ptr nextPtr
	dim as ListNode ptr prevPtr

	if element = NULL then
		' TODO: throw error
		return
	end if

	if listPtr = NULL then
		' TODO: throw error
		return
	end if

	nextPtr = element->nextPtr
	prevPtr = element->prevPtr

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
