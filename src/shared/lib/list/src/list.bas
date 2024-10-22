
/''
 ' @requires console_v0.1.0
 ' @requires fault_v0.1.0
 ' @requires error-handling_v0.*
 ' @requires tester_v0.1.0
 ' @requires iterator_v0.1.0
 '/

#include once "module.bi"
#include once "errors.bi"
#include once "test.bi"

/''
 ' @namespace List
 ' @version 0.1.0
 '/
namespace List

/''
 ' @typedef {function} CompareFn
 ' @param {any ptr} criteria
 ' @param {any ptr} current
 ' @returns {short}
 '/

/''
 ' @class Node
 ' @member {Node ptr} nextPtr
 ' @member {Node ptr} prevPtr
 ' @member {any ptr} element
 '/

/''
 ' @class Instance
 ' @member {Node ptr} first
 ' @member {Node ptr} last
 ' @member {long} length
 '/

/''
 ' Application main routine.
 ' @function startup
 ' @returns {short}
 '/
function startup cdecl () as short
	_console->logMessage("Starting list module")

	return true
end function

/''
 ' Application main routine.
 ' @function shutdown
 ' @returns {short}
 '/
function shutdown cdecl () as short
	_console->logMessage("Shutting down list module")

	return true
end function

/''
 ' Standard test runner for modules.
 ' @function test
 ' @param {any ptr} describeFn
 ' @returns {short}
 '/
function test cdecl (describeFn as any ptr) as short
	dim as Tester.describeCallback describePtr = describeFn
	dim as short result = true

	result = result andalso describePtr ("The List module", @testCreate)

	return result
end function

/''
 ' Creates a new list instance.
 ' @function construct
 ' @returns {Instance ptr}
 ' @throws {ResourceAllocationError}
 '/
function construct cdecl () as Instance ptr
	dim as Instance ptr listPtr = allocate(sizeof(Instance))

	if listPtr = NULL then
		_throwListAllocationError(__FILE__, __LINE__)
		return NULL
	end if

	listPtr->first = NULL
	listPtr->last = NULL
	listPtr->length = 0

	return listPtr
end function

/''
 ' Deletes a previously created list instance.
 ' @function destruct
 ' @param {Instance ptr} listPtr
 ' @throws {NullReferenceError|ReleaseResourceError}
 '/
sub destruct cdecl (listPtr as Instance ptr)
	dim as Node ptr nodePtr
	dim as Node ptr nextPtr

	if listPtr = NULL then
		_throwListDestructNullReferenceError(__FILE__, __LINE__)
		exit sub
	end if

	nodePtr = getFirst(listPtr)

	while (nodePtr <> NULL)
		nextPtr = getNext(listPtr, nodePtr)
		remove (listPtr, nodePtr)
		nodePtr = nextPtr
	wend

	if listPtr->length <> 0 then
		_throwListReleaseError(__FILE__, __LINE__)
	end if

	deallocate (listPtr)
end sub

/''
 ' Inserts a node after the prevPtr node.  If prevPtr is not supplied or null,
 ' the new node is inserted as the first element.
 ' @function insert
 ' @param {Instance ptr} listPtr
 ' @param {any ptr} element
 ' @param {Node ptr} [prevPtr=0]
 ' @returns {Node ptr}
 ' @throws {NullReferenceError|InvalidArgumentError|ResourceAllocationError}
 '/
function insert cdecl (listPtr as Instance ptr, element as any ptr, prevPtr as Node ptr = NULL) as Node ptr
	dim as Node ptr nodePtr = NULL

	if listPtr = NULL then
		_throwListInsertNullReferenceError(__FILE__, __LINE__)
		return NULL
	end if

	if element = NULL then
		_throwListInsertInvalidArgumentError(__FILE__, __LINE__)
		return NULL
	end if

	nodePtr = allocate(sizeof(Node))

	if nodePtr = NULL then
		_throwListNodeAllocationError(__FILE__, __LINE__)
		return NULL
	end if

	nodePtr->element = element

	if prevPtr = NULL then
		nodePtr->prevPtr = NULL
		nodePtr->nextPtr = listPtr->first

		listPtr->first = nodePtr

		if listPtr->last = NULL then
			listPtr->last = nodePtr
		end if

		if nodePtr->nextPtr <> NULL then
			nodePtr->nextPtr->prevPtr = nodePtr
		end if
	else
		if prevPtr->nextPtr = NULL then
			listPtr->last = nodePtr
		else
			prevPtr->nextPtr->prevPtr = nodePtr
		end if

		nodePtr->prevPtr = prevPtr
		nodePtr->nextPtr = prevPtr->nextPtr
		prevPtr->nextPtr = nodePtr

		if listPtr->first = NULL then
			listPtr->first = nodePtr
		end if

		if nodePtr->prevPtr <> NULL then
			nodePtr->prevPtr->nextPtr = nodePtr
		end if
	end if

	listPtr->length += 1

	return nodePtr
