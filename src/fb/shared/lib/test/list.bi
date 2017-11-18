
#include once "../list.bi"

declare function listTestModule (describe as describeCallback) as integer
declare function listTestCreate (it as itCallback) as integer
declare function listTestCreate1 () as integer
declare function listTestCreate2 () as integer

function listTestModule (describe as describeCallback) as integer
	dim as integer result = TRUE

	result = result ANDALSO describe ("The List module", @listTestCreate)

	return RESULT
end function

function listTestCreate (it as itCallback) as integer
	dim as integer result = TRUE

	result = result ANDALSO it ("does a little of this", @listTestCreate1)
	result = result ANDALSO it ("does a little of that", @listTestCreate2)

	return result
end function

function listTestCreate1 () as integer
	return TRUE
end function

function listTestCreate2 () as integer
	return TRUE
end function
