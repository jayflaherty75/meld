
#include once "../../../../../modules/headers/console/console-v1.bi"

namespace Console

declare function load (corePtr as Core.Interface ptr) as integer
declare sub unload()
declare function register() as integer
declare sub unregister()
declare sub logMessage (byref message as string)
declare sub logWarning (byref id as zstring, byref message as string, byref source as zstring, lineNum as integer)
declare sub logError (byref id as zstring, byref message as string, byref source as zstring, lineNum as integer)
declare sub logSuccess (byref id as zstring, byref message as string, byref source as zstring, lineNum as integer)

end namespace
