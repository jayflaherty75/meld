#include once "../../../../../modules/headers/map/map-v1.bi"

namespace Map

declare function load (corePtr as Core.Interface ptr) as integer
declare sub unload()
declare function register() as integer
declare sub unregister()
declare function construct(byref id as zstring) as MapObj ptr
declare sub destruct (mapPtr as MapObj ptr)

declare function assign (mapPtr as MapObj ptr, byref mapping as zstring) as Location ptr
declare function request (mapPtr as MapObj ptr, byref mapping as zstring) as Location ptr
declare function reference (mapPtr as MapObj ptr, loc as Location ptr) as zstring ptr
declare sub unassign (mapPtr as MapObj ptr, byref mapping as zstring)

end namespace
