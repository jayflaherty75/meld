
#include once "resource-container.bi"

namespace ResourceContainerTest

#define RESCONTAINER_TEST_LENGTH				1024
#define RESCONTAINER_TEST_DATATYPE				integer

declare function testModule (describe as describeCallback) as integer
declare function create (it as itCallback) as integer
declare function test1 () as integer

declare function test8 () as integer

dim shared as RESCONTAINER_TEST_DATATYPE testData(1024)
dim shared as ResourceContainerObj ptr contPtr

function testModule (describe as describeCallback) as integer
	dim as integer result = true

	result = result ANDALSO describe ("The ResourceContainer module", @create)

	return result
end function

function create (it as itCallback) as integer
	dim as integer i
	dim as integer result = true

	for i = 0 to RESCONTAINER_TEST_LENGTH
		testData(i) = i + 5
	next

	result = result ANDALSO it ("creates a PagedArray instance", @test1)

	result = result ANDALSO it ("releases remaining nodes when paged array deleted", @test8)

	return result
end function

function test1 () as integer
	contPtr = ResourceContainer.construct("testResourceContainer", sizeof(integer), 8, 1018)

	if contPtr = NULL then
		return false
	end if

	return true
end function

function test8 () as integer
	ResourceContainer.destruct(contPtr)
	contPtr = NULL

	return true
end function

end namespace
