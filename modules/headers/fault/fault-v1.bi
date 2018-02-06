
#include once "../constants/constants-v1.bi"
#include once "../module/module-v1.bi"
#include once "../console/console-v1.bi"

namespace Fault

type Header
	name as zstring*64
	code as ushort
end type

type Handler as sub cdecl (byref errName as zstring, byref message as zstring, byref filename as zstring, lineNum as integer)

type Interface
	startup as function cdecl () as short
	shutdown as function cdecl () as short
	registerType as function cdecl (byref errName as zstring) as short
	assignHandler as function cdecl (errCode as short, handler as Handler) as short
	getCode as function cdecl (errName as zstring) as short
	throw as sub cdecl (errCode as integer, errName as zstring, message as zstring, filename as zstring, lineNum as integer)
	defaultFatalHandler as sub cdecl (byref errName as zstring, byref message as zstring, byref filename as zstring, lineNum as integer)
	defaultErrorHandler as sub cdecl (byref errName as zstring, byref message as zstring, byref filename as zstring, lineNum as integer)
	defaultWarningHandler as sub cdecl (byref errName as zstring, byref message as zstring, byref filename as zstring, lineNum as integer)
end type

end namespace
