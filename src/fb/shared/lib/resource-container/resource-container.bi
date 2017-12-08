
#include once "../../../../../modules/headers/resource-container/resource-container-v1.bi"

namespace ResourceContainer

declare function load (corePtr as Core.Interface ptr) as integer
declare sub unload()
declare function register() as integer
declare sub unregister()
declare function construct (byref id as zstring, size as integer, pageLength as integer, warnLimit as integer) as ResourceContainerObj ptr
declare sub destruct (idPtr as ResourceContainerObj ptr)

declare function request (contPtr as ResourceContainerObj ptr) as integer
declare function release (contPtr as ResourceContainerObj ptr, resourceId as integer) as integer
declare function getPtr (contPtr as ResourceContainerObj ptr, resourceId as integer) as any ptr

end namespace
