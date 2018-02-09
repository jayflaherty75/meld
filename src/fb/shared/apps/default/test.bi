
namespace Default

function testModule (interfacePtr as any ptr, describe as Tester.describeCallback) as short
	dim as short result = true

	result = result andalso describe ("The Default module", @create)

	return result
end function

function create (it as Tester.itCallback) as short
	dim as short result = true

	result = result andalso it ("performs test 1 successfully", @test1)
	result = result andalso it ("performs test 2 successfully", @test2)
	result = result andalso it ("performs test 3 successfully", @test3)
	result = result andalso it ("performs test 4 successfully", @test4)

	return result
end function

function test1 () as short
	return true
end function

function test2 () as short
	return true
end function

function test3 () as short
	return false
end function

function test4 () as short
	return true
end function

end namespace
