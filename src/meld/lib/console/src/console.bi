
/'
' Generated by Meld Framework, do not modify.  Any changes will be overwritten
' during the next build.
'/

#include once "../../../../../modules/headers/console/console-v1.bi"

#define NULL 0

dim shared _module as Module.Interface ptr
dim shared _console as Console.Interface ptr

type ModuleStateType
	methods as Console.Interface
	isLoaded as short
	isStarted as short
end type

dim shared as ModuleStateType moduleState

namespace Console


end namespace

