
#include once "bst.bi"
#include once "module.bi"

namespace Bst

declare function _createNode (btreePtr as BstObj ptr, element as any ptr) as Bst.Node ptr
declare sub _deleteNode (btreePtr as BstObj ptr, nodePtr as Bst.Node ptr)
declare sub _deleteNodeRecurse (btreePtr as BstObj ptr, nodePtr as Bst.Node ptr)
declare function _searchRecurse (btreePtr as BstObj ptr, nodePtr as Bst.Node ptr, element as any ptr) as Bst.Node ptr
declare function _recurseLeft (nodePtr as Bst.Node ptr) as Bst.Node ptr
declare function _nextParentRecurse (btreePtr as BstObj ptr, current as Bst.Node ptr, element as any ptr) as Bst.Node ptr
declare function _iterationHandler (iter as IteratorObj ptr, target as any ptr) as integer

/''
 ' Creates a new binary search tree.
 ' @param {ztring} id - Used to tag BST for errors and messages
 ' @returns {BstObj ptr}
 '/
function construct(byref id as zstring) as BstObj ptr
	dim as BstObj ptr btreePtr = allocate(sizeof(BstObj))

	if btreePtr = NULL then
		_fault->throw(_
			errors.resourceAllocationError, _
			"BstAllocationError", "Failed to allocate BST instance: " & id, _
			__FILE__, __LINE__ _
		)
		return NULL
	end if

	btreePtr->id = left(id, 64)
	btreePtr->root = NULL
	btreePtr->length = 0
	btreePtr->compare = @defaultCompare

	return btreePtr
end function

/''
 ' Destroys a binary search tree and any nodes within it.  It does not affect
 ' any data the nodes point to.
 ' @param {BstObj ptr} btreePtr
 '/
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
		_deleteNodeRecurse(btreePtr, btreePtr->root)
		btreePtr->root = NULL
	end if

	if btreePtr->length <> 0 then
		_fault->throw(_
			errors.releaseResourceError, _
			"releaseBstError", "Failed to correctly release all resources from BST: " & btreePtr->id, _
			__FILE__, __LINE__ _
		)
	end if

	deallocate(btreePtr)
end sub

/''
 ' Creates a node for the given element and places it within the tree.
 ' @param {BstObj ptr} btreePtr
 ' @param {any ptr} element
 ' @returns {Bst.Node ptr}
 '/
function insert (btreePtr as BstObj ptr, element as any ptr) as Bst.Node ptr
	dim as Bst.Node ptr nodePtr = NULL
	dim as Bst.Node ptr searchPtr = NULL
	dim as integer compareValue

	if btreePtr = NULL then
		_fault->throw(_
			errors.nullReferenceError, _
			"BstInsertNullReferenceError", "Attempt to reference a NULL BST", _
			__FILE__, __LINE__ _
		)
		return NULL
	end if

	if element = NULL then
		_fault->throw(_
			errors.invalidArgumentError, _
			"BstInsertInvalidArgumentError", "Invalid 2nd Argument: element must not be NULL: " & btreePtr->id, _
			__FILE__, __LINE__ _
		)
		return NULL
	end if

	nodePtr = _createNode(btreePtr, element)

	if nodePtr = NULL then
		_fault->throw(_
			errors.resourceAllocationError, _
			"BstNodeAllocationError", "Failed to allocate BST node: " & btreePtr->id, _
			__FILE__, __LINE__ _
		)
		return NULL
	end if

	if btreePtr->root <> NULL then
		searchPtr = _searchRecurse(btreePtr, btreePtr->root, element)
		compareValue = btreePtr->compare(searchPtr->element, element)

		if compareValue = 0 then
			' Values must be unique
			_deleteNode(btreePtr, nodePtr)
			nodePtr = NULL
		elseif compareValue = 1 ANDALSO searchPtr->rightPtr = NULL then
			searchPtr->rightPtr = nodePtr
			nodePtr->parent = searchPtr
		elseif compareValue = -1 ANDALSO nodePtr->leftPtr = NULL then
			searchPtr->leftPtr = nodePtr
			nodePtr->parent = searchPtr
		end if
	else
		' Empty tree, simply set new node as root
		btreePtr->root = nodePtr
	end if

	return nodePtr
end function

/''
 ' Removes a node from the tree.
 ' @param {BstObj ptr} btreePtr
 ' @param {Bst.Node ptr} nodePtr
 '/
