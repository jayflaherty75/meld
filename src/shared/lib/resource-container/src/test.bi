
#include once "resource-container.bi"

#define RESCONTAINER_TEST_LENGTH				1024
#define RESCONTAINER_TEST_DATATYPE				integer

namespace ResourceContainer

declare function testCreate cdecl (it as Tester.itCallback) as short
declare sub test1 cdecl (done as Tester.doneFn)
declare sub test2 cdecl (done as Tester.doneFn)
declare sub test3 cdecl (done as Tester.doneFn)
declare sub test4 cdecl (done as Tester.doneFn)
declare sub test5 cdecl (done as Tester.doneFn)
declare sub test6 cdecl (done as Tester.doneFn)

dim shared as RESCONTAINER_TEST_DATATYPE testData(1024)
dim shared as Instance ptr contPtr

function testCreate cdecl (it as Tester.itCallback) as short
	dim as short i
	dim as short result = true

	for i = 0 to RESCONTAINER_TEST_LENGTH
		testData(i) = i + 5
	next

	result = result ANDALSO it ("creates a PagedArray instance", @test1)
	result = result ANDALSO it ("creates and populates resources", @test2)
	result = result ANDALSO it ("retrieves the same data it put in", @test3)
	result = result ANDALSO it ("releases resources without error", @test4)
	result = result ANDALSO it ("creates more resources", @test5)

	result = result ANDALSO it ("releases remaining nodes when paged array deleted", @test6)

	return result
end function

sub test1 cdecl (done as Tester.doneFn)
	contPtr = _resourceContainer->construct()
	_tester->expectPtrNot(contPtr, NULL, "Constructor returned NULL")

	if contPtr <> NULL then
		_tester->expect(_resourceContainer->initialize(contPtr, sizeof(integer), 8, 100000), true, "Failed to initialize container")
	end if

	done()
end sub

sub test2 cdecl (done as Tester.doneFn)
	dim as short i
	dim as long index
	dim as RESCONTAINER_TEST_DATATYPE ptr dataPtr

	for i = 0 to RESCONTAINER_TEST_LENGTH
		index = _resourceContainer->request(contPtr)

		_tester->expectNot(index, -1, "Resource request failed")

		dataPtr = _resourceContainer->getPtr(contPtr, index)

		_tester->expectPtrNot(dataPtr, NULL, "Resource pointer returned NULL")

		if dataPtr <> NULL then
			*dataPtr = testData(i)
		end if
	next

	done()
end sub

sub test3 cdecl (done as Tester.doneFn)
	dim as integer index
	dim as RESCONTAINER_TEST_DATATYPE ptr dataPtr

	for index = 0 to RESCONTAINER_TEST_LENGTH
		dataPtr = _resourceContainer->getPtr(contPtr, index)

		_tester->expectPtrNot(dataPtr, NULL, "Resource pointer returned NULL")

		if dataPtr <> NULL then
			_tester->expect(*dataPtr, testData(index), "Incorrect value of resource")
		end if
	next

	done()
end sub

sub test4 cdecl (done as Tester.doneFn)
	dim as integer index
	dim as RESCONTAINER_TEST_DATATYPE ptr dataPtr

	for index = RESCONTAINER_TEST_LENGTH \ 2 to RESCONTAINER_TEST_LENGTH
		_tester->expect(_resourceContainer->release(contPtr, index), true, "Failed to release resource")
	next

	done()
end sub

sub test5 cdecl (done as Tester.doneFn)
	dim as integer i
	dim as integer index
	dim as RESCONTAINER_TEST_DATATYPE ptr dataPtr

	for i = RESCONTAINER_TEST_LENGTH \ 2 to RESCONTAINER_TEST_LENGTH
		index = _resourceContainer->request(contPtr)

		_tester->expectNot(index, -1, "Resource request failed")

		dataPtr = _resourceContainer->getPtr(contPtr, index)

		_tester->expectPtrNot(dataPtr, NULL, "Resource pointer returned NULL")

		if dataPtr <> NULL then
			*dataPtr = testData(i) + 12
		end if
	next

	done()
end sub

sub test6 cdecl (done as Tester.doneFn)
	_resourceContainer->destruct(contPtr)
	contPtr = NULL

	done()
end sub

end namespace

