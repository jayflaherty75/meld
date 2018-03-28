
#include once "../../../../../modules/headers/tester/tester-v1.bi"
#include once "map.bi"

namespace MapTest

#define MAP_TEST_DATATYPE				integer

declare function testModule (corePtr as Core.Interface ptr, describe as Tester.describeCallback) as integer
declare function create (it as Tester.itCallback) as integer
declare function test1 () as integer

dim shared as MAP_TEST_DATATYPE testData(1024)
dim shared as MapObj ptr mapPtr

function testModule (corePtr as Core.Interface ptr, describe as Tester.describeCallback) as integer
	dim as integer result = true

	result = result ANDALSO describe ("The Map module", @create)

	return result
end function

function create (it as Tester.itCallback) as integer
	dim as integer result = true

	result = result ANDALSO it ("creates a Map instance", @test1)

	return result
end function

function test1 () as integer

	return true
end function

end namespace