sub remove (btreePtr as Bst.Instance ptr, nodePtr as Bst.Node ptr)
	if btreePtr = NULL then
		_fault->throw(_
			errors.nullReferenceError, _
			"BstRemoveNullReferenceError", "Attempt to reference a NULL BST", _
			__FILE__, __LINE__ _
		)
		exit sub
	end if

	if nodePtr = NULL then
		_fault->throw(_
			errors.invalidArgumentError, _
			"BstRemoveInvalidArgumentError", "Invalid 2nd Argument: node must not be NULL: " & btreePtr->id, _
			__FILE__, __LINE__ _
		)
		exit sub
	end if

	dim as Bst.Node ptr rightPtr = nodePtr->rightPtr
	dim as Bst.Node ptr leftPtr = nodePtr->leftPtr
	dim as Bst.Node ptr replacement = NULL

	if rightPtr <> NULL andalso leftPtr <> NULL then
		replacement = _recurseLeft(rightPtr)
	elseif rightPtr <> NULL then
		replacement = rightPtr
	elseif leftPtr <> NULL then
		replacement = leftPtr
	end if

	if replacement <> NULL then
		nodePtr->element = replacement->element
		remove(btreePtr, replacement)
	else
		dim as Bst.Node ptr parent = nodePtr->parent

		if btreePtr->root = nodePtr then
			btreePtr->root = NULL
		elseif nodePtr = parent->rightPtr then
			parent->rightPtr = NULL
		elseif nodePtr = parent->leftPtr then
			parent->leftPtr = NULL
		end if

		_deleteNode(btreePtr, nodePtr)
	end if
end sub

/''
 ' Purges tree of all elements.
 ' @param {BstObj ptr} btreePtr
'/
sub purge (btreePtr as Bst.Instance ptr)
	if btreePtr = NULL then
		_fault->throw(_
			errors.nullReferenceError, _
			"BstPurgeNullReferenceError", "Attempt to reference a NULL BST", _
			__FILE__, __LINE__ _
		)
		exit sub
	end if

	if btreePtr->root <> NULL then
		_deleteNodeRecurse(btreePtr, btreePtr->root)
		btreePtr->root = NULL
	end if

	if btreePtr->length <> 0 then
		_fault->throw(_
			errors.releaseResourceError, _
			"BstPurgeError", "Failed to correctly purge all nodes from BST: " & btreePtr->id, _
			__FILE__, __LINE__ _
		)
	end if
end sub

/''
 ' Returns the node referencing the given element.  The element values must be
 ' equal, not the element pointers.  Results are based on the BSTs compare
 ' function.
 ' @param {BstObj ptr} btreePtr
 ' @param {any ptr} element
 ' @param {Bst.Node ptr} start - Defaults to root node
 ' @returns {Bst.Node ptr}
 '/
function search (btreePtr as BstObj ptr, element as any ptr, start as Bst.Node ptr = NULL) as Bst.Node ptr
	dim as Bst.Node ptr searchPtr = NULL

	if btreePtr = NULL then
		_fault->throw(_
			errors.nullReferenceError, _
			"BstSearchNullReferenceError", "Attempt to reference a NULL BST", _
			__FILE__, __LINE__ _
		)
		return NULL
	end if

	if element = NULL then
		_fault->throw(_
			errors.invalidArgumentError, _
			"BstSearchInvalidArgumentError", "Invalid 2nd Argument: element must not be NULL: " & btreePtr->id, _
			__FILE__, __LINE__ _
		)
		return NULL
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

/''
 ' Returns the number of nodes in the tree.
 ' @param {BstObj ptr} btreePtr
 ' @returns {integer}
 '/
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

/''
 ' Creates a new Iterator for the tree.  Use the Iterator->destruct function
 ' to destroy the iterator.
 ' @param {BstObj ptr} btreePtr
 ' @returns {IteratorObj ptr}
 '/
function getIterator (btreePtr as BstObj ptr) as IteratorObj ptr
	dim as IteratorObj ptr iter

	if btreePtr = NULL then
		_fault->throw(_
			errors.nullReferenceError, _
			"BstGetIteratorNullReferenceError", "Attempt to reference a NULL BST", _
			__FILE__, __LINE__ _
		)
		return NULL
	end if

	iter = _iterator->construct()

	if iter = NULL then
		_fault->throw(_
			errors.resourceAllocationError, _
			"BstIteratorAllocationError", "Failed to allocate BST iterator: " & btreePtr->id, _
			__FILE__, __LINE__ _
		)
		return NULL
	end if

	iter->handler = @_iterationHandler

	_iterator->setData(iter, btreePtr)

	return iter
