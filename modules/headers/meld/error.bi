
#define ERROR_NAME_MAX_LENGTH               32
#define ERROR_MESSAGE_DEFAULT_LENGTH        64
#define ERROR_MAX_TYPES                     256

type ErrorHeader
	name as zstring*ERROR_NAME_MAX_LENGTH
	code as uinteger
end type

type ErrorData
	lineNum as integer
	filename as zstring ptr
	dataPtr as any ptr
end type

type ErrorMessage
	info as ErrorHeader
	trace as ErrorData
	message as zstring*ERROR_MESSAGE_DEFAULT_LENGTH
end type

type ErrorHandler as sub(errName as zstring ptr, byref message as string, filename as zstring ptr, lineNum as integer)
