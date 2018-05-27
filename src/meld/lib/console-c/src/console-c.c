

/**
 * @requires fault_v0.*
 * @requires sys_v0.*
 * @requires tester_v0.*
 */

#include <stdio.h>
#include <time.h>
#include "module.h"
#include "console-c.h"
#include "errors.h"
#include "test.h"

#define ANSI_COLOR_RED     "\x1b[31m"
#define ANSI_COLOR_GREEN   "\x1b[32m"
#define ANSI_COLOR_YELLOW  "\x1b[33m"
#define ANSI_COLOR_BLUE    "\x1b[34m"
#define ANSI_COLOR_MAGENTA "\x1b[35m"
#define ANSI_COLOR_CYAN    "\x1b[36m"
#define ANSI_COLOR_RESET   "\x1b[0m"

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
	_consoleC->logMessage("Starting console-c module");

	return TRUE;
}

/**
 * Application main routine.
 * @function shutdown
 * @returns {short}
 */
short shutdown () {
	_consoleC->logMessage("Shutting down console-c module");

	return TRUE;
}

/**
 * Standard test runner for modules.
 * @function test
 * @param {any ptr} describeFn
 * @returns {short}
 */
short test (void *describeFn) {
	Tester::describeCallback describePtr = reinterpret_cast<Tester::describeCallback>(describeFn);
	short result = TRUE;

	result = result && describePtr ("The ConsoleC module", testCreate);

	return result;
}

/**
 * Log a message to the console.
 * @function logMessage
 * @param {char *} message
 */
void logMessage (char*  message ) {
	char buffer[16];

	printf("%s - %s%s", _time(buffer), message, _sys->getNewline());
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
	char buffer[16];

	printf(
		ANSI_COLOR_YELLOW "%s - %s(%d)" ANSI_COLOR_RESET "%s",
		_time(buffer),
		source,
		lineNum,
		_sys->getNewline()
	);
	printf(
		ANSI_COLOR_YELLOW "%s: %s" ANSI_COLOR_RESET "%s",
		id,
		message,
		_sys->getNewline()
	);
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
	char buffer[16];

	printf(
		ANSI_COLOR_RED "%s - %s(%d)" ANSI_COLOR_RESET "%s",
		_time(buffer),
		source,
		lineNum,
		_sys->getNewline()
	);
	printf(
		ANSI_COLOR_RED "%s: %s" ANSI_COLOR_RESET "%s",
		id,
		message,
		_sys->getNewline()
	);
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
	char buffer[16];

	printf(
		ANSI_COLOR_GREEN "%s - %s(%d)" ANSI_COLOR_RESET "%s",
		_time(buffer),
		source,
		lineNum,
		_sys->getNewline()
	);
	printf(
		ANSI_COLOR_GREEN "%s: %s" ANSI_COLOR_RESET "%s",
		id,
		message,
		_sys->getNewline()
	);
}

/**
 * @function _time
 * @param {char *} buffer
 * @returns {char *} Simply returns the buffer pointer for chaining
 * @private
 */
char * _time (char *buffer) {
	time_t rawtime;
	struct tm * timeinfo;

	time (&rawtime);
	timeinfo = localtime (&rawtime);
	strftime(buffer, 16, "%H:%M:%S", timeinfo);

	return buffer;
}

}
