
namespace Bst

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

dim shared _core as Core.Interface ptr
dim shared _fault as Fault.Interface ptr
dim shared _iterator as Iterator.Interface ptr

dim shared as StateType state
dim shared as ErrorCodes errors

/''
 ' Loading lifecycle function called by Meld framework.
 ' @param {Core.Interface ptr} corePtr
 ' @returns {integer}
 '/
function load cdecl alias "load" (byval corePtr as Core.Interface ptr) as integer export
	if corePtr = NULL then
		print ("**** Bst.load: Invalid Core interface pointer")
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

	if not corePtr->register("bst", @state.methods) then
		return false
	end if

	_core = corePtr

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
function register() as integer
	_fault = _core->require("fault")
	_iterator = _core->require("iterator")
	_core = _core->require("core")

	if _fault = NULL then
		print ("**** Bst.load: Missing Fault dependency")
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
			"BstLoadingError", "BST module missing Core dependency", _
			__FILE__, __LINE__ _
		)
		return false
	end if

	if _iterator = NULL then
		_fault->throw(_
			errors.moduleLoadingError, _
			"BstLoadingError", "BST module missing Iterator dependency", _
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
