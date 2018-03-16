
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

type doneFn as sub cdecl ()

type testFunc as sub cdecl (done as doneFn)

type itCallback as function cdecl (byref description as zstring, test as testFunc) as short

type suiteFunc as function cdecl (it as itCallback) as short

type describeCallback as function cdecl (byref description as zstring, callback as suiteFunc) as short

type testModule as function cdecl (describeFn as describeCallback) as short

type Interface
	startup as function cdecl () as short
	shutdown as function cdecl () as short
	construct as any ptr
	destruct as any ptr
	update as any ptr
	test as function cdecl (describe as Tester.describeCallback) as short
	run as function cdecl (tests as testModule ptr, count as short) as short
	describe as function cdecl (description as zstring, callback as suiteFunc) as short
	suite as function cdecl (description as zstring, testFn as testFunc) as short
	expect as sub cdecl (result as long, expected as long, byref message as zstring)
	expectNot as sub cdecl (result as long, expected as long, byref message as zstring)
	expectStr as sub cdecl (byref result as zstring, byref expected as zstring, byref message as zstring)
	expectStrNot as sub cdecl (byref result as zstring, byref expected as zstring, byref message as zstring)
	expectPtr as sub cdecl (result as any ptr, expected as any ptr, byref message as zstring)
	expectPtrNot as sub cdecl (result as any ptr, expected as any ptr, byref message as zstring)
end type

end namespace
