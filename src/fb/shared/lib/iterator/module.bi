
namespace Iterator

type StateType
	methods as Interface
end type

type ErrorCodes
	resourceAllocationError as integer
	nullReferenceError as integer
	invalidArgumentError as integer
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
function load cdecl alias "load" (byval corePtr as Core.Interface ptr) as integer
	if corePtr = NULL then
		print ("**** Iterator.load: Invalid corePtr interface pointer")
		return false
	end if

	state.methods.load = @load
	state.methods.unload = @unload
	state.methods.register = @register
	state.methods.unregister = @unregister
	state.methods.construct = @construct
	state.methods.destruct = @destruct
	state.methods.setHandler = @setHandler
	state.methods.setData = @setData
	state.methods.getNext = @getNext
	state.methods.reset = @reset

	if not corePtr->register("iterator", @state.methods) then
		return false
	end if

	_core = corePtr

	return true
end function

/''
 ' Unload lifecycle function called by Meld framework.
 '/
sub unload cdecl alias "unload" ()
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
		print ("**** Iterator.load: Missing Fault dependency")
		return false
	end if

	errors.resourceAllocationError = _fault->getCode("ResourceAllocationError")
	errors.nullReferenceError = _fault->getCode("NullReferenceError")
	errors.invalidArgumentError = _fault->getCode("InvalidArgumentError")
	errors.moduleLoadingError = _fault->getCode("ModuleLoadingError")

	if _core = NULL then
		_fault->throw(_
			errors.moduleLoadingError, _
			"iteratorLoadingError", "Iterator module missing Core dependency", _
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
