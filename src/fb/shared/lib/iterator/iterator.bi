
#include once "../../../../../modules/headers/iterator/iterator-v1.bi"

type IteratorHandler as function (iter as IteratorObj ptr, target as any ptr) as integer

namespace Iterator

declare function load (meld as MeldInterface ptr) as integer
declare sub unload()

declare function construct(dataSet as any ptr = NULL, length as integer = -1) as IteratorObj ptr
declare sub destruct (iter as IteratorObj ptr)

declare sub setHandler (iter as IteratorObj ptr, cb as IteratorHandler)
declare sub setData (iter as IteratorObj ptr, dataSet as any ptr, length as integer = -1)
declare function getNext (iter as IteratorObj ptr, target as any ptr) as integer
declare sub reset (iter as IteratorObj ptr)

end namespace
