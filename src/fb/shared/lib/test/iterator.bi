
#include once "../iterator.bi"

namespace iteratorTest

declare function iteratorTestModule (describe as describeCallback) as integer
declare function create (it as itCallback) as integer
declare function test1 () as integer
declare function test2 () as integer
declare function test3 () as integer
declare function test4 () as integer

dim shared as integer testData(8-1) = { 1, 2, 3, 4, 5, 6, 7, 8 }
dim shared as Iterator ptr iter

function iteratorTestModule (describe as describeCallback) as integer
	dim as integer result = true

	result = result ANDALSO describe ("The Iterator module", @create)

	return result
end function

function create (it as itCallback) as integer
	dim as integer result = true

	result = result ANDALSO it ("creates an iterator instance", @test1)
	result = result ANDALSO it ("correctly iterates an array", @test2)
	result = result ANDALSO it ("correctly iterates after it has been reset", @test3)
	result = result ANDALSO it ("deletes the instance", @test4)

	return result
end function

function test1 () as integer
	iter = iteratorNew(@testData(0), 8)

	if iter = NULL then
		return false
	end if

	return true
end function

function test2 () as integer
	dim as integer value
	dim as string result = ""

	while (iteratorNext(iter, @value))
		result = result & value
	wend

	if result <> "12345678" then
		return false
	end if

	return true
end function

function test3 () as integer
	dim as integer value
	dim as string result = ""

	iteratorReset(iter)

	while (iteratorNext(iter, @value))
		result = result & value
	wend

	if result <> "12345678" then
		return false
	end if

	return true
end function

function test4 () as integer
	iteratorDelete(iter)
	iter = NULL

	return true
end function

end namespace
