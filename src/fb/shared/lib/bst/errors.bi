
namespace Bst

declare sub _throwBstAllocationError (byref id as zstring, byref filename as zstring, lineNum as integer)
declare sub _throwBstDestructNullReferenceError (byref filename as zstring, lineNum as integer)
declare sub _throwBstDestructReleaseError (btreePtrbstPtr as BstObj ptr, byref filename as zstring, lineNum as integer)
declare sub _throwBstInsertNullReferenceError (byref filename as zstring, lineNum as integer)
declare sub _throwBstInsertInvalidArgumentError (btreePtr as BstObj ptr, byref filename as zstring, lineNum as integer)
declare sub _throwBstNodeAllocationError (btreePtr as BstObj ptr, byref filename as zstring, lineNum as integer)
declare sub _throwBstRemoveNullReferenceError (byref filename as zstring, lineNum as integer)
declare sub _throwBstRemoveInvalidArgumentError (btreePtr as BstObj ptr, byref filename as zstring, lineNum as integer)
declare sub _throwBstPurgeNullReferenceError (byref filename as zstring, lineNum as integer)
declare sub _throwBstPurgeReleaseError (btreePtr as BstObj ptr, byref filename as zstring, lineNum as integer)
declare sub _throwBstSearchNullReferenceError (byref filename as zstring, lineNum as integer)
declare sub _throwBstSearchInvalidArgumentError (btreePtr as BstObj ptr, byref filename as zstring, lineNum as integer)
declare sub _throwBstGetLengthNullReferenceError (byref filename as zstring, lineNum as integer)
declare sub _throwBstGetIteratorNullReferenceError (byref filename as zstring, lineNum as integer)
declare sub _throwBstIteratorAllocationError (btreePtr as BstObj ptr, byref filename as zstring, lineNum as integer)

sub _throwBstAllocationError (byref id as zstring, byref filename as zstring, lineNum as integer)
	_fault->throw(_
		errors.resourceAllocationError, _
		"BstAllocationError", "Failed to allocate BST instance: " & id, _
		filename, lineNum _
	)
end sub

sub _throwBstDestructNullReferenceError (byref filename as zstring, lineNum as integer)
	_fault->throw(_
		errors.nullReferenceError, _
		"BstDestructNullReferenceError", "Attempt to reference a NULL BST", _
		filename, lineNum _
	)
end sub

sub _throwBstDestructReleaseError (btreePtr as BstObj ptr, byref filename as zstring, lineNum as integer)
	_fault->throw(_
		errors.releaseResourceError, _
		"BstDestructReleaseError", "Failed to correctly release all resources from BST: " & btreePtr->id, _
		filename, lineNum _
	)
end sub

sub _throwBstInsertNullReferenceError (byref filename as zstring, lineNum as integer)
	_fault->throw(_
		errors.nullReferenceError, _
		"BstInsertNullReferenceError", "Attempt to reference a NULL BST", _
		filename, lineNum _
	)
end sub

sub _throwBstInsertInvalidArgumentError (btreePtr as BstObj ptr, byref filename as zstring, lineNum as integer)
	_fault->throw(_
		errors.invalidArgumentError, _
		"BstInsertInvalidArgumentError", "Invalid 2nd Argument: element must not be NULL: " & btreePtr->id, _
		filename, lineNum _
	)
end sub

sub _throwBstNodeAllocationError (btreePtr as BstObj ptr, byref filename as zstring, lineNum as integer)
	_fault->throw(_
		errors.resourceAllocationError, _
		"BstNodeAllocationError", "Failed to allocate BST node: " & btreePtr->id, _
		filename, lineNum _
	)
end sub

sub _throwBstRemoveNullReferenceError (byref filename as zstring, lineNum as integer)
	_fault->throw(_
		errors.nullReferenceError, _
		"BstRemoveNullReferenceError", "Attempt to reference a NULL BST", _
		filename, lineNum _
	)
end sub

sub _throwBstRemoveInvalidArgumentError (btreePtr as BstObj ptr, byref filename as zstring, lineNum as integer)
	_fault->throw(_
		errors.invalidArgumentError, _
		"BstRemoveInvalidArgumentError", "Invalid 2nd Argument: node must not be NULL: " & btreePtr->id, _
		filename, lineNum _
	)
end sub

sub _throwBstPurgeNullReferenceError (byref filename as zstring, lineNum as integer)
	_fault->throw(_
		errors.nullReferenceError, _
		"BstPurgeNullReferenceError", "Attempt to reference a NULL BST", _
		filename, lineNum _
	)
end sub

sub _throwBstPurgeReleaseError (btreePtr as BstObj ptr, byref filename as zstring, lineNum as integer)
	_fault->throw(_
		errors.releaseResourceError, _
		"BstPurgeReleaseError", "Failed to correctly purge all nodes from BST: " & btreePtr->id, _
		filename, lineNum _
	)
end sub

sub _throwBstSearchNullReferenceError (byref filename as zstring, lineNum as integer)
	_fault->throw(_
		errors.nullReferenceError, _
		"BstSearchNullReferenceError", "Attempt to reference a NULL BST", _
		filename, lineNum _
	)
end sub

sub _throwBstSearchInvalidArgumentError (btreePtr as BstObj ptr, byref filename as zstring, lineNum as integer)
	_fault->throw(_
		errors.invalidArgumentError, _
		"BstSearchInvalidArgumentError", "Invalid 2nd Argument: element must not be NULL: " & btreePtr->id, _
		filename, lineNum _
	)
end sub

sub _throwBstGetLengthNullReferenceError (byref filename as zstring, lineNum as integer)
	_fault->throw(_
		errors.nullReferenceError, _
		"BstGetLengthNullReferenceError", "Attempt to reference a NULL BST", _
		filename, lineNum _
	)
end sub

sub _throwBstGetIteratorNullReferenceError (byref filename as zstring, lineNum as integer)
	_fault->throw(_
		errors.nullReferenceError, _
		"BstGetIteratorNullReferenceError", "Attempt to reference a NULL BST", _
		filename, lineNum _
	)
end sub

sub _throwBstIteratorAllocationError (btreePtr as BstObj ptr, byref filename as zstring, lineNum as integer)
	_fault->throw(_
		errors.resourceAllocationError, _
		"BstIteratorAllocationError", "Failed to allocate BST iterator: " & btreePtr->id, _
		filename, lineNum _
	)
end sub

end namespace
