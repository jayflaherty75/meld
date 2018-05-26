
namespace TypeMap

sub _throwTypeMapStartupMapAllocationError (byref filename as zstring, lineNum as integer)
	_fault->throwErr(_
		errors.resourceAllocationError, _
		"TypeMapStartupMapAllocationError", "Failed to construct type mapper", _
		filename, lineNum _
	)
end sub

sub _throwTypeMapStartupContAllocationError (byref filename as zstring, lineNum as integer)
	_fault->throwErr(_
		errors.resourceAllocationError, _
		"TypeMapStartupContAllocationError", "Failed to construct type entry container", _
		filename, lineNum _
	)
end sub

sub _throwTypeMapStartupContInitializationError (byref filename as zstring, lineNum as integer)
	_fault->throwErr(_
		errors.resourceInitializationError, _
		"TypeMapStartupContInitializationError", "Failed to initialize type entry container", _
		filename, lineNum _
	)
end sub

sub _throwTypeMapStartupResourceMissingError (byref filename as zstring, lineNum as integer)
	_fault->throwErr(_
		errors.resourceMissingError, _
		"TypeMapStartupResourceMissingError", "Failed to create mutex, multithreading will not be supported", _
		filename, lineNum _
	)
end sub

sub _throwTypeMapRequestInvalidArgumentError (byref filename as zstring, lineNum as integer)
	_fault->throwErr(_
		errors.invalidArgumentError, _
		"TypeMapRequestInvalidArgumentError", "Invalid id argument", _
		filename, lineNum _
	)
end sub

sub _throwTypeMapRequestResourceAllocationError (byref filename as zstring, lineNum as integer)
	_fault->throwErr(_
		errors.resourceAllocationError, _
		"TypeMapRequestResourceAllocationError", "Container request failed for type entry", _
		filename, lineNum _
	)
end sub

sub _throwTypeMapRequestResourceInitializationError (byref filename as zstring, lineNum as integer)
	_fault->throwErr(_
		errors.resourceInitializationError, _
		"TypeMapRequestResourceInitializationError", "Failed to assign type entry", _
		filename, lineNum _
	)
end sub

sub _throwTypeMapAssignNullReferenceError (byref filename as zstring, lineNum as integer)
	_fault->throwErr(_
		errors.nullReferenceError, _
		"TypeMapAssignNullReferenceError", "Invalid entryPtr argument", _
		filename, lineNum _
	)
end sub

sub _throwTypeMapAssignInvalidArgumentError (byref filename as zstring, lineNum as integer)
	_fault->throwErr(_
		errors.invalidArgumentError, _
		"TypeMapAssignInvalidArgumentError", "Invalid size argument", _
		filename, lineNum _
	)
end sub

sub _throwTypeMapIsAssignedNullReferenceError (byref filename as zstring, lineNum as integer)
	_fault->throwErr(_
		errors.nullReferenceError, _
		"TypeMapIsAssignedNullReferenceError", "Invalid entryPtr argument", _
		filename, lineNum _
	)
end sub

sub _throwTypeMapGetSizeNullReferenceError (byref filename as zstring, lineNum as integer)
	_fault->throwErr(_
		errors.nullReferenceError, _
		"TypeMapGetSizeNullReferenceError", "Invalid entryPtr argument", _
		filename, lineNum _
	)
end sub

sub _throwTypeMapGetDestructorNullReferenceError (byref filename as zstring, lineNum as integer)
	_fault->throwErr(_
		errors.nullReferenceError, _
		"TypeMapGetDestructorNullReferenceError", "Invalid entryPtr argument", _
		filename, lineNum _
	)
end sub

sub _throwTypeMapDestroyNullReferenceError (byref filename as zstring, lineNum as integer)
	_fault->throwErr(_
		errors.nullReferenceError, _
		"TypeMapDestroyNullReferenceError", "Invalid entryPtr argument", _
		filename, lineNum _
	)
end sub

sub _throwTypeMapDestroyNullInstanceReferenceError (byref filename as zstring, lineNum as integer)
	_fault->throwErr(_
		errors.nullReferenceError, _
		"TypeMapDestroyNullReferenceError", "Invalid instancePtr argument", _
		filename, lineNum _
	)
end sub

end namespace

