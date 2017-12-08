
namespace PagedArray

type StateType
	methods as Interface
end type

type ErrorCodes
	resourceAllocationError as integer
	invalidArgumentError as integer
	nullReferenceError as integer
	outOfBoundsError as integer
	resourceLimitSurpassed as integer
	moduleLoadingError as integer
end type

dim shared _core as Core.Interface ptr
dim shared _fault as Fault.Interface ptr

dim shared as StateType state
dim shared as ErrorCodes errors

/''
 ' Loading lifecycle function called by Meld framework.
 ' @param {Core.Interface ptr} corePtr
 ' @returns {integer}
 '/
function load (corePtr as Core.Interface ptr) as integer
	if corePtr = NULL then
		print ("**** PagedArray.load: Invalid corePtr interface pointer")
		return false
	end if

	state.methods.load = @load
	state.methods.unload = @unload
	state.methods.register = @register
	state.methods.unregister = @unregister
	state.methods.construct = @construct
	state.methods.destruct = @destruct
	state.methods.createIndex = @createIndex
	state.methods.getIndex = @getIndex
	state.methods.pop = @pop
	state.methods.isEmpty = @isEmpty

	if not corePtr->register("paged-array", @state.methods) then
		return false
	end if

	_core = corePtr

	return true
end function

/''
 ' Unload lifecycle function called by Meld framework.
 '/
sub unload()
end sub

/''
 ' Register lifecycle function called by Meld framework.
 ' @returns {integer}
 ' @throws {ModuleLoadingError}
 '/
function register() as integer
	_fault = _core->require("fault")
	_core = _core->require("core")

	if _fault = NULL then
		print ("**** PagedArray.load: Missing Fault dependency")
		return false
	end if

	errors.resourceAllocationError = _fault->getCode("ResourceAllocationError")
	errors.nullReferenceError = _fault->getCode("NullReferenceError")
	errors.invalidArgumentError = _fault->getCode("InvalidArgumentError")
	errors.outOfBoundsError = _fault->getCode("OutOfBoundsError")
	errors.resourceLimitSurpassed = _fault->getCode("ResourceLimitSurpassed")
	errors.moduleLoadingError = _fault->getCode("ModuleLoadingError")

	if _core = NULL then
		_fault->throw(_
			errors.moduleLoadingError, _
			"PagedArrayLoadingError", "PagedArray module missing Core dependency", _
			__FILE__, __LINE__ _
		)
		return false
	end if

	return true
end function

/''
 ' Unregister lifecycle function called by Meld framework.
 '/
sub unregister()
end sub

end namespace
