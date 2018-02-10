
#include once "../constants/constants-v1.bi"
#include once "../module/module-v1.bi"
#include once "../console/console-v1.bi"

namespace Tester

type testFunc as function cdecl () as short

type itCallback as function cdecl (byref description as zstring, test as testFunc) as short

type suiteFunc as function cdecl (it as itCallback) as short

type describeCallback as function cdecl (byref description as zstring, callback as suiteFunc) as short

type testModule as function cdecl (interfacePtr as any ptr, describe as describeCallback) as short

type expect as sub cdecl (expected as long, result as long, message as zstring)

type done as sub cdecl ()

type Interface
	startup as function cdecl () as short
	shutdown as function cdecl () as short
	run as function cdecl (tests as testModule ptr, interfacePtr as any ptr, count as short) as short
	describe as function cdecl (description as zstring, callback as suiteFunc) as short
	suite as function cdecl (description as zstring, test as testFunc) as short
end type

end namespace
