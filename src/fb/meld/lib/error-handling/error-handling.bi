
#include once "../../../../../modules/headers/error-handling/error-handling-v1.bi"

namespace ErrorHandling

type Codes
	uncaughtError as integer
	internalSystemError as integer
	fatalOperationalError as integer
	moduleLoadingError as integer
	resourceAllocationError as integer
	releaseResourceError as integer
	nullReferenceError as integer
	resourceMissingError as integer
	invalidArgumentError as integer
	outOfBoundsError as integer
	resourceLimitSurpassed as integer
	generalError as integer
end type

type StateType
	methods as Interface
	errs as Codes
end type

dim shared as StateType state

declare function startup cdecl () as short
declare function shutdown cdecl () as short

declare sub _assignHandler(_fault as Fault.Interface ptr, errCodePtr as integer ptr, byref errName as zstring, handler as Fault.handler)

end namespace
