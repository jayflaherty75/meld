
#include once "fault.bi"

#define ERROR_MAX_TYPES                     256

namespace Fault

type Dependencies
	meld as MeldInterface ptr
end type

type State
	mutexId as any ptr
	errors(ERROR_MAX_TYPES) as Header
	errorCount as uinteger
	handlers(ERROR_MAX_TYPES) as Handler
	uncaughtError as integer
	internalSystemError as integer
	typeLimitErrorMsg as string
	methods as Interface
	deps as Dependencies
end type

static shared as zstring*64 uncaughtError = "MeldInternalUncaughtError"
static shared as zstring*64 internalSystemError = "MeldInternalSystemError"
static shared as zstring*64 moduleFile = __FILE__

dim shared as State errState

declare sub _clearAll()
declare sub _handleError (errName as zstring ptr, byref message as string, filename as zstring ptr, lineNum as integer)
declare sub _handleWarning (errName as zstring ptr, byref message as string, filename as zstring ptr, lineNum as integer)

declare sub _log (errName as zstring ptr, filename as zstring ptr, lineNum as integer, byref message as string)
declare function _format (errName as zstring ptr, filename as zstring ptr, lineNum as integer, byref message as string) as string

/''
 ' @param {MeldInterface ptr} meldPtr
 '/
function load (meld as MeldInterface ptr) as integer
	if meld = NULL then
		' TODO: Throw error
		print ("load: Invalid meld interface pointer")
		return false
	end if

	errState.methods.initialize = @initialize
	errState.methods.uninitialize = @uninitialize
	errState.methods.registerType = @registerType
	errState.methods.assignHandler = @assignHandler
	errState.methods.getCode = @getCode
	errState.methods.throw = @throw

	if not meld->register("error", @errState.methods) then
		return false
	end if

	errState.deps.meld = meld

	return true
end function

sub unload ()
end sub

/''
 ' Error system setup.
 ' @param {any ptr} mutexId - Takes the system mutex ID for thread safety
 '/
function initialize (mutexId as any ptr) as integer
	errState.typeLimitErrorMsg = "Can not create new error types.  The system has reached the limit it can handle."

	errState.mutexId = mutexId
	errState.errorCount = 0

	errState.uncaughtError = registerType(@uncaughtError)
	errState.internalSystemError = registerType(@internalSystemError)
	assignHandler(errState.uncaughtError, @_handleError)
	assignHandler(errState.internalSystemError, @_handleError)

	return true
end function

/''
 ' Error system shutdown.
 '/
sub uninitialize()
	_clearAll()

	errState.mutexId = NULL
end sub

/''
 ' Registers a new error type and returns the assigned error code.
 ' @param {zstring ptr} errName
 ' @returns {integer}
 '/
function registerType (errName as zstring ptr) as integer
	dim as integer errCode = -1
	dim as Fault.Header ptr errPtr

	if errState.errorCount < ERROR_MAX_TYPES then
		mutexlock(errState.mutexId)

		errCode = errState.errorCount
		errState.errorCount += 1

		mutexunlock(errState.mutexId)

		errPtr = @errState.errors(errCode)
		errPtr->name = *errName
		errPtr->code = errCode
	else
		throw(_
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
function assignHandler (errCode as integer, handler as Fault.Handler) as integer
	DIM as integer result = true

	mutexlock (errState.mutexId)

	if not errCode ORELSE not errState.errors(errCode).code then
		result = false
	else
		errState.handlers(errCode) = handler
	end if

	mutexunlock (errState.mutexId)

	return result
end function

/''
 ' Returns the error code for the registered error name
 '/
function getCode (errName as zstring ptr) as integer
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
 '	triggered, can be retrieved with getCode
 ' @param {string} message - Contains full error message
 ' @param {zstring ptr} filename - Pointer to a string containing the current
 '	filename.  Can be set to a constant containing __FILE__.
 ' @param {integer} lineNum - Line number where error occurred.  Can be set
 '	with __LINE__.
 '/
sub throw (errName as zstring ptr, errCode as integer, byref message as string, filename as zstring ptr, lineNum as integer)
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
sub _clearAll()
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
sub _handleError (errName as zstring ptr, byref message as string, filename as zstring ptr, lineNum as integer)
	' TODO: Implement a logging system and call it here
	_log (*errName, *filename, lineNum, message)

	' TODO: Implement interfaces and call meld
	' meld->shutdown(1)
	end(1)
end sub

/''
 ' Handler for logging warnings.
 ' @private
 '/
sub _handleWarning (errName as zstring ptr, byref message as string, filename as zstring ptr, lineNum as integer)
	' TODO: Implement a logging system and call it here
	_log (*errName, *filename, lineNum, message)
end sub

/''
 ' TODO: Add logging and remove this temporary logging handler.
 ' @private
 '/
sub _log (errName as zstring ptr, filename as zstring ptr, lineNum as integer, byref message as string)
	print (_format(errName, filename, lineNum, message))
end sub

/''
 ' @private
 '/
function _format (errName as zstring ptr, filename as zstring ptr, lineNum as integer, byref message as string) as string
	dim as MeldInterface ptr meld = errState.deps.meld

	return Time () & errName & ": " & filename & " (" & lineNum & ") " & meld->newline & message
end function

end namespace
