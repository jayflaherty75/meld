
#ifndef MODULE_MAX_ENTRIES
#define MODULE_MAX_ENTRIES		2048
#endif

#include once "../../../../../modules/headers/module/module-v1.bi"
#include once "file.bi"

#IFDEF __FB_WIN32__
	#define EXTERNAL_MODULE_EXTENSION		"dll"
	#define DIR_SEP							!"\\"
#ELSE
	#define EXTERNAL_MODULE_EXTENSION		"so"
	#define DIR_SEP							"/"
#ENDIF

namespace Module

declare sub initialize cdecl()
declare function exports cdecl (byref moduleName as zstring, interface as any ptr) as short
declare function require cdecl (byref moduleName as zstring) as any ptr
declare sub setHandlers cdecl (setEntry as SetEntryFnc = NULL, getEntry as GetEntryFnc)
declare function test cdecl (value as short) as short

declare function _getEntryDefault (byref moduleName as zstring) as Entry ptr

end namespace
