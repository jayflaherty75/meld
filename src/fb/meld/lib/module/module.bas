
#include once "module.bi"

/''
 ' @namespace Module
 '/
namespace Module

/''
 ' @class LibraryEntry
 ' @member {any ptr} library
 ' @member {any ptr} interfacePtr
 ' @member {String} moduleName
 ' @member {String} fileName
 '/

/''
 ' @typedef {function} ModuleWillLoadFn
 ' @param {any ptr} entryPtr
 ' @returns {short}
 '/

/''
 ' @typedef {function} ModuleHasUnloadedFn
 ' @param {any ptr} entryPtr
 ' @returns {short}
 '/

type StateType
	libraries(MODULE_MAX_ENTRIES) as LibraryEntry
	libraryCount as short
	argc as integer
	argv as zstring ptr ptr
	preloadHandler as ModuleWillLoadFn
	unloadHandler as ModuleHasUnloadedFn
end type

dim shared as StateType state
dim shared as Interface api

/''
 ' Initializes (or reinitializes) base module system.
 ' @function initialize
 ' @param {integer} _argc
 ' @param {any ptr} _argv
 ' @returns {short}
 '/
function initialize cdecl(_argc as integer, _argv as any ptr) as short
	state.libraryCount = 0
	state.argc = _argc
	state.argv = _argv

	api.initialize = @initialize
	api.uninitialize = @uninitialize
	api.setModuleWillLoad = @setModuleWillLoad
	api.setModuleHasUnloaded = @setModuleHasUnloaded
	api.require = @require
	api.argv = @argv
	api.argc = @argc

	setModuleWillLoad(NULL)
	setModuleHasUnloaded(NULL)

	return true
end function

/''
 ' Releases all external libraries.
 ' @function uninitialize
 ' @returns {short}
 '/
function uninitialize cdecl() as short
	dim as function cdecl () as short shutdownFn
	dim as function cdecl () as short unloadFn

	dim as any ptr library
	dim as integer index
	dim as short result = true

	for index = 0 to state.libraryCount - 1
		library = state.libraries(index).library

		shutdownFn = dylibsymbol(library, "shutdown")

		if shutdownFn <> NULL andalso not shutdownFn() then
			print("**** Module.uninitialize: Module shutdown failed")
			result = false
		end if
	next

	for index = 0 to state.libraryCount - 1
		library = state.libraries(index).library

		unloadFn = dylibsymbol(library, "unload")
		if unloadFn = NULL orelse not unloadFn() then
			dylibfree(library)

			if not state.unloadHandler(@state.libraries(index)) then
				print("**** Module.uninitialize: Warning: unload handler failed for " & state.libraries(index).moduleName)
			end if

			state.libraries(index).library = NULL
		end if
	next

	return result
end function

/''
 ' Set a handler callback to set the filenames for external libraries.  If
 ' passed NULL, the default handler will be set.
 ' @function setModuleWillLoad
 ' @param {ModuleWillLoadFn} handler
 '/
sub setModuleWillLoad cdecl (handler as ModuleWillLoadFn)
	if handler = NULL then
		state.preloadHandler = @_defaultPreloadHandler
	else
		state.preloadHandler = handler
	end if
end sub

/''
 ' Set a handler callback to set the filenames for external libraries.  If
 ' passed NULL, the default handler will be set.
 ' @function setModuleHasUnloaded
 ' @param {ModuleHasUnloadedFn} handler
 '/
sub setModuleHasUnloaded cdecl (handler as ModuleHasUnloadedFn)
	if handler = NULL then
		state.unloadHandler = @_defaultUnloadHandler
	else
		state.unloadHandler = handler
	end if
