
#include once "identity.bi"

namespace Identity

type Dependencies
	meld as MeldInterface ptr
	PagedArray as PagedArray.Interface ptr
end type

type StateType
	deps as Dependencies
	methods as Interface
end type

dim shared as StateType state

/''
 ' @param {MeldInterface ptr} meldPtr
 '/
function load (meld as MeldInterface ptr) as integer
	if meld = NULL then
		' TODO: Throw error
		print ("load: Invalid meld interface pointer")
		return false
	end if

	state.methods.load = @load
	state.methods.unload = @unload
	state.methods.construct = @construct
	state.methods.destruct = @destruct
	state.methods.request = @request

	if not meld->register("identity", @state.methods) then
		return false
	end if

	state.deps.meld = meld

	return true
end function

sub unload()
end sub

function construct() as IdentityObj ptr
	dim as IdentityObj ptr identityPtr = allocate(sizeof(IdentityObj))

	return identityPtr
end function

sub destruct(idPtr as IdentityObj ptr)
end sub

function request (idPtr as IdentityObj ptr, byref identifier as zstring) as integer
	return 0
end function

end namespace
