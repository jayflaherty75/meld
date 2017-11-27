
#include once "../iterator/iterator.bi"
#include once "../../../../../modules/headers/bst/bst-v1.bi"

namespace Bst

declare function construct() as BstObj ptr
declare sub destruct (btreePtr as BstObj ptr)
declare function insert (btreePtr as BstObj ptr, element as any ptr, start as Bst.Node ptr = NULL) as Bst.Node ptr
declare function search (btreePtr as BstObj ptr, element as any ptr, start as Bst.Node ptr = NULL) as Bst.Node ptr
declare function getLength (btreePtr as BstObj ptr) as integer
declare function getIterator (btreePtr as BstObj ptr) as IteratorObj ptr
declare function defaultCompare(criteria as any ptr, element as any ptr) as integer

end namespace
