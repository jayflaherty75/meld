
#include once "../../../../../modules/headers/template/template-v1.bi"
#include once "../../../../../modules/headers/fault/fault-v1.bi"

namespace Template

declare function load (corePtr as Core.Interface ptr) as integer
declare sub unload()
declare function register() as integer
declare sub unregister()
declare function construct(byref id as zstring) as TemplateObj ptr
declare sub destruct (templatePtr as TemplateObj ptr)


end namespace
