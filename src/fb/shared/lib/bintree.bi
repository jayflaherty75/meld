
#include once "../../../../modules/headers/constants/constants-v1.bi"

type BinTreeNode
	rightPtr as BinTreeNode ptr
	leftPtr as BinTreeNode ptr
	element as any ptr
	balance as byte
end type

type BinTree
	root as BinTreeNode ptr
	length as integer
	compare as function(criteria as any ptr, element as any ptr) as integer
end type

declare function bintreeNew() as BinTree ptr
declare sub bintreeDelete (btreePtr as BinTree ptr)
declare function bintreeInsert (btreePtr as BinTree ptr, element as any ptr) as BinTreeNode ptr
declare function bintreeDefaultCompare(criteria as any ptr, element as any ptr) as integer
declare function _bintreeInsertRecurse (btreePtr as BinTree ptr, nodePtr as BinTreeNode ptr, parent as BinTreeNode ptr, element as any ptr) as BinTreeNode ptr
declare function _bintreeFullCompare (btreePtr as BinTree ptr, nodePtr as BinTreeNode ptr, element as any ptr) as integer
declare function _bintreeCreateNode (btreePtr as BinTree ptr, element as any ptr) as BinTreeNode ptr

function bintreeNew() as BinTree ptr
	dim as BinTree ptr btreePtr = allocate (sizeof(list))

	if btreePtr <> NULL then
		btreePtr->root = NULL
		btreePtr->length = 0
		btreePtr->compare = @bintreeDefaultCompare
	else
		' TODO: throw error
		print ("bintreeNew: Failed to allocate BinTree object")
	end if

	return btreePtr
end function

sub bintreeDelete (btreePtr as BinTree ptr)
	dim as BinTreeNode ptr nodePtr
	dim as BinTreeNode ptr nextPtr

	if btreePtr <> NULL then
		'nodePtr = listGetFirst(listPtr)

		'while (nodePtr <> NULL)
		'	nextPtr = listGetNext(listPtr, nodePtr)
		'	listRemove (listPtr, nodePtr)
		'	nodePtr = nextPtr
		'wend

		deallocate (btreePtr)
	else
		' TODO: throw error
		print ("bintreeDelete: Invalid binary tree")
	end if
end sub

function bintreeInsert (btreePtr as BinTree ptr, element as any ptr) as BinTreeNode ptr
	dim as BinTreeNode ptr nodePtr = NULL

	if btreePtr = NULL then
		' TODO: throw error
		print ("bintreeInsert: Invalid list")
		exit function
	end if

	if element = NULL then
		' TODO: throw error
		print ("bintreeInsert: Invalid element")
		exit function
	end if

	if btreePtr->root = NULL then
		btreePtr->root = _bintreeCreateNode (btreePtr, element)

		return btreePtr->root
	else
		return _bintreeInsertRecurse (btreePtr, btreePtr->root, NULL, element)
	end if
end function

function bintreeDefaultCompare(criteria as any ptr, element as any ptr) as integer
	return sgn(*cptr(integer ptr, element) - *cptr(integer ptr, criteria))
end function

function _bintreeInsertRecurse (btreePtr as BinTree ptr, nodePtr as BinTreeNode ptr, parent as BinTreeNode ptr, element as any ptr) as BinTreeNode ptr
	dim as BinTreeNode ptr result = NULL

	if _bintreeFullCompare(btreePtr, nodePtr, element) = 1 then
		if nodePtr->rightPtr <> NULL then
			result = _bintreeInsertRecurse (btreePtr, nodePtr->rightPtr, parent, element)

			if result <> NULL then
				nodePtr->balance += 1
			end if
		else
			result = _bintreeCreateNode (btreePtr, element)

			if result <> NULL then
				nodePtr->rightPtr = result
				nodePtr->balance += 1
			end if
		end if

		if nodePtr->balance > 2 then
			' TODO: Rotate node left
		end if
	else
		if nodePtr->leftPtr <> NULL then
			result = _bintreeInsertRecurse (btreePtr, nodePtr->leftPtr, nodePtr, element)

			if result <> NULL then
				nodePtr->balance -= 1
			end if
		else
			result = _bintreeCreateNode (btreePtr, element)

			if result <> NULL then
				nodePtr->leftPtr = result
				nodePtr->balance -= 1
			end if
		end if

		if nodePtr->balance < 2 then
			' TODO: Rotate node right
		end if
	end if

	return result
end function

function _bintreeFullCompare (btreePtr as BinTree ptr, nodePtr as BinTreeNode ptr, element as any ptr) as integer
	dim as integer compare = btreePtr->compare(nodePtr->element, element)

	if compare = 0 then
		if nodePtr->balance < 0 then
			return 1
		else
			return -1
		end if
	end if
end function

function _bintreeCreateNode (btreePtr as BinTree ptr, element as any ptr) as BinTreeNode ptr
	dim as BinTreeNode ptr nodePtr = allocate(sizeof(BinTreeNode))

	if nodePtr = NULL then
		' TODO: throw error
		print ("bintreeInsert: Failed to create new node")
		return NULL
	end if

	nodePtr->rightPtr = NULL
	nodePtr->leftPtr = NULL
	nodePtr->element = element
	nodePtr->balance = 0

	btreePtr->length += 1

	return nodePtr
end function

'sub _bintreeRotateLeft (parent as BinTreeNode ptr, nodePtr as BinTreeNode ptr)
'	dim as BinTreeNode rightPtr = nodePtr->rightPtr
'end sub

'sub _bintreeRotateRight (parent as BinTreeNode ptr, nodePtr as BinTreeNode ptr)
'	dim as BinTreeNode leftPtr = nodePtr->leftPtr
'end sub
