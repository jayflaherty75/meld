
#ifndef MODULE_MAX_ENTRIES
#define MODULE_MAX_ENTRIES		4096
#endif

#include once "headers/meld_v0.1.0/module.bi"
#include once "headers/module_v0.1.0/module.bi"
#include once "file.bi"

#IFDEF __FB_WIN32__
	#define EXTERNAL_MODULE_EXTENSION		"dll"
	#define DIR_SEP							!"\\"
	#define NEW_LINE						!"\r\n"
#ELSE
	#define EXTERNAL_MODULE_EXTENSION		"so"
	#define DIR_SEP							"/"
	#define NEW_LINE						!"\n"
#ENDIF

#define NULL	0

namespace Module

declare function initialize cdecl(argc as integer, argv as any ptr) as short
declare function uninitialize cdecl() as short
declare sub setModuleWillLoad cdecl (handler as ModuleWillLoadFn)
declare sub setModuleHasUnloaded cdecl (handler as ModuleHasUnloadedFn)
declare function require cdecl (moduleName as zstring ptr) as any ptr
declare function unload cdecl (moduleName as zstring ptr) as short
declare function testModule cdecl (moduleName as zstring ptr) as short
declare function argv cdecl (index as ulong) as zstring ptr
declare function argc cdecl () as long
declare function _findEntry(moduleName as zstring ptr) as LibraryEntry ptr
declare function _defaultPreloadHandler cdecl (entryPtr as any ptr) as short
declare function _defaultUnloadHandler cdecl (entryPtr as any ptr) as short

end namespace
