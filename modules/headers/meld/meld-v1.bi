
/'
' Generated by Meld Framework, do not modify.  Any changes will be overwritten
' during the next build.
'/

#include once "../constants/constants-v1.bi"
#include once "../module/module-v1.bi"
#include once "../tester/tester-v1.bi"

namespace Meld

type Instance
	references as ulong
end type

type Interface
	startup as function cdecl () as short
	shutdown as function cdecl () as short
	construct as function cdecl () as Instance ptr
	destruct as sub cdecl (instancePtr as Instance ptr)
	test as function cdecl (describe as Tester.describeCallback) as short
end type

end namespace
