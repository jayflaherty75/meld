
#include once "../../modules/headers/core/core-v1.bi"

#IFDEF __FB_WIN32__
	#define CORE_MODULE		"modules\\core.dll"
#ELSE
	#define CORE_MODULE		"modules/core.so"
#ENDIF

dim as Core.Interface _core
dim as zstring*64 Config = command(1)
dim as string filename = CORE_MODULE
dim as any ptr library

if not fileexists(filename) then
	print("**** Missing module: " & filename)
	end(1)
end if

library = dylibload (filename)

if library = NULL then
	print("**** Failed to core module")
	end(1)
end if
