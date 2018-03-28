
#include once "global.bi"
#include once "parser-types.bi"
#include once "parser-lib.bi"

namespace ParserXmlCmdRequires

type StateType
	moduleName as string
	moduleVersion as string
end type

dim shared as StateType state

declare function handler(ByRef cmd As String, ByRef definition As String, parserPtr As Parser.StateType Ptr) As Short

declare function _parseDescription(parserPtr as Parser.StateType ptr, byref source as string) as short
declare sub _parseVersion(byref modName as string, byref version as string)

function handler(ByRef cmd As String, ByRef definition As String, parserPtr As Parser.StateType Ptr) As Short
	dim as short position

	if cmd = "requires" then
		if trim(definition) = "" then
			logError("Error: Incomplete @requires directive")
			return false
		end if

		state.moduleName = ""
		state.moduleVersion = "0.0.0"

		if not _parseDescription(parserPtr, definition) then
			return false
		end if

		print("  <requires module='" & state.moduleName & "' version='" & state.moduleVersion & "' />")
	end if

	return true
end function

function _parseDescription(parserPtr as Parser.StateType ptr, byref source as string) as short
	dim as short nameEnd

	nameEnd = ParserLib.parseName(source, state.moduleName, state.moduleVersion)
	if nameEnd = -1 then
		logError("Error: Missing name delimiter in @requires")
		return false
	end if

	if nameEnd = 0 then
		nameEnd = ParserLib.parseWord(source, state.moduleName)
		if state.moduleName = "" then
			logError("Error: Missing module name in @requires")
			return false
		end if
	end if

	_parseVersion(state.moduleName, state.moduleVersion)

	return true
end function

sub _parseVersion(byref modName as string, byref version as string)
	dim as short seperator = instr(modName, "_v")

	if seperator > 0 then
		version = mid(modName, seperator + 2)
		modName = left(modName, seperator - 1)
	end if
end sub

end namespace
