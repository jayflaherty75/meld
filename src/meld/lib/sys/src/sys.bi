
/'
' Generated by Meld Framework, do not modify.  Any changes will be overwritten
' during the next build.
'/

#include once "headers/sys_v0.1.0.bi"

#define NULL 0

dim shared _module as Module.Interface ptr
dim shared _sys as Sys.Interface ptr
dim shared _semVer as SemVer.Interface ptr

type ModuleStateType
	methods as Sys.Interface
	isLoaded as short
	isStarted as short
end type

dim shared as ModuleStateType moduleState

namespace Sys

declare function startup cdecl () as short
declare function shutdown cdecl () as short
declare function getNewline cdecl () as zstring ptr
declare function getDirsep cdecl () as zstring ptr
declare function getModuleExt cdecl () as zstring ptr
declare function getTimestamp cdecl () as ulongint
declare sub getMacAddress cdecl (byref addr as zstring)
declare sub _loadMacAddress cdecl ()
declare sub _readFileLine cdecl (byref directory as zstring, byref filename as zstring, byref result as string)
declare function _isMacAddress cdecl (byref addr as zstring) as short

end namespace
