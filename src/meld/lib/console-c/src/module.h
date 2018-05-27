
/*
 * Generated by Meld Framework, do not modify.  Any changes will be overwritten
 * during the next build.
 */

#pragma once

#include <stdio.h>
#include "headers/tester_v0.1.0.h"
#include "headers/console-c_v0.1.0.h"
#include "console-c.h"

Module::Interface _moduleLocal;

extern "C" void* exports () __attribute__((cdecl));
extern "C" short load (Module::Interface * modulePtr) __attribute__((cdecl));
extern "C" short unload () __attribute__((cdecl));
extern "C" short startup () __attribute__((cdecl));
extern "C" short shutdown () __attribute__((cdecl));

extern "C" void* exports () {
	moduleState.methods.startup = ConsoleC::startup;
	moduleState.methods.shutdown = ConsoleC::shutdown;
	moduleState.methods.logMessage = ConsoleC::logMessage;
	moduleState.methods.logWarning = ConsoleC::logWarning;
	moduleState.methods.logError = ConsoleC::logError;
	moduleState.methods.logSuccess = ConsoleC::logSuccess;
	moduleState.methods.test = ConsoleC::test;

	return &moduleState.methods;
}

extern "C" short load (Module::Interface * modulePtr) {
	printf("\n");

	if (modulePtr == NULL) {
		printf("**** ConsoleC::load: Invalid Module interface pointer\n");
		return FALSE;
	}

	if (!moduleState.isLoaded) {
		moduleState.isStarted = FALSE;
		moduleState.isLoaded = TRUE;

		_moduleLocal = *modulePtr;
		_module = &_moduleLocal;

		_consoleC = static_cast<ConsoleC::Interface*>(exports());

		_fault = static_cast<Fault::Interface*>((*modulePtr->require)("fault_v0.1.0"));
		if (_fault == NULL) {
			printf("**** ConsoleC::load: Failed to load fault dependency\n");
			return FALSE;
		}

		_sys = static_cast<Sys::Interface*>((*modulePtr->require)("sys_v0.1.0"));
		if (_sys == NULL) {
			printf("**** ConsoleC::load: Failed to load sys dependency\n");
			return FALSE;
		}

		_tester = static_cast<Tester::Interface*>((*modulePtr->require)("tester_v0.1.0"));
		if (_tester == NULL) {
			printf("**** ConsoleC::load: Failed to load tester dependency\n");
			return FALSE;
		}

		errors.generalError = _fault->getCode("GeneralError");
		if (errors.generalError == NULL) {
			printf("**** Default.load: Missing error definition for GeneralError\n");
			return FALSE;
		}
	}

	return TRUE;
}

extern "C" short unload () {
	if (moduleState.isStarted) {
		if (moduleState.methods.shutdown != NULL) {
			if (!moduleState.methods.shutdown()) {
				printf("**** ConsoleC::unload: Module shutdown handler failed\n");
				return FALSE;
			}
		}

		moduleState.isStarted = FALSE;
	}

	moduleState.isLoaded = FALSE;

	return TRUE;
}

extern "C" short test () {
	ConsoleC::Interface *interfacePtr = _consoleC;
	Tester::testModule tests[1];

	if (interfacePtr->test == NULL) {
		return TRUE;
	}

	tests[0] = interfacePtr->test;

	if (!_tester->run(tests, 1)) {
		return FALSE;
	}

	return TRUE;
}

extern "C" short startup () {
	if (!moduleState.isStarted) {
		if (moduleState.methods.startup != NULL) {
			if (!moduleState.methods.startup()) {
				printf("**** ConsoleC::startup: Module startup handler failed\n");
				return FALSE;
			}
		}

		moduleState.isStarted = TRUE;
	}

	return TRUE;
}

extern "C" short shutdown () {
	if (moduleState.isStarted) {
		if (moduleState.methods.shutdown != NULL) {
			if (!moduleState.methods.shutdown()) {
				printf("**** ConsoleC::shutdown: Module shutdown handler failed\n");
			}
		}

		moduleState.isStarted = FALSE;
	}

	return TRUE;
}
