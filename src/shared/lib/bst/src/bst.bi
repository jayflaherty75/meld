
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
#include once "headers/bst_v0.1.0.bi"

#define NULL 0

dim shared _module as Module.Interface ptr
dim shared _bst as Bst.Interface ptr
dim shared _console as Console.Interface ptr
dim shared _fault as Fault.Interface ptr
dim shared _errorHandling as ErrorHandling.Interface ptr
dim shared _tester as Tester.Interface ptr
dim shared _iterator as Iterator.Interface ptr

type ModuleStateType
	methods as Bst.Interface
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

namespace Bst

declare function startup cdecl () as short
declare function shutdown cdecl () as short
declare function test cdecl (describeFn as any ptr) as short
declare function construct cdecl () as Bst.Instance ptr
declare sub destruct cdecl (btreePtr as Bst.Instance ptr)
declare function insert cdecl (btreePtr as Bst.Instance ptr, element as any ptr) as Bst.Node ptr
declare sub remove cdecl (btreePtr as Bst.Instance ptr, nodePtr as Bst.Node ptr)
declare sub purge cdecl (btreePtr as Bst.Instance ptr)
declare function search cdecl (btreePtr as Bst.Instance ptr, element as any ptr, start as Bst.Node ptr = 0) as Bst.Node ptr
declare function getLength cdecl (btreePtr as Bst.Instance ptr) as integer
declare function getIterator cdecl (btreePtr as Bst.Instance ptr) as any ptr
declare function defaultCompare cdecl (criteria as any ptr, element as any ptr) as short
declare function _createNode cdecl (btreePtr as Bst.Instance ptr, element as any ptr) as Bst.Node ptr
declare sub _deleteNode cdecl (btreePtr as Bst.Instance ptr, nodePtr as Bst.Node ptr)
declare sub _deleteNodeRecurse cdecl (btreePtr as Bst.Instance ptr, nodePtr as Bst.Node ptr)
declare function _searchRecurse cdecl (btreePtr as Bst.Instance ptr, nodePtr as Bst.Node ptr, element as any ptr) as Bst.Node ptr
declare function _recurseLeft cdecl (nodePtr as Bst.Node ptr) as Bst.Node ptr
declare function _nextParentRecurse cdecl (btreePtr as Bst.Instance ptr, current as Bst.Node ptr, element as any ptr) as Bst.Node ptr
declare function _iterationHandler cdecl (iter as Iterator.Instance ptr, target as any ptr) as integer

end namespace

