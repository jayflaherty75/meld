
#include once "../../../../../modules/headers/iterator/iterator-v1.bi"

type IteratorHandler as function (iter as IteratorObj ptr, target as any ptr) as integer

namespace Iterator

declare function load cdecl alias "load" (byval corePtr as Core.Interface ptr) as integer
declare sub unload cdecl alias "unload" ()
declare function register() as integer
declare sub unregister()
declare function construct(dataSet as any ptr = NULL, length as integer = -1) as IteratorObj ptr
declare sub destruct (iter as IteratorObj ptr)

declare sub setHandler (iter as IteratorObj ptr, cb as IteratorHandler)
declare sub setData (iter as IteratorObj ptr, dataSet as any ptr, length as integer = -1)
declare function getNext (iter as IteratorObj ptr, target as any ptr) as integer
declare sub reset (iter as IteratorObj ptr)

end namespace