end function

/''
 ' Removes a node from the list.
 ' @function remove
 ' @param {Instance ptr} listPtr
 ' @param {Node ptr} node
 ' @throws {NullReferenceError|InvalidArgumentError}
 '/
sub remove cdecl (listPtr as Instance ptr, node as Node ptr)
	dim as Node ptr nextPtr
	dim as Node ptr prevPtr

	if listPtr = NULL then
		_throwListRemoveNullReferenceError(__FILE__, __LINE__)
		exit sub
	end if

	if node = NULL then
		_throwListRemoveInvalidArgumentError(__FILE__, __LINE__)
		exit sub
	end if

	if listPtr->length = 0 then
		exit sub
	end if

	nextPtr = node->nextPtr
	prevPtr = node->prevPtr

	if nextPtr <> NULL then
		nextPtr->prevPtr = prevPtr
	else
		listPtr->last = prevPtr

		if prevPtr <> NULL then
			prevPtr->nextPtr = NULL
		end if
	end if

	if prevPtr <> NULL then
		prevPtr->nextPtr = nextPtr
	else
		listPtr->first = nextPtr

		if nextPtr <> NULL then
			nextPtr->prevPtr = NULL
		end if
	end if

	listPtr->length -= 1

	deallocate(node)
end sub

/''
 ' Returns the first node of a list.
 ' @function getFirst
 ' @param {Instance ptr} listPtr
 ' @returns {Node ptr}
 ' @throws {NullReferenceError}
 '/
function getFirst cdecl (listPtr as Instance ptr) as Node ptr
	if listPtr = NULL then
		_throwListGetFirstNullReferenceError(__FILE__, __LINE__)
		return NULL
	end if

	return listPtr->first
end function

/''
 ' Returns the last node of a list.
 ' @function getLast
 ' @param {Instance ptr} listPtr
 ' @returns {Node ptr}
 ' @throws {NullReferenceError}
 '/
function getLast cdecl (listPtr as Instance ptr) as Node ptr
	if listPtr = NULL then
		_throwListGetLastNullReferenceError(__FILE__, __LINE__)
		return NULL
	end if

	return listPtr->last
end function

/''
 ' Returns the node after the given node.
 ' @function getNext
 ' @param {Instance ptr} listPtr
 ' @param {Node ptr} node
 ' @returns {Node ptr}
 ' @throws {NullReferenceError}
 '/
function getNext cdecl (listPtr as Instance ptr, node as Node ptr) as Node ptr
	if listPtr = NULL then
		_throwListGetNextNullReferenceError(__FILE__, __LINE__)
		return NULL
	end if

	if node <> NULL then
		return node->nextPtr
	else
		return NULL
	end if
end function

/''
 ' Returns the length of the given list.
 ' @function getLength
 ' @param {Instance ptr} listPtr
 ' @returns {long}
 ' @throws {NullReferenceError}
 '/
function getLength cdecl (listPtr as Instance ptr) as long
	if listPtr = NULL then
		_throwListGetLengthNullReferenceError(__FILE__, __LINE__)
		return -1
	end if

	return listPtr->length
end function

/''
 ' Search for an element in the list using the given compare function.  If
 ' searching for integer values, just pass defaultCompare.
 ' @function search
 ' @param {Instance ptr} listPtr
 ' @param {any ptr} element
 ' @param {CompareFn} compare
 ' @returns {Node ptr}
 ' @throws {NullReferenceError|InvalidArgumentError}
 '/
