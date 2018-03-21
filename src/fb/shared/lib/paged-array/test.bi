
#include once "paged-array.bi"

#define PAGED_ARRAY_TEST_LENGTH				1024
#define PAGED_ARRAY_TEST_DATATYPE			integer

namespace PagedArray

declare function testCreate cdecl (it as Tester.itCallback) as short
declare sub test1 cdecl (done as Tester.doneFn)
declare sub test2 cdecl (done as Tester.doneFn)
declare sub test3 cdecl (done as Tester.doneFn)
declare sub test4 cdecl (done as Tester.doneFn)
declare sub test5 cdecl (done as Tester.doneFn)
declare sub test6 cdecl (done as Tester.doneFn)
declare sub test7 cdecl (done as Tester.doneFn)
declare sub test8 cdecl (done as Tester.doneFn)

dim shared as PAGED_ARRAY_TEST_DATATYPE testData(1024)
dim shared as Instance ptr arrayPtr

function testCreate cdecl (it as Tester.itCallback) as short
	dim as short i
	dim as short result = true

	for i = 0 to PAGED_ARRAY_TEST_LENGTH
		testData(i) = i + 5
	next

	result = result ANDALSO it ("creates a PagedArray instance", @test1)
	result = result ANDALSO it ("handles a data dump, should show a limit warning", @test2)
	result = result ANDALSO it ("retrieves same data it put in", @test3)
	result = result ANDALSO it ("pops all values in reverse order", @test4)
	result = result ANDALSO it ("has an internal index of zero after everything is popped", @test5)
	result = result ANDALSO it ("correctly rebuilds data after old data torn down", @test6)
	result = result ANDALSO it ("returns the correct data", @test7)
	result = result ANDALSO it ("releases remaining nodes when paged array deleted", @test8)

	return result
end function

'sub test1 cdecl (done as Tester.doneFn)
'	_tester->expect(true, true, "Invalid result from test1")
'	done()
'end sub

sub test1 cdecl (done as Tester.doneFn)
	arrayPtr = _pagedArray->construct()
	_tester->expectPtrNot(arrayPtr, NULL, "Constructor returned NULL")

	if arrayPtr <> NULL then
		_pagedArray->initialize(arrayPtr, sizeof(integer), 8, 1018)
	end if

	done()
end sub

sub test2 cdecl (done as Tester.doneFn)
	dim as integer result = true
	dim as integer i
	dim as integer index
	dim as PAGED_ARRAY_TEST_DATATYPE ptr dataPtr

	for i = 0 to PAGED_ARRAY_TEST_LENGTH
		index = _pagedArray->createIndex(arrayPtr)
		dataPtr = _pagedArray->getIndex(arrayPtr, index)

		_tester->expectPtrNot(dataPtr, NULL, "Failed to add new element")

		if dataPtr <> NULL then
			*dataPtr = testData(i)
		end if
	next

	done()
end sub

sub test3 cdecl (done as Tester.doneFn)
	dim as integer result = true
	dim as integer index
	dim as PAGED_ARRAY_TEST_DATATYPE ptr dataPtr

	for index = 0 to PAGED_ARRAY_TEST_LENGTH
		dataPtr = _pagedArray->getIndex(arrayPtr, index)

		_tester->expectPtrNot(dataPtr, NULL, "Failed to add new element")

		if dataPtr <> NULL then
			_tester->expect(*dataPtr, testData(index), "Returned incorrect element")
		end if
	next

	done()
end sub

sub test4 cdecl (done as Tester.doneFn)
	dim as integer result = true
	dim as integer index
	dim as PAGED_ARRAY_TEST_DATATYPE dataVal

	for index = PAGED_ARRAY_TEST_LENGTH to 0 step -1
		_tester->expect(_pagedArray->pop(arrayPtr, @dataVal), true, "Encountered a problem popping element")
		_tester->expect(dataVal, testData(index), "Popped incorrect element")
	next

	done()
end sub

sub test5 cdecl (done as Tester.doneFn)
	_tester->expect(arrayPtr->currentIndex, 0, "Current index should be zero")

	done()
end sub

sub test6 cdecl (done as Tester.doneFn)
	dim as integer result = true
	dim as integer i
	dim as integer index
	dim as PAGED_ARRAY_TEST_DATATYPE ptr dataPtr

	for i = 0 to PAGED_ARRAY_TEST_LENGTH
		index = _pagedArray->createIndex(arrayPtr)
		dataPtr = _pagedArray->getIndex(arrayPtr, index)

		_tester->expectPtrNot(dataPtr, NULL, "Returned NULL index")

		if dataPtr <> NULL then
			*dataPtr = testData(i)
		end if
	next

	done()
end sub

sub test7 cdecl (done as Tester.doneFn)
	dim as integer result = true
	dim as integer index
	dim as PAGED_ARRAY_TEST_DATATYPE ptr dataPtr

	for index = 0 to PAGED_ARRAY_TEST_LENGTH
		dataPtr = _pagedArray->getIndex(arrayPtr, index)

		_tester->expectPtrNot(dataPtr, NULL, "Returned NULL index")

		if dataPtr <> NULL then
			_tester->expect(*dataPtr, testData(index), "Returned incorrect value")
		end if
	next

	done()
end sub

sub test8 cdecl (done as Tester.doneFn)
	_pagedArray->destruct(arrayPtr)
	arrayPtr = NULL

	done()
end sub

end namespace

