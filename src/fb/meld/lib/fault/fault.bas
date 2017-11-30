
#include once "fault.bi"

#define ERROR_MAX_TYPES                     256

namespace Fault

type Dependencies
	meld as MeldInterface ptr
	console as Console.Interface ptr
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

static shared as zstring*26 uncaughtError = "MeldInternalUncaughtError"
static shared as zstring*24 internalSystemError = "MeldInternalSystemError"
static shared as zstring*256 moduleFile = __FILE__

dim shared as State errState

declare function _initialize () as integer
declare sub _uninitialize()
declare sub _clearAll()
declare sub _handleError (byref errName as zstring, byref message as string, byref filename as zstring, lineNum as integer)
declare sub _handleWarning (byref errName as zstring, byref message as string, byref filename as zstring, lineNum as integer)

'declare sub _log (byref errName as zstring, byref filename as zstring, lineNum as integer, byref message as string)
'declare function _format (byref errName as zstring, byref filename as zstring, lineNum as integer, byref message as string) as string

/''
 ' @param {MeldInterface ptr} meldPtr
 '/
function load (meld as MeldInterface ptr) as integer
	if meld = NULL then
		print ("load: Invalid meld interface pointer")
		return false
	end if

	errState.methods.load = @load
	errState.methods.unload = @unload
	errState.methods.registerType = @registerType
	errState.methods.assignHandler = @assignHandler
	errState.methods.getCode = @getCode
	errState.methods.throw = @throw

	if not meld->register("error", @errState.methods) then
		return false
	end if

	errState.deps.meld = meld
	errState.deps.console = meld->require("console")

	if not _initialize() then
		print ("load: Failed to initialize")
		return false
	end if

	return true
end function

sub unload ()
	_uninitialize()
end sub

/''
 ' Error system setup.
 '/
function _initialize () as integer
	errState.typeLimitErrorMsg = "Can not create new error types.  The system has reached the limit it can handle."

	errState.mutexId = mutexcreate()
	errState.errorCount = 0

	errState.uncaughtError = registerType(uncaughtError)
	errState.internalSystemError = registerType(internalSystemError)
	assignHandler(errState.uncaughtError, @_handleError)
	assignHandler(errState.internalSystemError, @_handleError)

	return true
end function

/''
 ' Error system shutdown.
 '/
sub _uninitialize()
	_clearAll()

	if errState.mutexId <> NULL then
		mutexdestroy(errState.mutexId)
		errState.mutexId = NULL
	end if
end sub

/''
 ' Registers a new error type and returns the assigned error code.
 ' @param {zstring} errName
 ' @returns {integer}
 '/
function registerType (byref errName as zstring) as integer
	dim as integer errCode = -1
	dim as Fault.Header ptr errPtr

	if errState.errorCount < ERROR_MAX_TYPES then
		mutexlock(errState.mutexId)

		errCode = errState.errorCount
		errState.errorCount += 1

		mutexunlock(errState.mutexId)

		errPtr = @errState.errors(errCode)
		errPtr->name = errName
		errPtr->code = errCode
	else
		throw(_
			internalSystemError, _
			errState.internalSystemError, _
			errState.typeLimitErrorMsg, _
			moduleFile, _
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
function getCode (byref errName as zstring) as integer
	dim as integer result = 0
	dim as integer index = 0

	mutexlock (errState.mutexId)

	while (result <> 0 ANDALSO index < errState.errorCount)
		if errState.errors(index).name = errName then
			result = index
		end if
	wend

	mutexunlock (errState.mutexId)

	return result
end function

/''
 ' Pass an error to be handled.  Make sure you do trust exercises with whoever
 ' writes your error handlers.
 ' @param {zstring} errName
 ' @param {integer} errCode - Error code deciding what error handler will be
 '	triggered, can be retrieved with getCode
 ' @param {string} message - Contains full error message
 ' @param {zstring} filename - Pointer to a string containing the current
 '	filename.  Can be set to a constant containing __FILE__.
 ' @param {integer} lineNum - Line number where error occurred.  Can be set
 '	with __LINE__.
 '/
sub throw (byref errName as zstring, errCode as integer, byref message as string, byref filename as zstring, lineNum as integer)
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
sub _handleError (byref errName as zstring, byref message as string, byref filename as zstring, lineNum as integer)
	dim as Dependencies ptr deps = @state.deps

	deps->console->logmessage(errName, message, filename, lineNum)
	deps->meld->shutdown(1)
end sub

/''
 ' Handler for logging warnings.
 ' @private
 '/
sub _handleWarning (byref errName as zstring, byref message as string, byref filename as zstring, lineNum as integer)
	dim as Dependencies ptr deps = @state.deps

	deps->console->logmessage(errName, message, filename, lineNum)
end sub

/''
 ' TODO: Add logging and remove this temporary logging handler.
 ' @private
 '/
'sub _log (byref errName as zstring, byref filename as zstring, lineNum as integer, byref message as string)
'	print (_format(errName, filename, lineNum, message))
'end sub

/''
 ' @private
 '/
'function _format (byref errName as zstring, byref filename as zstring, lineNum as integer, byref message as string) as string
'	dim as MeldInterface ptr meld = errState.deps.meld

'	return Time () & errName & ": " & filename & " (" & lineNum & ") " & meld->newline & message
'end function

end namespace
