
#include once "../constants/constants-v1.bi"
#include once "../module/module-v1.bi"

namespace Console

type Interface
	logMessage as sub cdecl (byref message as zstring)
	logWarning as sub cdecl (byref id as zstring, byref message as zstring, byref source as zstring, lineNum as integer)
	logError as sub cdecl (byref id as zstring, byref message as zstring, byref source as zstring, lineNum as integer)
	logSuccess as sub cdecl (byref id as zstring, byref message as zstring, byref source as zstring, lineNum as integer)
end type

end namespace
