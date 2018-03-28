
/'
' Generated by Meld Framework, do not modify.  Any changes will be overwritten
' during the next build.
'/

#include once "headers/module_v0.1.0.bi"
#include once "headers/console_v0.1.0.bi"
#include once "headers/fault_v0.1.0.bi"
#include once "headers/error-handling_v0.1.0.bi"
#include once "headers/tester_v0.1.0.bi"
#include once "headers/paged-array_v0.1.0.bi"
#include once "headers/resource-container_v0.1.0.bi"

#define NULL 0

dim shared _module as Module.Interface ptr
dim shared _resourcecontainer as Resourcecontainer.Interface ptr
dim shared _console as Console.Interface ptr
dim shared _fault as Fault.Interface ptr
dim shared _errorHandling as ErrorHandling.Interface ptr
dim shared _tester as Tester.Interface ptr
dim shared _pagedArray as PagedArray.Interface ptr

type ModuleStateType
	methods as ResourceContainer.Interface
	isLoaded as short
	isStarted as short
end type

type ErrorCodes
	invalidArgumentError as integer
	nullReferenceError as integer
	releaseResourceError as integer
	resourceAllocationError as integer
	resourceMissingError as integer
end type

dim shared as ModuleStateType moduleState
dim shared as ErrorCodes errors

namespace ResourceContainer

declare function startup cdecl () as short
declare function shutdown cdecl () as short
declare function test cdecl (describeFn as Tester.describeCallback) as short
declare function construct cdecl () as Instance ptr
declare sub destruct cdecl (contPtr as Instance ptr)
declare function initialize cdecl (contPtr as Instance ptr, size as short, pageLength as long, warnLimit as long) as short
declare function request cdecl (contPtr as Instance ptr) as long
declare function release cdecl (contPtr as Instance ptr, resourceId as long) as short
declare function getPtr cdecl (contPtr as Instance ptr, resourceId as long) as any ptr

end namespace

