
#define ERROR_NAME_MAX_LENGTH               32

type ErrorHeader
	name as zstring*ERROR_NAME_MAX_LENGTH
	code as uinteger
end type

type ErrorHandler as sub(errName as zstring ptr, byref message as string, filename as zstring ptr, lineNum as integer)

type ErrorInterface
	initialize as function (mutexId as any ptr) as integer
	uninitialize as sub()
	registerType as function (errName as zstring ptr) as integer
	assignHandler as function (errCode as integer, handler as ErrorHandler) as integer
	getCode as function (errName as zstring ptr) as integer
	throw as sub (_
		errName as zstring ptr, _
		errCode as integer, _
		byref message as string, _
		filename as zstring ptr, _
		linenum as integer _	
	)
end type
