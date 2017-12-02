
#include once "../constants/constants-v1.bi"
#include once "../core/core-v1.bi"
#include once "../fault/fault-v1.bi"
#include once "../console/console-v1.bi"

namespace ErrorHandling

type Interface
	load as function (corePtr as Core.Interface ptr) as integer
	unload as sub()
end type

end namespace
