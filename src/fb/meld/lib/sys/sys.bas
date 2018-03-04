

#include once "../../../../../modules/headers/constants/constants-v1.bi"
#include once "module.bi"

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
	return true
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