end function

/''
 ' Default compare function operating on integer values.
 ' @param {any ptr} criteria
 ' @param {any ptr} element
 ' @returns {integer}
 '/
function defaultCompare(criteria as any ptr, element as any ptr) as integer
	return sgn(*cptr(integer ptr, element) - *cptr(integer ptr, criteria))
end function

/''
 ' Creates a node, increments the length but does not place in the tree.
 ' @param {BstObj ptr} btreePtr
 ' @param {any ptr} element
 ' @returns {Bst.Node ptr}
 ' @private
 '/
function _createNode (btreePtr as BstObj ptr, element as any ptr) as Bst.Node ptr
	dim as Bst.Node ptr nodePtr = allocate(sizeof(Bst.Node))

	nodePtr->rightPtr = NULL
	nodePtr->leftPtr = NULL
	nodePtr->parent = NULL
	nodePtr->element = element

	btreePtr->length += 1

	return nodePtr
end function

/''
 ' Deletes node completely from tree.
 ' @param {BstObj ptr} btreePtr
 ' @param {Bst.Node ptr} nodePtr
 ' @private
 '/
sub _deleteNode (btreePtr as BstObj ptr, nodePtr as Bst.Node ptr)
	nodePtr->rightPtr = NULL
	nodePtr->leftPtr = NULL
	nodePtr->parent = NULL
	nodePtr->element = NULL

	btreePtr->length -= 1

	deallocate(nodePtr)
end sub

/''
 ' Deletes node and all of it's children.
 ' @param {BstObj ptr} btreePtr
 ' @param {Bst.Node ptr} nodePtr
 ' @private
 '/
sub _deleteNodeRecurse (btreePtr as BstObj ptr, nodePtr as Bst.Node ptr)
	if nodePtr->leftPtr <> NULL then
		_deleteNodeRecurse(btreePtr, nodePtr->leftPtr)
	end if
	
	if nodePtr->rightPtr <> NULL then
		_deleteNodeRecurse(btreePtr, nodePtr->rightPtr)
	end if

	_deleteNode(btreePtr, nodePtr)
end sub

/''
 ' Handles search recursion.
 ' @param {BstObj ptr} btreePtr
 ' @param {Bst.Node ptr} nodePtr
 ' @param {any ptr} element
 ' @returns {Bst.Node ptr} Last node in search, never returns NULL.
 ' @private
 '/
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
 ' tree, iteration, etc.
 ' @params {BstObj ptr} btreePtr
 ' @params {Bst.Node ptr} nodePtr
 ' @returns {Bst.Node ptr}
 ' @private
 '/
function _recurseLeft (nodePtr as Bst.Node ptr) as Bst.Node ptr
	if nodePtr->leftPtr <> NULL then
		return _recurseLeft(nodePtr->leftPtr)
	else
		return nodePtr
	end if
end function

/''
 ' Searches up the tree through parents to find next highest parent.
 ' @param {BstObj ptr} btreePtr
 ' @param {Bst.Node ptr} current
 ' @param {any ptr} element
 ' @returns {Bst.Node ptr}
 ' @private
 '/
function _nextParentRecurse (btreePtr as BstObj ptr, current as Bst.Node ptr, element as any ptr) as Bst.Node ptr
	if current <> NULL andalso btreePtr->compare(current->element, element) = 1 then
		return _nextParentRecurse(btreePtr, current->parent, element)
	else
		return current
	end if
end function

/''
 ' Handler for generic Iterator.
 ' @param {IteratorObj ptr} iter
 ' @param {any ptr} target
 ' @returns {integer}
 ' @private
 '/
function _iterationHandler (iter as IteratorObj ptr, target as any ptr) as integer
	dim as BstObj ptr btreePtr = iter->dataSet
	dim as Bst.Node ptr current
	dim as Bst.Node ptr parent

	if target = NULL then
		iter->index = 0
		iter->current = _recurseLeft(btreePtr->root)
		iter->length = btreePtr->length
	elseif iter->current <> NULL then
		current = iter->current
		parent = current->parent

		*cptr(any ptr ptr, target) = current->element

		if current->rightPtr <> NULL then
			current = _recurseLeft(current->rightPtr)
		else
			current = _nextParentRecurse(btreePtr, parent, current->element)
		end if

		iter->current = current
		iter->index += 1
	else
		return false
	end if

	return true
end function

end namespace
