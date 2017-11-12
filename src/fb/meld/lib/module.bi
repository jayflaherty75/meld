
#include once "../../../../modules/headers/meld/meld.bi"
#include once "../shared/constants.bi"

#define MELD_MAX_MODULES			16

type lifecycleInterface
	' Called when the file is loaded, setting any data global to the service
	load as function (meldPtr as meldInterface ptr, mutexId as any ptr = NULL) as integer
	' Called when instantiated.  This creates any state required by the service instance
	construct as function () as any ptr
	' Called when installed by another service and receives it's resourceId
	register as function () as any ptr
	' Once all services have been loaded for a group, called to build state for that group
	initalize as function () as any ptr
	' All set to go, this is called on every frame
	update as function () as any ptr
	' Service group is disbanding so stop anything currently running
	uninitialize as function () as any ptr
	' Remove all references created in registration
	unregister as function () as any ptr
	' No longer associated with service group, free to release resources
	destruct as function () as any ptr
	' File is being removed from memory altogether; Important for application shutdown
	unload as function () as any ptr
end type

type ModuleInfo
	parent as any ptr
	dependencies as integer
	childCount as integer
	index as integer
	dataPtr as any ptr
end type

type Module
	info as moduleInfo
	lifecycle as lifecycleInterface
	interfaceOffset as integer
	internalOffset as integer
	interface as interfaceHeader
end type

type ModuleState
	modules(MELD_MAX_MODULES) as Module ptr
	moduleCount as integer
end type

dim shared as ModuleState modState

declare function moduleNew(interface as InterfaceHeader ptr) as Module ptr
declare sub moduleDelete(modulePtr as any ptr)
declare function moduleRequest () as any ptr
declare function moduleRelease () as integer

function moduleNew(interface as InterfaceHeader ptr) as Module ptr
	dim as Module ptr modulePtr = NULL
	dim as integer moduleSize = sizeof(Module)
	dim as integer funcCount = interface->funcCount
	dim as functionHeader ptr funcs = cptr(any ptr, interface + 1)

	return modulePtr
end function

sub moduleDelete(modulePtr as any ptr)
end sub

function moduleRequest () as any ptr
	return NULL
end function

function moduleRelease () as integer
	return TRUE
end function
