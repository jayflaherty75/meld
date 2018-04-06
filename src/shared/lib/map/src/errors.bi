
namespace Map

declare sub _throwMapConstructAllocationError (byref filename as zstring, lineNum as integer)
declare sub _throwMapConstructResourceAllocationError (byref detail as zstring, byref filename as zstring, lineNum as integer)
declare sub _throwMapConstructResourceInitializationError (byref filename as zstring, lineNum as integer)
declare sub _throwMapDestructNullReferenceError (byref filename as zstring, lineNum as integer)
declare sub _throwMapUnassignNullReferenceError (byref filename as zstring, lineNum as integer)
declare sub _throwMapUnassignResourceMissingError (byref filename as zstring, lineNum as integer)
declare sub _throwMapGetLengthNullReferenceError (byref filename as zstring, lineNum as integer)
declare sub _throwMapPurgeNullReferenceError (byref filename as zstring, lineNum as integer)
declare sub _throwMapGetIteratorNullReferenceError (byref filename as zstring, lineNum as integer)
declare sub _throwMapGetIteratorResourceAllocationError (byref filename as zstring, lineNum as integer)
declare sub _throwMapAssignNullReferenceError (byref filename as zstring, lineNum as integer)
declare sub _throwMapAssignResourceMissingError (byref detail as zstring, byref filename as zstring, lineNum as integer)
declare sub _throwMapRequestNullReferenceError (byref filename as zstring, lineNum as integer)
declare sub _throwMapRequestResourceMissingError (byref filename as zstring, lineNum as integer)

sub _throwMapConstructAllocationError (byref filename as zstring, lineNum as integer)
	_fault->throw(_
		errors.allocationError, _
		"MapConstructAllocationError", "Failed to construct Map instance", _
		filename, lineNum _
	)
end sub

sub _throwMapConstructResourceAllocationError (byref detail as zstring, byref filename as zstring, lineNum as integer)
	_fault->throw(_
		errors.resourceAllocationError, _
		"MapConstructResourceAllocationError", "Failed to allocate resource: " & detail, _
		filename, lineNum _
	)
end sub

sub _throwMapConstructResourceInitializationError (byref filename as zstring, lineNum as integer)
	_fault->throw(_
		errors.resourceInitializationError, _
		"MapConstructResourceInitializationError", "Failed to initialize container", _
		filename, lineNum _
	)
end sub

sub _throwMapDestructNullReferenceError (byref filename as zstring, lineNum as integer)
	_fault->throw(_
		errors.nullReferenceError, _
		"MapDestructNullReferenceError", "Invalid Map pointer", _
		filename, lineNum _
	)
end sub

sub _throwMapUnassignNullReferenceError (byref filename as zstring, lineNum as integer)
	_fault->throw(_
		errors.nullReferenceError, _
		"MapUnassignNullReferenceError", "Invalid Map pointer", _
		filename, lineNum _
	)
end sub

sub _throwMapUnassignResourceMissingError (byref filename as zstring, lineNum as integer)
	_fault->throw(_
		errors.resourceMissingError, _
		"MapUnassignResourceMissingError", "Encountered missing node element", _
		filename, lineNum _
	)
end sub

sub _throwMapGetLengthNullReferenceError (byref filename as zstring, lineNum as integer)
	_fault->throw(_
		errors.nullReferenceError, _
		"MapGetLengthNullReferenceError", "Invalid Map pointer", _
		filename, lineNum _
	)
end sub

sub _throwMapPurgeNullReferenceError (byref filename as zstring, lineNum as integer)
	_fault->throw(_
		errors.nullReferenceError, _
		"MapPurgeNullReferenceError", "Invalid Map pointer", _
		filename, lineNum _
	)
end sub

sub _throwMapGetIteratorNullReferenceError (byref filename as zstring, lineNum as integer)
	_fault->throw(_
		errors.nullReferenceError, _
		"MapGetIteratorNullReferenceError", "Invalid Map pointer", _
		filename, lineNum _
	)
end sub

sub _throwMapGetIteratorResourceAllocationError (byref filename as zstring, lineNum as integer)
	_fault->throw(_
		errors.resourceAllocationError, _
		"MapGetIteratorResourceAllocationError", "Failed to create iterator instance", _
		filename, lineNum _
	)
end sub

sub _throwMapAssignNullReferenceError (byref filename as zstring, lineNum as integer)
	_fault->throw(_
		errors.nullReferenceError, _
		"MapAssignNullReferenceError", "Invalid Map pointer", _
		filename, lineNum _
	)
end sub

sub _throwMapAssignResourceMissingError (byref detail as zstring, byref filename as zstring, lineNum as integer)
	_fault->throw(_
		errors.resourceMissingError, _
		"MapAssignResourceMissingError", "Missing resource: " & detail, _
		filename, lineNum _
	)
end sub

sub _throwMapRequestNullReferenceError (byref filename as zstring, lineNum as integer)
	_fault->throw(_
		errors.nullReferenceError, _
		"MapRequestNullReferenceError", "Invalid Map pointer", _
		filename, lineNum _
	)
end sub

sub _throwMapRequestResourceMissingError (byref filename as zstring, lineNum as integer)
	_fault->throw(_
		errors.resourceMissingError, _
		"MapRequestResourceMissingError", "Encountered missing node element", _
		filename, lineNum _
	)
end sub

end namespace

