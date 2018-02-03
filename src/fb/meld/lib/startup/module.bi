
namespace Startup

type StateType
	methods as Interface
end type

type ErrorCodes
	resourceAllocationError as integer
	releaseResourceError as integer
	nullReferenceError as integer
	invalidArgumentError as integer
	moduleLoadingError as integer
end type

dim shared as StateType state
dim shared as ErrorCodes errors

/''
 ' Loading lifecycle function called by Meld framework.
 ' @param {Core.Interface ptr} corePtr
 ' @returns {integer}
 '/
function load cdecl alias "load" (modulePtr as Module.Interface ptr) as integer export
	if modulePtr = NULL then
		print ("**** Startup.load: Invalid Module interface")
		return false
	end if

	state.methods.load = @load
	state.methods.construct = @construct
	state.methods.destruct = @destruct
	state.methods.unload = @unload
	state.methods.insert = @insert
	state.methods.search = @search
	state.methods.getLength = @getLength
	state.methods.getIterator = @getIterator
	state.methods.defaultCompare = @defaultCompare

	if not modulePtr->register("bst", @state.methods) then
		return false
	end if

	return true
end function

/''
 ' Unload lifecycle function called by Meld framework.
 '/
sub unload cdecl alias "unload" () export
end sub

/''
 ' Register lifecycle function called by Meld framework.
 ' @returns {integer}
 ' @throws {ModuleLoadingError}
 '/
function startup cdecl alias "startup"() as integer export
	_fault = _core->require("fault")
	_iterator = _core->require("iterator")
	_core = _core->require("core")

	if _fault = NULL then
		print ("**** Startup.load: Missing Fault dependency")
		return false
	end if

	errors.resourceAllocationError = _fault->getCode("ResourceAllocationError")
	errors.releaseResourceError = _fault->getCode("ReleaseResourceError")
	errors.nullReferenceError = _fault->getCode("NullReferenceError")
	errors.invalidArgumentError = _fault->getCode("InvalidArgumentError")
	errors.moduleLoadingError = _fault->getCode("ModuleLoadingError")

	if _core = NULL then
		_fault->throw(_
			errors.moduleLoadingError, _
			"StartupLoadingError", "BST module missing Core dependency", _
			__FILE__, __LINE__ _
		)
		return false
	end if

	if _iterator = NULL then
		_fault->throw(_
			errors.moduleLoadingError, _
			"StartupLoadingError", "BST module missing Iterator dependency", _
			__FILE__, __LINE__ _
		)
		return false
	end if

	return true
end function

/''
 ' Unregister lifecycle function called by Meld framework.
 '/
sub shutdown cdecl alias "shutdown" () export
end sub

end namespace
