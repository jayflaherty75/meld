
#include once "../constants/constants-v1.bi"
#include once "../meld/meld-v1.bi"
#include once "../console/console-v1.bi"

#define ERROR_NAME_MAX_LENGTH               32

namespace Fault

type Header
	name as zstring*ERROR_NAME_MAX_LENGTH
	code as uinteger
end type

type Handler as sub(byref errName as zstring, byref message as string, byref filename as zstring, lineNum as integer)

type Interface
	load as function (meld as MeldInterface ptr) as integer
	unload as sub ()
	registerType as function (byref errName as zstring) as integer
	assignHandler as function (errCode as integer, handler as Fault.Handler) as integer
	getCode as function (byref errName as zstring) as integer
	throw as sub (_
		byref errName as zstring, _
		errCode as integer, _
		byref message as string, _
		byref filename as zstring, _
		linenum as integer _	
	)
end type

end namespace