
/'
 ' Generated by Meld Framework, do not modify.  Any changes will be overwritten
 ' during the next build.
 '/

#include once "headers/module_v0.1.0.bi"
#include once "headers/console_v0.1.0.bi"
#include once "headers/fault_v0.1.0.bi"
#include once "headers/error-handling_v0.1.0.bi"

#define NULL 0

dim shared _module as Module.Interface ptr
dim shared _errorHandling as ErrorHandling.Interface ptr
dim shared _console as Console.Interface ptr
dim shared _fault as Fault.Interface ptr

type ModuleStateType
	methods as ErrorHandling.Interface
	isLoaded as short
	isStarted as short
end type

dim shared as ModuleStateType moduleState

namespace ErrorHandling

declare function startup cdecl () as short
declare function shutdown cdecl () as short
declare sub _assignHandler cdecl (_fault as Fault.Interface ptr, errCodePtr as integer ptr, errName as zstring ptr, handler as Fault.handler)

end namespace

