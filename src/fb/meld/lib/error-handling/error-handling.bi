
/'
' Generated by Meld Framework, do not modify.  Any changes will be overwritten
' during the next build.
'/

#include once "../../../../../modules/headers/error-handling/error-handling-v1.bi"

dim shared _module as Module.Interface ptr
dim shared _errorhandling as Errorhandling.Interface ptr
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
declare sub _assignHandler cdecl (_fault as Fault.Interface ptr, errCodePtr as integer ptr, byref errName as zstring, handler as Fault.handler)

end namespace

