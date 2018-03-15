
#ifndef MODULE_MAX_ENTRIES
#define MODULE_MAX_ENTRIES		4096
#endif

#include once "../../../../../modules/headers/meld/meld-v1.bi"
#include once "file.bi"

#IFDEF __FB_WIN32__
	#define EXTERNAL_MODULE_EXTENSION		"dll"
	#define DIR_SEP							!"\\"
#ELSE
	#define EXTERNAL_MODULE_EXTENSION		"so"
	#define DIR_SEP							"/"
#ENDIF

namespace Module

declare function initialize cdecl(argc as integer, argv as any ptr) as short
declare function uninitialize cdecl() as short
declare sub setModuleWillLoad cdecl (handler as ModuleWillLoadFn)
declare sub setModuleHasUnloaded cdecl (handler as ModuleHasUnloadedFn)
declare function require cdecl (byref moduleName as zstring) as any ptr
declare function argv cdecl (index as ulong) as zstring ptr
declare function argc cdecl () as long
declare function _defaultPreloadHandler cdecl (entryPtr as any ptr) as short
declare function _defaultUnloadHandler cdecl (entryPtr as any ptr) as short

end namespace
