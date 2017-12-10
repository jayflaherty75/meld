
#include once "../constants/constants-v1.bi"
#include once "../core/core-v1.bi"
#include once "../bst/bst-v1.bi"

namespace Map

union Location
	atByte(7) as ubyte
	atLong as ulongint
	atStr as zstring*8
end union

type Instance
	id as zstring*64
	mappings as BstObj ptr
	reverseMappings as BstObj ptr
end type

type Interface
	load as function (corePtr as Core.Interface ptr) as integer
	unload as sub()
	register as function() as integer
	unregister as sub()
	construct as function (byref id as zstring) as Map.Instance ptr
	destruct as sub (idPtr as Map.Instance ptr)

end type

end namespace

type MapObj as Map.Instance
