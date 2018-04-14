
#include once "type-map.bi"

namespace TypeMap

type TestType1
	x as long
	y as long
end type

type TestType2
	x as long
	y as long
	z as long
end type

dim shared as string testIDs(4-1)
dim shared as long testTypes(4-1)
dim shared as Entry ptr testTypePtr(4-1)

declare function testCreate cdecl (it as Tester.itCallback) as short
declare sub test1 cdecl (done as Tester.doneFn)
declare sub test2 cdecl (done as Tester.doneFn)
declare sub test3 cdecl (done as Tester.doneFn)
declare sub test4 cdecl (done as Tester.doneFn)
declare sub test5 cdecl (done as Tester.doneFn)
declare sub test6 cdecl (done as Tester.doneFn)

function testCreate cdecl (it as Tester.itCallback) as short
	dim as short result = true

	testIDs(0) = "zdfjychjmc"
	testIDs(1) = "893749a8uhdfh"
	testIDs(2) = "do9s8huw93z"
	testIDs(3) = "zds9gz8dll4kjrdfm"

	result = result andalso it("maps identifiers to type indices", @test1)
	result = result andalso it("returns the correct indices for existing types", @test2)
	result = result andalso it("returns pointers to type information", @test3)
	result = result andalso it("successfully assigns type information", @test4)
	result = result andalso it("returns correct type information", @test5)
	result = result andalso it("correctly allocates and handles destruction of instances", @test6)

	return result
end function

sub test1 cdecl (done as Tester.doneFn)
	testTypes(0) = _typeMap->request(cptr(ubyte ptr, strptr(testIDs(0))))
	testTypes(1) = _typeMap->request(cptr(ubyte ptr, strptr(testIDs(1))))
	testTypes(2) = _typeMap->request(cptr(ubyte ptr, strptr(testIDs(2))))
	testTypes(3) = _typeMap->request(cptr(ubyte ptr, strptr(testIDs(3))))

	_tester->expectNot(testTypes(0), -1, "Attempt #0 failed to return an index")
	_tester->expectNot(testTypes(1), -1, "Attempt #1 failed to return an index")
	_tester->expectNot(testTypes(2), -1, "Attempt #2 failed to return an index")
	_tester->expectNot(testTypes(3), -1, "Attempt #3 failed to return an index")

	done()
end sub

sub test2 cdecl (done as Tester.doneFn)
	_tester->expect(_typeMap->request(cptr(ubyte ptr, strptr(testIDs(0)))), testTypes(0), "Attempt #0 failed to return an index")
	_tester->expect(_typeMap->request(cptr(ubyte ptr, strptr(testIDs(1)))), testTypes(1), "Attempt #1 failed to return an index")
	_tester->expect(_typeMap->request(cptr(ubyte ptr, strptr(testIDs(2)))), testTypes(2), "Attempt #2 failed to return an index")
	_tester->expect(_typeMap->request(cptr(ubyte ptr, strptr(testIDs(3)))), testTypes(3), "Attempt #3 failed to return an index")

	done()
end sub

sub test3 cdecl (done as Tester.doneFn)
	testTypePtr(0) = _typeMap->getEntry(testTypes(0))
	testTypePtr(1) = _typeMap->getEntry(testTypes(1))
	testTypePtr(2) = _typeMap->getEntry(testTypes(2))
	testTypePtr(3) = _typeMap->getEntry(testTypes(3))

	_tester->expectPtrNot(testTypePtr(0), NULL, "Invalid pointer returned for type #0")
	_tester->expectPtrNot(testTypePtr(1), NULL, "Invalid pointer returned for type #1")
	_tester->expectPtrNot(testTypePtr(2), NULL, "Invalid pointer returned for type #2")
	_tester->expectPtrNot(testTypePtr(3), NULL, "Invalid pointer returned for type #3")

	done()
end sub

sub test4 cdecl (done as Tester.doneFn)
	_tester->expect(_typeMap->assign(testTypePtr(0), sizeof(long), @deallocate), true, "Failed to assign type #0")
	_tester->expect(_typeMap->assign(testTypePtr(1), sizeof(any ptr), @deallocate), true, "Failed to assign type #1")
	_tester->expect(_typeMap->assign(testTypePtr(2), sizeof(testType1), @deallocate), true, "Failed to assign type #2")
	_tester->expect(_typeMap->assign(testTypePtr(3), sizeof(testType2), @deallocate), true, "Failed to assign type #3")

	_tester->expect(_typeMap->isAssigned(testTypePtr(0)), true, "Type #0 not assigned")
	_tester->expect(_typeMap->isAssigned(testTypePtr(1)), true, "Type #1 not assigned")
	_tester->expect(_typeMap->isAssigned(testTypePtr(2)), true, "Type #2 not assigned")
	_tester->expect(_typeMap->isAssigned(testTypePtr(3)), true, "Type #3 not assigned")

	done()
end sub

sub test5 cdecl (done as Tester.doneFn)
	_tester->expect(_typeMap->getSize(testTypePtr(0)), sizeof(long), "Returned incorrect size for type #0")
	_tester->expectPtr(_typeMap->getDestructor(testTypePtr(0)), @deallocate, "Returned incorrect destructor for type #0")

	_tester->expect(_typeMap->getSize(testTypePtr(1)), sizeof(any ptr), "Returned incorrect size for type #1")
	_tester->expectPtr(_typeMap->getDestructor(testTypePtr(1)), @deallocate, "Returned incorrect destructor for type #1")

	_tester->expect(_typeMap->getSize(testTypePtr(2)), sizeof(testType1), "Returned incorrect size for type #2")
	_tester->expectPtr(_typeMap->getDestructor(testTypePtr(2)), @deallocate, "Returned incorrect destructor for type #2")

	_tester->expect(_typeMap->getSize(testTypePtr(3)), sizeof(testType2), "Returned incorrect size for type #3")
	_tester->expectPtr(_typeMap->getDestructor(testTypePtr(3)), @deallocate, "Returned incorrect destructor for type #3")

	done()
end sub

sub test6 cdecl (done as Tester.doneFn)
	dim as long ptr res1 = allocate(_typeMap->getSize(testTypePtr(0)))
	dim as any ptr ptr res2 = allocate(_typeMap->getSize(testTypePtr(1)))
	dim as testType1 ptr res3 = allocate(_typeMap->getSize(testTypePtr(2)))
	dim as testType2 ptr res4 = allocate(_typeMap->getSize(testTypePtr(3)))

	*res1 = 239847
	*res2 = @test6
	res3->x = 39234
	res3->y = 3409587
	res4->x = 39234
	res4->y = 3409587
	res4->z = 29

	_tester->expect(*res1, 239847, "value incorrect or corrupted")
	_tester->expectPtr(*res2, @test6, "value incorrect or corrupted")
	_tester->expect(res3->x, 39234, "value incorrect or corrupted")
	_tester->expect(res3->y, 3409587, "value incorrect or corrupted")
	_tester->expect(res4->x, 39234, "value incorrect or corrupted")
	_tester->expect(res4->y, 3409587, "value incorrect or corrupted")
	_tester->expect(res4->z, 29, "value incorrect or corrupted")

	_tester->expect(_typeMap->destroy(testTypePtr(0), res1), true, "Failed to destroy resource #1")
	_tester->expect(_typeMap->destroy(testTypePtr(1), res2), true, "Failed to destroy resource #2")
	_tester->expect(_typeMap->destroy(testTypePtr(2), res3), true, "Failed to destroy resource #3")
	_tester->expect(_typeMap->destroy(testTypePtr(3), res4), true, "Failed to destroy resource #4")

	done()
end sub

end namespace

