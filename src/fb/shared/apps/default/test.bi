
namespace Default

declare function testCreate (it as Tester.itCallback) as short
declare sub test1 (done as Tester.doneFn)
declare sub test2 (done as Tester.doneFn)
declare sub test3 (done as Tester.doneFn)
declare sub test4 (done as Tester.doneFn)

function testCreate (it as Tester.itCallback) as short
	dim as short result = true

	result = result andalso it("performs test 1 successfully", @test1)
	result = result andalso it("performs test 2 successfully", @test2)
	result = result andalso it("performs test 3 successfully", @test3)
	result = result andalso it("performs test 4 successfully", @test4)

	return result
end function

sub test1 (done as Tester.doneFn)
	_tester->expect(true, true, "Invalid result from test1")
	done()
end sub

sub test2 (done as Tester.doneFn)
	_tester->expectNot(0, 1234, "Invalid result from test2")
	done()
end sub

sub test3 (done as Tester.doneFn)
	_tester->expectStr("Alice", "Alice", "Invalid result from test3")
	done()
end sub

sub test4 (done as Tester.doneFn)
	_tester->expectStrNot("Alice", "Bob", "Invalid result from test4")
	done()
end sub

end namespace
