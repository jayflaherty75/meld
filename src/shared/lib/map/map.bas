
#include once "map.bi"
#include once "module.bi"
#include once "errors.bi"

namespace Map

function construct(byref id as zstring) as MapObj ptr
	return NULL
end function

sub destruct (mapPtr as MapObj ptr)
end sub

function assign (mapPtr as MapObj ptr, byref mapping as zstring) as Location ptr
	return NULL
end function

function request (mapPtr as MapObj ptr, byref mapping as zstring) as Location ptr
	return NULL
end function

function reference (mapPtr as MapObj ptr, loc as Location ptr) as zstring ptr
	return NULL
end function

sub unassign (mapPtr as MapObj ptr, byref mapping as zstring)
end sub

end namespace
