
#include once "../../../../modules/headers/meld/meld.bi"
#include once "../../shared/constants.bi"
#include once "module.bi"
#include once "error.bi"

' TODO: Read application config based on command line argument
' TODO: Register functions
' TODO: Add shutdown hook

type MeldCoreState
    isRunning as integer
    mutexId as any ptr
end type

dim shared meldCore as meldCoreState

declare function meldInitialize (config as zstring ptr) as integer
declare sub meldUninitialize()
declare function meldIsRunning() as integer
declare sub meldShutdown()

/''
 ' Sets up everything needed by the Meld system and returns false on failure.
 ' @param {zstring ptr} config - First argument from command line
 ' @returns {integer}
 '/
function meldInitialize (config as zstring ptr) as integer
    meldCore.mutexId = mutexcreate()

    if meldCore.mutexId = NULL then
        return FALSE
    end if

	errorInitialize(meldCore.mutexId)

    meldCore.isRunning = TRUE

    return TRUE
end function

/''
 ' Releases all resources used by the Meld Core system. Not responsible for
 ' installed system.  Ensure all installed resources have been released before
 ' calling meldUninitialize.
 '/
sub meldUninitialize()
	errorUninitialize()

    mutexlock(meldCore.mutexId)
    meldCore.isRunning = FALSE
    mutexunlock(meldCore.mutexId)

    if meldCore.mutexId then
        mutexdestroy (meldCore.mutexId)
        meldCore.mutexId = NULL
    end if
end sub

/''
 ' @returns {integer} - True if Meld is running
 '/
function meldIsRunning() as integer
    dim as integer isRunning

    mutexlock(meldCore.mutexId)
    isRunning = meldCore.isRunning
    mutexunlock(meldCore.mutexId)

    return isRunning
end function

/''
 ' Signals that Meld should stop running. It is up to the caller to check
 ' meldIsRunning and shut down the application when ready.
 '/
sub meldShutdown()
    mutexlock(meldCore.mutexId)
    meldCore.isRunning = FALSE
    mutexunlock(meldCore.mutexId)
end sub
