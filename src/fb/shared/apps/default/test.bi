
namespace Default

function create (it as Tester.itCallback) as short
	dim as short result = true

	result = result andalso it ("performs test 1 successfully", @test1)
	result = result andalso it ("performs test 2 successfully", @test2)
	result = result andalso it ("performs test 3 successfully", @test3)
	result = result andalso it ("performs test 4 successfully", @test4)

	return result
end function

function test1 (expect as expectFn, done as doneFn) as short
	return true
end function

function test2 (expect as expectFn, done as doneFn) as short
	return true
end function

function test3 (expect as expectFn, done as doneFn) as short
	return true
end function

function test4 (expect as expectFn, done as doneFn) as short
	return true
end function

end namespace
