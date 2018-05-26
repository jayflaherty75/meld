

/**
 * @requires fault_v0.*
 * @requires sys_v0.*
 */

#include <stdio.h>
#include "module.h"
#include "errors.h"

/**
 * @namespace ConsoleC
 * @version 0.1.0
 */
namespace ConsoleC {

/**
 * Application main routine.
 * @function startup
 * @returns {short}
 */
short startup () {
	//_console->logMessage("Starting console module")

	return TRUE;
}

/**
 * Application main routine.
 * @function shutdown
 * @returns {short}
 */
short shutdown () {
	//_console->logMessage("Shutting down console module")

	return TRUE;
}

/**
 * Log a message to the console.
 * @function logMessage
 * @param {char *} message
 */
void logMessage (char*  message ) {
	//printf(!"%s - %s\n", Time(), message)
}

/**
 * Log a warning to the console.
 * @function logWarning
 * @param {char *} id
 * @param {char *} message
 * @param {char *} source
 * @param {int} lineNum
 */
void logWarning (char * id , char *  message , char*  source , int lineNum ) {
	//dim as ulong oldcol = color()

	//color 14
	//printf(_format(id, message, source, lineNum))
	//color (oldcol)
}

/**
 * Log an error to the console.
 * @function logError
 * @param {char *} id
 * @param {char *} message
 * @param {char *} source
 * @param {int} lineNum
 */
void logError (char*  id , char*  message , char*  source , int lineNum ) {
	//dim as ulong oldcol = color()

	//color 4
	//printf(_format(id, message, source, lineNum))
	//color (oldcol)
}

/**
 * Log a success message to the console.
 * @function logSuccess
 * @param {char *} id
 * @param {char *} message
 * @param {char *} source
 * @param {int} lineNum
 */
void logSuccess (char*  id , char*  message , char*  source, int lineNum ) {
	//dim as ulong oldcol = color()

	//color 2
	//printf(_format(id, message, source, lineNum))
	//color (oldcol)
}

/**
 * Write all messages to a standard format.
 * @function _format
 * @param {char *} id
 * @param {char *} message
 * @param {char *} source
 * @param {int} lineNum
 * @param {char *} source
 * @returns {string}
 * @private
 */
//function _format cdecl (byref id as zstring, byref message as zstring, byref source as zstring, lineNum as int) as string
//	return Time () & " - " & source & "(" & lineNum & ") " & *_sys->getNewline() & id & ": " & message & !"\n"
//end function

}

