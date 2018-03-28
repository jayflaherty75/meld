
/'
' Generated by Meld Framework, do not modify.  Any changes will be overwritten
' during the next build.
'/

#include once "headers/module_v0.1.0.bi"
#include once "headers/console_v0.1.0.bi"
#include once "headers/fault_v0.1.0.bi"
#include once "headers/error-handling_v0.1.0.bi"
#include once "headers/tester_v0.1.0.bi"
#include once "headers/sys_v0.1.0.bi"
#include once "headers/identity_v0.1.0.bi"

#define NULL 0

dim shared _module as Module.Interface ptr
dim shared _identity as Identity.Interface ptr
dim shared _console as Console.Interface ptr
dim shared _fault as Fault.Interface ptr
dim shared _errorHandling as ErrorHandling.Interface ptr
dim shared _tester as Tester.Interface ptr
dim shared _sys as Sys.Interface ptr

type ModuleStateType
	methods as Identity.Interface
	isLoaded as short
	isStarted as short
end type

type ErrorCodes
	nullReferenceError as integer
	resourceAllocationError as integer
end type

dim shared as ModuleStateType moduleState
dim shared as ErrorCodes errors

namespace Identity

declare function startup cdecl () as short
declare function shutdown cdecl () as short
declare function test cdecl (describeFn as any ptr) as short
declare function construct cdecl () as Identity.Instance ptr
declare sub destruct cdecl (idPtr as Identity.Instance ptr)
declare function getAutoInc cdecl (idPtr as Identity.Instance ptr) as ulong
declare function generate cdecl () as Unique
declare sub encode cdecl (id as Unique ptr, dest as Encoded ptr)
declare sub decode cdecl (source as Encoded ptr, id as Unique ptr)
declare sub _reverseByteOrder cdecl (dest as ubyte ptr, source as ubyte ptr, length as long)
declare sub _mapEncoding cdecl (index as ubyte, ascii as ubyte)
declare sub _generateEncodeMapping cdecl ()
declare sub _generateBinDistMapping cdecl ()
declare function _convertMacAddress cdecl (byref source as zstring) as ulongint
declare function _convertHex cdecl (byref char as zstring) as ubyte
declare sub _copy cdecl (source as ubyte ptr, dest as ubyte ptr, length as long)

end namespace

