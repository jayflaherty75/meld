
namespace Console

type StateType
	methods as Interface
end type

dim shared _core as Core.Interface ptr

dim shared as StateType state

/''
 ' Loading lifecycle function called by Meld framework.
 ' @param {Core.Interface ptr} corePtr
 ' @returns {integer}
 '/
function load (corePtr as Core.Interface ptr) as integer
	if corePtr = NULL then
		print ("**** Console.load: Invalid Core interface pointer")
		return false
	end if

	state.methods.load = @load
	state.methods.unload = @unload
	state.methods.logMessage = @logMessage
	state.methods.logWarning = @logWarning
	state.methods.logError = @logError
	state.methods.logSuccess = @logSuccess

	if not corePtr->register("console", @state.methods) then
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
	_core = _core->require("core")

	if _core = NULL then
		print ("**** Console.load: Missing Core dependency")
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
