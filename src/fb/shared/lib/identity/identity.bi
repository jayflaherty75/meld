
/'
' Generated by Meld Framework, do not modify.  Any changes will be overwritten
' during the next build.
'/

#include once "../../../../../modules/headers/identity/identity-v1.bi"

dim shared _moduleLocal as Module.Interface
dim shared _module as Module.Interface ptr
dim shared _identity as Identity.Interface ptr
dim shared _console as Console.Interface ptr
dim shared _fault as Fault.Interface ptr
dim shared _errorHandling as ErrorHandling.Interface ptr
dim shared _tester as Tester.Interface ptr

type ModuleStateType
	methods as Identity.Interface
	isLoaded as short
	references as integer
	startups as integer
end type

dim shared as ModuleStateType moduleState

namespace Identity

declare function startup cdecl () as short
declare function shutdown cdecl () as short
declare function test cdecl (describeFn as Tester.describeCallback) as short

end namespace

