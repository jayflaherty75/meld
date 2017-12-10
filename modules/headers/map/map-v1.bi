
#include once "../constants/constants-v1.bi"
#include once "../core/core-v1.bi"
#include once "../bst/bst-v1.bi"

namespace Map

union Location
	atInt as uinteger
	atPtr as any ptr
end union

type Instance
	id as zstring*64
	mappings as BstObj ptr
	reverse as BstObj ptr
end type

type Interface
	load as function (corePtr as Core.Interface ptr) as integer
	unload as sub()
	register as function() as integer
	unregister as sub()
	construct as function (byref id as zstring) as Map.Instance ptr
	destruct as sub (idPtr as Map.Instance ptr)
	assign as function (mapPtr as Map.Instance ptr, byref mapping as zstring) as Location ptr
	request as function (mapPtr as Map.Instance ptr, byref mapping as zstring) as Location ptr
	reference as function (mapPtr as Map.Instance ptr, loc as Location ptr) as zstring ptr
	unassign as sub (mapPtr as Map.Instance ptr, byref mapping as zstring)
end type

end namespace

type MapObj as Map.Instance
