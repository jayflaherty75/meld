#include once "../../../modules/headers/tester/tester-v1.bi"
#include once "../meld/lib/fault/test.bi"
#include once "../shared/lib/list/test.bi"
#include once "../shared/lib/iterator/test.bi"
#include once "../shared/lib/bst/test.bi"
#include once "../shared/lib/map/test.bi"
#include once "../shared/lib/paged-array/test.bi"
#include once "../shared/lib/resource-container/test.bi"
#include once "../shared/lib/identity/test.bi"

'#define TEST_COUNT			8
#define TEST_COUNT			6

dim shared as Tester.testModule tests(TEST_COUNT - 1)

tests(0) = @FaultTest.testModule
tests(1) = @ListTest.testModule
tests(2) = @IteratorTest.testModule
tests(3) = @PagedArrayTest.testModule
tests(4) = @ResourceContainerTest.testModule
tests(5) = @IdentityTest.testModule
'tests(6) = @BstTest.testModule
'tests(7) = @MapTest.testModule
