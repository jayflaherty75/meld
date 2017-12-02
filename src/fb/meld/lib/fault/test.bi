
#include once "../../../../../modules/headers/tester/tester-v1.bi"
#include once "fault.bi"

namespace FaultTest

declare function testModule (corePtr as Core.Interface ptr, describe as Tester.describeCallback) as integer
declare function create (it as Tester.itCallback) as integer
declare function test1 () as integer
declare function test2 () as integer

function testModule (corePtr as Core.Interface ptr, describe as Tester.describeCallback) as integer
	dim as integer result = true

	result = result ANDALSO describe ("The Error module", @create)

	return RESULT
end function

function create (it as Tester.itCallback) as integer
	dim as integer result = true

	result = result ANDALSO it ("does a little of this", @test1)
	result = result ANDALSO it ("does a little of that", @test2)

	return result
end function

function test1 () as integer
	return true
end function

function test2 () as integer
	return true
end function

end namespace
