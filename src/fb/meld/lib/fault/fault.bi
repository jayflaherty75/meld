
#include once "../../../../../modules/headers/fault/fault-v1.bi"

namespace Fault

declare function load (meldPtr as MeldInterface ptr) as integer
declare sub unload ()

declare function initialize (mutexId as any ptr) as integer
declare sub uninitialize()

declare function registerType (errName as zstring ptr) as integer
declare function assignHandler (errCode as integer, handler as Fault.Handler) as integer
declare function getCode (errName as zstring ptr) as integer
declare sub throw (_
	errName as zstring ptr, _
	errCode as integer, _
	byref message as string, _
	filename as zstring ptr, _
	linenum as integer _	
)

end namespace
