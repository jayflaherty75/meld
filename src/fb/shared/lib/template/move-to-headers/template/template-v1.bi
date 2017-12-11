
#include once "../constants/constants-v1.bi"
#include once "../core/core-v1.bi"
#include once "../fault/fault-v1.bi"

namespace Template

type Instance
	id as zstring*64
end type

type Interface
	load as function (corePtr as Core.Interface ptr) as integer
	unload as sub()
	register as function() as integer
	unregister as sub()
	construct as function (byref id as zstring) as Template.Instance ptr
	destruct as sub (idPtr as Template.Instance ptr)

end type

end namespace

type TemplateObj as Template.Instance
