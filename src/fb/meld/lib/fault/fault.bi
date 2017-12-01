
#include once "../../../../../modules/headers/fault/fault-v1.bi"

namespace Fault

declare function load (corePtr as Core.Interface ptr) as integer
declare sub unload ()

declare function registerType (byref errName as zstring) as integer
declare function assignHandler (errCode as integer, handler as Fault.Handler) as integer
declare function getCode (byref errName as zstring) as integer
declare sub throw (_
	byref errName as zstring, _
	errCode as integer, _
	byref message as string, _
	byref filename as zstring, _
	linenum as integer _	
)

end namespace
