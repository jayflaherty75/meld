
/*
 * Generated by Meld Framework, do not modify.  Any changes will be overwritten
 * during the next build.
 */


#include <stdio.h>
#include once "headers/test-c_v0.1.0.bi"
#include once "test-c.bi"

Module::Interface _moduleLocal;

extern "C" void* exports () __attribute__((cdecl));
extern "C" short load (Module::Interface * modulePtr) __attribute__((cdecl));
extern "C" short unload () __attribute__((cdecl));

extern "C" short startup () __attribute__((cdecl));
extern "C" short shutdown () __attribute__((cdecl));

extern "C" void* exports () {
	

	return &moduleState.methods;
}

extern "C" short load (Module::Interface * modulePtr) {
	if (modulePtr == NULL) {
		printf("**** TestC::load: Invalid Module interface pointer\n");
		return FALSE;
	}

	if (!moduleState.isLoaded) {
		moduleState.isStarted = FALSE;
		moduleState.isLoaded = TRUE;

		_moduleLocal = *modulePtr;
		_module = &_moduleLocal;

		_testC = static_cast<TestC::Interface*>(exports());



	}

	return TRUE;
}

extern "C" short unload () {
	if (moduleState.isStarted) {
		if (moduleState.methods.shutdown != NULL) {
			if (!moduleState.methods.shutdown()) {
				printf("**** TestC::unload: Module shutdown handler failed\n");
				return FALSE;
			}
		}

		moduleState.isStarted = FALSE;
	}

	moduleState.isLoaded = FALSE;

	return TRUE;
}



extern "C" short startup () {
	if (!moduleState.isStarted) {
		if (moduleState.methods.startup != NULL) {
			if (!moduleState.methods.startup()) {
				printf("**** TestC::startup: Module startup handler failed\n");
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
				printf("**** TestC::shutdown: Module shutdown handler failed\n");
			}
		}

		moduleState.isStarted = FALSE;
	}

	return TRUE;
}
