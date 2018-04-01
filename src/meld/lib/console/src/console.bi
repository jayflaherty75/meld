
/'
' Generated by Meld Framework, do not modify.  Any changes will be overwritten
' during the next build.
'/

#include once "headers/module_v0.1.0.bi"
#include once "headers/fault_v0.1.0.bi"
#include once "headers/sys_v0.1.0.bi"
#include once "headers/console_v0.1.0.bi"

#define NULL 0

dim shared _module as Module.Interface ptr
dim shared _console as Console.Interface ptr
dim shared _fault as Fault.Interface ptr
dim shared _sys as Sys.Interface ptr

type ModuleStateType
	methods as Console.Interface
	isLoaded as short
	isStarted as short
end type

dim shared as ModuleStateType moduleState

namespace Console

declare function startup cdecl () as short
declare function shutdown cdecl () as short
declare sub logMessage cdecl (byref message as zstring)
declare sub logWarning cdecl (byref id as zstring, byref message as zstring, byref source as zstring, lineNum as integer)
declare sub logError cdecl (byref id as zstring, byref message as zstring, byref source as zstring, lineNum as integer)
declare sub logSuccess cdecl (byref id as zstring, byref message as zstring, byref source as zstring, lineNum as integer)
declare function _format cdecl (byref id as zstring, byref message as zstring, byref source as zstring, lineNum as integer) as string

end namespace
