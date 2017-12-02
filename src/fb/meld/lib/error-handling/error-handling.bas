
#include once "error-handling.bi"

namespace ErrorHandling

type ErrorCodes
	uncaughtError as integer
	internalSystemError as integer
end type

type Dependencies
	core as Core.Interface ptr
	console as Console.Interface ptr
	fault as Fault.Interface ptr
end type

type State
	methods as Interface
	deps as Dependencies
	errs as ErrorCodes
end type

static shared as zstring*26 uncaughtError = "UncaughtError"
static shared as zstring*24 internalSystemError = "InternalSystemError"

dim shared as State errState

/''
 ' @param {Core.Interface ptr} corePtr
 '/
function load (corePtr as Core.Interface ptr) as integer
	if corePtr = NULL then
		print ("load: Invalid Core interface pointer")
		return false
	end if

	errState.methods.load = @load
	errState.methods.unload = @unload
	errState.methods.registerType = @registerType
	errState.methods.assignHandler = @assignHandler
	errState.methods.getCode = @getCode
	errState.methods.throw = @throw

	if not corePtr->register("error", @errState.methods) then
		return false
	end if

	errState.deps.core = corePtr->require("core")
	errState.deps.console = corePtr->require("console")

	return true
end function

sub unload ()
end sub

end namespace
