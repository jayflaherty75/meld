
#include once "../../../../../modules/headers/console/console-v1.bi"
#include once "module.bi"

namespace Console

declare sub logMessage (byref message as string)
declare sub logWarning (byref id as zstring, byref message as string, byref source as zstring, lineNum as integer)
declare sub logError (byref id as zstring, byref message as string, byref source as zstring, lineNum as integer)
declare sub logSuccess (byref id as zstring, byref message as string, byref source as zstring, lineNum as integer)

declare function _format (byref id as zstring, byref message as string, byref source as zstring, lineNum as integer) as string

end namespace
