
#include once "map.bi"

namespace Map

dim shared as Instance ptr testPtr

dim shared as long indices(8) = { 498123, 284, 0, 927, 12476, 82271, 7, 59295383}
dim shared as string id1
dim shared as string id2
dim shared as string id3
dim shared as string id4
dim shared as string id5
dim shared as string id6
dim shared as string id7
dim shared as string id8

declare function testCreate cdecl (it as Tester.itCallback) as short
declare sub test1 cdecl (done as Tester.doneFn)
declare sub test2 cdecl (done as Tester.doneFn)
declare sub test3 cdecl (done as Tester.doneFn)
declare sub test30 cdecl (done as Tester.doneFn)

function testCreate cdecl (it as Tester.itCallback) as short
	dim as short result = true

	id1 = "zdfjychjmc"
	id2 = "893749a8uhdfh"
	id3 = "do9s8huw93z"
	id4 = "zds9gz8dll4kjrdfm"
	id5 = "dvbkuysm,snsemnb"
	id6 = "xufyyy ya348oyoreu87tyhzdkfj"
	id7 = "FOO_MODULE-THISLOOKS_LIKEAREALID"
	id8 = "38499ea97e8347uzer7gakm"

	result = result andalso it("constructs an instance", @test1)
	result = result andalso it("assigns a set of key/index pairs", @test2)
	result = result andalso it("destroys instance", @test30)

	return result
end function

sub test1 cdecl (done as Tester.doneFn)
	testPtr = _map->construct()

	_tester->expectPtrNot(testPtr, NULL, "Failed to construct State instance")
	done()
end sub

sub test2 cdecl (done as Tester.doneFn)
	_tester->expect(_map->assign(testPtr, strptr(id1), indices(0)), true, "Failed to assign " & id1 & " -> " & indices(0))
	_tester->expect(_map->assign(testPtr, strptr(id2), indices(1)), true, "Failed to assign " & id2 & " -> " & indices(1))
	_tester->expect(_map->assign(testPtr, strptr(id3), indices(2)), true, "Failed to assign " & id3 & " -> " & indices(2))
	_tester->expect(_map->assign(testPtr, strptr(id4), indices(3)), true, "Failed to assign " & id4 & " -> " & indices(3))
	_tester->expect(_map->assign(testPtr, strptr(id5), indices(4)), true, "Failed to assign " & id5 & " -> " & indices(4))
	_tester->expect(_map->assign(testPtr, strptr(id6), indices(5)), true, "Failed to assign " & id6 & " -> " & indices(5))
	_tester->expect(_map->assign(testPtr, strptr(id7), indices(6)), true, "Failed to assign " & id7 & " -> " & indices(6))
	_tester->expect(_map->assign(testPtr, strptr(id8), indices(7)), true, "Failed to assign " & id8 & " -> " & indices(7))

	done()
end sub

sub test30 cdecl (done as Tester.doneFn)
	_map->destruct(testPtr)
	testPtr = NULL

	done()
end sub

end namespace

