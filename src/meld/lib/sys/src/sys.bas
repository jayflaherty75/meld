
/''
 ' @requires sem-ver
 '/

#include once "module.bi"
#include once "vbcompat.bi"
#include once "file.bi"

/''
 ' @namespace Sys
 ' @version 0.1.0
 '/
namespace Sys

type StateType
	newline as zstring*3
	dirsep as zstring*3
	moduleExt as zstring*4
	macAddress as zstring*18
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

	_loadMacAddress()

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
function getNewline cdecl () as zstring ptr
	return @state.newline
end function

/''
 ' @function getDirsep
 ' @returns {zstring ptr}
 '/
function getDirsep cdecl () as zstring ptr
	return @state.dirsep
end function

/''
 ' @function getModuleExt
 ' @returns {zstring ptr}
 '/
function getModuleExt cdecl () as zstring ptr
	return @state.moduleExt
end function

/''
 ' @function getTimestamp
 ' @returns {ulongint}
 '/
function getTimestamp cdecl () as ulongint
	dim as double rnow = now()
	dim as ulongint rsec = culngint(timer() * 1000) mod MILLISECONDS_PER_DAY
	dim as ulongint rday = culngint(day(rnow) - 1) * MILLISECONDS_PER_DAY
	dim as ulongint rmon = culngint(month(rnow) - 1) * MILLISECONDS_PER_MONTH
	dim as ulongint ryear = culngint(year(rnow) - 2018) * MILLISECONDS_PER_YEAR

	return rsec + rday + rmon + ryear
end function

/''
 ' @function getMacAddress
 ' @param {byref zstring} addr
 '/
sub getMacAddress cdecl (byref addr as zstring)
	addr = state.macAddress
end sub

/''
 ' @function _loadMacAddress
 ' @private
 '/
sub _loadMacAddress cdecl ()
	dim as string addr

	#IFDEF __FB_WIN32__

	''''''''''''''''''''''''' WINDOWS IMPLEMENTATION ''''''''''''''''''''''''''
	dim as long fHandle = freefile

	open pipe "ipconfig /all" for input as #fHandle

	do while not eof(fHandle) andalso state.macAddress = ""
		line input #fHandle, addr
		if instr(addr, "Physical Address") > 0 then
			state.macAddress = trim(mid(addr, instr(addr, ":") + 1))
		end if
	loop

	close #fHandle

	#ELSE

	'''''''''''''''''''''''''' LINUX IMPLEMENTATION '''''''''''''''''''''''''''
	dim as string currentDir = curdir()
	dim as string directory

	chdir("/sys/class/net")
	directory = dir("*", fbNormal or fbDirectory or fbHidden or fbSystem)

	do while len(directory) > 0 andalso state.macAddress = ""
		if left(directory, 1) <> "." then
			_readFileLine("/sys/class/net/" & directory, "address", addr)

			if _isMacAddress(addr) then
				state.macAddress = addr
			end if
		end if

		directory = Dir()
	loop

	chdir(currentDir)

	#ENDIF
end sub

/''
 ' @function _readFileLine
 ' @param {byref zstring} directory
 ' @param {byref zstring} filename
 ' @param {byref string} result
 ' @private
 '/
sub _readFileLine cdecl (byref directory as zstring, byref filename as zstring, byref result as string)
	dim as string currentDir = curdir()

	chdir(directory)

	Open filename For Input As #1
	Line Input #1, result
	Close #1

	chdir(currentDir)
end sub

/''
 ' @function _isMacAddress
 ' @param {byref zstring} addr
 ' @returns {short}
 ' @private
 '/
function _isMacAddress cdecl (byref addr as zstring) as short
	if len(addr) = 17 andalso addr <> "00:00:00:00:00:00" then
		return true
	end if

	return false
end function

end namespace

