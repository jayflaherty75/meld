
#include once "../../../../modules/headers/meld/error.bi"

type ErrorState
	mutexId as any ptr
	errors(ERROR_MAX_TYPES) as ErrorHeader
	errorCount as uinteger
	handlers(ERROR_MAX_TYPES) as ErrorHandler
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

declare function errorRegisterType (errName as zstring ptr) as integer
declare function errorRegisterHandler (errName as zstring ptr, handler as ErrorHandler) as integer
declare function errorGetCode (errName as zstring ptr) as integer

declare sub _errorClearHandlers()

/''
 '
 '/
function errorInitialize (mutexId as any ptr) as integer
	errState.mutexId = mutexId
	errState.errorCount = 0

	return TRUE
end function

/''
 '
 '/
sub errorUninitialize()
	_errorClearHandlers()

	errState.mutexId = NULL
end sub

/''
 '
 '/
function errorNew (errCode as integer, byref message as string, filename as zstring ptr, linenum as integer) as ErrorMessage ptr
	dim as integer msgLen = sizeof(errorHeader) + sizeof(errorData) + len(message)
	dim as ErrorMessage ptr errObj

	mutexlock (errState.mutexId)

	if errState.errors(errCode).code = errCode ANDALSO errCode < ERROR_MAX_TYPES then
		errObj = allocate(msgLen)
		errObj->info.name = errState.errors(errCode).name
		errObj->info.code = errCode
		errObj->trace.filename = filename
		errObj->trace.lineNum = linenum
	end if

	mutexunlock (errState.mutexId)

	return errObj
end function

/''
 '
 '/
sub errorDelete (errMsg as ErrorMessage ptr)
	if errMsg then
		deallocate(errMsg)
	else
		' TODO: Setup an "error error" and throw one here
	end if
end sub

/''
 '
 '/
function errorRegisterType (errName as zstring ptr) as integer
	dim as integer errCode
	dim as ErrorHeader ptr errPtr

	mutexlock(errState.mutexId)

	errCode = errState.errorCount
	errState.errorCount += 1

	mutexunlock(errState.mutexId)

	errPtr = @errState.errors(errCode)
	errPtr->name = *errName
	errPtr->code = errCode

	return errCode
end function

/''
 '
 '/
function errorRegisterHandler (errName as zstring ptr, handler as ErrorHandler) as integer
	DIM as integer errCode = errorGetCode (errName)
	DIM as integer result = TRUE

	mutexlock (errState.mutexId)

	if not errCode ORELSE not errState.errors(errCode).code then
		result = FALSE
	else
		errState.handlers(errCode) = handler
	end if

	mutexunlock (errState.mutexId)

	return result
end function

/''
 '
 '/
function errorGetCode (errName as zstring ptr) as integer
	dim as integer result = 0
	dim as integer index = 0

	mutexlock (errState.mutexId)

	while (result <> 0 ANDALSO index < errState.errorCount)
		if errState.errors(index).name = *errName then
			result = index
		end if
	wend

	mutexunlock (errState.mutexId)

	return result
end function

/''
 '
 '/
sub _errorClearHandlers()
	dim as integer i
	mutexlock(errState.mutexId)

	for i = 0 to errState.errorCount - 1
		errState.errors(i).code = 0
		errState.handlers(i) = NULL
	next

	mutexunlock(errState.mutexId)

	errState.errorCount = 0
end sub
