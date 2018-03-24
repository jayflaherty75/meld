
/'
' Generated by Meld Framework, do not modify.  Any changes will be overwritten
' during the next build.
'/

#include once "../../../../../modules/headers/default/default-v1.bi"

dim shared _module as Module.Interface ptr
dim shared _default as Default.Interface ptr
dim shared _sys as Sys.Interface ptr
dim shared _console as Console.Interface ptr
dim shared _fault as Fault.Interface ptr
dim shared _errorHandling as ErrorHandling.Interface ptr
dim shared _tester as Tester.Interface ptr

type ModuleStateType
	methods as Default.Interface
	isLoaded as short
	isStarted as short
end type

type ErrorCodes
	generalError as integer
end type

dim shared as ModuleStateType moduleState
dim shared as ErrorCodes errors

namespace Default

declare function startup cdecl () as short
declare function shutdown cdecl () as short
declare function update cdecl (instancePtr as any ptr) as short
declare function test cdecl (describe as Tester.describeCallback) as short

end namespace

