
#include once "identity.bi"

namespace IdentityTest

declare function testModule (describe as describeCallback) as integer
declare function create (it as itCallback) as integer
declare function test1 () as integer
declare function test8 () as integer

dim shared as integer testData(1024)
dim shared as IdentityObj ptr idPtr

function testModule (describe as describeCallback) as integer
	dim as integer result = true

	result = result ANDALSO describe ("The Identity module", @create)

	return result
end function

function create (it as itCallback) as integer
	dim as integer i
	dim as integer result = true

	result = result ANDALSO it ("creates a Identity instance", @test1)

	result = result ANDALSO it ("succeeds in deleting Identity instance", @test8)

	return result
end function

function test1 () as integer

	return true
end function

function test8 () as integer
	'Identity.destruct(idPtr)
	'idPtr = NULL

	return true
end function

end namespace
