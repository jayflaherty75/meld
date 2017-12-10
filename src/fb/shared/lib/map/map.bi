#include once "../../../../../modules/headers/map/map-v1.bi"

namespace Map

declare function load (corePtr as Core.Interface ptr) as integer
declare sub unload()
declare function register() as integer
declare sub unregister()
declare function construct(byref id as zstring) as MapObj ptr
declare sub destruct (mapPtr as MapObj ptr)

end namespace
