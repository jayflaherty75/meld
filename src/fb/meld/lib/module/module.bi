
#ifndef MODULE_MAX_ENTRIES
#define MODULE_MAX_ENTRIES		32768
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
declare function require cdecl (byref moduleName as zstring) as any ptr
declare function argv cdecl (index as ulong) as zstring ptr
declare function argc cdecl () as long

end namespace
