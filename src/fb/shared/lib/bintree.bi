
#include once "../../../../modules/headers/constants/constants-v1.bi"
#include once "iterator.bi"

type BinTreeNode
	rightPtr as BinTreeNode ptr
	leftPtr as BinTreeNode ptr
	parent as BinTreeNode ptr
	element as any ptr
end type

type BinTree
	root as BinTreeNode ptr
	length as integer
	compare as function(criteria as any ptr, element as any ptr) as integer
end type

declare function bintreeNew() as BinTree ptr
declare sub bintreeDelete (btreePtr as BinTree ptr)
declare function bintreeInsert (btreePtr as BinTree ptr, element as any ptr, start as BinTreeNode ptr = NULL) as BinTreeNode ptr
declare function bintreeSearch (btreePtr as BinTree ptr, element as any ptr, start as BinTreeNode ptr = NULL) as BinTreeNode ptr
declare function bintreeGetLength (btreePtr as BinTree ptr) as integer
declare function bintreeIterator (btreePtr as BinTree ptr) as Iterator ptr
declare function bintreeDefaultCompare(criteria as any ptr, element as any ptr) as integer
declare function _bintreeSearchRecurse (btreePtr as BinTree ptr, nodePtr as BinTreeNode ptr, element as any ptr) as BinTreeNode ptr
declare function _bintreeCreateNode (btreePtr as BinTree ptr, element as any ptr) as BinTreeNode ptr
declare sub _bintreeDeleteNode (btreePtr as BinTree ptr, nodePtr as BinTreeNode ptr)
declare function _bintreeIterationHandler (iter as Iterator ptr, target as any ptr) as integer

function bintreeNew() as BinTree ptr
	dim as BinTree ptr btreePtr = allocate(sizeof(list))

	if btreePtr <> NULL then
		btreePtr->root = NULL
		btreePtr->length = 0
		btreePtr->compare = @bintreeDefaultCompare
	else
		' TODO: throw error
		print("bintreeNew: Failed to allocate BinTree object")
	end if

	return btreePtr
end function

sub bintreeDelete (btreePtr as BinTree ptr)
	if btreePtr <> NULL then
		if btreePtr->root <> NULL then
			btreePtr->root->parent = NULL
			_bintreeDeleteNode(btreePtr, btreePtr->root)
		end if

		deallocate(btreePtr)
	else
		' TODO: throw error
		print("bintreeDelete: Invalid binary tree")
	end if
end sub

function bintreeInsert (btreePtr as BinTree ptr, element as any ptr, start as BinTreeNode ptr = NULL) as BinTreeNode ptr
	dim as BinTreeNode ptr nodePtr = NULL
	dim as BinTreeNode ptr searchPtr = NULL

	if btreePtr = NULL then
		' TODO: throw error
		print("bintreeInsert: Invalid list")
		exit function
	end if

	if element = NULL then
		' TODO: throw error
		print("bintreeInsert: Invalid element")
		exit function
	end if

	if start = NULL then
		start = btreePtr->root
	end if

	nodePtr = _bintreeCreateNode(btreePtr, element)

	if start <> NULL then
		searchPtr = _bintreeSearchRecurse(btreePtr, start, element)

		if btreePtr->compare(searchPtr->element, element) = 1 ANDALSO searchPtr->rightPtr = NULL then
			searchPtr->rightPtr = nodePtr
			nodePtr->parent = searchPtr
		elseif nodePtr->leftPtr = NULL then
			searchPtr->leftPtr = nodePtr
			nodePtr->parent = searchPtr
		else
			_bintreeDeleteNode(btreePtr, element)
		end if
	else
		btreePtr->root = nodePtr
	end if

	return nodePtr
end function

