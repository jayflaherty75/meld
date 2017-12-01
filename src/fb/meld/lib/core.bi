
#include once "../../../../modules/headers/meld/meld-v1.bi"
#include once "../../../../modules/headers/constants/constants-v1.bi"
'#include once "../interfaces/interfaces.bi"

' TODO: Read application config based on command line argument
' TODO: Register functions
' TODO: Add shutdown hook

type MeldCoreState
    isRunning as integer
	status as integer
    mutexId as any ptr
	systemNewLine as string
	systemDirChar as string
	methods as MeldInterface
end type

dim shared meldCore as meldCoreState

declare function meldInitialize (config as zstring ptr) as integer
declare sub meldUninitialize()
declare function meldIsRunning() as integer
declare function meldGetStatus() as integer
declare function meldRegister (byref moduleName as zstring, interface as any ptr) as integer
declare function meldRequire (byref moduleName as zstring) as any ptr
declare sub meldShutdown(status as integer)

/''
 ' Sets up everything needed by the Meld system and returns false on failure.
 ' @param {zstring ptr} config - First argument from command line
 ' @returns {integer}
 '/
function meldInitialize (config as zstring ptr) as integer
	#IFDEF __FB_WIN32__
		meldCore.systemNewLine = "\r\n"
		meldCore.systemDirChar = "\\"
	#ELSE
		meldCore.systemNewLine = "\n"
		meldCore.systemDirChar = "/"
	#ENDIF

    meldCore.methods.initialize = @meldInitialize
    meldCore.methods.uninitialize = @meldUninitialize
    meldCore.methods.isRunning = @meldIsRunning
	meldCore.methods.getStatus = @meldGetStatus
	meldCore.methods.register = @meldRegister
	meldCore.methods.require = @meldRequire
    meldCore.methods.shutdown = @meldShutdown

	meldCore.methods.newline = strptr(meldCore.systemNewLine)
	meldCore.methods.dirsep = strptr(meldCore.systemDirChar)

    meldCore.mutexId = mutexcreate()

    if meldCore.mutexId = NULL then
        return false
    end if

    meldCore.isRunning = true
	meldCore.status = 0

    return true
end function

/''
 ' Releases all resources used by the Meld Core system. Not responsible for
 ' installed system.  Ensure all installed resources have been released before
 ' calling meldUninitialize.
 '/
sub meldUninitialize()
    mutexlock(meldCore.mutexId)
    meldCore.isRunning = false
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
 ' Return the status for the system.
 ' @returns {integer}
 '/
function meldGetStatus() as integer
	return meldCore.status
end function

/''
 ' @param {zstring} name
 ' @param {any ptr} interface
 ' @returns {integer}
 '/
function meldRegister(byref moduleName as zstring, interface as any ptr) as integer
	return true
end function

/''
 ' @param {zstring} name
 ' @returns {any ptr}
 '/
function meldRequire (byref moduleName as zstring) as any ptr
	return NULL
end function

/''
 ' Signals that Meld should stop running. It is up to the caller to check
 ' meldIsRunning and shut down the application when ready.
 ' @param {integer} status
 '/
sub meldShutdown(status as integer)
    mutexlock(meldCore.mutexId)
    meldCore.isRunning = false
	meldCore.status = status
    mutexunlock(meldCore.mutexId)
end sub
