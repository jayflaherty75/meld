
namespace Default

function testCreate (it as Tester.itCallback) as short
	dim as short result = true

	result = result andalso it("performs test 1 successfully", @test1)
	result = result andalso it("performs test 2 successfully", @test2)
	result = result andalso it("performs test 3 successfully", @test3)
	result = result andalso it("performs test 4 successfully", @test4)

	return result
end function

sub test1 (expect as Tester.expectFn, done as Tester.doneFn)
	expect(true, true, "Invalid result from test1")
	done()
end sub

sub test2 (expect as Tester.expectFn, done as Tester.doneFn)
	expect(false, false, "Invalid result from test2")
	done()
end sub

sub test3 (expect as Tester.expectFn, done as Tester.doneFn)
	expect(0, 0, "Invalid result from test3")
	done()
end sub

sub test4 (expect as Tester.expectFn, done as Tester.doneFn)
	expect(1234, 1234, "Invalid result from test4")
	done()
end sub

end namespace
