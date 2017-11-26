
#include once "../../../../modules/headers/constants/constants-v1.bi"
#include once "../../../../modules/headers/identity/identity-v1.bi"

namespace Identity

declare function load (meld as MeldInterface ptr) as integer
declare function construct() as Identity ptr
declare sub destruct(idPtr as Identity ptr)
declare sub unload()

declare function request (byref identifier as zstring)

end namespace
