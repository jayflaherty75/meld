
#include once "../../../../../modules/headers/console/console-v1.bi"

namespace Console

declare sub logMessage cdecl (byref message as zstring)
declare sub logWarning cdecl (byref id as zstring, byref message as zstring, byref source as zstring, lineNum as integer)
declare sub logError cdecl (byref id as zstring, byref message as zstring, byref source as zstring, lineNum as integer)
declare sub logSuccess cdecl (byref id as zstring, byref message as zstring, byref source as zstring, lineNum as integer)

declare function _format (byref id as zstring, byref message as zstring, byref source as zstring, lineNum as integer) as string

end namespace
