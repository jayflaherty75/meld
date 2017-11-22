
#include once "tester.bi"
#include once "../meld/lib/test/error.bi"
#include once "../shared/lib/test/list.bi"
#include once "../shared/lib/test/iterator.bi"

#define TEST_COUNT			3

dim shared as testModule tests(TEST_COUNT)

tests(0) = @errorTestModule
tests(1) = @listTest.listTestModule
tests(2) = @iteratorTest.iteratorTestModule
