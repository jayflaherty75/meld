
#include once "map.bi"

namespace Map

dim shared as Instance ptr testPtr

dim shared as string id(8-1)
dim shared as long indices(8) = { 498123, 284, 0, 927, 12476, 82271, 7, 59295383}

declare function testCreate cdecl (it as Tester.itCallback) as short
declare sub test1 cdecl (done as Tester.doneFn)
declare sub test2 cdecl (done as Tester.doneFn)
declare sub test3 cdecl (done as Tester.doneFn)
declare sub test3_1 cdecl (done as Tester.doneFn)
declare sub test4 cdecl (done as Tester.doneFn)
declare sub test5 cdecl (done as Tester.doneFn)
declare sub test6 cdecl (done as Tester.doneFn)
declare sub test30 cdecl (done as Tester.doneFn)

function testCreate cdecl (it as Tester.itCallback) as short
	dim as short result = true

	id(0) = "zdfjychjmc"
	id(1) = "893749a8uhdfh"
	id(2) = "do9s8huw93z"
	id(3) = "zds9gz8dll4kjrdfm"
	id(4) = "dvbkuysm,snsemnb"
	id(5) = "xufyyy ya348oyoreu87tyhzdkfj"
	id(6) = "FOO_MODULE-THISLOOKS_LIKEAREALMESSAGEID"
	id(7) = "38499ea97e8347uzer7gakm"

	result = result andalso it("constructs an instance", @test1)
	result = result andalso it("assigns a set of key/index pairs", @test2)
	result = result andalso it("returns correct locators", @test3)
	result = result andalso it("iterates keys", @test3_1)
	result = result andalso it("unassigns mappings", @test4)
	result = result andalso it("iterates remaining keys", @test5)
	result = result andalso it("purges all contents", @test6)
	result = result andalso it("destroys instance", @test30)

	return result
end function

sub test1 cdecl (done as Tester.doneFn)
	testPtr = _map->construct()

	_tester->expectPtrNot(testPtr, NULL, "Failed to construct State instance")
	done()
end sub

sub test2 cdecl (done as Tester.doneFn)
	_tester->expect(_map->assign(testPtr, strptr(id(0)), indices(0)), true, "Failed to assign '" & id(0) & "' -> " & indices(0))
	_tester->expect(_map->assign(testPtr, strptr(id(1)), indices(1)), true, "Failed to assign '" & id(1) & "' -> " & indices(1))
	_tester->expect(_map->assign(testPtr, strptr(id(2)), indices(2)), true, "Failed to assign '" & id(2) & "' -> " & indices(2))
	_tester->expect(_map->assign(testPtr, strptr(id(3)), indices(3)), true, "Failed to assign '" & id(3) & "' -> " & indices(3))
	_tester->expect(_map->assign(testPtr, strptr(id(4)), indices(4)), true, "Failed to assign '" & id(4) & "' -> " & indices(4))
	_tester->expect(_map->assign(testPtr, strptr(id(5)), indices(5)), true, "Failed to assign '" & id(5) & "' -> " & indices(5))
	_tester->expect(_map->assign(testPtr, strptr(id(6)), indices(6)), true, "Failed to assign '" & id(6) & "' -> " & indices(6))
	_tester->expect(_map->assign(testPtr, strptr(id(7)), indices(7)), true, "Failed to assign '" & id(7) & "' -> " & indices(7))
	_tester->expect(_map->getLength(testPtr), 8, "Incorrect length returned")

	done()
end sub

sub test3 cdecl (done as Tester.doneFn)
	_tester->expect(_map->request(testPtr, strptr(id(6))), indices(6), "Request failed for '" & id(6) & "'")
	_tester->expect(_map->request(testPtr, strptr(id(7))), indices(7), "Request failed for '" & id(7) & "'")
	_tester->expect(_map->request(testPtr, strptr(id(4))), indices(4), "Request failed for '" & id(4) & "'")
	_tester->expect(_map->request(testPtr, strptr(id(1))), indices(1), "Request failed for '" & id(1) & "'")
	_tester->expect(_map->request(testPtr, strptr(id(5))), indices(5), "Request failed for '" & id(5) & "'")
	_tester->expect(_map->request(testPtr, strptr(id(0))), indices(0), "Request failed for '" & id(0) & "'")
	_tester->expect(_map->request(testPtr, strptr(id(2))), indices(2), "Request failed for '" & id(2) & "'")
	_tester->expect(_map->request(testPtr, strptr(id(3))), indices(3), "Request failed for '" & id(3) & "'")

	done()
end sub

sub test3_1 cdecl (done as Tester.doneFn)
	dim as Iterator.Instance ptr iterPtr = _map->getIterator(testPtr)
	dim as zstring ptr idPtr
	dim as short index = 0
	dim as short order(8-1) = { 7, 1, 6, 2, 4, 5, 0, 3 }

	do while _iterator->getNext(iterPtr, @idPtr) ANDALSO index < 20
		_tester->expectPtrNot(iterPtr, NULL, "Iterator returned NULL")

		if idPtr <> NULL then
			_tester->expectStr(*idPtr, id(order(index)), "Incorrect value returned at #" & index)
		end if

		index += 1
	loop

	done()
end sub

sub test4 cdecl (done as Tester.doneFn)
	_tester->expect(_map->unassign(testPtr, strptr(id(6))), true, "Failed to unassign '" & id(6) & "'")
	_tester->expect(_map->unassign(testPtr, strptr(id(2))), true, "Failed to unassign '" & id(2) & "'")
	_tester->expect(_map->unassign(testPtr, strptr(id(0))), true, "Failed to unassign '" & id(0) & "'")
	_tester->expect(_map->request(testPtr, strptr(id(6))), -1, "Request failed for '" & id(6) & "'")
	_tester->expect(_map->request(testPtr, strptr(id(2))), -1, "Request failed for '" & id(2) & "'")
	_tester->expect(_map->request(testPtr, strptr(id(0))), -1, "Request failed for '" & id(0) & "'")
	_tester->expect(_map->getLength(testPtr), 5, "Incorrect length returned")

	done()
end sub

sub test5 cdecl (done as Tester.doneFn)
	dim as Iterator.Instance ptr iterPtr = _map->getIterator(testPtr)
	dim as zstring ptr idPtr
	dim as short index = 0
	dim as short order(8-1) = { 7, 1, 4, 5, 3 }

	do while _iterator->getNext(iterPtr, @idPtr) ANDALSO index < 20
		_tester->expectPtrNot(iterPtr, NULL, "Iterator returned NULL")

		if idPtr <> NULL then
			_tester->expectStr(*idPtr, id(order(index)), "Incorrect value returned at #" & index)
		end if

		index += 1
	loop

	done()
end sub

sub test6 cdecl (done as Tester.doneFn)
	_map->purge(testPtr)
	_tester->expect(_map->getLength(testPtr), 0, "Incorrect length returned")

	done()
end sub

sub test30 cdecl (done as Tester.doneFn)
	_map->destruct(testPtr)
	testPtr = NULL

	done()
end sub

end namespace

