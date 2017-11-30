
#include once "../../../../../modules/headers/console/console-v1.bi"

namespace Console

declare function load (meld as MeldInterface ptr) as integer
declare sub unload()
declare sub logMessage (byref id as zstring, byref message as string, byref source as zstring, lineNum as integer)
declare sub logWarning (byref id as zstring, byref message as string, byref source as zstring, lineNum as integer)
declare sub logError (byref id as zstring, byref message as string, byref source as zstring, lineNum as integer)
declare sub logSuccess (byref id as zstring, byref message as string, byref source as zstring, lineNum as integer)

end namespace
