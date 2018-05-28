
/**
 * @requires sys_v0.1.0
 * @requires console_v0.1.0
 * @requires fault_v0.1.0
 * @requires tester_v0.1.0
 */

#include "module.h"
#include "test-c.h"
#include "errors.h"
#include "test.h"

/**
 * @namespace TestC
 * @version 0.1.0
 */
namespace TestC {

/**
 * Application main routine.
 * @function startup
 * @returns {short}
 */
short startup () {
	_console->logMessage("Starting test-c module");

	return TRUE;
}

/**
 * Application main routine.
 * @function shutdown
 * @returns {short}
 */
short shutdown () {
	_console->logMessage("Shutting down test-c module");

	return TRUE;
}

/**
 * Standard test runner for modules.
 * @function test
 * @param {void *} describeFn
 * @returns {short}
 */
short test (void *describeFn) {
	Tester::describeCallback describePtr = reinterpret_cast<Tester::describeCallback>(describeFn);
	short result = TRUE;

	result = result && describePtr ("The TestC module", testCreate);

	return result;
}

}
