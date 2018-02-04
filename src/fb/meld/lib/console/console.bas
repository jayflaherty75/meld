
/''
 ' @requires constants
 ' @requires module
 '/

#include once "module.bi"
' #include once "errors.bi"

/''
 ' Console interface
 ' @namespace Console
 '/
namespace Console

/''
 ' Log a message to the console.
 ' @function logMessage
 ' @param {byref string} message
 '/
sub logMessage cdecl (byref message as string)
	print(Time () & " - " & message)
end sub

/''
 ' Log a warning to the console.
 ' @function logWarning
 ' @param {byref zstring} id
 ' @param {byref string} message
 ' @param {byref zstring} source
 ' @param {integer} lineNum
 '/
sub logWarning cdecl (byref id as zstring, byref message as string, byref source as zstring, lineNum as integer)
	dim as ulong oldcol = color()

	color 6
	print(_format(id, message, source, lineNum))
	color (oldcol)
end sub

/''
 ' Log an error to the console.
 ' @function logError
 ' @param {byref zstring} id
 ' @param {byref string} message
 ' @param {byref zstring} source
 ' @param {integer} lineNum
 '/
sub logError cdecl (byref id as zstring, byref message as string, byref source as zstring, lineNum as integer)
	dim as ulong oldcol = color()

	color 4
	print(_format(id, message, source, lineNum))
	color (oldcol)
end sub

/''
 ' Log a success message to the console.
 ' @function logSuccess
 ' @param {byref zstring} id
 ' @param {byref string} message
 ' @param {byref zstring} source
 ' @param {integer} lineNum
 '/
sub logSuccess cdecl (byref id as zstring, byref message as string, byref source as zstring, lineNum as integer)
	dim as ulong oldcol = color()

	color 2
	print(_format(id, message, source, lineNum))
	color (oldcol)
end sub

/''
 ' Write all messages to a standard format.
 ' @function _format
 ' @param {byref zstring} id
 ' @param {byref string} message
 ' @param {byref zstring} source
 ' @param {integer} lineNum
 ' @returns {string}
 ' @private
 '/
function _format (byref id as zstring, byref message as string, byref source as zstring, lineNum as integer) as string
	dim as zstring*3 newline

	'if _core->getNewline <> NULL then
		newline = !"\n" ' *_core->getNewline()
	'else
	'	logMessage ("**** Console logger not properly initialized")
	'	newline = " "
	'end if

	return Time () & " - " & source & "(" & lineNum & ") " & newline & id & ": " & message
end function

end namespace
