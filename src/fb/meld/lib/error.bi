
#include once "../../../../modules/headers/meld/error.bi"

type ErrorState
	mutexId as any ptr
	errors(ERROR_MAX_TYPES) as ErrorHeader
	errorCount as uinteger
	handlers(ERROR_MAX_TYPES) as ErrorHandler
end type

static shared as zstring*64 defaultError = "UnCaughtError"
static shared as zstring*64 inteneraltError = "InternalSystemError"
static shared as zstring*64 moduleFile = __FILE__

static shared as zstring*512 typeLimitError = "Can not create new error types.  The system has reached the limit it can handle."

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
declare function errorAssignHandler (errName as zstring ptr, handler as ErrorHandler) as integer
declare function errorGetCode (errName as zstring ptr) as integer
declare sub errorThrow (errMsg as ErrorMessage ptr)

declare sub _errorClearAll()
declare sub _errorHandleError (errMsg as ErrorMessage PTR)
declare sub _errorHandleWarning (errMsg as ErrorMessage ptr)

declare sub _errorLog (errName as zstring ptr, filename as zstring ptr, lineNum as integer, byref message as string)
declare function _errorFormat (errName as zstring ptr, filename as zstring ptr, lineNum as integer, byref message as string) as string

/''
 ' Error system setup.
 ' @param {any ptr} mutexId - Takes the system mutex ID for thread safety
 '/
function errorInitialize (mutexId as any ptr) as integer
	errState.mutexId = mutexId
	errState.errorCount = 0

	errorRegisterType(@defaultError)
	errorRegisterType(@inteneraltError)
	errorAssignHandler(@defaultError, @_errorHandleError)
	errorAssignHandler(@inteneraltError, @_errorHandleError)

	return TRUE
end function

/''
 ' Error system shutdown.
 '/
sub errorUninitialize()
	_errorClearAll()

	errState.mutexId = NULL
end sub

/''
 ' Generates a new error instance for the given message and error code.
 ' @param {integer} errCode - Error code deciding what error handler will be
 '	triggered, can be retrieved with errorGetCode
 ' @param {string} message - Contains full error message
 ' @param {zstring ptr} filename - Pointer to a string containing the current
 '	filename.  Can be set to a constant containing __FILE__.
 ' @param {integer} lineNum - Line number where error occurred.  Can be set
 '	with __LINE__.
 ' @returns {ErrorMessage ptr}
 '/
function errorNew (errCode as integer, byref message as string, filename as zstring ptr, lineNum as integer) as ErrorMessage ptr
	dim as integer msgLen = sizeof(errorHeader) + sizeof(errorData) + len(message)
	dim as ErrorMessage ptr errObj

	errObj = allocate(msgLen)

	if errObj then
		errObj->info.name = errState.errors(errCode).name
		errObj->info.code = errCode
		errObj->trace.filename = filename
		errObj->trace.lineNum = lineNum
	else
		_errorLog (@"ErrorMessageAllocationFailure", @moduleFile, __LINE__, "Attempt to delete null error")
		_errorLog (@"ErrorOrigin", filename, lineNum, message)
	end if

	return errObj
end function

/''
 ' Deallocates an error message created with errorNew
 ' @param {ErrorMessage ptr} errMsg
 '/
sub errorDelete (errMsg as ErrorMessage ptr)
	if errMsg then
		deallocate(errMsg)
	else
		_errorLog (@"ErrorNullPointerDelete", @moduleFile, __LINE__, "Attempt to delete null error")
	end if
end sub

/''
 ' Registers a new error type and returns the assigned error code.
 ' @param {zstring ptr} errName
 ' @returns {integer}
 '/
function errorRegisterType (errName as zstring ptr) as integer
	dim as integer errCode = -1
	dim as ErrorHeader ptr errPtr

	if errState.errorCount < ERROR_MAX_TYPES then
		mutexlock(errState.mutexId)

		errCode = errState.errorCount
		errState.errorCount += 1

		mutexunlock(errState.mutexId)

		errPtr = @errState.errors(errCode)
		errPtr->name = *errName
		errPtr->code = errCode
	else
		errorThrow(errorNew(errorGetCode(@inteneraltError), typeLimitError, @moduleFile, __LINE__))
	end if

	return errCode
end function

/''
 ' Assigns a handler for a specific registered error type.
 ' @param {zstring ptr} errName
 ' @param {errorHandler} handler
 ' @returns {integer}
 '/
function errorAssignHandler (errName as zstring ptr, handler as ErrorHandler) as integer
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
 ' Returns the error code for the registered error name
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
 ' Thread-safe clearing of all error types and handlers
 ' @private
 '/
sub _errorClearAll()
	dim as integer i

	mutexlock(errState.mutexId)

	for i = 0 to errState.errorCount - 1
		errState.errors(i).code = 0
		errState.handlers(i) = NULL
	next

	errState.errorCount = 0

	mutexunlock(errState.mutexId)
end sub

/''
 ' Pass an error to be handled.  Make sure you do trust exercises with whoever
 ' writes your error handlers.
 ' @param {ErrorMessage ptr} errMsg
 '/
sub errorThrow (errMsg as ErrorMessage ptr)
	dim as integer errCode

	if errMsg then
		errCode = errMsg->info.code
		if errCode < ERROR_MAX_TYPES andalso errState.errors(errCode).code _
			andalso errState.handlers(errCode) then

			errState.handlers(errCode) (errMsg)
		else
			' All unhandled errors go to uncaught handler defined during
			' initialization of error system.
			errState.handlers(0) (errMsg)
		end if

		' TODO: look into a better way of doing releasing the error message.
		errorDelete (errMsg)
	else
		' TODO: Log a warning here.
	end if
end sub

/''
 ' Default error handler for uncaught errors.
 ' @param {ErrorMessage ptr} errMsg
 '/
sub _errorHandleError (errMsg as ErrorMessage ptr)
	dim as integer lineNum = errMsg->trace.lineNum

	' TODO: Implement a logging system and call it here
	_errorLog (@errMsg->info.name, errMsg->trace.filename, lineNum, errMsg->message)

	end(1)
end sub

/''
 ' Handler for logging warnings.
 ' @param {ErrorMessage ptr} errMsg
 '/
sub _errorHandleWarning (errMsg as ErrorMessage ptr)
	dim as integer lineNum = errMsg->trace.lineNum

	' TODO: Implement a logging system and call it here
	_errorLog (@errMsg->info.name, errMsg->trace.filename, lineNum, errMsg->message)
end sub

/''
 ' TODO: Add logging and remove this temporary logging handler.
 '/
sub _errorLog (errName as zstring ptr, filename as zstring ptr, lineNum as integer, byref message as string)
	print (_errorFormat(errName, filename, lineNum, message))
end sub

/''
 '
 '/
function _errorFormat (errName as zstring ptr, filename as zstring ptr, lineNum as integer, byref message as string) as string
	return errName & ": " & filename & " (" & lineNum & ") \n" & message
end function
