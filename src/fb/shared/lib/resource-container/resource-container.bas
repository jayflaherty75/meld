
#include once "resource-container.bi"

namespace ResourceContainer

type Dependencies
	core as Core.Interface ptr
	pagedArray as PagedArray.Interface ptr
end type

type StateType
	deps as Dependencies
	methods as Interface
end type

dim shared as StateType state

/''
 ' Loading lifecycle function called by Meld framework.
 ' @param {MeldInterface ptr} corePtr
 ' @returns {integer}
 '/
function load (corePtr as Core.Interface ptr) as integer
	if corePtr = NULL then
		' TODO: Throw error
		print ("ResourceContainer.load: Invalid Core interface pointer")
		return false
	end if

	state.methods.load = @load
	state.methods.construct = @construct
	state.methods.destruct = @destruct
	state.methods.unload = @unload
	state.methods.request = @request
	state.methods.release = @release
	state.methods.getPtr = @getPtr

	if not corePtr->register("resource-container", @state.methods) then
		return false
	end if

	state.deps.core = corePtr->require("core")
	state.deps.pagedArray = corePtr->require("paged-array")

	return true
end function

/''
 ' Unload lifecycle function called by Meld framework.
 '/
sub unload()
end sub

/''
 ' Creates a resource container that manages the creation and reuse of existing
 ' resource.
 ' @param {zstring} id
 ' @param {integer} size
 ' @param {integer} pageLength
 ' @param {integer} warnLimit
 ' @returns {ResourceContainerObj ptr}
 '/
function construct (byref id as zstring, size as integer, pageLength as integer, warnLimit as integer) as ResourceContainerObj ptr
	dim as Dependencies ptr deps = @state.deps
	dim as ResourceContainerObj ptr contPtr = allocate(sizeof(ResourceContainerObj))
	dim as PagedArrayObj ptr resources
	dim as PagedArrayObj ptr stack

	if size <= 0 then
		' TODO: Throw error
		print ("RersourceContainer.construct: Element size must be greater than zero: " & id)
		return NULL
	end if

	resources = deps->pagedArray->construct(id & "_resources", size, pageLength, warnLimit)

	if resources = NULL then
		' TODO: Throw error
		print ("RersourceContainer.construct: Failed to create resources: " & id)
		return NULL
	end if

	stack = deps->pagedArray->construct(id & "_stack", sizeof(integer), pageLength, warnLimit)

	if stack = NULL then
		' TODO: Throw error
		print ("RersourceContainer.construct: Failed to create stack: " & id)
		return NULL
	end if

	contPtr->id = left(id, 32)
	contPtr->resources = resources
	contPtr->stack = stack

	return contPtr
end function

/''
 ' @param {ResourceContainerObj ptr} contPtr
 '/
sub destruct (contPtr as ResourceContainerObj ptr)
	dim as Dependencies ptr deps = @state.deps

	if contPtr = NULL then
		' TODO: Throw error
		print ("RersourceContainer.destruct: Invalid ResourceContainer pointer")
		exit sub
	end if

	if contPtr->resources <> NULL then
		deps->pagedArray->destruct(contPtr->resources)
		contPtr->resources = NULL
	end if

	if contPtr->stack <> NULL then
		deps->pagedArray->destruct(contPtr->stack)
		contPtr->stack = NULL
	end if
end sub

/''
 ' Request the index of a newly created resource.
 ' @param {ResourceContainerObj ptr} contPtr
 ' @returns {integer}
 '/
function request (contPtr as ResourceContainerObj ptr) as integer
	dim as Dependencies ptr deps = @state.deps
	dim as integer resourceId
	dim as any ptr resource = NULL

	if contPtr = NULL then
		' TODO: Throw error
		print ("RersourceContainer.request: Invalid ResourceContainer pointer")
		return -1
	end if

	if deps->pagedArray->isEmpty(contPtr->stack) then
		resourceId = deps->pagedArray->createIndex(contPtr->resources)
	else
		if not deps->pagedArray->pop(contPtr->stack, @resourceId) then
			' TODO: Throw error
			print ("RersourceContainer.request: Failed to reuse resouce from stack: " & contPtr->id)
			return -1
		end if
	end if

	return resourceId
end function

/''
 ' Release the resource of the given index.
 ' @param {ResourceContainerObj ptr} contPtr
 ' @param {integer} resourceId
 ' @returns {integer}
 '/
function release (contPtr as ResourceContainerObj ptr, resourceId as integer) as integer
	dim as Dependencies ptr deps = @state.deps
	dim as integer index
	dim as integer ptr stackPtr

	if contPtr = NULL then
		' TODO: Throw error
		print ("RersourceContainer.request: Invalid ResourceContainer pointer")
		return -1
	end if

	if resourceId <= 0 then
		' TODO: Throw error
		print ("RersourceContainer.release: Invalid resourceId argument: " & contPtr->id)
		return -1
	end if

	index = deps->pagedArray->createIndex(contPtr->stack)
	stackPtr = deps->pagedArray->getIndex(contPtr->stack, index)

	if stackPtr = NULL then
		' TODO: Throw error
		print ("RersourceContainer.release: Failed to reference stack: " & contPtr->id)
		return -1
	end if

	*stackPtr = resourceId

	return true
end function

/''
 ' Returns the point to the resource of the given index.
 ' @param {ResourceContainerObj ptr} contPtr
 ' @param {integer} resourceId
 ' @returns {any ptr}
 '/
function getPtr (contPtr as ResourceContainerObj ptr, resourceId as integer) as any ptr
	dim as Dependencies ptr deps = @state.deps

	if contPtr = NULL then
		' TODO: Throw error
		print ("RersourceContainer.request: Invalid ResourceContainer pointer")
		return NULL
	end if

	return deps->pagedArray->getIndex(contPtr->resources, resourceId)
end function

end namespace
