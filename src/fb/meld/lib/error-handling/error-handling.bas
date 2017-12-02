
#include once "error-handling.bi"

namespace ErrorHandling

type ErrorCodes
	uncaughtError as integer
	internalSystemError as integer
	fatalOperationalError as integer
	moduleLoadingError as integer
	resourceAllocationError as integer
	releaseResourceError as integer
	nullReferenceError as integer
	resourceMissingError as integer
	invalidArgumentError as integer
	outOfBoundsError as integer
	resourceLimitSurpassed as integer
end type

type Dependencies
	core as Core.Interface ptr
	console as Console.Interface ptr
	fault as Fault.Interface ptr
end type

type StateType
	methods as Interface
	deps as Dependencies
	errs as ErrorCodes
end type

static shared as zstring*256 moduleFile = __FILE__

dim shared as StateType state

declare sub _assignHandler(_fault as Fault.Interface ptr, errCodePtr as integer ptr, errName as zstring, handler as Fault.handler)

/''
 ' @param {Core.Interface ptr} corePtr
 '/
function load (corePtr as Core.Interface ptr) as integer
	dim as Core.Interface ptr _core
	dim as Console.Interface ptr _console
	dim as Fault.Interface ptr _fault

	if corePtr = NULL then
		print ("load: Invalid Core interface pointer")
		return false
	end if

	state.methods.load = @load
	state.methods.unload = @unload

	if not corePtr->register("error-handling", @state.methods) then
		return false
	end if

	_core = corePtr->require("core")
	_console = corePtr->require("console")
	_fault = corePtr->require("fault")

	state.errs.uncaughtError = _fault->registerType("UncaughtError")
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

	state.deps.core = _core
	state.deps.console = _console
	state.deps.fault = _fault

	return true
end function

sub unload ()
end sub

sub _assignHandler(_fault as Fault.Interface ptr, errCodePtr as integer ptr, errName as zstring, handler as Fault.handler)
	dim as integer errCode = _fault->registerType(errName)

	if not _fault->assignHandler(errCode, handler) then
		_fault->throw(0, errName, "Failed to assign " & errName & " handler", moduleFile, __LINE__)
	end if

	*errCodePtr = errCode
end sub

end namespace
