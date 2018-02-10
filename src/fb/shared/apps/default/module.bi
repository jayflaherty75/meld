
#include once "../../../../../modules/headers/default/default-v1.bi"
#include once "default.bi"

/''
 ' Loading lifecycle function called by Meld framework.
 ' @param {Module.Interface ptr} modulePtr
 ' @returns {any ptr}
 '/
function exports cdecl alias "exports" () as any ptr export
	moduleState.methods.startup = @Default.startup
	moduleState.methods.shutdown = @Default.shutdown
	moduleState.methods.test = @Default.test

	return @moduleState.methods
end function

/''
 ' Loading lifecycle function called by Meld framework.
 ' @param {Module.Interface ptr} modulePtr
 ' @returns {short}
 '/
function load cdecl alias "load" (modulePtr as Module.Interface ptr) as short export
	if modulePtr = NULL then
		print("**** Default.load: Invalid Module interface pointer")
		return false
	end if

	if not moduleState.isLoaded then
		_console = modulePtr->require("console")
		if _console = NULL then
			print("**** Default.load: Failed to load Console dependency")
			return false
		end if

		_fault = modulePtr->require("fault")
		if _fault = NULL then
			print("**** Default.load: Failed to load Fault dependency")
			return false
		end if

		_errorHandling = modulePtr->require("error-handling")
		if _errorHandling = NULL then
			print("**** Default.load: Failed to load ErrorHandling dependency")
			return false
		end if

		_tester = modulePtr->require("tester")
		if _tester = NULL then
			print("**** Default.load: Failed to load Tester dependency")
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
 ' Standard test runner for modules.
 ' @returns {short}
 '/
function test () as short export
	dim as Default.Interface ptr interfacePtr = exports()
	dim as Tester.testModule tests(1)

	tests(0) = interfacePtr->test

	if not _tester->run(@tests(0), interfacePtr, 1) then
		return false
	end if

	return true
end function

/''
 ' Register lifecycle function called by Meld framework.
 ' @returns {short}
 '/
function startup cdecl alias "startup" () as short export
	if moduleState.startups = 0 then
		if moduleState.methods.startup <> NULL then
			if not moduleState.methods.startup() then
				print("**** Default.startup: Module startup handler failed")
			elseif not test() then
				' TODO: Remove test from startup and move startup function to
				' end of boilerplate
				print("**** Default.start: Unit test failed")
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
				print("**** Default.startup: Module shutdown handler failed")
			end if
		end if
	end if

	return true
end function
