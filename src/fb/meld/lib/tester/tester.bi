
#include once "../../../../../modules/headers/tester/tester-v1.bi"

namespace Tester

declare function load (corePtr as Core.Interface ptr) as integer
declare sub unload()

declare function run (testArray as testModule ptr, count as integer) as integer
declare function describe (byref description as string, callback as suiteFunc) as integer
declare function suite (byref description as string, test as testFunc) as integer

end namespace
