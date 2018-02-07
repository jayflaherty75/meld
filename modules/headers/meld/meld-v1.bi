
#include once "../module/module-v1.bi"

namespace Meld

type Interface
	exports as function cdecl () as any ptr
	load as function cdecl (modulePtr as Module.Interface ptr) as short
	unload as function cdecl () as short
	startup as function cdecl () as short
	shutdown as function cdecl () as short
end type

end namespace
