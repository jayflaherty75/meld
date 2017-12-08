
#include once "bst.bi"
#include once "module.bi"

namespace Bst

declare function _searchRecurse (btreePtr as BstObj ptr, nodePtr as Bst.Node ptr, element as any ptr) as Bst.Node ptr
declare function _nextRecurse (btreePtr as BstObj ptr, nodePtr as Bst.Node ptr) as Bst.Node ptr
declare function _createNode (btreePtr as BstObj ptr, element as any ptr) as Bst.Node ptr
declare sub _deleteNode (btreePtr as BstObj ptr, nodePtr as Bst.Node ptr)
declare function _iterationHandler (iter as IteratorObj ptr, target as any ptr) as integer

function construct() as BstObj ptr
	dim as BstObj ptr btreePtr = allocate(sizeof(BstObj))

	if btreePtr = NULL then
		_fault->throw(_
			errors.resourceAllocationError, _
			"BstAllocationError", "Failed to allocate BST instance", _
			__FILE__, __LINE__ _
		)
		return NULL
	end if

	btreePtr->root = NULL
	btreePtr->length = 0
	btreePtr->compare = @defaultCompare

	return btreePtr
end function

sub destruct (btreePtr as BstObj ptr)
	if btreePtr = NULL then
		_fault->throw(_
			errors.nullReferenceError, _
			"BstDestructNullReferenceError", "Attempt to reference a NULL BST", _
			__FILE__, __LINE__ _
		)
		exit sub
	end if

	if btreePtr->root <> NULL then
		btreePtr->root->parent = NULL
		_deleteNode(btreePtr, btreePtr->root)
	end if

	if btreePtr->length <> 0 then
		_fault->throw(_
			errors.releaseResourceError, _
			"releaseBstError", "Failed to correctly release all resources from BST", _
			__FILE__, __LINE__ _
		)
	end if

	deallocate(btreePtr)
end sub

function insert (btreePtr as BstObj ptr, element as any ptr, start as Bst.Node ptr = NULL) as Bst.Node ptr
	dim as Bst.Node ptr nodePtr = NULL
	dim as Bst.Node ptr searchPtr = NULL

	if btreePtr = NULL then
		_fault->throw(_
			errors.nullReferenceError, _
			"BstInsertNullReferenceError", "Attempt to reference a NULL BST", _
			__FILE__, __LINE__ _
		)
		exit function
	end if

	if element = NULL then
		_fault->throw(_
			errors.invalidArgumentError, _
			"BstInsertInvalidArgumentError", "Invalid 2nd Argument: element must not be NULL", _
			__FILE__, __LINE__ _
		)
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
		_fault->throw(_
			errors.nullReferenceError, _
			"BstSearchNullReferenceError", "Attempt to reference a NULL BST", _
			__FILE__, __LINE__ _
		)
		exit function
	end if

	if element = NULL then
		_fault->throw(_
			errors.invalidArgumentError, _
			"BstSearchInvalidArgumentError", "Invalid 2nd Argument: element must not be NULL", _
			__FILE__, __LINE__ _
		)
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
	if btreePtr = NULL then
		_fault->throw(_
			errors.nullReferenceError, _
			"BstGetLengthNullReferenceError", "Attempt to reference a NULL BST", _
			__FILE__, __LINE__ _
		)
		return NULL
	end if

	return btreePtr->length
end function

function getIterator (btreePtr as BstObj ptr) as IteratorObj ptr
	dim as IteratorObj ptr iter = _iterator->construct()

	if btreePtr = NULL then
		_fault->throw(_
			errors.nullReferenceError, _
			"BstGetIteratorNullReferenceError", "Attempt to reference a NULL BST", _
			__FILE__, __LINE__ _
		)
		return NULL
	end if

	iter->handler = @_iterationHandler

	_iterator->setData(iter, btreePtr)

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
			' Deleted node: taken care of
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
