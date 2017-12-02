
#include once "tester.bi"

namespace Tester

type StateType
	methods as Interface
end type

dim shared as Core.Interface ptr _core

dim shared as StateType state

function load (corePtr as Core.Interface ptr) as integer
	if corePtr = NULL then
		print ("*** Tester.load: Invalid corePtr interface pointer")
		return false
	end if

	state.methods.load = @load
	state.methods.unload = @unload
	state.methods.run = @run
	state.methods.describe = @describe
	state.methods.suite = @suite

	if not corePtr->register("tester", @state.methods) then
		return false
	end if

	' TODO: Use require() to get Core once Core require is finished
	_core = corePtr

	return true
end function

sub unload()
end sub

/''
 ' Given a pointer to an array of test modules and a count, runs all tests up
 ' until a first failure and returns true if all passed or false if any one
 ' fails.
 ' @param {function ptr} tests 
 ' @param {integer} count 
 ' @returns {integer}
 '/
function run (tests as testModule ptr, count as integer) as integer
	dim as integer i = 0
	dim as integer result = true

	while (i < count AND result = true)
		if tests[i] <> NULL then
			result = tests[i] (_core, @describe)
			i += 1
		else
			print ("run: WARNING! Null test function found.")
			result = false
		end if
	wend

	return result
end function

/''
 ' Passed to the test module so the module can provide a description.
 ' @param {string} description
 ' @param {function} callback
 ' @returns {integer}
 '/
function describe (byref description as string, callback as suiteFunc) as integer
	print (description & "...")

	if callback = NULL then
		print ("describe: WARNING! Null test function found.")
		return false
	end if

	return callback (@suite)
end function

/''
 ' Passed to the test so the test can describe and run each individual testunit.
 ' @param {string} description
 ' @param {function} test
 ' @returns {integer}
 '/
function suite (byref description as string, test as testFunc) as integer
	print ("  ..." & description)

	if test = NULL then
		print ("suite: WARNING! Null test function found.")
		return false
	end if

	return test()
end function

end namespace
