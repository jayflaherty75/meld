
/'
' Generated by Meld Framework, do not modify.  Any changes will be overwritten
' during the next build.
'/

#include once "../constants/constants-v1.bi"
#include once "../module/module-v1.bi"

namespace Sys

type Interface
	startup as function cdecl () as short
	shutdown as function cdecl () as short
	getNewline as function cdecl () as zstring ptr
	getDirsep as function cdecl () as zstring ptr
	getModuleExt as function cdecl () as zstring ptr
	getTimestamp as function cdecl () as ulongint
	getMacAddress as sub cdecl (byref addr as zstring)
end type

end namespace
