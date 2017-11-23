
#include once "../../../../modules/headers/meld/meld-v1.bi"
#include once "../../../../modules/headers/constants/constants-v1.bi"
#include once "../../../../modules/headers/error/error-v1.bi"

#define ERROR_MAX_TYPES                     256

type ErrorDependencies
	meld as MeldInterface ptr
end type

type ErrorState
	mutexId as any ptr
	errors(ERROR_MAX_TYPES) as ErrorHeader
	errorCount as uinteger
	handlers(ERROR_MAX_TYPES) as ErrorHandler
	uncaughtError as integer
	internalSystemError as integer
	typeLimitErrorMsg as string
	methods as ErrorInterface
	deps as ErrorDependencies
end type

static shared as zstring*64 uncaughtError = "MeldInternalUncaughtError"
static shared as zstring*64 internalSystemError = "MeldInternalSystemError"
static shared as zstring*64 moduleFile = __FILE__

dim shared as ErrorState errState

declare function errorLoad (meldPtr as MeldInterface ptr) as integer
declare function errorInitialize (mutexId as any ptr) as integer
declare sub errorUninitialize()
declare function errorRegisterType (errName as zstring ptr) as integer
declare function errorAssignHandler (errCode as integer, handler as ErrorHandler) as integer
declare function errorGetCode (errName as zstring ptr) as integer
declare sub errorThrow (_
	errName as zstring ptr, _
	errCode as integer, _
	byref message as string, _
	filename as zstring ptr, _
	linenum as integer _	
)

declare sub _errorClearAll()
declare sub _errorHandleError (errName as zstring ptr, byref message as string, filename as zstring ptr, lineNum as integer)
declare sub _errorHandleWarning (errName as zstring ptr, byref message as string, filename as zstring ptr, lineNum as integer)

declare sub _errorLog (errName as zstring ptr, filename as zstring ptr, lineNum as integer, byref message as string)
declare function _errorFormat (errName as zstring ptr, filename as zstring ptr, lineNum as integer, byref message as string) as string

/''
 ' @param {MeldInterface ptr} meldPtr
 '/
function errorLoad (meld as MeldInterface ptr) as integer
	if meld <> NULL then
		errState.methods.initialize = @errorInitialize
		errState.methods.uninitialize = @errorUninitialize
		errState.methods.registerType = @errorRegisterType
		errState.methods.assignHandler = @errorAssignHandler
		errState.methods.getCode = @errorGetCode
		errState.methods.throw = @errorThrow

		if not meld->register("error", @errState.methods) then
			return false
		end if

		errState.deps.meld = meld

		return true
	else
		return false
	end if
end function

/''
 ' Error system setup.
 ' @param {any ptr} mutexId - Takes the system mutex ID for thread safety
 '/
function errorInitialize (mutexId as any ptr) as integer
	errState.typeLimitErrorMsg = "Can not create new error types.  The system has reached the limit it can handle."

	errState.mutexId = mutexId
	errState.errorCount = 0

	errState.uncaughtError = errorRegisterType(@uncaughtError)
	errState.internalSystemError = errorRegisterType(@internalSystemError)
	errorAssignHandler(errState.uncaughtError, @_errorHandleError)
	errorAssignHandler(errState.internalSystemError, @_errorHandleError)

	return true
end function

/''
 ' Error system shutdown.
 '/
sub errorUninitialize()
	_errorClearAll()

	errState.mutexId = NULL
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
		errorThrow(_
			@internalSystemError, _
			errState.internalSystemError, _
			errState.typeLimitErrorMsg, _
			@moduleFile, _
			__LINE__ _
		)
	end if

	return errCode
end function

/''
 ' Assigns a handler for a specific registered error type.
 ' @param {integer} errCode
 ' @param {errorHandler} handler
 ' @returns {integer}
 '/
function errorAssignHandler (errCode as integer, handler as ErrorHandler) as integer
	DIM as integer result = true

	mutexlock (errState.mutexId)

	if not errCode ORELSE not errState.errors(errCode).code then
		result = true
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
 ' Pass an error to be handled.  Make sure you do trust exercises with whoever
 ' writes your error handlers.
 ' @param {zstring ptr} errName
 ' @param {integer} errCode - Error code deciding what error handler will be
 '	triggered, can be retrieved with errorGetCode
 ' @param {string} message - Contains full error message
 ' @param {zstring ptr} filename - Pointer to a string containing the current
 '	filename.  Can be set to a constant containing __FILE__.
 ' @param {integer} lineNum - Line number where error occurred.  Can be set
 '	with __LINE__.
 '/
sub errorThrow (errName as zstring ptr, errCode as integer, byref message as string, filename as zstring ptr, lineNum as integer)
	if errCode < ERROR_MAX_TYPES andalso errState.errors(errCode).code _
		andalso errState.handlers(errCode) then

		errState.handlers(errCode) (errName, message, filename, lineNum)
	else
		' All unhandled errors go to uncaught handler defined during
		' initialization of error system.
		errState.handlers(0) (errName, message, filename, lineNum)
	end if
end sub

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
 ' Default error handler for uncaught errors.
 ' @private
 '/
sub _errorHandleError (errName as zstring ptr, byref message as string, filename as zstring ptr, lineNum as integer)
	' TODO: Implement a logging system and call it here
	_errorLog (*errName, *filename, lineNum, message)

	' TODO: Implement interfaces and call meld
	' meld->shutdown(1)
	end(1)
end sub

/''
 ' Handler for logging warnings.
 ' @private
 '/
sub _errorHandleWarning (errName as zstring ptr, byref message as string, filename as zstring ptr, lineNum as integer)
	' TODO: Implement a logging system and call it here
	_errorLog (*errName, *filename, lineNum, message)
end sub

/''
 ' TODO: Add logging and remove this temporary logging handler.
 ' @private
 '/
sub _errorLog (errName as zstring ptr, filename as zstring ptr, lineNum as integer, byref message as string)
	print (_errorFormat(errName, filename, lineNum, message))
end sub

/''
 ' @private
 '/
function _errorFormat (errName as zstring ptr, filename as zstring ptr, lineNum as integer, byref message as string) as string
	dim as MeldInterface ptr meld = errState.deps.meld

	return Time () & errName & ": " & filename & " (" & lineNum & ") " & meld->newline & message
end function
