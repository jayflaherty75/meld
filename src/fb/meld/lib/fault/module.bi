
#include once "../../../../../modules/headers/fault/fault-v1.bi"
#include once "fault.bi"

type ModuleStateType
	methods as Fault.Interface
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
	moduleState.methods.startup = @Fault.startup
	moduleState.methods.shutdown = @Fault.shutdown
	moduleState.methods.registerType = @Fault.registerType
	moduleState.methods.assignHandler = @Fault.assignHandler
	moduleState.methods.getCode = @Fault.getCode
	moduleState.methods.throw = @Fault.throw
	moduleState.methods.defaultFatalHandler = @Fault.defaultFatalHandler
	moduleState.methods.defaultErrorHandler = @Fault.defaultErrorHandler
	moduleState.methods.defaultWarningHandler = @Fault.defaultWarningHandler

	return @moduleState.methods
end function

/''
 ' Loading lifecycle function called by Meld framework.
 ' @param {Module.Interface ptr} modulePtr
 ' @returns {short}
 '/
function load cdecl alias "load" (modulePtr as Module.Interface ptr) as short export
	if modulePtr = NULL then
		print ("**** Fault.load: Invalid Module interface pointer")
		return false
	end if

	if not moduleState.isLoaded then
		_console = modulePtr->require("console")

		if _console = NULL then
			print ("**** Fault.load: Failed to load Console dependency")
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
 ' @returns {short} - State of module isLoaded property
 '/
function unload cdecl alias "unload" () as short export
	moduleState.references -= 1

	if moduleState.references <= 0 then
		moduleState.references = 0
		moduleState.startups = 0
		moduleState.isLoaded = false
	end if

	return moduleState.isLoaded
end function

/''
 ' Register lifecycle function called by Meld framework.
 ' @returns {short}
 '/
function startup cdecl alias "startup" () as short export
	if moduleState.startups = 0 then
		if moduleState.methods.startup <> NULL then
			if not moduleState.methods.startup() then
				print ("**** Fault.startup: Module startup handler failed")
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

		if moduleState.methods.shutdown <> NULL then
			if not moduleState.methods.shutdown() then
				print ("**** Fault.startup: Module shutdown handler failed")
			end if
		end if
	end if

	return true
end function
