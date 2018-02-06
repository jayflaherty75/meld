
/''
 ' @requires constants
 ' @requires module
 ' @requires console
 '/

#include once "module.bi"

#define ERROR_MAX_TYPES                     256

/''
 ' @namespace Fault
 '/
namespace Fault

/''
 ' @class Header
 ' @property {zstring*64} name
 ' @property {ushort} code
 '/

/''
 ' @typedef {function} Handler
 ' @param {byref zstring} errName
 ' @param {byref zstring} message
 ' @param {byref zstring} filename
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
 ' Error system setup.
 ' @function startup
 ' @returns {short}
 '/
function startup cdecl () as short
	errState.typeLimitErrorMsg = "Can not create new error types.  The system has reached the limit it can handle."
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
 ' @function shutdown
 ' @returns {short}
 '/
function shutdown cdecl () as short
	dim as integer i

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
 ' @param {byref zstring} errName
 ' @returns {short}
 ' @throws {InternalSystemError}
 '/
function registerType cdecl (byref errName as zstring) as short
	dim as short errCode = -1
	dim as Fault.Header ptr errPtr

	if errState.errorCount < ERROR_MAX_TYPES then
		errCode = errState.errorCount
		errState.errorCount += 1

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
 ' @param {zstring} errName
 ' @returns {short} - Error code or -1 if none found
 '/
function getCode cdecl (byref errName as zstring) as short
	dim as short result = -1
	dim as short index = 0

	while (result = -1 ANDALSO index < errState.errorCount)
		if errState.errors(index).name = errName then
			result = index
		end if
		index += 1
	wend

	return result
end function

/''
 ' Pass an error to be handled.  Make sure you do trust exercises with whoever
 ' writes your error handlers.
 ' @function throw
 ' @param {integer} errCode - Error code deciding what error handler will be
 '	triggered, can be retrieved with getCode
 ' @param {zstring} errName
 ' @param {zstring} message - Contains full error message
 ' @param {zstring} filename - Pointer to a string containing the current
 '	filename.  Can be set to a constant containing __FILE__.
 ' @param {integer} lineNum - Line number where error occurred.  Can be set
 '	with __LINE__.
 '/
sub throw cdecl (errCode as integer, byref errName as zstring, byref message as zstring, byref filename as zstring, lineNum as integer)
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
 ' @param {byref zstring} errName
 ' @param {byref zstring} message
 ' @param {byref zstring} filename
 ' @param {integer} lineNum
 '/
sub defaultFatalHandler (byref errName as zstring, byref message as zstring, byref filename as zstring, lineNum as integer)
	_console->logError(errName, message, filename, lineNum)
	'_core->shutdown(1)
end sub

/''
 ' Default error handler for non-fatal errors.
 ' @function defaultErrorHandler
 ' @param {byref zstring} errName
 ' @param {byref zstring} message
 ' @param {byref zstring} filename
 ' @param {integer} lineNum
 '/
sub defaultErrorHandler (byref errName as zstring, byref message as zstring, byref filename as zstring, lineNum as integer)
	_console->logError(errName, message, filename, lineNum)
end sub

/''
 ' Handler for logging warnings.
 ' @function defaultWarningHandler
 ' @param {byref zstring} errName
 ' @param {byref zstring} message
 ' @param {byref zstring} filename
 ' @param {integer} lineNum
 '/
sub defaultWarningHandler (byref errName as zstring, byref message as zstring, byref filename as zstring, lineNum as integer)
	_console->logWarning(errName, message, filename, lineNum)
end sub

end namespace
