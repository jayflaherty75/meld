
#include once "../../../../../modules/headers/fault/fault-v1.bi"

namespace Fault

declare function load (corePtr as Core.Interface ptr) as integer
declare sub unload ()

declare function registerType (byref errName as zstring) as integer
declare function assignHandler (errCode as integer, handler as Fault.Handler) as integer
declare function getCode (byref errName as zstring) as integer
declare sub throw (_
	errCode as integer, _
	byref errName as zstring, _
	byref message as string, _
	byref filename as zstring, _
	linenum as integer _	
)
declare sub defaultFatalHandler (byref errName as zstring, byref message as string, byref filename as zstring, lineNum as integer)
declare sub defaultErrorHandler (byref errName as zstring, byref message as string, byref filename as zstring, lineNum as integer)
declare sub defaultWarningHandler (byref errName as zstring, byref message as string, byref filename as zstring, lineNum as integer)

end namespace
