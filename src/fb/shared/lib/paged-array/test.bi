
#define PAGED_ARRAY_INITIAL_PAGING			8

#include once "../../../../../modules/headers/tester/tester-v1.bi"
#include once "paged-array.bi"

namespace PagedArrayTest

#define PAGED_ARRAY_TEST_LENGTH				1024
#define PAGED_ARRAY_TEST_DATATYPE			integer

declare function testModule (corePtr as Core.Interface ptr, describe as Tester.describeCallback) as integer
declare function create (it as Tester.itCallback) as integer
declare function test1 () as integer
declare function test2 () as integer
declare function test3 () as integer
declare function test4 () as integer
declare function test5 () as integer
declare function test6 () as integer
declare function test7 () as integer
declare function test8 () as integer

dim shared as PAGED_ARRAY_TEST_DATATYPE testData(1024)
dim shared as PagedArrayObj ptr arrayPtr

function testModule (corePtr as Core.Interface ptr, describe as Tester.describeCallback) as integer
	dim as integer result = true

	result = result ANDALSO describe ("The PagedArray module", @create)

	return result
end function

function create (it as Tester.itCallback) as integer
	dim as integer i
	dim as integer result = true

	for i = 0 to PAGED_ARRAY_TEST_LENGTH
		testData(i) = i + 5
	next

	result = result ANDALSO it ("creates a PagedArray instance", @test1)
	result = result ANDALSO it ("handles a data dump, should show a limit warning", @test2)
	result = result ANDALSO it ("retrieves same data it put in", @test3)
	result = result ANDALSO it ("pops all values in reverse order", @test4)
	result = result ANDALSO it ("has an internal index of zero after everything is popped", @test5)
	result = result ANDALSO it ("correctly rebuilds data after old data torn down", @test6)
	result = result ANDALSO it ("returns the correct data", @test7)
	result = result ANDALSO it ("releases remaining nodes when paged array deleted", @test8)

	return result
end function

function test1 () as integer
	arrayPtr = PagedArray.construct("testPagedArray", sizeof(integer), 8, 1018)

	if arrayPtr = NULL then
		return false
	end if

	return true
end function

function test2 () as integer
	dim as integer result = true
	dim as integer i
	dim as integer index
	dim as PAGED_ARRAY_TEST_DATATYPE ptr dataPtr

	for i = 0 to PAGED_ARRAY_TEST_LENGTH
		index = PagedArray.createIndex(arrayPtr)
		dataPtr = PagedArray.getIndex(arrayPtr, index)

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
	dim as PAGED_ARRAY_TEST_DATATYPE ptr dataPtr

	for index = 0 to PAGED_ARRAY_TEST_LENGTH
		dataPtr = PagedArray.getIndex(arrayPtr, index)

		if dataPtr = NULL then
			result = false
			exit for
		end if

		if *dataPtr <> testData(index) then
			result = false
		end if
	next

	return result
end function

function test4 () as integer
	dim as integer result = true
	dim as integer index
	dim as PAGED_ARRAY_TEST_DATATYPE dataVal

	for index = PAGED_ARRAY_TEST_LENGTH to 0 step -1
		if not PagedArray.pop(arrayPtr, @dataVal) then
			result = false
			exit for
		end if

		if dataVal <> testData(index) then
			result = false
		end if
	next

	return result
end function

function test5 () as integer
	if arrayPtr->currentIndex <> 0 then
		return false
	end if

	return true
end function

function test6 () as integer
	dim as integer result = true
	dim as integer i
	dim as integer index
	dim as PAGED_ARRAY_TEST_DATATYPE ptr dataPtr

	for i = 0 to PAGED_ARRAY_TEST_LENGTH
		index = PagedArray.createIndex(arrayPtr)
		dataPtr = PagedArray.getIndex(arrayPtr, index)

		if dataPtr = NULL then
			result = false
			exit for
		end if

		*dataPtr = testData(i)
	next

	return result
end function

function test7 () as integer
	dim as integer result = true
	dim as integer index
	dim as PAGED_ARRAY_TEST_DATATYPE ptr dataPtr

	for index = 0 to PAGED_ARRAY_TEST_LENGTH
		dataPtr = PagedArray.getIndex(arrayPtr, index)

		if dataPtr = NULL then
			result = false
			exit for
		end if

		if *dataPtr <> testData(index) then
			result = false
		end if
	next

	return result
end function

function test8 () as integer
	PagedArray.destruct(arrayPtr)
	arrayPtr = NULL

	return true
end function

end namespace
