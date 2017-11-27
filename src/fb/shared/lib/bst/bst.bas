
#include once "bst.bi"

namespace Bst

declare function _searchRecurse (btreePtr as BstObj ptr, nodePtr as Bst.Node ptr, element as any ptr) as Bst.Node ptr
declare function _nextRecurse (btreePtr as BstObj ptr, nodePtr as Bst.Node ptr) as Bst.Node ptr
declare function _createNode (btreePtr as BstObj ptr, element as any ptr) as Bst.Node ptr
declare sub _deleteNode (btreePtr as BstObj ptr, nodePtr as Bst.Node ptr)
declare function _iterationHandler (iter as IteratorObj ptr, target as any ptr) as integer

function construct() as BstObj ptr
	dim as BstObj ptr btreePtr = allocate(sizeof(BstObj))

	if btreePtr <> NULL then
		btreePtr->root = NULL
		btreePtr->length = 0
		btreePtr->compare = @defaultCompare
	else
		' TODO: throw error
		print("Bst.construct: Failed to allocate BST object")
	end if

	return btreePtr
end function

sub destruct (btreePtr as BstObj ptr)
	if btreePtr <> NULL then
		if btreePtr->root <> NULL then
			btreePtr->root->parent = NULL
			_deleteNode(btreePtr, btreePtr->root)
		end if

		if btreePtr->length <> 0 then
			' TODO: throw error
			print("Bst.destruct: Failed to correctly release all resources")
		end if

		deallocate(btreePtr)
	else
		' TODO: throw error
		print("Bst.destruct: Invalid binary tree")
	end if
end sub

function insert (btreePtr as BstObj ptr, element as any ptr, start as Bst.Node ptr = NULL) as Bst.Node ptr
	dim as Bst.Node ptr nodePtr = NULL
	dim as Bst.Node ptr searchPtr = NULL

	if btreePtr = NULL then
		' TODO: throw error
		print("Bst.insert: Invalid list")
		exit function
	end if

	if element = NULL then
		' TODO: throw error
		print("Bst.insert: Invalid element")
		exit function
	end if

	if start = NULL then
		start = btreePtr->root
	end if

	nodePtr = _createNode(btreePtr, element)

	if start <> NULL then
		searchPtr = _searchRecurse(btreePtr, start, element)

		if btreePtr->compare(searchPtr->element, element) = 1 ANDALSO searchPtr->rightPtr = NULL then
			searchPtr->rightPtr = nodePtr
			nodePtr->parent = searchPtr
		elseif nodePtr->leftPtr = NULL then
			searchPtr->leftPtr = nodePtr
			nodePtr->parent = searchPtr
		else
			_deleteNode(btreePtr, element)
		end if
	else
		btreePtr->root = nodePtr
	end if

	return nodePtr
end function

function search (btreePtr as BstObj ptr, element as any ptr, start as Bst.Node ptr = NULL) as Bst.Node ptr
	dim as Bst.Node ptr searchPtr = NULL

	if btreePtr = NULL then
		' TODO: throw error
		print("Bst.insert: Invalid list")
		exit function
	end if

	if element = NULL then
		' TODO: throw error
		print("Bst.insert: Invalid element")
		exit function
	end if

	if start = NULL then
		start = btreePtr->root
	end if

	if start <> NULL then
		searchPtr = _searchRecurse(btreePtr, start, element)

		if btreePtr->compare(searchPtr->element, element) = 0 then
			return searchPtr
		end if
	end if

	return NULL
end function

function getLength (btreePtr as BstObj ptr) as integer
	return btreePtr->length
end function

function getIterator (btreePtr as BstObj ptr) as IteratorObj ptr
	dim as IteratorObj ptr iter = Iterator.construct()

	if btreePtr = NULL then
		' TODO: throw error
		print("Bst.getIterator: Invalid binary tree")
		return NULL
	end if

	iter->handler = @_iterationHandler

	Iterator.setData(iter, btreePtr)

	return iter
end function

function defaultCompare(criteria as any ptr, element as any ptr) as integer
	return sgn(*cptr(integer ptr, element) - *cptr(integer ptr, criteria))
