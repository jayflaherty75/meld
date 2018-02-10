
/''
 ' @requires constants
 ' @requires module
 ' @requires console
 '/

#include once "module.bi"

/''
 ' @namespace Tester
 '/
namespace Tester

/''
 ' @typedef {function} testFunc
 ' @returns {short}
 '/

/''
 ' @typedef {function} itCallback
 ' @param {byref zstring} description
 ' @param {testFunc} test
 ' @returns {short}
 '/

/''
 ' @typedef {function} suiteFunc
 ' @param {itCallback} it
 ' @returns {short}
 '/

/''
 ' @typedef {function} describeCallback
 ' @param {byref zstring} description
 ' @param {suiteFunc} callback
 ' @returns {short}
 '/

/''
 ' @typedef {function} testModule
 ' @param {any ptr} interfacePtr
 ' @param {describeCallback} describe
 ' @returns {short}
 '/

/''
 ' @typedef {function} expect
 ' @param {long} expected
 ' @param {long} result
 ' @param {zstring} message
 '/

/''
 ' @typedef {function} done
 '/

/''
 ' Application main routine.
 ' @function startup
 ' @returns {short}
 '/
function startup cdecl () as short
	return true
end function

/''
 ' Application main routine.
 ' @function shutdown
 ' @returns {short}
 '/
function shutdown cdecl () as short
	return true
end function

/''
 ' Given a pointer to an array of test modules and a count, runs all tests up
 ' until a first failure and returns true if all passed or false if any one
 ' fails.
 ' @function run
 ' @param {testModule ptr} tests 
 ' @param {any ptr} interfacePtr 
 ' @param {short} count 
 ' @returns {short}
 '/
function run (tests as testModule ptr, interfacePtr as any ptr, count as short) as short
	dim as short i = 0
	dim as short result = true

	while (i < count AND result = true)
		if tests[i] <> NULL then
			result = tests[i] (interfacePtr, @describe)
			i += 1
		else
			_console->logMessage("Tester.run: WARNING! Null test function found.")
			result = false
		end if
	wend

	return result
end function

/''
 ' Passed to the test module so the module can provide a description.
 ' @function describe
 ' @param {zstring} description
 ' @param {suiteFunc} callback
 ' @returns {short}
 '/
function describe (byref description as zstring, callback as suiteFunc) as short
	_console->logMessage(description & "...")

	if callback = NULL then
		_console->logMessage("Tester.describe: WARNING! Null test function found.")
		return false
	end if

	return callback (@suite)
end function

/''
 ' Passed to the test so the test can describe and run each individual testunit.
 ' @function suite
 ' @param {zstring} description
 ' @param {testFunc} test
 ' @returns {short}
 '/
function suite (byref description as zstring, test as testFunc) as short
	_console->logMessage("  ..." & description)

	if test = NULL then
		_console->logMessage("Tester.suite: WARNING! Null test function found.")
		return false
	end if

	return test()
end function

end namespace
