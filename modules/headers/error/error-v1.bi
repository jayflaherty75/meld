
#include once "../constants/constants-v1.bi"
#include once "../meld/meld-v1.bi"

#define ERROR_NAME_MAX_LENGTH               32

namespace Fault

type Header
	name as zstring*ERROR_NAME_MAX_LENGTH
	code as uinteger
end type

type Handler as sub(errName as zstring ptr, byref message as string, filename as zstring ptr, lineNum as integer)

type Interface
	initialize as function (mutexId as any ptr) as integer
	uninitialize as sub()
	registerType as function (errName as zstring ptr) as integer
	assignHandler as function (errCode as integer, handler as Fault.Handler) as integer
	getCode as function (errName as zstring ptr) as integer
	throw as sub (_
		errName as zstring ptr, _
		errCode as integer, _
		byref message as string, _
		filename as zstring ptr, _
		linenum as integer _	
	)
end type

end namespace