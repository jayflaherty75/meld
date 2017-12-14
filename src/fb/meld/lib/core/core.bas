
#include once "file.bi"
#include once "core.bi"
#include once "../error-handling/error-handling.bi"
#include once "../fault/fault.bi"
#include once "../tester/tester.bi"
#include once "../../../shared/lib/console/console.bi"
#include once "../../../shared/lib/identity/identity.bi"
#include once "../../../shared/lib/iterator/iterator.bi"
#include once "../../../shared/lib/list/list.bi"
#include once "../../../shared/lib/map/map.bi"
#include once "../../../shared/lib/paged-array/paged-array.bi"
#include once "../../../shared/lib/resource-container/resource-container.bi"

#define MELDCORE_MAX_LOADED_MODULES			2048

namespace Core

type loadHandler as function cdecl (corePtr as Core.Interface ptr) as integer

type ModuleDesc
	moduleName as zstring*32
	fileName as zstring*36
	interface as any ptr
	lib as any ptr
end type

type StateType
	modules(MELDCORE_MAX_LOADED_MODULES) as ModuleDesc
	moduleCount as integer
	moduleInitCount as integer
    isRunning as integer
	status as integer
    mutexId as any ptr
	systemNewLine as zstring*3
	systemDirChar as zstring*3
	systemModuleExt as zstring*4
	methods as Interface
end type

dim shared _bst as Bst.Interface ptr

dim shared as StateType state

declare function _getModule (byref moduleName as zstring) as ModuleDesc ptr
declare function _loadModule (byref moduleName as zstring) as any ptr
declare function _registerModules() as integer

/''
 ' Sets up everything needed by the Meld system and returns false on failure.
 ' @param {zstring ptr} config - First argument from command line
 ' @returns {integer}
 '/
function load (corePtr as Core.Interface ptr) as integer
	#IFDEF __FB_WIN32__
		state.systemNewLine = !"\r\n"
		state.systemDirChar = !"\\"
		state.systemModuleExt = "dll"
	#ELSE
		state.systemNewLine = !"\n"
		state.systemDirChar = "/"
		state.systemModuleExt = "so"
	#ENDIF

	state.methods.load = @load
	state.methods.unload = @unload
	state.methods.initialize = NULL
	state.methods.uninitialize = NULL
    state.methods.isRunning = @isRunning
	state.methods.getStatus = @getStatus
	state.methods.register = @register
	state.methods.require = @require
    state.methods.isLoaded = @isLoaded
    state.methods.shutdown = @shutdown
	state.methods.getNewline = @getNewline
	state.methods.getDirSep = @getDirSep

    state.mutexId = mutexcreate()

    if state.mutexId = NULL then
        return false
    end if

	state.moduleCount = 0
	state.moduleInitCount = 0
	state.status = 0
    state.isRunning = true

	if not corePtr->register("core", @state.methods) then
		return false
	end if

	if not register("core", @state.methods) then
		return false
	end if

	_registerModules()

	Tester.load(@state.methods)
	Console.load(@state.methods)
	Fault.load(@state.methods)

	_registerModules()

	'_bst = require("bst")

	ErrorHandling.load(@state.methods)
	Identity.load(@state.methods)
	Iterator.load(@state.methods)
	List.load(@state.methods)
	'Map.load(@state.methods)
	PagedArray.load(@state.methods)
	ResourceContainer.load(@state.methods)

	_registerModules()

    return true
end function

sub unload ()
	dim as integer index

    mutexlock(state.mutexId)

	for index = 0 to state.moduleCount - 1
		if state.modules(index).lib <> NULL then
			dylibfree(state.modules(index).lib)
		end if
	next

	state.moduleCount = 0
	state.moduleInitCount = 0
    state.isRunning = false

    mutexunlock(state.mutexId)

    if state.mutexId then
        mutexdestroy (state.mutexId)
        state.mutexId = NULL
    end if
end sub

/''
 ' @returns {integer} - True if Meld is running
 '/
function isRunning() as integer
    dim as integer result

    mutexlock(state.mutexId)
    result = state.isRunning
    mutexunlock(state.mutexId)

    return result
end function

/''
 ' Return the status for the system.
 ' @returns {integer}
 '/
function getStatus() as integer
	return state.status
end function

/''
 ' @param {zstring} name
 ' @param {any ptr} interface
 ' @returns {integer}
 '/
