
/''
 ' @requires console_v0.1.0
 ' @requires fault_v0.1.0
 '/

#include once "module.bi"
#include once "errors.bi"
#include once "test.bi"

#define TESTER_TIMEOUT_DEFAULT		2000

/''
 ' @namespace Tester
 ' @version 0.1.0
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
 ' @param {zstring ptr} description
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
 ' @param {zstring ptr} description
 ' @param {suiteFunc} callback
 ' @returns {short}
 '/

/''
 ' @typedef {function} testModule
 ' @param {any ptr} describeFn
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
 ' @param {any ptr} describeFn
 ' @returns {short}
 '/
function test cdecl (describeFn as any ptr) as short
	dim as Tester.describeCallback describePtr = describeFn
	dim as short result = true

	result = result andalso describePtr ("The Tester module", @testCreate)

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
function run cdecl (tests as testModule ptr, count as short) as short
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
 ' @param {zstring ptr} description
 ' @param {suiteFunc} callback
 ' @returns {short}
 '/
function describe cdecl (description as zstring ptr, callback as suiteFunc) as short
	state.result = true

	_console->logMessage(*description & "...")

	if callback = NULL then
		_console->logMessage("Tester.describe: WARNING! Null test function found.")
		return false
	end if

	return callback (@suite)
end function

/''
 ' Passed to the test so the test can describe and run each individual testunit.
 ' @function suite
 ' @param {zstring ptr} description
 ' @param {testFunc} testFn
 ' @returns {short}
 '/
function suite cdecl (description as zstring ptr, testFn as testFunc) as short
	dim as integer waitTime = 0

	_console->logMessage("  ..." & *description)

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
 ' @param {zstring ptr} message
 '/
sub expect cdecl (result as long, expected as long, message as zstring ptr)
	if result <> expected then
		_console->logMessage("    - " & *message)
		_console->logMessage("      Expected: " & expected)
		_console->logMessage("      Actual:   " & result)

		state.result = false
	end if
end sub

/''
 ' @function expectNot
 ' @param {long} result
 ' @param {long} expected
 ' @param {zstring ptr} message
 '/
sub expectNot cdecl (result as long, expected as long, message as zstring ptr)
	if result = expected then
		_console->logMessage("    - " & *message)
		_console->logMessage("      Expected Not: " & expected)
		_console->logMessage("      Actual:   " & result)

		state.result = false
	end if
end sub

/''
 ' @function expectStr 
 ' @param {zstring ptr} result
 ' @param {zstring ptr} expected
 ' @param {zstring ptr} message
 '/
sub expectStr cdecl (result as zstring ptr, expected as zstring ptr, message as zstring ptr)
	if *result <> *expected then
		_console->logMessage("    - " & *message)
		_console->logMessage("      Expected: " & *expected)
		_console->logMessage("      Actual:   " & *result)

		state.result = false
	end if
end sub

/''
 ' @function expectStrNot
 ' @param {zstring ptr} result
 ' @param {zstring ptr} expected
 ' @param {zstring ptr} message
 '/
sub expectStrNot cdecl (result as zstring ptr, expected as zstring ptr, message as zstring ptr)
	if *result = *expected then
		_console->logMessage("    - " & *message)
		_console->logMessage("      Expected Not: " & *expected)
		_console->logMessage("      Actual:   " & *result)

		state.result = false
	end if
end sub

/''
 ' @function expectPtr
 ' @param {any ptr} result
 ' @param {any ptr} expected
 ' @param {zstring ptr} message
 '/
sub expectPtr cdecl (result as any ptr, expected as any ptr, message as zstring ptr)
	if result <> expected then
		_console->logMessage("    - " & *message)
		_console->logMessage("      Expected: " & expected)
		_console->logMessage("      Actual:   " & result)

		state.result = false
	end if
end sub

/''
 ' @function expectPtrNot
 ' @param {any ptr} result
 ' @param {any ptr} expected
 ' @param {zstring ptr} message
 '/
sub expectPtrNot cdecl (result as any ptr, expected as any ptr, message as zstring ptr)
	if result = expected then
		_console->logMessage("    - " & *message)
		_console->logMessage("      Expected Not: " & expected)
		_console->logMessage("      Actual:   " & result)

		state.result = false
	end if
end sub

/''
 ' @function _done
 ' @private
 '/
sub _done cdecl ()
	state.isDone = true
end sub

end namespace

