
#include once "../constants/constants-v1.bi"

namespace Module

type Interface
	initialize as function cdecl () as short
	uninitialize as function cdecl () as short
	require as function cdecl (byref moduleName as zstring) as any ptr
end type

end namespace
