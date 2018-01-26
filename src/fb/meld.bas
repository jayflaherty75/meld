
#include once "../../modules/headers/core/core-v1.bi"
#include once "file.bi"

#IFDEF __FB_WIN32__
	#define CORE_MODULE		"modules\\core.dll"
#ELSE
	#define CORE_MODULE		"modules/core.so"
#ENDIF

function main() As Integer
	dim as Core.Interface _core
	dim as zstring*64 config = command(1)
	dim as string filename = CORE_MODULE
	dim as any ptr library

	if not fileexists(filename) then
		print("**** Missing module: " & filename)
		return 1
	end if

	library = dylibload (filename)

	if library = NULL then
		print("**** Failed to core module")
		return 1
	end if

	' TODO: This message is temporary and must be removed
	print("Core library loaded successfully: " + config)

	return 0
end function

end main()
