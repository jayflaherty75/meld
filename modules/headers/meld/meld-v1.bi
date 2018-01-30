
#include once "../module/module-v1.bi"

namespace Meld

type Interface
	load as function cdecl (modulePtr as Module.Interface ptr) as short
	unload as sub cdecl ()
	startup as function cdecl () as short
	shutdown as sub cdecl ()
end type

end namespace
