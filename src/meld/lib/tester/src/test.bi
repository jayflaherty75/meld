
#include once "tester.bi"

namespace Tester

declare function testCreate cdecl (it as Tester.itCallback) as short
declare sub test1 cdecl (done as Tester.doneFn)
declare sub test2 cdecl (done as Tester.doneFn)
declare sub test3 cdecl (done as Tester.doneFn)
declare sub test4 cdecl (done as Tester.doneFn)
declare sub test5 cdecl (done as Tester.doneFn)
declare sub test6 cdecl (done as Tester.doneFn)

function testCreate cdecl (it as Tester.itCallback) as short
	dim as short result = true

	result = result andalso it("properly compares equal integer values", @test1)
	result = result andalso it("properly compares unequal integer values", @test2)
	result = result andalso it("properly compares equal strings", @test3)
	result = result andalso it("properly compares unequal strings", @test4)
	result = result andalso it("properly compares equal pointers", @test5)
	result = result andalso it("properly compares unequal pointers", @test6)

	return result
end function

sub test1 cdecl (done as Tester.doneFn)
	_tester->expect(true, true, "Invalid result from expect()")
	done()
end sub

sub test2 cdecl (done as Tester.doneFn)
	_tester->expectNot(0, 1234, "Invalid result from expectNot()")
	done()
end sub

sub test3 cdecl (done as Tester.doneFn)
	_tester->expectStr("Alice", "Alice", "Invalid result from expectStr()")
	done()
end sub

sub test4 cdecl (done as Tester.doneFn)
	_tester->expectStrNot("Alice", "Bob", "Invalid result from expectStrNot()")
	done()
end sub

sub test5 cdecl (done as Tester.doneFn)
	_tester->expectPtr(@testCreate, @testCreate, "Invalid result from expectPtr()")
	done()
end sub

sub test6 cdecl (done as Tester.doneFn)
	_tester->expectPtrNot(@testCreate, NULL, "Invalid result from expectPtrNot()")
	done()
end sub

end namespace

