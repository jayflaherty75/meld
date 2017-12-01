
#include once "list.bi"

namespace List

type Dependencies
	core as Core.Interface ptr
end type

type StateType
	deps as Dependencies
	methods as Interface
end type

dim shared as StateType state

declare function _iterationHandler (iter as IteratorObj ptr, target as any ptr) as integer

function load (corePtr as Core.Interface ptr) as integer
	if corePtr = NULL then
		' TODO: Throw error
		print ("List.load: Invalid corePtr interface pointer")
		return false
	end if

	state.methods.load = @load
	state.methods.unload = @unload
	state.methods.construct = @construct
	state.methods.destruct = @destruct
	state.methods.insert = @insert
	state.methods.remove = @remove
	state.methods.getFirst = @getFirst
	state.methods.getLast = @getLast
	state.methods.getNext = @getNext
	state.methods.getLength = @getLength
	state.methods.search = @search
	state.methods.defaultCompare = @defaultCompare
	state.methods.getIterator = @getIterator

	if not corePtr->register("list", @state.methods) then
		return false
	end if

	state.deps.core = corePtr

	return true
end function

sub unload()
end sub

/''
 ' Creates a new list instance.
 ' @returns {ListObj ptr}
 '/
function construct() as ListObj ptr
	dim as ListObj ptr listPtr = allocate(sizeof(ListObj))

	if listPtr <> NULL then
		listPtr->first = NULL
		listPtr->last = NULL
		listPtr->length = 0
	else
		' TODO: throw error
		print ("List.construct: Failed to allocate list object")
	end if

	return listPtr
end function

/''
 ' Deletes a previously created list instance.
 ' @param {ListObj ptr} listPtr
 '/
sub destruct (listPtr as ListObj ptr)
	dim as List.Node ptr nodePtr
	dim as List.Node ptr nextPtr

	if listPtr <> NULL then
		nodePtr = getFirst(listPtr)

		while (nodePtr <> NULL)
			nextPtr = getNext(listPtr, nodePtr)
			remove (listPtr, nodePtr)
			nodePtr = nextPtr
		wend

		if listPtr->length <> 0 then
			' TODO: throw error
			print("List.destruct: Failed to correctly release all resources")
		end if

		deallocate (listPtr)
	else
		' TODO: throw error
		print("List.destruct: Invalid list")
	end if
end sub

/''
 ' Inserts a node after the prevPtr node.  If prevPtr is not supplied or null,
 ' the new node is inserted as the first element.
 ' @param {ListObj ptr} listPtr
 ' @param {any ptr} element
 ' @param {List.Node ptr} prevPtr
 '/
function insert (listPtr as ListObj ptr, element as any ptr, prevPtr as List.Node ptr = NULL) as List.Node ptr
	dim as List.Node ptr nodePtr = NULL

	if listPtr = NULL then
		' TODO: throw error
		print("List.insert: Invalid list")
		exit function
	end if

	if element = NULL then
		' TODO: throw error
		print("List.insert: Invalid element")
		exit function
	end if

	nodePtr = allocate(sizeof(List.Node))

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
		print("List.insert: Failed to allocate node")
	end if

	return nodePtr
end function

/''
 ' Removes a node from the list.
 ' @param {ListObj ptr} listPtr
 ' @param {List.Node ptr} node
 '/
sub remove (listPtr as ListObj ptr, node as List.Node ptr)
	dim as List.Node ptr nextPtr
	dim as List.Node ptr prevPtr

	if listPtr = NULL then
		' TODO: throw error
		print("List.remove: Invalid list")
		exit sub
	end if

	if node = NULL then
		' TODO: throw error
		print("List.remove: Invalid node")
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
 ' @param {ListObj ptr} listPtr
 ' @returns {List.Node ptr}
 '/
function getFirst (listPtr as ListObj ptr) as List.Node ptr
	if listPtr = NULL then
		' TODO: throw error
		print("List.getFirst: Invalid list")
		return NULL
	end if

	return listPtr->first
end function

/''
 ' Returns the last node of a list.
 ' @param {ListObj ptr} listPtr
 ' @returns {List.Node ptr}
 '/
function getLast (listPtr as ListObj ptr) as List.Node ptr
	if listPtr = NULL then
		' TODO: throw error
		print("List.getLast: Invalid list")
		return NULL
	end if

	return listPtr->last
end function

/''
 ' Returns the node after the given node.
 ' @param {ListObj ptr} listPtr
 ' @param {List.Node ptr} node
 ' @returns {List.Node ptr}
 '/
function getNext (listPtr as ListObj ptr, node as List.Node ptr) as List.Node ptr
	if listPtr = NULL then
		' TODO: throw error
		print("List.getNext: Invalid list")
		return NULL
	end if

	if node <> NULL then
		return node->nextPtr
	else
		return NULL
	end if
end function

function getLength (listPtr as ListObj ptr) as integer
	if listPtr = NULL then
		' TODO: throw error
		print("List.getNext: Invalid list")
		return NULL
	end if

	return listPtr->length
end function

/''
 ' Search for an element in the list using the given compare function.  If
 ' searching for integer values, just pass defaultCompare.
 ' @param {ListObj ptr} listPtr
 ' @param {any ptr} element
 ' @param {function} compare
 ' @returns {List.Node ptr}
 '/
function search (listPtr as ListObj ptr, element as any ptr, compare as function(criteria as any ptr, current as any ptr) as integer) as List.Node ptr
	dim as List.Node ptr nodePtr = NULL
	dim as List.Node ptr result = NULL

	if listPtr = NULL then
		' TODO: throw error
		print("List.search: Invalid list")
		return NULL
	end if

	nodePtr = getFirst(listPtr)

	while (nodePtr <> NULL ANDALSO result = NULL)
		if compare(element, nodePtr->element) = true then
			result = nodePtr
		else
			nodePtr = getNext(listPtr, nodePtr)
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
function defaultCompare (criteria as any ptr, current as any ptr) as integer
	if *cptr(integer ptr, criteria) = *cptr(integer ptr, current) then
		return true
	else
		return false
	end if
end function

/''
 ' Provides an Iterator instance that will return the element pointers of each
 ' node in the given list.
 ' @param {ListObj ptr} listPtr
 ' @returns {IteratorObj ptr}
 '/
function getIterator (listPtr as ListObj ptr) as IteratorObj ptr
	dim as IteratorObj ptr iter = Iterator.construct()

	if listPtr = NULL then
		' TODO: throw error
		print("List.search: Invalid list")
		return NULL
	end if

	iter->handler = @_iterationHandler

	Iterator.setData(iter, listPtr)

	return iter
end function

/''
 ' Iteration handler for lists.
 ' @params {IteratorObj ptr} iter
 ' @params {any ptr} target
 ' @returns {integer}
 ' @private
 '/
function _iterationHandler (iter as IteratorObj ptr, target as any ptr) as integer
	dim as ListObj ptr listPtr = iter->dataSet
	dim as List.Node ptr current

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

end namespace
