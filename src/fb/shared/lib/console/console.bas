
#include once "console.bi"

namespace Console

type Dependencies
	core as Core.Interface ptr
end type

type StateType
	deps as Dependencies
	methods as Interface
end type

dim shared as StateType state

declare function _format (byref id as zstring, byref message as string, byref source as zstring, lineNum as integer) as string

/''
 ' Loading lifecycle function called by Meld framework.
 ' @param {Core.Interface ptr} corePtr
 ' @returns {integer}
 '/
function load (corePtr as Core.Interface ptr) as integer
	if corePtr = NULL then
		print ("**** Console.load: Invalid Core interface pointer")
		return false
	end if

	state.methods.load = @load
	state.methods.unload = @unload
	state.methods.logMessage = @logMessage
	state.methods.logWarning = @logWarning
	state.methods.logError = @logError
	state.methods.logSuccess = @logSuccess

	if not corePtr->register("console", @state.methods) then
		return false
	end if

	state.deps.core = corePtr->require("core")

	return true
end function

/''
 ' Unload lifecycle function called by Meld framework.
 '/
sub unload()
end sub

sub logMessage (byref message as string)
	print (Time () & message)
end sub

sub logWarning (byref id as zstring, byref message as string, byref source as zstring, lineNum as integer)
	dim as ulong oldcol = color()

	color 6
	print (_format(id, message, source, lineNum))
	color (oldcol)
end sub

sub logError(byref id as zstring, byref message as string, byref source as zstring, lineNum as integer)
	dim as ulong oldcol = color()

	color 4
	print (_format(id, message, source, lineNum))
	color (oldcol)
end sub

sub logSuccess (byref id as zstring, byref message as string, byref source as zstring, lineNum as integer)
	dim as ulong oldcol = color()

	color 2
	print (_format(id, message, source, lineNum))
	color (oldcol)
end sub

function _format (byref id as zstring, byref message as string, byref source as zstring, lineNum as integer) as string
	dim as Core.Interface ptr corePtr = state.deps.core
	dim as zstring*3 newline = *corePtr->getNewline()

	return Time () & " - " & source & "(" & lineNum & ") " & newline & id & ": " & message
end function

end namespace
