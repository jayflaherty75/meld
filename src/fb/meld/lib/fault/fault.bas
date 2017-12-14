
#include once "fault.bi"

#define ERROR_MAX_TYPES                     256

namespace Fault

type ErrorCodes
	uncaughtError as integer
	internalSystemError as integer
end type

type Dependencies
	core as Core.Interface ptr
	console as Console.Interface ptr
end type

type State
	mutexId as any ptr
	errors(ERROR_MAX_TYPES) as Header
	errorCount as uinteger
	handlers(ERROR_MAX_TYPES) as Handler
	typeLimitErrorMsg as string
	methods as Interface
	deps as Dependencies
	errs as ErrorCodes
end type

static shared as zstring*26 uncaughtError = "UncaughtError"
static shared as zstring*24 internalSystemError = "InternalSystemError"

dim shared as State errState

declare function _initialize () as integer
declare sub _uninitialize()
declare sub _clearAll()

/''
 ' @param {Core.Interface ptr} corePtr
 '/
function load (corePtr as Core.Interface ptr) as integer
	if corePtr = NULL then
		print ("load: Invalid Core interface pointer")
		return false
	end if

	errState.methods.load = @load
	errState.methods.unload = @unload
	errState.methods.register = NULL
	errState.methods.unregister = NULL
	errState.methods.registerType = @registerType
	errState.methods.assignHandler = @assignHandler
	errState.methods.getCode = @getCode
	errState.methods.throw = @throw
	errState.methods.defaultFatalHandler = @defaultFatalHandler
	errState.methods.defaultErrorHandler = @defaultErrorHandler
	errState.methods.defaultWarningHandler = @defaultWarningHandler

	if not corePtr->register("fault", @errState.methods) then
		return false
	end if

	errState.deps.core = corePtr->require("core")
	errState.deps.console = corePtr->require("console")

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

	errState.errs.uncaughtError = registerType(uncaughtError)
	if not assignHandler(errState.errs.uncaughtError, @defaultErrorHandler) then
		print ("Fault.initialize: Failed to assign handler for uncaught error")
	end if

	errState.errs.internalSystemError = registerType(internalSystemError)
	if not assignHandler(errState.errs.internalSystemError, @defaultErrorHandler) then
		print ("Fault.initialize: Failed to assign handler for internal system error")
	end if

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
			errState.errs.internalSystemError, _
			internalSystemError, errState.typeLimitErrorMsg, _
			__FILE__, __LINE__ _
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

	if errCode < 0 ORELSE errState.errors(errCode).code < 0 then
		result = false
	else
		errState.handlers(errCode) = handler
	end if

	mutexunlock (errState.mutexId)

	return result
end function

/''
 ' Returns the error code for the registered error name
 ' @param {zstring} errName
 ' @returns {integer} - Error code or -1 if none found
 '/
function getCode (byref errName as zstring) as integer
	dim as integer result = -1
	dim as integer index = 0

	mutexlock (errState.mutexId)

	while (result = -1 ANDALSO index < errState.errorCount)
		if errState.errors(index).name = errName then
			result = index
		end if
		index += 1
	wend

	mutexunlock (errState.mutexId)

	return result
end function

/''
 ' Pass an error to be handled.  Make sure you do trust exercises with whoever
 ' writes your error handlers.
 ' @param {integer} errCode - Error code deciding what error handler will be
 '	triggered, can be retrieved with getCode
 ' @param {zstring} errName
 ' @param {string} message - Contains full error message
 ' @param {zstring} filename - Pointer to a string containing the current
 '	filename.  Can be set to a constant containing __FILE__.
 ' @param {integer} lineNum - Line number where error occurred.  Can be set
 '	with __LINE__.
 '/
sub throw (errCode as integer, byref errName as zstring, byref message as string, byref filename as zstring, lineNum as integer)
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
 ' Default error handler for fatal errors.
 ' @private
 '/
sub defaultFatalHandler (byref errName as zstring, byref message as string, byref filename as zstring, lineNum as integer)
	dim as Dependencies ptr deps = @errState.deps

	deps->console->logError(errName, message, filename, lineNum)
	deps->core->shutdown(1)
end sub

/''
 ' Default error handler for non-fatal errors.
 ' @private
 '/
sub defaultErrorHandler (byref errName as zstring, byref message as string, byref filename as zstring, lineNum as integer)
	dim as Dependencies ptr deps = @errState.deps

	deps->console->logError(errName, message, filename, lineNum)
end sub

/''
 ' Handler for logging warnings.
 ' @private
 '/
sub defaultWarningHandler (byref errName as zstring, byref message as string, byref filename as zstring, lineNum as integer)
	dim as Dependencies ptr deps = @errState.deps

	deps->console->logWarning(errName, message, filename, lineNum)
end sub

end namespace