end function

function _createNode (btreePtr as BstObj ptr, element as any ptr) as Bst.Node ptr
	dim as Bst.Node ptr nodePtr = allocate(sizeof(Bst.Node))

	nodePtr->rightPtr = NULL
	nodePtr->leftPtr = NULL
	nodePtr->parent = NULL
	nodePtr->element = element

	btreePtr->length += 1

	return nodePtr
end function

sub _deleteNode (btreePtr as BstObj ptr, nodePtr as Bst.Node ptr)
	if nodePtr->parent <> NULL then
		dim as Bst.Node ptr parent = nodePtr->parent
		dim as Bst.Node ptr rightPtr = nodePtr->rightPtr
		dim as Bst.Node ptr leftPtr = nodePtr->leftPtr
		dim as Bst.Node ptr replacement = NULL

		if rightPtr <> NULL andalso leftPtr <> NULL then
			' Deleted node: of which care has been taken
			' Parent: Can be reset with replacement
			' replacement: becomes the new node
			' Get parent of replacement
			replacement = _nextRecurse(btreePtr, nodePtr->rightPtr)
		elseif rightPtr <> NULL then
			replacement = rightPtr
		elseif leftPtr <> NULL then
			replacement = leftPtr
		end if

		if nodePtr = parent->rightPtr then
			parent->rightPtr = replacement
		elseif nodePtr = parent->leftPtr then
			parent->leftPtr = replacement
		end if
	else
		if nodePtr->rightPtr <> NULL then
			nodePtr->rightPtr->parent = NULL
			_deleteNode(btreePtr, nodePtr->rightPtr)
		end if

		if nodePtr->leftPtr <> NULL then
			nodePtr->leftPtr->parent = NULL
			_deleteNode(btreePtr, nodePtr->leftPtr)
		end if
	end if

	if btreePtr->root = nodePtr then
		btreePtr->root = NULL
	end if

	btreePtr->length -= 1

	nodePtr->rightPtr = NULL
	nodePtr->leftPtr = NULL
	nodePtr->parent = NULL
	nodePtr->element = NULL

	deallocate(nodePtr)
end sub

function _searchRecurse (btreePtr as BstObj ptr, nodePtr as Bst.Node ptr, element as any ptr) as Bst.Node ptr
	dim as integer compare = btreePtr->compare(nodePtr->element, element)

	if compare = 1 then
		if nodePtr->rightPtr <> NULL then
			return _searchRecurse(btreePtr, nodePtr->rightPtr, element)
		else
			return nodePtr
		end if
	elseif compare = -1 then
		if nodePtr->leftPtr <> NULL then
			return _searchRecurse(btreePtr, nodePtr->leftPtr, element)
		else
			return nodePtr
		end if
	else
		return nodePtr
	end if
end function

/''
 ' This routine initially expects the right pointer of the starting node and
 ' traverses left from there.  In a BST, this will always produce the next
 ' highest value, not including the parent.  This can be used to great purpose
 ' in many processes dealing with BSTs, such as removing nodes, balancing the
 ' tree, etc.
 ' @params {BstObj ptr} btreePtr
 ' @params {Bst.Node ptr} nodePtr
 ' @returns {Bst.Node ptr}
 ' @private
 '/
function _nextRecurse (btreePtr as BstObj ptr, nodePtr as Bst.Node ptr) as Bst.Node ptr
	if nodePtr->leftPtr <> NULL then
		return _nextRecurse(btreePtr, nodePtr->leftPtr)
	else
		return nodePtr
	end if
end function

function _iterationHandler (iter as IteratorObj ptr, target as any ptr) as integer
	dim as BstObj ptr btreePtr = iter->dataSet
	dim as Bst.Node ptr current

	if target = NULL then
		iter->index = 0
		iter->current = btreePtr->root
		iter->length = btreePtr->length
	else
		if iter->index < iter->length then
			current = iter->current

			*cptr(any ptr ptr, target) = current->element

			iter->current = current->leftPtr
			iter->index += 1
		else
			return false
		end if
	end if

	return true
end function

end namespace
