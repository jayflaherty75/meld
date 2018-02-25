
/'
' Generated by Meld Framework, do not modify.  Any changes will be overwritten
' during the next build.
'/

#include once "../constants/constants-v1.bi"
#include once "../module/module-v1.bi"
#include once "../console/console-v1.bi"
#include once "../fault/fault-v1.bi"
#include once "../error-handling/error-handling-v1.bi"

namespace Tester

type expectFn as sub cdecl (result as long, expected as long, byref message as zstring)

type doneFn as sub cdecl ()

type testFunc as sub cdecl (expect as expectFn, done as doneFn)

type itCallback as function cdecl (byref description as zstring, test as testFunc) as short

type suiteFunc as function cdecl (it as itCallback) as short

type describeCallback as function cdecl (byref description as zstring, callback as suiteFunc) as short

type testModule as function cdecl (interfacePtr as any ptr, describe as describeCallback) as short

type Interface
	startup as function cdecl () as short
	shutdown as function cdecl () as short
	test as function cdecl (interfacePtr as any ptr, describeFn as Tester.describeCallback) as short
	run as function cdecl (tests as testModule ptr, interfacePtr as any ptr, count as short) as short
	describe as function cdecl (description as zstring, callback as suiteFunc) as short
	suite as function cdecl (description as zstring, testFn as testFunc) as short
end type

end namespace
