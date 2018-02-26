
/'
' Generated by Meld Framework, do not modify.  Any changes will be overwritten
' during the next build.
'/

#include once "../../../../../modules/headers/tester/tester-v1.bi"

dim shared _tester as Tester.Interface ptr
dim shared _console as Console.Interface ptr
dim shared _fault as Fault.Interface ptr
dim shared _errorHandling as ErrorHandling.Interface ptr

type ModuleStateType
	methods as Tester.Interface
	isLoaded as short
	references as integer
	startups as integer
end type

dim shared as ModuleStateType moduleState

namespace Tester

declare function startup cdecl () as short
declare function shutdown cdecl () as short
declare function test cdecl (describeFn as describeCallback) as short
declare function run cdecl (tests as testModule ptr, count as short) as short
declare function describe cdecl (description as zstring, callback as suiteFunc) as short
declare function suite cdecl (description as zstring, testFn as testFunc) as short
declare sub expect cdecl (result as long, expected as long, byref message as zstring)
declare sub expectNot cdecl (result as long, expected as long, byref message as zstring)
declare sub expectStr cdecl (byref result as zstring, byref expected as zstring, byref message as zstring)
declare sub expectStrNot cdecl (byref result as zstring, byref expected as zstring, byref message as zstring)
declare sub expectPtr cdecl (result as any ptr, expected as any ptr, byref message as zstring)
declare sub expectPtrNot cdecl (result as any ptr, expected as any ptr, byref message as zstring)
declare sub _done cdecl ()

end namespace

