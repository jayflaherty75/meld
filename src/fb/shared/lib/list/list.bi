
#include once "../../../../../modules/headers/list/list-v1.bi"

namespace List

declare function load (corePtr as Core.Interface ptr) as integer
declare sub unload()
declare function register() as integer
declare sub unregister()
declare function construct() as ListObj ptr
declare sub destruct (listPtr as ListObj ptr)

declare function insert (listPtr as ListObj ptr, element as any ptr, nodePtr as List.Node ptr = NULL) as List.Node ptr
declare sub remove (listPtr as ListObj ptr, node as List.Node ptr)
declare function getFirst (listPtr as ListObj ptr) as List.Node ptr
declare function getLast (listPtr as ListObj ptr) as List.Node ptr
declare function getNext (listPtr as ListObj ptr, node as List.Node ptr) as List.Node ptr
declare function getLength (listPtr as ListObj ptr) as integer
declare function search (listPtr as ListObj ptr, element as any ptr, compare as function(criteria as any ptr, current as any ptr) as integer) as List.Node ptr
declare function defaultCompare (criteria as any ptr, current as any ptr) as integer
declare function getIterator (listPtr as ListObj ptr) as IteratorObj ptr

end namespace
