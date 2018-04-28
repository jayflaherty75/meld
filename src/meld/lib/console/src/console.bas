

/''
 ' @requires fault_v0.1.0
 ' @requires sys_v0.1.0
 '/

#include once "module.bi"
#include once "errors.bi"
#include once "crt.bi"

/''
 ' @namespace Console
 ' @version 0.1.0
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
 ' @param {zstring ptr} message
 '/
sub logMessage cdecl (message as zstring ptr)
	printf(!"%s - %s\n", Time(), message)
end sub

/''
 ' Log a warning to the console.
 ' @function logWarning
 ' @param {zstring ptr} id
 ' @param {zstring ptr} message
 ' @param {zstring ptr} source
 ' @param {integer} lineNum
 '/
sub logWarning cdecl (id as zstring ptr, message as zstring ptr, source as zstring ptr, lineNum as integer)
	dim as ulong oldcol = color()

	color 14
	printf(_format(id, message, source, lineNum))
	color (oldcol)
end sub

/''
 ' Log an error to the console.
 ' @function logError
 ' @param {zstring ptr} id
 ' @param {zstring ptr} message
 ' @param {zstring ptr} source
 ' @param {integer} lineNum
 '/
sub logError cdecl (id as zstring ptr, message as zstring ptr, source as zstring ptr, lineNum as integer)
	dim as ulong oldcol = color()

	color 4
	printf(_format(id, message, source, lineNum))
	color (oldcol)
end sub

/''
 ' Log a success message to the console.
 ' @function logSuccess
 ' @param {zstring ptr} id
 ' @param {zstring ptr} message
 ' @param {zstring ptr} source
 ' @param {integer} lineNum
 '/
sub logSuccess cdecl (id as zstring ptr, message as zstring ptr, source as zstring ptr, lineNum as integer)
	dim as ulong oldcol = color()

	color 2
	printf(_format(id, message, source, lineNum))
	color (oldcol)
end sub

/''
 ' Write all messages to a standard format.
 ' @function _format
 ' @param {zstring ptr} id
 ' @param {zstring ptr} message
 ' @param {zstring ptr} source
 ' @param {integer} lineNum
 ' @returns {string}
 ' @private
 '/
function _format cdecl (id as zstring ptr, message as zstring ptr, source as zstring ptr, lineNum as integer) as string
	return Time () & " - " & *source & "(" & lineNum & ") " & *_sys->getNewline() & *id & ": " & *message & !"\n"
end function

end namespace

