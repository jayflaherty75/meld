
#include once "../../modules/headers/constants/constants-v1.bi"
#include once "../../modules/headers/core/core-v1.bi"
#include once "meld/lib/core/core.bi"
#include once "meld/lib/error-handling/error-handling.bi"
#include once "meld/lib/fault/fault.bi"
#include once "meld/lib/tester/tester.bi"
#include once "shared/lib/bst/bst.bi"
#include once "shared/lib/console/console.bi"
#include once "shared/lib/identity/identity.bi"
#include once "shared/lib/iterator/iterator.bi"
#include once "shared/lib/list/list.bi"
#include once "shared/lib/paged-array/paged-array.bi"
#include once "shared/lib/resource-container/resource-container.bi"

namespace Bootstrap

type Dependencies
	core as Core.Interface ptr
	bst as Bst.Interface ptr
	console as Console.Interface ptr
	errorHandling as ErrorHandling.Interface ptr
	fault as Fault.Interface ptr
	identity as Identity.Interface ptr
	iterator as Iterator.Interface ptr
	list as List.Interface ptr
	pagedArray as PagedArray.Interface ptr
	resourceContainer as ResourceContainer.Interface ptr
	tester as Tester.Interface ptr
end type

dim shared as Dependencies deps
dim shared as Core.Interface corePtr

declare function run () as Bootstrap.Dependencies ptr

declare function _register (moduleName as zstring, interface as any ptr) as integer
declare function _require (moduleName as zstring) as any ptr

function run () as Bootstrap.Dependencies ptr

	corePtr.register = @_register
	corePtr.require = @_require

	Core.load(@corePtr)
	Tester.load(@corePtr)
	Console.load(@corePtr)
	Fault.load(@corePtr)
	ErrorHandling.load(@corePtr)
	Iterator.load(@corePtr)
	List.load(@corePtr)
	Bst.load(@corePtr)
	PagedArray.load(@corePtr)
	ResourceContainer.load(@corePtr)
	Identity.load(@corePtr)

	return @deps
end function

function _register (moduleName as zstring, interface as any ptr) as integer
	select case moduleName
		case "bst":
			deps.bst = interface
		case "console":
			deps.console = interface
		case "core":
			deps.core = interface
		case "fault":
			deps.fault = interface
		case "error-handling":
			deps.errorHandling = interface
		case "identity":
			deps.identity = interface
		case "iterator":
			deps.iterator = interface
		case "list":
			deps.list = interface
		case "paged-array":
			deps.pagedArray = interface
		case "resource-container":
			deps.resourceContainer = interface
		case "tester":
			deps.tester = interface
	end select

	return true
end function

function _require (moduleName as zstring) as any ptr
	dim as any ptr interface

	select case moduleName
		case "bst":
			interface = deps.bst
		case "console":
			interface = deps.console
		case "core":
			interface = deps.core
		case "fault":
			interface = deps.fault
		case "error-handling":
			interface = deps.errorHandling
		case "identity":
			interface = deps.identity
		case "iterator":
			interface = deps.iterator
		case "list":
			interface = deps.list
		case "paged-array":
			interface = deps.pagedArray
		case "resource-container":
			interface = deps.resourceContainer
		case "tester":
			interface = deps.tester
	end select

	return interface
end function

end namespace