function register(byref moduleName as zstring, interface as any ptr) as integer
	dim as ModuleDesc ptr modulePtr = _getModule(moduleName)

	if modulePtr <> NULL then
		print("**** Module already loaded: " & moduleName)
		return false
	end if

    mutexlock(state.mutexId)
	modulePtr = @state.modules(state.moduleCount)
	modulePtr->moduleName = moduleName
	modulePtr->fileName = moduleName
	modulePtr->interface = interface
	modulePtr->lib = NULL
	state.moduleCount += 1
    mutexunlock(state.mutexId)

	return true
end function

/''
 ' @param {zstring} name
 ' @returns {any ptr}
 '/
function require (byref moduleName as zstring) as any ptr
	dim as ModuleDesc ptr modulePtr = _getModule(moduleName)
	dim as integer isRootRequire = sgn(state.moduleInitCount - state.moduleCount)
	dim as any ptr moduleExt
	dim as loadHandler loadFn

	' Already loaded, just return the interface
	if modulePtr <> NULL then
		return modulePtr->interface
	end if

	' Attempt to load the module from directory
	moduleExt = _loadModule(moduleName)

	if moduleExt = NULL then
		print("**** Failed to load module: " & moduleName)
		return NULL
	end if

	' Find load handler function in module library
	loadFn = dylibsymbol (moduleExt, "moduleLoader")

	if loadFn = NULL then
		print("**** Missing loader function in module: " & moduleName)
		dylibfree(moduleExt)
		return NULL
	end if

	' Call load handler which should call back to register()
	if not load(@state.methods) then
		print("**** Module loader function failed: " & moduleName)
		return NULL
	end if

	' If register was properly called, we should have a module saved
	modulePtr = _getModule(moduleName)

	if modulePtr = NULL then
		print("**** Module failed to register: " & moduleName)
		return NULL
	end if

	' Save the library in memory to the module descriptor
	modulePtr->lib = moduleExt

	' Register this and any dependencies if a root call to require
	if isRootRequire andalso not _registerModules() then
		return NULL
	end if

	return modulePtr->interface
end function

/''
 ' @param {zstring} moduleName
 '/
function isLoaded (byref moduleName as zstring) as integer
	dim as ModuleDesc ptr modulePtr = _getModule(moduleName)
	dim as integer result = false

	if modulePtr <> NULL then
		result = true
	end if

	return result
end function

/''
 ' Signals that Meld should stop running. It is up to the caller to check
 ' Core.isRunning and shut down the application when ready.
 ' @param {integer} status
 '/
sub shutdown(status as integer)
    mutexlock(state.mutexId)
    state.isRunning = false
	state.status = status
    mutexunlock(state.mutexId)
end sub

/''
 ' @returns {zstring}
 '/
function getNewline() as zstring ptr
	return @state.systemNewLine
end function

/''
 ' @returns {zstring}
 '/
function getDirSep() as zstring ptr
	return @state.systemDirChar
end function

/''
 ' @param {zstring} moduleName
 ' @returns {ModuleDesc ptr}
 ' @private
 '/
function _getModule (byref moduleName as zstring) as ModuleDesc ptr
	dim as ModuleDesc ptr result = NULL
	dim as integer index = 0

	if _bst then
		' TODO: Implement module search
	else
		do while index < state.moduleCount andalso result = NULL
			if state.modules(index).moduleName = moduleName then
				result = @state.modules(index)
			else
				index += 1
			end if
		loop
	end if

	return result
end function

/''
 ' @param {zstring} name
 ' @returns {any ptr}
 ' @private
 '/
function _loadModule (byref moduleName as zstring) as any ptr
	dim as string filename = "modules" & state.systemDirChar & moduleName & "." & state.systemModuleExt

	if not fileexists(filename) then
		print("**** Missing module: " & filename)
	end if

	' TODO: Load module from copy in modules/running

	return dylibload (filename)
end function

/''
 ' Calls register lifecycle function on any modules that have not been
 ' registered.
 ' @returns {integer}
 ' @private
 '/
function _registerModules() as integer
	dim as StandardInterface ptr interface
	dim as integer result = true
	dim as integer regIndex

	for regIndex = state.moduleCount - 1 to state.moduleInitCount step -1
		interface = state.modules(regIndex).interface

		if interface <> NULL andalso interface->register <> NULL andalso not interface->register() then
			print ("**** Failed to register module: " & state.modules(regIndex).moduleName)
			result = false
		end if
	next

	state.moduleInitCount = state.moduleCount

	return result
end function

end namespace