function search cdecl (listPtr as Instance ptr, element as any ptr, compare as CompareFn) as Node ptr
	dim as Node ptr nodePtr = NULL
	dim as Node ptr result = NULL

	if listPtr = NULL then
		_throwListSearchNullReferenceError(__FILE__, __LINE__)
		return NULL
	end if

	if element = NULL orelse compare = NULL then
		_throwListSearchInvalidArgumentError(__FILE__, __LINE__)
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
 ' @function defaultCompare
 ' @param {any ptr} criteria
 ' @param {any ptr} current
 ' @returns {short}
 '/
function defaultCompare cdecl (criteria as any ptr, current as any ptr) as short
	if *cptr(integer ptr, criteria) = *cptr(integer ptr, current) then
		return true
	else
		return false
	end if
end function

/''
 ' Provides an Iterator instance that will return the element pointers of each
 ' node in the given list.
 ' @function getIterator
 ' @param {Instance ptr} listPtr
 ' @returns {any ptr}
 ' @throws {NullReferenceError}
 '/
function getIterator cdecl (listPtr as Instance ptr) as any ptr
	dim as Iterator.Instance ptr iter = _iterator->construct()

	if listPtr = NULL then
		_throwListGetIteratorNullReferenceError(__FILE__, __LINE__)
		return NULL
	end if

	iter->handler = @_iterationHandler

	_iterator->setData(iter, listPtr)

	return iter
end function

/''
 ' Rigorously validates the entire structure of a list.
 ' @function isValid
 ' @param {Instance ptr} listPtr
 ' @returns {short}
 '/
function isValid cdecl (listPtr as Instance ptr) as short
	dim as long length = 0
	dim as Node ptr first = NULL
	dim as Node ptr last = NULL
	dim as short result = true
	dim as Node ptr current = listPtr->first

	if listPtr = NULL then
		return false
	end if

	do while current <> NULL andalso length < _list->getLength(listPtr) + 4
		if first = NULL then
			if current->prevPtr <> NULL then
				_console->logWarning("ValidationError", "Forward iteration: First node has a non-null prevPtr", __FILE__, __LINE__)
				result = false
			end if

			first = current
		end if

		if current->element = NULL then
			_console->logWarning("ValidationError", "Forward iteration: Empty list node found at node #" & length, __FILE__, __LINE__)
			result = false
		end if

		if current->nextPtr = NULL andalso current <> listPtr->last then
			_console->logWarning("ValidationError", "Forward iteration: Last node does not match last node in list", __FILE__, __LINE__)
			result = false
		end if

		current = current->nextPtr
		length += 1
	loop

	if length <> _list->getLength(listPtr) then
		_console->logWarning("ValidationError", "Forward iteration: Resulting length does not match list length: " & length & " != " & _list->getLength(listPtr), __FILE__, __LINE__)
		result = false
	end if

	current = listPtr->last
	length = 0

	do while current <> NULL andalso length < _list->getLength(listPtr) + 4
		if last = NULL then
			if current->nextPtr <> NULL then
				_console->logWarning("ValidationError", "Reverse iteration: Last node has a non-null nextPtr", __FILE__, __LINE__)
				result = false
			end if

			last = current
		end if

		if current->element = NULL then
			_console->logWarning("ValidationError", "Reverse iteration: Empty list node found at node #" & length, __FILE__, __LINE__)
			result = false
		end if

		if current->prevPtr = NULL andalso current <> listPtr->first then
			_console->logWarning("ValidationError", "Reverse iteration: First node does not match first node in list", __FILE__, __LINE__)
			result = false
		end if

		current = current->prevPtr
		length += 1
	loop

	if length <> _list->getLength(listPtr) then
		_console->logWarning("ValidationError", "Reverse iteration: Resulting length does not match list length: " & length & " != " & _list->getLength(listPtr), __FILE__, __LINE__)
		result = false
	end if

	if first <> listPtr->first then
		_console->logWarning("ValidationError", "First node does not match", __FILE__, __LINE__)
		result = false
	end if

	if last <> listPtr->last then
		_console->logWarning("ValidationError", "Last node does not match", __FILE__, __LINE__)
		result = false
	end if

	return result
end function

/''
 ' Iteration handler for lists.
 ' @function _iterationHandler
 ' @param {Iterator.Instance ptr} iter
 ' @param {any ptr} target
 ' @returns {short}
 ' @private
 '/
function _iterationHandler cdecl (iter as Iterator.Instance ptr, target as any ptr) as short
	dim as Instance ptr listPtr = iter->dataSet
	dim as Node ptr current

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

