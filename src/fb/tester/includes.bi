
#include once "tester.bi"
#include once "../meld/lib/test/error.bi"
#include once "../shared/lib/list/test.bi"
#include once "../shared/lib/iterator/test.bi"
#include once "../shared/lib/bst/test.bi"
#include once "../shared/lib/paged-array/test.bi"
#include once "../shared/lib/identity/test.bi"

#define TEST_COUNT			6

dim shared as testModule tests(TEST_COUNT - 1)

tests(0) = @errorTestModule
tests(1) = @ListTest.listTestModule
tests(2) = @IteratorTest.iteratorTestModule
tests(3) = @BstTest.bstTestModule
tests(4) = @PagedArrayTest.pagedArrayTestModule
tests(5) = @IdentityTest.identityTestModule
