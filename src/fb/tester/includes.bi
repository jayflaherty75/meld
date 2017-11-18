
#include once "tester.bi"
#include once "../meld/lib/test/error.bi"
#include once "../shared/lib/test/list.bi"

#define TEST_COUNT			2

dim shared as testModule tests(TEST_COUNT)

tests(0) = @errorTestModule
tests(1) = @listTestModule
