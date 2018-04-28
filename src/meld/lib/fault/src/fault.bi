
/'
 ' Generated by Meld Framework, do not modify.  Any changes will be overwritten
 ' during the next build.
 '/

#include once "headers/module_v0.1.0.bi"
#include once "headers/console_v0.1.0.bi"
#include once "headers/fault_v0.1.0.bi"

#define NULL 0

dim shared _module as Module.Interface ptr
dim shared _fault as Fault.Interface ptr
dim shared _console as Console.Interface ptr

type ModuleStateType
	methods as Fault.Interface
	isLoaded as short
	isStarted as short
end type

type ErrorCodes
	internalSystemError as integer
end type

dim shared as ModuleStateType moduleState
dim shared as ErrorCodes errors

namespace Fault

declare function startup cdecl () as short
declare function shutdown cdecl () as short
declare function registerType cdecl (errName as zstring ptr) as short
declare function assignHandler cdecl (errCode as short, handler as Handler) as short
declare function getCode cdecl (errName as zstring ptr) as short
declare sub throw cdecl (errCode as integer, errName as zstring ptr, message as zstring ptr, filename as zstring ptr, lineNum as integer)
declare sub defaultFatalHandler cdecl (errName as zstring ptr, message as zstring ptr, filename as zstring ptr, lineNum as integer)
declare sub defaultErrorHandler cdecl (errName as zstring ptr, message as zstring ptr, filename as zstring ptr, lineNum as integer)
declare sub defaultWarningHandler cdecl (errName as zstring ptr, message as zstring ptr, filename as zstring ptr, lineNum as integer)

end namespace

