
#include once "../../../../../modules/headers/identity/identity-v1.bi"

namespace Identity

declare function load (corePtr as Core.Interface ptr) as integer
declare sub unload()

declare function construct() as IdentityObj ptr
declare sub destruct(idPtr as IdentityObj ptr)

declare function request (idPtr as IdentityObj ptr, byref identifier as zstring) as integer

end namespace
