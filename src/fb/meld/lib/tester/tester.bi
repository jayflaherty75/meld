
#include once "../../../../../modules/headers/tester/tester-v1.bi"

dim shared _console as Console.Interface ptr

namespace Tester

declare function startup cdecl () as short
declare function shutdown cdecl () as short
declare function run cdecl (testArray as testModule ptr, interfacePtr as any ptr, count as short) as short
declare function describe cdecl (byref description as zstring, callback as suiteFunc) as short
declare function suite cdecl (byref description as zstring, test as testFunc) as short

declare function _expect (result as long, expected as long, byref message as zstring)
declare sub _done (hasPassed as short)

end namespace
