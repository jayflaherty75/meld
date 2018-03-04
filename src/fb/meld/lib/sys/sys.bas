

/''
 ' @requires console
 ' @requires fault
 ' @requires error-handling
 ' @requires tester
 '/

#include once "../../../../../modules/headers/constants/constants-v1.bi"
#include once "module.bi"
#include once "errors.bi"
#include once "test.bi"

/''
 ' @namespace Sys
 '/
namespace Sys

type StateType
	newline as zstring*3
	dirsep as zstring*3
	moduleExt as zstring*4
end type

dim shared as StateType state

/''
 ' Application main routine.
 ' @function startup
 ' @returns {short}
 '/
function startup cdecl () as short
	_console->logMessage("Starting sys module")

	#IFDEF __FB_WIN32__
		state.newline = !"\r\n"
		state.dirsep = !"\\"
		state.moduleExt = "dll"
	#ELSE
		state.newline = !"\n"
		state.dirsep = "/"
		state.moduleExt = "so"
	#ENDIF

	return true
end function

/''
 ' Application main routine.
 ' @function shutdown
 ' @returns {short}
 '/
function shutdown cdecl () as short
	_console->logMessage("Shutting down sys module")

	return true
end function

/''
 ' Standard test runner for modules.
 ' @function test
 ' @param {Tester.describeCallback} describeFn
 ' @returns {short}
 '/
function test cdecl (describeFn as Tester.describeCallback) as short
	dim as short result = true

	result = result andalso describeFn ("The Sys module", @testCreate)

	return result
end function

/''
 ' @function getNewline
 ' @returns {zstring ptr}
 '/
function getNewline() as zstring ptr
	return @state.newline
end function

/''
 ' @function getDirsep
 ' @returns {zstring ptr}
 '/
function getDirsep() as zstring ptr
	return @state.dirsep
end function

/''
 ' @function getModuleExt
 ' @returns {zstring ptr}
 '/
function getModuleExt() as zstring ptr
	return @state.moduleExt
end function

end namespace

