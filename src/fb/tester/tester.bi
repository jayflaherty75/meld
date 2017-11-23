
type testFunc as function() as integer
type itCallback as function (byref description as string, test as testFunc) as integer
type suiteFunc as function (it as itCallback) as integer
type describeCallback as function (byref description as string, callback as suiteFunc) as integer
type testModule as function (describe as describeCallback) as integer

declare function testRunner (testArray as testModule ptr, count as integer) as integer
declare function testDescribe (byref description as string, callback as suiteFunc) as integer
declare function testSuite (byref description as string, test as testFunc) as integer

/''
 ' Given a pointer to an array of test modules and a count, runs all tests up
 ' until a first failure and returns true if all passed or false if any one
 ' fails.
 ' @param {function ptr} tests 
 ' @param {integer} count 
 ' @returns {integer}
 '/
function testRunner (tests as testModule ptr, count as integer) as integer
	dim as integer i = 0
	dim as integer result = true

	while (i < count AND result = true)
		result = tests[i] (@testDescribe)
		i += 1
	wend

	return result
end function

/''
 ' Passed to the test module so the module can provide a description.
 ' @param {string} description
 ' @param {function} callback
 ' @returns {integer}
 '/
function testDescribe (byref description as string, callback as suiteFunc) as integer
	print (description & "...")

	return callback (@testSuite)
end function

/''
 ' Passed to the test so the test can describe and run each individual testunit.
 ' @param {string} description
 ' @param {function} test
 ' @returns {integer}
 '/
function testSuite (byref description as string, test as testFunc) as integer
	print ("  ..." & description)

	return test()
end function
