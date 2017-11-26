
#define PAGED_ARRAY_INITIAL_PAGING			8

#include once "../paged-array.bi"

namespace PagedArrayTest

#define PAGED_ARRAY_TEST_LENGTH				1024

declare function pagedArrayTestModule (describe as describeCallback) as integer
declare function create (it as itCallback) as integer
declare function test1 () as integer
declare function test2 () as integer
declare function test3 () as integer

declare function test30 () as integer

dim shared as integer testData(1024)
dim shared as PagedArrayObj ptr arrayPtr

function pagedArrayTestModule (describe as describeCallback) as integer
	dim as integer result = true

	result = result ANDALSO describe ("The PagedArray module", @create)

	return result
end function

function create (it as itCallback) as integer
	dim as integer i
	dim as integer result = true

	for i = 0 to PAGED_ARRAY_TEST_LENGTH
		testData(i) = i + 5
	next

	result = result ANDALSO it ("creates a PagedArray instance", @test1)
	result = result ANDALSO it ("Handles a data dump, should show a limit warning", @test2)
	result = result ANDALSO it ("Retrieves same data it put in", @test3)

	result = result ANDALSO it ("releases remaining nodes when paged array deleted", @test30)

	return result
end function

function test1 () as integer
	arrayPtr = PagedArray.construct("testPagedArray", sizeof(integer ptr), 8, 1018)

	if arrayPtr = NULL then
		return false
	end if

	return true
end function

function test2 () as integer
	dim as integer result = true
	dim as integer i
	dim as integer index
	dim as integer ptr ptr dataPtr

	for i = 0 to PAGED_ARRAY_TEST_LENGTH
		index = PagedArray.createIndex(arrayPtr)
		dataPtr = PagedArray.getIndex(arrayPtr, index)

		if dataPtr = NULL then
			result = false
			exit for
		end if

		*dataPtr = @testData(i)
	next

	return result
end function

function test3 () as integer
	dim as integer result = true
	dim as integer index
	dim as integer ptr ptr dataPtr

	for index = 0 to PAGED_ARRAY_TEST_LENGTH
		dataPtr = PagedArray.getIndex(arrayPtr, index)

		if dataPtr = NULL then
			result = false
			exit for
		end if

		if *dataPtr <> @testData(index) then
			result = false
		end if
	next

	return result
end function

/'
function test1 () as integer
	return true
end function

function test1 () as integer
	return true
end function

function test1 () as integer
	return true
end function

function test1 () as integer
	return true
end function

function test1 () as integer
	return true
end function

function test1 () as integer
	return true
end function

function test1 () as integer
	return true
end function

function test1 () as integer
	return true
end function

function test1 () as integer
	return true
end function

function test1 () as integer
	return true
end function
'/

function test30 () as integer
	dim as integer length

	PagedArray.destruct(arrayPtr)
	arrayPtr = NULL

	return true
end function

end namespace
