
/''
 ' @requires console_v0.1.0
 '/

#include once "crt.bi"
#include once "module.bi"
#include once "errors.bi"

#define ERROR_MAX_TYPES                     256

/''
 ' @namespace Fault
 ' @version 0.1.0
 '/
namespace Fault

/'
 ' @class Header
 ' @property {zstring*64} name
 ' @property {ushort} code
 ' @private
 '/
type Header
	name as zstring*64
	code as ushort
end type

/''
 ' @typedef {function} Handler
 ' @param {zstring ptr} errName
 ' @param {zstring ptr} message
 ' @param {zstring ptr} filename
 ' @param {integer} lineNum
 '/

type ErrorCodes
	uncaughtError as integer
	internalSystemError as integer
end type

type State
	errors(ERROR_MAX_TYPES) as Header
	errorCount as uinteger
	handlers(ERROR_MAX_TYPES) as Handler
	typeLimitErrorMsg as string
	errs as ErrorCodes
end type

static shared as zstring*26 uncaughtError = "UncaughtError"
static shared as zstring*24 internalSystemError = "InternalSystemError"

dim shared as State errState

/''
 ' Application main routine.
 ' @function startup
 ' @returns {short}
 '/
function startup cdecl () as short
	_console->logMessage("Starting fault module")

	errState.typeLimitErrorMsg = "Can not create new error types.  The system has reached the limit it can handle."
	errState.errorCount = 0

	errState.errs.uncaughtError = registerType(uncaughtError)
	if not assignHandler(errState.errs.uncaughtError, @defaultErrorHandler) then
		printf(!"Fault.initialize: Failed to assign handler for uncaught error\n")
	end if

	errState.errs.internalSystemError = registerType(internalSystemError)
	if not assignHandler(errState.errs.internalSystemError, @defaultErrorHandler) then
		printf(!"Fault.initialize: Failed to assign handler for internal system error\n")
	end if

	return true
end function

/''
 ' Application main routine.
 ' @function shutdown
 ' @returns {short}
 '/
function shutdown cdecl () as short
	dim as integer i

	_console->logMessage("Shutting down fault module")

	for i = 0 to errState.errorCount - 1
		errState.errors(i).code = 0
		errState.handlers(i) = NULL
	next

	errState.errorCount = 0

	return true
end function

/''
 ' Registers a new error type and returns the assigned error code.
 ' @function registerType
 ' @param {zstring ptr} errName
 ' @returns {short}
 ' @throws {InternalSystemError}
 '/
function registerType cdecl (errName as zstring ptr) as short
	dim as short errCode = -1
	dim as Fault.Header ptr errPtr

	if errState.errorCount < ERROR_MAX_TYPES then
		errCode = errState.errorCount
		errState.errorCount += 1

		errPtr = @errState.errors(errCode)
		errPtr->name = *errName
		errPtr->code = errCode
	else
		throwErr(_
			errState.errs.internalSystemError, _
			internalSystemError, errState.typeLimitErrorMsg, _
			__FILE__, __LINE__ _
		)
	end if

	return errCode
end function

/''
 ' Assigns a handler for a specific registered error type.
 ' @function assignHandler
 ' @param {short} errCode
 ' @param {Handler} handler
 ' @returns {short}
 '/
function assignHandler cdecl (errCode as short, handler as Handler) as short
	DIM as short result = true

	if errCode < 0 ORELSE errState.errors(errCode).code < 0 then
		result = false
	else
		errState.handlers(errCode) = handler
	end if

	return result
end function

/''
 ' Returns the error code for the registered error name
 ' @function getCode
 ' @param {zstring ptr} errName
 ' @returns {short} - Error code or -1 if none found
 '/
function getCode cdecl (errName as zstring ptr) as short
	dim as short result = -1
	dim as short index = 0

	while (result = -1 ANDALSO index < errState.errorCount)
		if errState.errors(index).name = *errName then
			result = index
		end if
		index += 1
	wend

	return result
end function

/''
 ' Pass an error to be handled.  Make sure you do trust exercises with whoever
 ' writes your error handlers.
 ' @function throwErr
 ' @param {integer} errCode - Error code deciding what error handler will be
 '	triggered, can be retrieved with getCode
 ' @param {zstring ptr} errName
 ' @param {zstring ptr} message - Contains full error message
 ' @param {zstring ptr} filename - Pointer to a string containing the current
 '	filename.  Can be set to a constant containing __FILE__.
 ' @param {integer} lineNum - Line number where error occurred.  Can be set
 '	with __LINE__.
 '/
sub throwErr cdecl (errCode as integer, errName as zstring ptr, message as zstring ptr, filename as zstring ptr, lineNum as integer)
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
 ' Default error handler for fatal errors.
 ' @function defaultFatalHandler
 ' @param {zstring ptr} errName
 ' @param {zstring ptr} message
 ' @param {zstring ptr} filename
 ' @param {integer} lineNum
 '/
sub defaultFatalHandler cdecl (errName as zstring ptr, message as zstring ptr, filename as zstring ptr, lineNum as integer)
	_console->logError(errName, message, filename, lineNum)
	'_core->shutdown(1)
end sub

/''
 ' Default error handler for non-fatal errors.
 ' @function defaultErrorHandler
 ' @param {zstring ptr} errName
 ' @param {zstring ptr} message
 ' @param {zstring ptr} filename
 ' @param {integer} lineNum
 '/
sub defaultErrorHandler cdecl (errName as zstring ptr, message as zstring ptr, filename as zstring ptr, lineNum as integer)
	_console->logError(errName, message, filename, lineNum)
end sub

/''
 ' Handler for logging warnings.
 ' @function defaultWarningHandler
 ' @param {zstring ptr} errName
 ' @param {zstring ptr} message
 ' @param {zstring ptr} filename
 ' @param {integer} lineNum
 '/
sub defaultWarningHandler cdecl (errName as zstring ptr, message as zstring ptr, filename as zstring ptr, lineNum as integer)
	_console->logWarning(errName, message, filename, lineNum)
end sub

end namespace
