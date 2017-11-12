
#define ERROR_NAME_MAX_LENGTH               32
#define ERROR_MESSAGE_DEFAULT_LENGTH        64
#define ERROR_MAX_TYPES                     256

type BaseErrorHeader
    name as zstring*ERROR_NAME_MAX_LENGTH
    code as uinteger
end type

type ErrorMessage
    info as BaseErrorHeader
    lineNum as integer
    filename as zstring ptr
    dataPtr as any ptr
    message as zstring*ERROR_MESSAGE_DEFAULT_LENGTH
end type
