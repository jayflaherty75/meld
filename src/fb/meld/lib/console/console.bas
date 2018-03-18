

/''
 ' @requires fault
 ' @requires error-handling
 ' @requires sys
 '/

#include once "../../../../../modules/headers/constants/constants-v1.bi"
#include once "module.bi"
#include once "errors.bi"

/''
 ' @namespace Console
 '/
namespace Console

/''
 ' Application main routine.
 ' @function startup
 ' @returns {short}
 '/
function startup cdecl () as short
	_console->logMessage("Starting console module")

	return true
end function

/''
 ' Application main routine.
 ' @function shutdown
 ' @returns {short}
 '/
function shutdown cdecl () as short
	_console->logMessage("Shutting down console module")

	return true
end function

/''
 ' Log a message to the console.
 ' @function logMessage
 ' @param {byref zstring} message
 '/
sub logMessage cdecl (byref message as zstring)
	print(Time () & " - " & message)
end sub

/''
 ' Log a warning to the console.
 ' @function logWarning
 ' @param {byref zstring} id
 ' @param {byref zstring} message
 ' @param {byref zstring} source
 ' @param {integer} lineNum
 '/
sub logWarning cdecl (byref id as zstring, byref message as zstring, byref source as zstring, lineNum as integer)
	dim as ulong oldcol = color()

	color 6
	print(_format(id, message, source, lineNum))
	color (oldcol)
end sub

/''
 ' Log an error to the console.
 ' @function logError
 ' @param {byref zstring} id
 ' @param {byref zstring} message
 ' @param {byref zstring} source
 ' @param {integer} lineNum
 '/
sub logError cdecl (byref id as zstring, byref message as zstring, byref source as zstring, lineNum as integer)
	dim as ulong oldcol = color()

	color 4
	print(_format(id, message, source, lineNum))
	color (oldcol)
end sub

/''
 ' Log a success message to the console.
 ' @function logSuccess
 ' @param {byref zstring} id
 ' @param {byref zstring} message
 ' @param {byref zstring} source
 ' @param {integer} lineNum
 '/
sub logSuccess cdecl (byref id as zstring, byref message as zstring, byref source as zstring, lineNum as integer)
	dim as ulong oldcol = color()

	color 2
	print(_format(id, message, source, lineNum))
	color (oldcol)
end sub

/''
 ' Write all messages to a standard format.
 ' @function _format
 ' @param {byref zstring} id
 ' @param {byref zstring} message
 ' @param {byref zstring} source
 ' @param {integer} lineNum
 ' @returns {string}
 ' @private
 '/
function _format cdecl (byref id as zstring, byref message as zstring, byref source as zstring, lineNum as integer) as string
	return Time () & " - " & source & "(" & lineNum & ") " & *_sys->getNewline() & id & ": " & message
end function

end namespace

