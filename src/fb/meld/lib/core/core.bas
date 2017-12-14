
#include once "core.bi"

namespace Core

type StateType
    isRunning as integer
	status as integer
    mutexId as any ptr
	systemNewLine as zstring*8
	systemDirChar as zstring*8
	methods as Interface
end type

dim shared _console as Console.Interface ptr

dim shared as StateType state

/''
 ' Sets up everything needed by the Meld system and returns false on failure.
 ' @param {zstring ptr} config - First argument from command line
 ' @returns {integer}
 '/
function load (corePtr as Core.Interface ptr) as integer
	#IFDEF __FB_WIN32__
		state.systemNewLine = !"\r\n"
		state.systemDirChar = !"\\"
	#ELSE
		state.systemNewLine = !"\n"
		state.systemDirChar = "/"
	#ENDIF

    'state.methods.initialize = @initialize
    'state.methods.uninitialize = @uninitialize
    state.methods.isRunning = @isRunning
	state.methods.getStatus = @getStatus
	state.methods.register = @register
	state.methods.require = @require
    state.methods.shutdown = @shutdown
	state.methods.getNewline = @getNewline
	state.methods.getDirSep = @getDirSep

    state.mutexId = mutexcreate()

    if state.mutexId = NULL then
        return false
    end if

	if not corePtr->register("core", @state.methods) then
		return false
	end if

    state.isRunning = true
	state.status = 0

    return true
end function

sub unload ()
    mutexlock(state.mutexId)
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
	return true
end function

/''
 ' @param {zstring} name
 ' @returns {any ptr}
 '/
function require (byref moduleName as zstring) as any ptr
	return NULL
end function

/''
 ' @param {zstring} moduleName
 '/
function isLoaded (byref moduleName as zstring) as integer
	return true
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

end namespace
