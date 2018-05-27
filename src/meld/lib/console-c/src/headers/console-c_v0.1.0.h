
/*
 * Generated by Meld Framework, do not modify.  Any changes will be overwritten
 * during the next build.
 */

#pragma once

namespace ConsoleC {


struct Interface {
	short (*startup) () __attribute__((cdecl));
	short (*shutdown) () __attribute__((cdecl));
	void* construct;
	void* destruct;
	void* update;
	short (*test) (void* describeFn) __attribute__((cdecl));
	void  (*logMessage) (char*  message ) __attribute__((cdecl));
	void  (*logWarning) (char*  id , char*  message , char*  source , int lineNum ) __attribute__((cdecl));
	void  (*logError) (char*  id , char*  message , char*  source , int lineNum ) __attribute__((cdecl));
	void  (*logSuccess) (char*  id , char*  message , char*  source , int lineNum ) __attribute__((cdecl));
};

}
