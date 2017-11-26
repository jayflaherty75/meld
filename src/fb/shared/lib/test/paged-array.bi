
#include once "../paged-array.bi"

namespace PagedArrayTest

declare function pagedArrayTestModule (describe as describeCallback) as integer
declare function create (it as itCallback) as integer
declare function test1 () as integer

declare function test30 () as integer

dim shared as integer testData(8-1) = { 5, 1, 6, 7, 2, 3, 4, 8 }
dim shared as PagedArrayObj ptr arrayPtr

function pagedArrayTestModule (describe as describeCallback) as integer
	dim as integer result = true

	result = result ANDALSO describe ("The PagedArray module", @create)

	return result
end function

function create (it as itCallback) as integer
	dim as integer result = true

	result = result ANDALSO it ("creates a PagedArray instance", @test1)

	result = result ANDALSO it ("releases remaining nodes when tree deleted", @test30)

	return result
end function

function test1 () as integer
	arrayPtr = PagedArray.construct(4, 128, 1024)

	if arrayPtr = NULL then
		return false
	end if

	return true
end function

function test30 () as integer
	dim as integer length

	PagedArray.destruct(arrayPtr)
	arrayPtr = NULL

	return true
end function

end namespace
