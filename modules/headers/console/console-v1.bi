
#include once "../constants/constants-v1.bi"
#include once "../meld/meld-v1.bi"

namespace Console

type Interface
	load as function (meld as MeldInterface ptr) as integer
	unload as sub()
	logMessage as sub (byref id as zstring, byref message as string, byref source as zstring, lineNum as integer)
	logWarning as sub (byref id as zstring, byref message as string, byref source as zstring, lineNum as integer)
	logError as sub (byref id as zstring, byref message as string, byref source as zstring, lineNum as integer)
	logSuccess as sub (byref id as zstring, byref message as string, byref source as zstring, lineNum as integer)
end type

end namespace
