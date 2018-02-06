
#include once "../../../../../modules/headers/default/default-v1.bi"

dim shared _console as Console.Interface ptr
dim shared _fault as Fault.Interface ptr
dim shared _errorHandling as ErrorHandling.Interface ptr

type ModuleStateType
	methods as Default.Interface
	isLoaded as short
	references as integer
	startups as integer
end type

type ErrorCodes
	generalError as integer
end type

dim shared as ModuleStateType moduleState
dim shared as ErrorCodes errors

namespace Default

declare function startup cdecl () as short
declare function shutdown cdecl () as short

end namespace
