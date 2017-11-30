
#include once "console.bi"

namespace Console

type Dependencies
	meld as MeldInterface ptr
end type

type StateType
	deps as Dependencies
	methods as Interface
end type

dim shared as StateType state

declare function _format (byref id as zstring, byref message as string, byref source as zstring, lineNum as integer) as string

/''
 ' Loading lifecycle function called by Meld framework.
 ' @param {MeldInterface ptr} meld
 ' @returns {integer}
 '/
function load (meld as MeldInterface ptr) as integer
	if meld = NULL then
		print ("Console.load: Invalid meld interface pointer")
		return false
	end if

	state.methods.load = @load
	state.methods.unload = @unload
	state.methods.logmessage = @logmessage

	if not meld->register("console", @state.methods) then
		return false
	end if

	state.deps.meld = meld

	return true
end function

/''
 ' Unload lifecycle function called by Meld framework.
 '/
sub unload()
end sub

sub logMessage (byref id as zstring, byref message as string, byref source as zstring, lineNum as integer)
	print (_format(id, message, source, lineNum))
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
	dim as MeldInterface ptr meld = state.deps.meld

	return Time () & " - " & id & ": " & source & " (" & lineNum & ") " & meld->newline & message
end function

end namespace
