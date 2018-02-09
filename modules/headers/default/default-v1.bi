
#include once "../constants/constants-v1.bi"
#include once "../module/module-v1.bi"
#include once "../console/console-v1.bi"
#include once "../fault/fault-v1.bi"
#include once "../error-handling/error-handling-v1.bi"
#include once "../tester/tester-v1.bi"

namespace Default

type Interface
	startup as function cdecl () as short
	shutdown as function cdecl () as short
end type

end namespace
