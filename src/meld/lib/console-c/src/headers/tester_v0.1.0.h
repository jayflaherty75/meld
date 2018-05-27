
/*
 * Generated by Meld Framework, do not modify.  Any changes will be overwritten
 * during the next build.
 */

#pragma once

namespace Tester {

typedef void  (*doneFn) () __attribute__((cdecl));
typedef void  (*testFunc) (doneFn done ) __attribute__((cdecl));
typedef short (*itCallback) (char*  description , testFunc test ) __attribute__((cdecl));
typedef short (*suiteFunc) (itCallback it ) __attribute__((cdecl));
typedef short (*describeCallback) (char*  description , suiteFunc callback ) __attribute__((cdecl));
typedef short (*testModule) (void*  describeFn ) __attribute__((cdecl));

struct Interface {
	short (*startup) () __attribute__((cdecl));
	short (*shutdown) () __attribute__((cdecl));
	void* construct;
	void* destruct;
	void* update;
	short (*test) (void* describeFn) __attribute__((cdecl));
	short (*run) (testModule*  tests , short count ) __attribute__((cdecl));
	short (*describe) (char*  description , suiteFunc callback ) __attribute__((cdecl));
	short (*suite) (char*  description , testFunc testFn ) __attribute__((cdecl));
	void  (*expect) (long result , long expected , char*  message ) __attribute__((cdecl));
	void  (*expectNot) (long result , long expected , char*  message ) __attribute__((cdecl));
	void  (*expectStr) (char*  result , char*  expected , char*  message ) __attribute__((cdecl));
	void  (*expectStrNot) (char*  result , char*  expected , char*  message ) __attribute__((cdecl));
	void  (*expectPtr) (void*  result , void*  expected , char*  message ) __attribute__((cdecl));
	void  (*expectPtrNot) (void*  result , void*  expected , char*  message ) __attribute__((cdecl));
};

}
