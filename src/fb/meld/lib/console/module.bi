
#include once "../../../../../modules/headers/console/console-v1.bi"
#include once "console.bi"

type ModuleStateType
	methods as Console.Interface
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
	moduleState.methods.logMessage = @Console.logMessage
	moduleState.methods.logWarning = @Console.logWarning
	moduleState.methods.logError = @Console.logError
	moduleState.methods.logSuccess = @Console.logSuccess

	return @moduleState.methods
end function

/''
 ' Loading lifecycle function called by Meld framework.
 ' @param {Module.Interface ptr} modulePtr
 ' @returns {short}
 '/
function load cdecl alias "load" (modulePtr as Module.Interface ptr) as short export
	if modulePtr = NULL then
		print ("**** Console.load: Invalid Module interface pointer")
		return false
	end if

	if not moduleState.isLoaded then
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
		' Do startup
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
