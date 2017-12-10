
#include once "map.bi"
#include once "module.bi"
#include once "errors.bi"

namespace Map

function construct(byref id as zstring) as MapObj ptr
	return NULL
end function

sub destruct (mapPtr as MapObj ptr)
end sub

end namespace
