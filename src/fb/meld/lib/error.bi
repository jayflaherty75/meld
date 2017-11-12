
#include once "../../../../modules/headers/meld/error.bi"

type ErrorState
    mutexId as any ptr
    errors(ERROR_MAX_TYPES) as BaseErrorHeader
    errorCount as uinteger
end type

dim shared as ErrorState errState

declare function errorInitialize (mutexId as any ptr) as integer
declare sub errorUninitialize()

declare function errorNew (_
    errCode as integer, _
    byref message as string, _
    filename as zstring ptr, _
    linenum as integer _
) as ErrorMessage ptr
declare sub errorDelete (errMsg as ErrorMessage ptr)

declare function errorRegisterHandler (byref errName as zstring, handler as sub(err as ErrorMessage ptr)) as integer
declare function errorGetCode (byref errName as zstring) as integer

function errorInitialize (mutexId as any ptr) as integer
    return 0
end function

sub errorUninitialize()
end sub

function errorNew (errCode as integer, byref message as string, filename as zstring ptr, linenum as integer) as ErrorMessage ptr
    return NULL
end function

sub errorDelete (errMsg as ErrorMessage ptr)
end sub

function errorRegisterHandler (byref errName as zstring, handler as sub(err as ErrorMessage ptr)) as integer
    return 0
end function

function errorGetCode (byref errName as zstring) as integer
    return 0
end function
