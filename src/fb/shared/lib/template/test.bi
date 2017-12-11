
#include once "../../../../../modules/headers/tester/tester-v1.bi"
#include once "template.bi"

namespace TemplateTest

#define TEMPLATE_TEST_DATATYPE				integer

declare function testModule (corePtr as Core.Interface ptr, describe as Tester.describeCallback) as integer
declare function create (it as Tester.itCallback) as integer
declare function test1 () as integer

dim shared as TEMPLATE_TEST_DATATYPE testData(1024)
dim shared as TemplateObj ptr templatePtr

function testModule (corePtr as Core.Interface ptr, describe as Tester.describeCallback) as integer
	dim as integer result = true

	result = result ANDALSO describe ("The Template module", @create)

	return result
end function

function create (it as Tester.itCallback) as integer
	dim as integer result = true

	result = result ANDALSO it ("creates a Template instance", @test1)

	return result
end function

function test1 () as integer

	return true
end function

end namespace
