
#include once "../../../../../modules/headers/bst/bst-v1.bi"

namespace Bst

declare function load cdecl alias "load" (byval corePtr as Core.Interface ptr) as integer
declare sub unload cdecl alias "unload" ()
declare function register() as integer
declare sub unregister()
declare function construct(byref id as zstring) as BstObj ptr
declare sub destruct (btreePtr as BstObj ptr)

declare function insert (btreePtr as BstObj ptr, element as any ptr) as Bst.Node ptr
declare sub remove (btreePtr as Bst.Instance ptr, nodePtr as Bst.Node ptr)
declare sub purge (btreePtr as Bst.Instance ptr)
declare function search (btreePtr as BstObj ptr, element as any ptr, start as Bst.Node ptr = NULL) as Bst.Node ptr
declare function getLength (btreePtr as BstObj ptr) as integer
declare function getIterator (btreePtr as BstObj ptr) as IteratorObj ptr
declare function defaultCompare(criteria as any ptr, element as any ptr) as integer

end namespace

function moduleLoader cdecl alias "moduleLoader" (byval corePtr as Core.Interface ptr) as integer export
	return Bst.load(corePtr)
end function
