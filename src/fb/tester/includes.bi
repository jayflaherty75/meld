
#include once "tester.bi"
#include once "../shared/lib/test/list.bi"

#define TEST_COUNT			1

dim shared as testModule tests(TEST_COUNT)

tests(0) = @listTestModule
