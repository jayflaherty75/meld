
#include once "tester.bi"
#include once "../meld/lib/test/error.bi"
#include once "../shared/lib/test/list.bi"
#include once "../shared/lib/test/iterator.bi"
#include once "../shared/lib/test/bintree.bi"
#include once "../shared/lib/paged-array/test.bi"

#define TEST_COUNT			5

dim shared as testModule tests(TEST_COUNT - 1)

tests(0) = @errorTestModule
tests(1) = @listTest.listTestModule
tests(2) = @iteratorTest.iteratorTestModule
tests(3) = @binTreeTest.binTreeTestModule
tests(4) = @PagedArrayTest.pagedArrayTestModule
