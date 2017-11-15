
type listNode
	nextPtr as listNode ptr
	prevPtr as listNode ptr
	element as any ptr
end type

type list
	first as listNode ptr
	last as listNode ptr
end type

declare function listNew() as list ptr
declare sub listDelete (listPtr as list ptr)
declare sub listInsert (listPtr as list ptr, element as any ptr, nodePtr as listNode ptr = NULL)
declare sub listRemove (listPtr as list ptr, element as any ptr)
declare function listGetFirst (listPtr as list ptr) as listNode ptr
declare function listGetLast (listPtr as list ptr) as listNode ptr
declare function listGetNext (listPtr as list ptr, node as listNode ptr) as listNode ptr

/''
 ' Creates a new list instance.
 ' @returns {list ptr}
 '/
function listNew() as list ptr
	dim as list ptr listPtr = allocate (sizeof(list))

	if listPtr <> NULL then
		listPtr->first = NULL
	else
		' TODO: throw error
	end if

	return listPtr
end function

/''
 ' Deletes a previously created list instance.
 ' @param {list ptr} listPtr
 '/
sub listDelete (listPtr as list ptr)
	if listPtr <> NULL then
		deallocate (listPtr)
	else
		' TODO: throw error
	end if
end sub

/''
 ' Inserts a node after the prevPtr node.  If prevPtr is not supplied or null,
 ' the new node is inserted as the first element.
 ' @param {list ptr} listPtr
 ' @param {any ptr} element
 ' @param {listNode ptr} prevPtr
 '/
sub listInsert (listPtr as list ptr, element as any ptr, prevPtr as listNode ptr = NULL)
	dim as listNode ptr nodePtr

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
 ' @param {list ptr} listPtr
 ' @param {listNode ptr} node
 '/
sub listRemove (listPtr as list ptr, node as listNode ptr)
	dim as listNode ptr nextPtr
	dim as listNode ptr prevPtr

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
 ' @param {list ptr} listPtr
 ' @returns {listNode ptr}
 '/
function listGetFirst (listPtr as list ptr) as listNode ptr
	if listPtr = NULL then
		' TODO: throw error
		return NULL
	end if

	return listPtr->first
end function

/''
 ' Returns the last node of a list.
 ' @param {list ptr} listPtr
 ' @returns {listNode ptr}
 '/
function listGetLast (listPtr as list ptr) as listNode ptr
	if listPtr = NULL then
		' TODO: throw error
		return NULL
	end if

	return listPtr->last
end function

/''
 ' Returns the node after the given node.
 ' @param {list ptr} listPtr
 ' @param {listNode ptr} node
 ' @returns {listNode ptr}
 '/
function listGetNext (listPtr as list ptr, node as listNode ptr) as listNode ptr
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
