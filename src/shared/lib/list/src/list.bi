
/'
 ' Generated by Meld Framework, do not modify.  Any changes will be overwritten
 ' during the next build.
 '/

#include once "headers/module_v0.1.0.bi"
#include once "headers/console_v0.1.0.bi"
#include once "headers/fault_v0.1.0.bi"
#include once "headers/error-handling_v0.1.0.bi"
#include once "headers/tester_v0.1.0.bi"
#include once "headers/iterator_v0.1.0.bi"
#include once "headers/list_v0.1.0.bi"

#define NULL 0

dim shared _module as Module.Interface ptr
dim shared _list as List.Interface ptr
dim shared _console as Console.Interface ptr
dim shared _fault as Fault.Interface ptr
dim shared _errorHandling as ErrorHandling.Interface ptr
dim shared _tester as Tester.Interface ptr
dim shared _iterator as Iterator.Interface ptr

type ModuleStateType
	methods as List.Interface
	isLoaded as short
	isStarted as short
end type

type ErrorCodes
	invalidArgumentError as integer
	nullReferenceError as integer
	releaseResourceError as integer
	resourceAllocationError as integer
end type

dim shared as ModuleStateType moduleState
dim shared as ErrorCodes errors

namespace List

declare function startup cdecl () as short
declare function shutdown cdecl () as short
declare function test cdecl (describeFn as any ptr) as short
declare function construct cdecl () as Instance ptr
declare sub destruct cdecl (listPtr as Instance ptr)
declare function insert cdecl (listPtr as Instance ptr, element as any ptr, prevPtr as Node ptr = 0) as Node ptr
declare sub remove cdecl (listPtr as Instance ptr, node as Node ptr)
declare function getFirst cdecl (listPtr as Instance ptr) as Node ptr
declare function getLast cdecl (listPtr as Instance ptr) as Node ptr
declare function getNext cdecl (listPtr as Instance ptr, node as Node ptr) as Node ptr
declare function getLength cdecl (listPtr as Instance ptr) as long
declare function search cdecl (listPtr as Instance ptr, element as any ptr, compare as CompareFn) as Node ptr
declare function defaultCompare cdecl (criteria as any ptr, current as any ptr) as short
declare function getIterator cdecl (listPtr as Instance ptr) as any ptr
declare function isValid cdecl (listPtr as Instance ptr) as short
declare function _iterationHandler cdecl (iter as Iterator.Instance ptr, target as any ptr) as short

end namespace

