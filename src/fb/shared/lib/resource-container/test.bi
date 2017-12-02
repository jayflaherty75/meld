
#include once "../../../../../modules/headers/tester/tester-v1.bi"
#include once "resource-container.bi"

namespace ResourceContainerTest

#define RESCONTAINER_TEST_LENGTH				1024
#define RESCONTAINER_TEST_DATATYPE				integer

declare function testModule (corePtr as Core.Interface ptr, describe as Tester.describeCallback) as integer
declare function create (it as Tester.itCallback) as integer
declare function test1 () as integer
declare function test2 () as integer
declare function test3 () as integer
declare function test4 () as integer
declare function test5 () as integer

declare function test6 () as integer

dim shared as RESCONTAINER_TEST_DATATYPE testData(1024)
dim shared as ResourceContainerObj ptr contPtr

function testModule (corePtr as Core.Interface ptr, describe as Tester.describeCallback) as integer
	dim as integer result = true

	result = result ANDALSO describe ("The ResourceContainer module", @create)

	return result
end function

function create (it as Tester.itCallback) as integer
	dim as integer i
	dim as integer result = true

	for i = 0 to RESCONTAINER_TEST_LENGTH
		testData(i) = i + 5
	next

	result = result ANDALSO it ("creates a PagedArray instance", @test1)
	result = result ANDALSO it ("creates and populates resources", @test2)
	result = result ANDALSO it ("retrieves the same data it put in", @test3)
	result = result ANDALSO it ("releases resources without error", @test4)
	result = result ANDALSO it ("creates more resources", @test5)

	result = result ANDALSO it ("releases remaining nodes when paged array deleted", @test6)

	return result
end function

function test1 () as integer
	contPtr = ResourceContainer.construct("testResourceContainer", sizeof(integer), 8, 100000)

	if contPtr = NULL then
		return false
	end if

	return true
end function

function test2 () as integer
	dim as integer result = true
	dim as integer i
	dim as integer index
	dim as RESCONTAINER_TEST_DATATYPE ptr dataPtr

	for i = 0 to RESCONTAINER_TEST_LENGTH
		index = ResourceContainer.request(contPtr)

		if index = -1 then
			result = false
			exit for
		end if

		dataPtr = ResourceContainer.getPtr(contPtr, index)

		if dataPtr = NULL then
			result = false
			exit for
		end if

		*dataPtr = testData(i)
	next

	return result
end function

function test3 () as integer
	dim as integer result = true
	dim as integer index
	dim as RESCONTAINER_TEST_DATATYPE ptr dataPtr

	for index = 0 to RESCONTAINER_TEST_LENGTH
		dataPtr = ResourceContainer.getPtr(contPtr, index)

		if dataPtr = NULL then
			result = false
			exit for
		end if

		if *dataPtr <> testData(index) then
			result = false
			exit for
		end if
	next

	return result
end function

function test4 () as integer
	dim as integer result = true
	dim as integer index
	dim as RESCONTAINER_TEST_DATATYPE ptr dataPtr

	for index = RESCONTAINER_TEST_LENGTH \ 2 to RESCONTAINER_TEST_LENGTH
		if not ResourceContainer.release(contPtr, index) then
			result = false
			exit for
		end if
	next

	return result
end function

function test5 () as integer
	dim as integer result = true
	dim as integer i
	dim as integer index
	dim as RESCONTAINER_TEST_DATATYPE ptr dataPtr

	for i = RESCONTAINER_TEST_LENGTH \ 2 to RESCONTAINER_TEST_LENGTH
		index = ResourceContainer.request(contPtr)

		if index = -1 then
			result = false
			exit for
		end if

		dataPtr = ResourceContainer.getPtr(contPtr, index)

		if dataPtr = NULL then
			result = false
			exit for
		end if

		*dataPtr = testData(i) + 12
	next

	return result
end function

function test6 () as integer
	ResourceContainer.destruct(contPtr)
	contPtr = NULL

	return true
end function

end namespace
