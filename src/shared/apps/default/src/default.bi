
/'
' Generated by Meld Framework, do not modify.  Any changes will be overwritten
' during the next build.
'/

#include once "headers/module_v0.1.0.bi"
#include once "headers/sys_v0.1.0.bi"
#include once "headers/console_v0.1.0.bi"
#include once "headers/fault_v0.1.0.bi"
#include once "headers/error-handling_v0.1.0.bi"
#include once "headers/tester_v0.1.0.bi"
#include once "headers/default_v0.1.0.bi"

#define NULL 0

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
declare function test cdecl (describeFn as any ptr) as short

end namespace

