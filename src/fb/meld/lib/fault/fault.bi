
/'
' Generated by Meld Framework, do not modify.  Any changes will be overwritten
' during the next build.
'/

#include once "../../../../../modules/headers/fault/fault-v1.bi"

dim shared _fault as Fault.Interface ptr
dim shared _console as Console.Interface ptr

type ModuleStateType
	methods as Fault.Interface
	isLoaded as short
	references as integer
	startups as integer
end type

type ErrorCodes
	internalSystemError as integer
end type

dim shared as ModuleStateType moduleState
dim shared as ErrorCodes errors

namespace Fault

declare function startup cdecl () as short
declare function shutdown cdecl () as short
declare function registerType cdecl (byref errName as zstring) as short
declare function assignHandler cdecl (errCode as short, handler as Handler) as short
declare function getCode cdecl (errName as zstring) as short
declare sub throw cdecl (errCode as integer, errName as zstring, message as zstring, filename as zstring, lineNum as integer)
declare sub defaultFatalHandler cdecl (byref errName as zstring, byref message as zstring, byref filename as zstring, lineNum as integer)
declare sub defaultErrorHandler cdecl (byref errName as zstring, byref message as zstring, byref filename as zstring, lineNum as integer)
declare sub defaultWarningHandler cdecl (byref errName as zstring, byref message as zstring, byref filename as zstring, lineNum as integer)

end namespace

