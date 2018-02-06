
#include once "../../../../../modules/headers/fault/fault-v1.bi"

dim shared _console as Console.Interface ptr

namespace Fault

declare function startup cdecl () as short
declare function shutdown cdecl () as short
declare function registerType cdecl (byref errName as zstring) as short
declare function assignHandler cdecl (errCode as short, handler as Handler) as short
declare function getCode cdecl (byref errName as zstring) as short
declare sub throw cdecl (_
	errCode as integer, _
	byref errName as zstring, _
	byref message as zstring, _
	byref filename as zstring, _
	linenum as integer _	
)
declare sub defaultFatalHandler (byref errName as zstring, byref message as zstring, byref filename as zstring, lineNum as integer)
declare sub defaultErrorHandler (byref errName as zstring, byref message as zstring, byref filename as zstring, lineNum as integer)
declare sub defaultWarningHandler (byref errName as zstring, byref message as zstring, byref filename as zstring, lineNum as integer)

end namespace
