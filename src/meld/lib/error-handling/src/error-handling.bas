
/''
 ' @requires console_v0.1.0
 ' @requires fault_v0.1.0
 '/

#include once "module.bi"
#include once "errors.bi"

/''
 ' @namespace ErrorHandling
 ' @version 0.1.0
 '/
namespace ErrorHandling

type Codes
	uncaughtError as integer
	internalSystemError as integer
	fatalOperationalError as integer
	moduleLoadingError as integer
	resourceAllocationError as integer
	resourceInitializationError as integer
	releaseResourceError as integer
	nullReferenceError as integer
	resourceMissingError as integer
	invalidArgumentError as integer
	outOfBoundsError as integer
	resourceLimitSurpassed as integer
	unexpectedBehaviorError as integer
	generalError as integer
end type

type StateType
	methods as Interface
	errs as Codes
end type

dim shared as StateType state

/''
 ' Application main routine.
 ' @function startup
 ' @returns {short}
 '/
function startup cdecl () as short
	_console->logMessage("Starting error-handling module")

	state.errs.uncaughtError = _fault->getCode("UncaughtError")
	state.errs.internalSystemError = _fault->getCode("InternalSystemError")

	_assignHandler(_fault, @state.errs.fatalOperationalError, "FatalOperationalError", _fault->defaultFatalHandler)
	_assignHandler(_fault, @state.errs.moduleLoadingError, "ModuleLoadingError", _fault->defaultErrorHandler)
	_assignHandler(_fault, @state.errs.resourceAllocationError, "ResourceAllocationError", _fault->defaultErrorHandler)
	_assignHandler(_fault, @state.errs.resourceInitializationError, "ResourceInitializationError", _fault->defaultErrorHandler)
	_assignHandler(_fault, @state.errs.releaseResourceError, "ReleaseResourceError", _fault->defaultWarningHandler)
	_assignHandler(_fault, @state.errs.nullReferenceError, "NullReferenceError", _fault->defaultWarningHandler)
	_assignHandler(_fault, @state.errs.resourceMissingError, "ResourceMissingError", _fault->defaultWarningHandler)
	_assignHandler(_fault, @state.errs.invalidArgumentError, "InvalidArgumentError", _fault->defaultWarningHandler)
	_assignHandler(_fault, @state.errs.outOfBoundsError, "OutOfBoundsError", _fault->defaultWarningHandler)
	_assignHandler(_fault, @state.errs.resourceLimitSurpassed, "ResourceLimitSurpassed", _fault->defaultWarningHandler)
	_assignHandler(_fault, @state.errs.unexpectedBehaviorError, "UnexpectedBehaviorError", _fault->defaultWarningHandler)
	_assignHandler(_fault, @state.errs.generalError, "GeneralError", _fault->defaultWarningHandler)

	return true
end function

/''
 ' Application main routine.
 ' @function shutdown
 ' @returns {short}
 '/
function shutdown cdecl () as short
	_console->logMessage("Shutting down error-handling module")

	return true
end function

/''
 ' Helper function to assign a handler to an error code.
 ' @function _assignHandler
 ' @param {Fault.Interface ptr} _fault
 ' @param {integer ptr} errCodePtr
 ' @param {zstring ptr} errName
 ' @param {Fault.handler} handler
 ' @private
 '/
sub _assignHandler cdecl (_fault as Fault.Interface ptr, errCodePtr as integer ptr, errName as zstring ptr, handler as Fault.handler)
	dim as integer errCode = _fault->registerType(errName)

	if not _fault->assignHandler(errCode, handler) then
		_fault->throwErr(0, errName, "Failed to assign " & errName & " handler", __FILE__, __LINE__)
	end if

	*errCodePtr = errCode
end sub

end namespace

