

/''
 ' @requires console
 ' @requires fault
 ' @requires error-handling
 '/

#include once "../../../../../modules/headers/constants/constants-v1.bi"
#include once "module.bi"
#include once "errors.bi"
#include once "test.bi"

#define TESTER_TIMEOUT_DEFAULT		2000

/''
 ' @namespace Tester
 '/
namespace Tester

/''
 ' @typedef {function} doneFn
 '/

/''
 ' @typedef {function} testFunc
 ' @param {doneFn} done
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
 ' @param {describeCallback} describeFn
 ' @returns {short}
 '/

type StateType
	isDone as short
	result as short
end type

dim shared as StateType state

/''
 ' Application main routine.
 ' @function startup
 ' @returns {short}
 '/
function startup cdecl () as short
	_console->logMessage("Starting tester module")

	return true
end function

/''
 ' Application main routine.
 ' @function shutdown
 ' @returns {short}
 '/
function shutdown cdecl () as short
	_console->logMessage("Shutting down tester module")

	return true
end function

/''
 ' Standard test runner for modules.
 ' @function test
 ' @param {describeCallback} describeFn
 ' @returns {short}
 '/
function test cdecl (describeFn as describeCallback) as short
	dim as short result = true

	result = result andalso describeFn ("The Tester module", @testCreate)

	return result
end function

/''
 ' Given a pointer to an array of test modules and a count, runs all tests up
 ' until a first failure and returns true if all passed or false if any one
 ' fails.
 ' @function run
 ' @param {testModule ptr} tests 
 ' @param {short} count 
 ' @returns {short}
 '/
function run (tests as testModule ptr, count as short) as short
	dim as short i = 0
	dim as short result = true

	while (i < count AND result = true)
		if tests[i] <> NULL then
			result = tests[i] (@describe)
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
	state.result = true

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
 ' @param {testFunc} testFn
 ' @returns {short}
 '/
function suite (byref description as zstring, testFn as testFunc) as short
	dim as integer waitTime = 0

	_console->logMessage("  ..." & description)

	if testFn = NULL then
		_console->logMessage("Tester.suite: WARNING! Null test function found.")
		return false
	end if

	state.isDone = false

	testFn(@_done)

	while waitTime < TESTER_TIMEOUT_DEFAULT andalso state.isDone = false
		sleep(50, 1)
		waitTime += 50
	wend

	if state.isDone = false then
		_console->logMessage("    - Test exceeded " & TESTER_TIMEOUT_DEFAULT / 1000 & " seconds")
		state.result = false
	end if

	return state.result
end function

/''
 ' @function expect
 ' @param {long} result
 ' @param {long} expected
 ' @param {byref zstring} message
 '/
sub expect (result as long, expected as long, byref message as zstring)
	if result <> expected then
		_console->logMessage("    - " & message)
		_console->logMessage("      Expected: " & expected)
		_console->logMessage("      Actual:   " & result)

		state.result = false
	end if
end sub

/''
 ' @function _done
 ' @private
 '/
sub _done ()
	state.isDone = true
end sub

end namespace

