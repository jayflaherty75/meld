
#include once "../../../../../modules/headers/default/default-v1.bi"
#include once "default.bi"

type ModuleStateType
	methods as Default.Interface
	isLoaded as short
	references as integer
	startups as integer
end type

dim shared as ModuleStateType moduleState

/''
 ' Loading lifecycle function called by Meld framework.
 ' @param {Module.Interface ptr} modulePtr
 ' @returns {any ptr}
 '/
function exports cdecl alias "exports" () as any ptr export
	moduleState.methods.startup = @Default.startup

	return @moduleState.methods
end function

/''
 ' Loading lifecycle function called by Meld framework.
 ' @param {Module.Interface ptr} modulePtr
 ' @returns {short}
 '/
function load cdecl alias "load" (modulePtr as Module.Interface ptr) as short export
	if modulePtr = NULL then
		print ("**** Default.load: Invalid Module interface pointer")
		return false
	end if

	if not moduleState.isLoaded then
		_console = modulePtr->require("console")
		_fault = modulePtr->require("fault")

		if _console = NULL then
			print ("**** Default.load: Failed to load Console dependency")
			return false
		end if

		if _fault = NULL then
			print ("**** Default.load: Failed to load Fault dependency")
			return false
		end if

		moduleState.references = 0
		moduleState.startups = 0
		moduleState.isLoaded = true
	end if

	moduleState.references += 1

	return true
end function

/''
 ' Unload lifecycle function called by Meld framework.
 '/
sub unload cdecl alias "unload" () export
	moduleState.references -= 1

	if moduleState.references <= 0 then
		moduleState.references = 0
		moduleState.startups = 0
		moduleState.isLoaded = false
	end if
end sub

/''
 ' Register lifecycle function called by Meld framework.
 ' @returns {short}
 '/
function startup cdecl alias "startup" () as short export
	if moduleState.startups = 0 then
		if moduleState.methods.startup <> NULL then
			if not moduleState.methods.startup() then
				print ("**** Default.startup: Module startup handler failed")
			end if
		end if
	end if

	moduleState.startups += 1

	return true
end function

/''
 ' Unregister lifecycle function called by Meld framework.
 '/
function shutdown cdecl alias "shutdown" () as short export
	moduleState.startups -= 1

	if moduleState.startups <= 0 then
		moduleState.startups = 0

		' Do shutdown
	end if

	return true
end function