function bintreeSearch (btreePtr as BinTree ptr, element as any ptr, start as BinTreeNode ptr = NULL) as BinTreeNode ptr
	dim as BinTreeNode ptr searchPtr = NULL

	if btreePtr = NULL then
		' TODO: throw error
		print("bintreeInsert: Invalid list")
		exit function
	end if

	if element = NULL then
		' TODO: throw error
		print("bintreeInsert: Invalid element")
		exit function
	end if

	if start = NULL then
		start = btreePtr->root
	end if

	if start <> NULL then
		searchPtr = _bintreeSearchRecurse(btreePtr, start, element)

		if btreePtr->compare(searchPtr->element, element) = 0 then
			return searchPtr
		end if
	end if

	return NULL
end function

function bintreeGetLength (btreePtr as BinTree ptr) as integer
	return btreePtr->length
end function

function bintreeIterator (btreePtr as BinTree ptr) as Iterator ptr
	dim as Iterator ptr iter = iteratorNew()

	if btreePtr = NULL then
		' TODO: throw error
		print("bintreeIterator: Invalid binary tree")
		return NULL
	end if

	iter->handler = @_bintreeIterationHandler

	iteratorSetDataSet(iter, btreePtr)

	return iter
end function

function bintreeDefaultCompare(criteria as any ptr, element as any ptr) as integer
	return sgn(*cptr(integer ptr, element) - *cptr(integer ptr, criteria))
end function

function _bintreeSearchRecurse (btreePtr as BinTree ptr, nodePtr as BinTreeNode ptr, element as any ptr) as BinTreeNode ptr
	dim as integer compare = btreePtr->compare(nodePtr->element, element)

	if compare = 1 then
		if nodePtr->rightPtr <> NULL then
			return _bintreeSearchRecurse(btreePtr, nodePtr->rightPtr, element)
		else
			return nodePtr
		end if
	elseif compare = -1 then
		if nodePtr->leftPtr <> NULL then
			return _bintreeSearchRecurse(btreePtr, nodePtr->leftPtr, element)
		else
			return nodePtr
		end if
	else
		return nodePtr
	end if
end function

function _bintreeCreateNode (btreePtr as BinTree ptr, element as any ptr) as BinTreeNode ptr
	dim as BinTreeNode ptr nodePtr = allocate(sizeof(BinTreeNode))

	nodePtr->rightPtr = NULL
	nodePtr->leftPtr = NULL
	nodePtr->parent = NULL
	nodePtr->element = element

	btreePtr->length += 1

	return nodePtr
end function

sub _bintreeDeleteNode (btreePtr as BinTree ptr, nodePtr as BinTreeNode ptr)
	if nodePtr->parent <> NULL then
		dim as BinTreeNode ptr parent = nodePtr->parent
		dim as BinTreeNode ptr rightPtr = nodePtr->rightPtr
		dim as BinTreeNode ptr leftPtr = nodePtr->leftPtr
		dim as BinTreeNode ptr newParent = NULL

		if rightPtr <> NULL andalso leftPtr <> NULL then
			' TODO: Finish complex case of removing a fully connected node
			' and consider decoupling this logic from deallocation as it may be
			' reusable tree balancing.
		elseif rightPtr <> NULL then
			newParent = rightPtr
		elseif leftPtr <> NULL then
			newParent = leftPtr
		end if

		if nodePtr = parent->rightPtr then
			parent->rightPtr = newParent
		elseif nodePtr = parent->leftPtr then
			parent->leftPtr = newParent
		end if
	else
		if nodePtr->rightPtr <> NULL then
			nodePtr->rightPtr->parent = NULL
			_bintreeDeleteNode(btreePtr, nodePtr->rightPtr)
		end if

		if nodePtr->leftPtr <> NULL then
			nodePtr->leftPtr->parent = NULL
			_bintreeDeleteNode(btreePtr, nodePtr->leftPtr)
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

function _bintreeIterationHandler (iter as Iterator ptr, target as any ptr) as integer
	dim as BinTree ptr btreePtr = iter->dataSet
	dim as BinTreeNode ptr current

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