end sub

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

	dim as LibraryEntry ptr entryPtr
	dim as Interface safeApi = api

	if moduleName = "" then
		print("**** Module.require: Missing moduleName argument")
		return NULL
	end if

	entryPtr = _findEntry(moduleName)
	if entryPtr <> NULL then
		return entryPtr->interfacePtr
	end if

	entryPtr = @state.libraries(state.libraryCount)
	entryPtr->moduleName = moduleName

	if not state.preloadHandler(entryPtr) then
		print("**** Module.require: Missing module: " & moduleName)
		return NULL
	end if

	entryPtr->library = dylibload(entryPtr->filename)
	if entryPtr->library = NULL then
		print("**** Module.require: Failed to load module: " & moduleName)
		return NULL
	end if

	state.libraryCount += 1

	exportsFn = dylibsymbol(entryPtr->library, "exports")
	if exportsFn = NULL then
		print("**** Module.require: Missing exports function: " & moduleName)
		return NULL
	end if

	entryPtr->interfacePtr = exportsFn()
	if entryPtr->interfacePtr = NULL then
		print("**** Module.require: Missing interface: " & moduleName)
		return NULL
	end if

	loadFn = dylibsymbol(entryPtr->library, "load")
	if loadFn = NULL then
		print("**** Module.require: Missing load function: " & moduleName)
		return false
	end if

	if not loadFn(@safeApi) then
		print("**** Module.require: Call to load() method failed: " & moduleName)
		return false
	end if

	startupFn = dylibsymbol(entryPtr->library, "startup")
	if startupFn <> NULL andalso not startupFn() then
		print("**** Module.require: Call to startup() method failed: " & moduleName)
		return false
	end if

	return entryPtr->interfacePtr
end function

/''
 ' Manually shut down and unload a module
 ' @function unload
 ' @param {byref zstring} moduleName
 ' @returns {short}
 '/
function unload cdecl (byref moduleName as zstring) as short
	dim as function cdecl () as short shutdownFn
	dim as function cdecl () as short unloadFn

	dim as LibraryEntry ptr entryPtr

	if moduleName = "" then
		print("**** Module.unload: Missing moduleName argument")
		return false
	end if

	entryPtr = _findEntry(moduleName)
	if entryPtr = NULL then
		print("**** Module.unload: Not a loaded module: " & moduleName)
		return false
	end if

	if entryPtr->library = NULL then
		print("**** Module.unload: Module already unloaded: " & moduleName)
		return false
	end if

	shutdownFn = dylibsymbol(entryPtr->library, "shutdown")
	if shutdownFn <> NULL andalso not shutdownFn() then
		print("**** Module.unload: Module shutdown failed")
		return false
	end if

	unloadFn = dylibsymbol(entryPtr->library, "unload")
	if unloadFn = NULL orelse not unloadFn() then
		dylibfree(entryPtr->library)

		if not state.unloadHandler(entryPtr) then
			print("**** Module.unload: Warning: unload handler failed for " & entryPtr->moduleName)
		end if
	end if

	entryPtr->library = NULL
	entryPtr->moduleName = ""

	return true
end function

/''
 ' @function argv
 ' @param {ulong} index
 ' @returns {zstring ptr}
 '/
function argv cdecl (index as ulong) as zstring ptr
	if index >= state.argc then
		print("**** Module.argv: Invalid argument index: " & index)
		return NULL
	end if

	return state.argv[index]
end function

/''
 ' @function argc
 ' @returns {long}
 '/
function argc cdecl () as long
	return state.argc
end function

/''
 ' @function _findEntry
 ' @param {byref zstring} moduleName
 ' @returns {LibraryEntry ptr}
 ' @private
 '/
function _findEntry(byref moduleName as zstring) as LibraryEntry ptr
	dim as LibraryEntry ptr entryPtr = NULL
	dim as long index = 0

	do while entryPtr = NULL andalso index < state.libraryCount
		if state.libraries(index).moduleName = moduleName then
			entryPtr = @state.libraries(index)
		end if

		index += 1
	loop

	return entryPtr
end function

/''
 ' @function _defaultPreloadHandler
 ' @param {any ptr} entryPtr
 ' @returns {short}
 ' @private
 '/
function _defaultPreloadHandler cdecl (entryPtr as any ptr) as short
	dim as LibraryEntry ptr _entry = entryPtr

	_entry->filename = "modules" & DIR_SEP & _entry->moduleName & "." & EXTERNAL_MODULE_EXTENSION

	if not fileexists(_entry->filename) then
		return false
	end if

	return true
end function

/''
 ' @function _defaultUnloadHandler
 ' @param {any ptr} entryPtr
 ' @returns {short}
 ' @private
 '/
function _defaultUnloadHandler cdecl (entryPtr as any ptr) as short
	return true
end function

end namespace
