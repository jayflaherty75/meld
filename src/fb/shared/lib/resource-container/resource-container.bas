
#include once "resource-container.bi"

namespace ResourceContainer

type Dependencies
	meld as MeldInterface ptr
	pagedArray as PagedArray.Interface ptr
end type

type StateType
	deps as Dependencies
	methods as Interface
end type

dim shared as StateType state

/''
 ' Loading lifecycle function called by Meld framework.
 ' @param {MeldInterface ptr} meld
 ' @returns {integer}
 '/
function load (meld as MeldInterface ptr) as integer
	if meld = NULL then
		' TODO: Throw error
		print ("ResourceContainer.load: Invalid meld interface pointer")
		return false
	end if

	state.methods.load = @load
	state.methods.construct = @construct
	state.methods.destruct = @destruct
	state.methods.unload = @unload
	state.methods.request = @request
	state.methods.release = @release
	state.methods.getPtr = @getPtr

	if not meld->register("resource-container", @state.methods) then
		return false
	end if

	state.deps.meld = meld
	state.deps.pagedArray = meld->require("paged-array")

	return true
end function

/''
 ' Unload lifecycle function called by Meld framework.
 '/
sub unload()
end sub

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
