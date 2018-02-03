
namespace Console

type StateType
	methods as Interface
end type

dim shared as StateType state

/''
 ' Loading lifecycle function called by Meld framework.
 ' @param {Module.Interface ptr} modulePtr
 ' @returns {short}
 '/
function exports cdecl alias "exports" () as short export
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
 ' Loading lifecycle function called by Meld framework.
 ' @param {Module.Interface ptr} modulePtr
 ' @returns {short}
 '/
function load cdecl alias "load" (modulePtr as Module.Interface ptr) as short export
	if corePtr = NULL then
		print ("**** Console.load: Invalid Module interface pointer")
		return false
	end if

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
sub unload cdecl alias "unload" () export
end sub

/''
 ' Register lifecycle function called by Meld framework.
 ' @returns {short}
 '/
function register cdecl alias "register" () as short export
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
sub unregister cdecl alias "unregister" () export
end sub

end namespace
