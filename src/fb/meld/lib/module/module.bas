
/''
 ' @requires constants
 '/

#include once "module.bi"

/''
 ' @namespace Module
 '/
namespace Module

type StateType
	libraries(MODULE_MAX_ENTRIES) as any ptr
	libraryCount as short
end type

dim shared as StateType state
dim shared as Interface api

/''
 ' Initializes (or reinitializes) base module system.
 ' @function initialize
 ' @returns {short}
 '/
function initialize cdecl() as short
	dim as Interface ptr apiPtr = @api

	state.libraryCount = 0

	apiPtr->initialize = @initialize
	apiPtr->uninitialize = @uninitialize
	apiPtr->require = @require

	return true
end function

/''
 ' Releases all external libraries.
 ' @function uninitialize
 ' @returns {short}
 '/
function uninitialize cdecl() as short
	dim as function cdecl () as short shutdownFn
	dim as sub cdecl () unloadFn

	dim as any ptr library
	dim as integer index
	dim as short result = true

	for index = 0 to state.libraryCount - 1
		library = state.libraries(index)

		shutdownFn = dylibsymbol(library, "shutdown")
		if shutdownFn <> NULL andalso not shutdownFn() then
			print("**** Module.uninitialize: Module shutdown failed")
			result = false
		end if

		unloadFn = dylibsymbol(library, "unload")
		if unloadFn <> NULL then
			unloadFn()
		end if

		dylibfree(library)
		state.libraries(index) = NULL
	next

	return result
end function

/''
 ' Returns a pointer to the required interface.
 ' @function require
 ' @param {byref zstring} moduleName
 ' @returns {any ptr}
 '/
function require cdecl (byref moduleName as zstring) as any ptr
	dim as function cdecl (modulePtr as Interface ptr) as short loadFn
	dim as function cdecl () as any ptr exportsFn
	dim as function cdecl () as short startupFn

	dim as Interface safeApi = api
	dim as string filename
	dim as any ptr library
	dim as any ptr interfacePtr

	if moduleName = "" then
		print("**** Module.require: Missing moduleName argument")
		return NULL
	end if

	filename = "modules" & DIR_SEP & moduleName & "." & EXTERNAL_MODULE_EXTENSION
	if not fileexists(filename) then
		print("**** Module.require: Missing module: " & filename)
		return NULL
	end if

	library = dylibload(filename)
	if library = NULL then
		print("**** Module.require: Failed to load module: " & filename)
		return NULL
	end if

	state.libraries(state.libraryCount) = library
	state.libraryCount += 1

	exportsFn = dylibsymbol(library, "exports")
	if exportsFn = NULL then
		print("**** Module.require: Missing exports function: " & filename)
		return NULL
	end if

	interfacePtr = exportsFn()
	if interfacePtr = NULL then
		print("**** Module.require: Missing interface: " & filename)
		return NULL
	end if

	loadFn = dylibsymbol(library, "load")
	if loadFn = NULL then
		print("**** Module.require: Missing load function: " & filename)
		return false
	end if

	if not loadFn(@safeApi) then
		print("**** Module.require: Call to load() method failed: " & filename)
		return false
	end if

	startupFn = dylibsymbol(library, "startup")
	if startupFn <> NULL andalso not startupFn() then
		print("**** Module.require: Call to startup() method failed: " & filename)
		return false
	end if

	return interfacePtr
end function

end namespace
