
#include once "console.bi"
#include once "module.bi"

namespace Console

declare function _format (byref id as zstring, byref message as string, byref source as zstring, lineNum as integer) as string

sub logMessage (byref message as string)
	print (Time () & " - " & message)
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
	dim as zstring*3 newline

	if _core->getNewline <> NULL then
		newline = *_core->getNewline()
	else
		logMessage ("**** Console logger not properly initialized")
		newline = ""
	end if

	return Time () & " - " & source & "(" & lineNum & ") " & newline & id & ": " & message
end function

end namespace
