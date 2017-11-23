
#include once "../error.bi"

declare function errorTestModule (describe as describeCallback) as integer
declare function errorTestCreate (it as itCallback) as integer
declare function errorTestCreate1 () as integer
declare function errorTestCreate2 () as integer

function errorTestModule (describe as describeCallback) as integer
	dim as integer result = true

	result = result ANDALSO describe ("The Error module", @errorTestCreate)

	return RESULT
end function

function errorTestCreate (it as itCallback) as integer
	dim as integer result = true

	result = result ANDALSO it ("does a little of this", @errorTestCreate1)
	result = result ANDALSO it ("does a little of that", @errorTestCreate2)

	return result
end function

function errorTestCreate1 () as integer
	return true
end function

function errorTestCreate2 () as integer
	return true
end function
