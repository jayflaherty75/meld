
#include once "paged-array.bi"

namespace PagedArray

declare function testCreate cdecl (it as Tester.itCallback) as short
declare sub test1 cdecl (done as Tester.doneFn)

function testCreate cdecl (it as Tester.itCallback) as short
	dim as short result = true

	result = result andalso it("performs test 1 successfully", @test1)
	' result = result andalso it("performs test 2 successfully", @test2)

	return result
end function

sub test1 cdecl (done as Tester.doneFn)
	_tester->expect(true, true, "Invalid result from test1")
	done()
end sub

end namespace

