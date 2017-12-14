
#include once "../constants/constants-v1.bi"
#include once "../core/core-v1.bi"

namespace Tester

type testFunc as function() as integer
type itCallback as function (byref description as string, test as testFunc) as integer
type suiteFunc as function (it as itCallback) as integer
type describeCallback as function (byref description as string, callback as suiteFunc) as integer
type testModule as function (corePtr as Core.Interface ptr, describe as describeCallback) as integer

type Interface
	load as function (corePtr as Core.Interface ptr) as integer
	unload as sub()
	register as function () as integer
	unregister as sub ()
	run as function (testArray as testModule ptr, count as integer) as integer
	describe as function (byref description as string, callback as suiteFunc) as integer
	suite as function (byref description as string, test as testFunc) as integer
end type

end namespace
