
/''
 ' @requires constants
 ' @requires module
 ' @requires console
 ' @requires fault
 '/

#include once "module.bi"

/''
 ' @namespace ErrorHandling
 '/
namespace ErrorHandling

/''
 ' Loading lifecycle function called by Meld framework.
 ' @function startup
 ' @returns {short}
 '/
function startup cdecl () as short
	state.errs.uncaughtError = _fault->getCode("UncaughtError")
	state.errs.internalSystemError = _fault->getCode("InternalSystemError")

	_assignHandler(_fault, @state.errs.fatalOperationalError, "FatalOperationalError", _fault->defaultFatalHandler)
	_assignHandler(_fault, @state.errs.moduleLoadingError, "ModuleLoadingError", _fault->defaultErrorHandler)
	_assignHandler(_fault, @state.errs.resourceAllocationError, "ResourceAllocationError", _fault->defaultErrorHandler)
	_assignHandler(_fault, @state.errs.releaseResourceError, "ReleaseResourceError", _fault->defaultErrorHandler)
	_assignHandler(_fault, @state.errs.nullReferenceError, "NullReferenceError", _fault->defaultWarningHandler)
	_assignHandler(_fault, @state.errs.resourceMissingError, "ResourceMissingError", _fault->defaultWarningHandler)
	_assignHandler(_fault, @state.errs.invalidArgumentError, "InvalidArgumentError", _fault->defaultWarningHandler)
	_assignHandler(_fault, @state.errs.outOfBoundsError, "OutOfBoundsError", _fault->defaultWarningHandler)
	_assignHandler(_fault, @state.errs.resourceLimitSurpassed, "ResourceLimitSurpassed", _fault->defaultWarningHandler)
	_assignHandler(_fault, @state.errs.generalError, "GeneralError", _fault->defaultWarningHandler)

	return true
end function

/''
 ' Unload lifecycle function called by Meld framework.
 ' @function shutdown
 ' @returns {short}
 '/
function shutdown cdecl () as short
	return true
end function

/''
 ' Helper function to assign a handler to an error code.
 ' @function _assignHandler
 ' @param {Fault.Interface ptr} _fault
 ' @param {integer ptr} errCodePtr
 ' @param {byref zstring} errName
 ' @param {Fault.handler} handler
 ' @private
 ' @throws {UncaughtError}
 '/
sub _assignHandler(_fault as Fault.Interface ptr, errCodePtr as integer ptr, byref errName as zstring, handler as Fault.handler)
	dim as integer errCode = _fault->registerType(errName)

	if not _fault->assignHandler(errCode, handler) then
		_fault->throw(0, errName, "Failed to assign " & errName & " handler", __FILE__, __LINE__)
	end if

	*errCodePtr = errCode
end sub

end namespace
