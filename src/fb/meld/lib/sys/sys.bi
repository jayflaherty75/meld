
/'
' Generated by Meld Framework, do not modify.  Any changes will be overwritten
' during the next build.
'/

#include once "../../../../../modules/headers/sys/sys-v1.bi"

dim shared _moduleLocal as Module.Interface
dim shared _module as Module.Interface ptr
dim shared _sys as Sys.Interface ptr

type ModuleStateType
	methods as Sys.Interface
	isLoaded as short
	references as integer
	startups as integer
end type

dim shared as ModuleStateType moduleState

namespace Sys

declare function startup cdecl () as short
declare function shutdown cdecl () as short
declare function getNewline cdecl () as zstring ptr
declare function getDirsep cdecl () as zstring ptr
declare function getModuleExt cdecl () as zstring ptr

end namespace

