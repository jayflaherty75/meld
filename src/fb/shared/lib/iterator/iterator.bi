
/'
' Generated by Meld Framework, do not modify.  Any changes will be overwritten
' during the next build.
'/

#include once "../../../../../modules/headers/iterator/iterator-v1.bi"

dim shared _iterator as Iterator.Interface ptr
dim shared _console as Console.Interface ptr
dim shared _fault as Fault.Interface ptr
dim shared _errorHandling as ErrorHandling.Interface ptr
dim shared _tester as Tester.Interface ptr

type ModuleStateType
	methods as Iterator.Interface
	isLoaded as short
	references as integer
	startups as integer
end type

type ErrorCodes
	invalidArgumentError as integer
	nullReferenceError as integer
	resourceAllocationError as integer
end type

dim shared as ModuleStateType moduleState
dim shared as ErrorCodes errors

namespace Iterator

declare function startup cdecl () as short
declare function shutdown cdecl () as short
declare function test cdecl (describe as Tester.describeCallback) as short
declare function construct cdecl () as Iterator.Instance ptr
declare sub destruct cdecl (iter as Iterator.Instance ptr)
declare sub setHandler cdecl (iter as Iterator.Instance ptr, cb as IteratorHandler)
declare sub setData cdecl (iter as Iterator.Instance ptr, dataSet as any ptr, setLength as long = -1)
declare function length cdecl (iter as Iterator.Instance ptr) as long
declare function getNext cdecl (iter as Iterator.Instance ptr, target as any ptr) as short
declare sub reset cdecl (iter as Iterator.Instance ptr)
declare function _defaultHandler cdecl (iter as Iterator.Instance ptr, target as any ptr) as short

end namespace

