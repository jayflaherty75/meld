
/*
 * Generated by Meld Framework, do not modify.  Any changes will be overwritten
 * during the next build.
 */

#pragma once

namespace TestC {


struct Interface {
	short (*startup) () __attribute__((cdecl));
	short (*shutdown) () __attribute__((cdecl));
	void* construct;
	void* destruct;
	void* update;
	short (*test) (void* describeFn) __attribute__((cdecl));
	short (*sayHello) (char*  name ) __attribute__((cdecl));
};

}
