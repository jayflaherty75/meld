namespace Template

type StateType
	methods as Interface
end type

type ErrorCodes
	resourceAllocationError as integer
	moduleLoadingError as integer
	invalidArgumentError as integer
	nullReferenceError as integer
	resourceMissingError as integer
	releaseResourceError as integer
	generalError as integer
end type

dim shared _core as Core.Interface ptr
dim shared _fault as Fault.Interface ptr
'dim shared _bst as Bst.Interface ptr

dim shared as StateType state
dim shared as ErrorCodes errors

/''
 ' Loading lifecycle function called by Meld framework.
 ' @param {Core.Interface ptr} corePtr
 ' @returns {integer}
 '/
function load (corePtr as Core.Interface ptr) as integer
	if corePtr = NULL then
		print ("**** Template.load: Invalid Core interface pointer")
		return false
	end if

	state.methods.load = @load
	state.methods.unload = @unload
	state.methods.register = @register
	state.methods.unregister = @unregister
	state.methods.construct = @construct
	state.methods.destruct = @destruct

	if not corePtr->register("template", @state.methods) then
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
	'_bst = _core->require("bst")
	_core = _core->require("core")

	if _fault = NULL then
		print ("**** Template.register: Missing Fault dependency")
		return false
	end if

	errors.resourceAllocationError = _fault->getCode("ResourceAllocationError")
	errors.moduleLoadingError = _fault->getCode("ModuleLoadingError")
	errors.invalidArgumentError = _fault->getCode("InvalidArgumentError")
	errors.nullReferenceError = _fault->getCode("NullReferenceError")
	errors.resourceMissingError = _fault->getCode("ResourceMissingError")
	errors.releaseResourceError = _fault->getCode("ReleaseResourceError")
	errors.generalError = _fault->getCode("GeneralError")

	if _core = NULL then
		_fault->throw(_
			errors.moduleLoadingError, _
			"TemplateLoadingError", "Template module missing Core dependency", _
			__FILE__, __LINE__ _
		)
		return false
	end if

	'if _bst = NULL then
	'	_fault->throw(_
	'		errors.moduleLoadingError, _
	'		"TemplateLoadingError", "Template module missing Bst dependency", _
	'		__FILE__, __LINE__ _
	'	)
	'	return false
	'end if

	return true
end function

/''
 ' Unregister lifecycle function called by Meld framework.
 '/
sub unregister()
end sub

end namespace
