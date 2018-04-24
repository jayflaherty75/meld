
#include once "global.bi"
#include once "parser-types.bi"
#include once "parser-lib.bi"

namespace ParserXmlCmdConst

type StateType
	constName as string
	constType as string
	description as string
	modifier as string
	isConst as string
	defaultValue as string
end type

dim shared as StateType state

declare function handler(ByRef cmd As String, ByRef definition As String, parserPtr As Parser.StateType Ptr) As Short
declare function onExtraLine(ByRef srcLine As String, parserPtr As Parser.StateType Ptr) As Short
declare function onDirectiveEnd(parserPtr As Parser.StateType Ptr) As Short

declare function _parseDescription(parserPtr as Parser.StateType ptr, byref source as string) as short

function handler(ByRef cmd As String, ByRef definition As String, parserPtr As Parser.StateType Ptr) As Short
	dim as short position

	if cmd = "const" orelse cmd = "constant" then
		if trim(definition) = "" then
			logError("Error: Missing type in @" & cmd & " directive")
			return false
		end if

		parserPtr->onExtraLine = @onExtraLine
		parserPtr->onDirectiveEnd = @onDirectiveEnd

		state.constName = ""
		state.constType = ""
		state.description = ""

		if not _parseDescription(parserPtr, definition) then
			return false
		end if
	end if

	return true
end function

function onExtraLine(ByRef srcLine As String, parserPtr As Parser.StateType Ptr) As Short
	state.description = trim(state.description & " " & srcLine)

	return true
end function

Function onDirectiveEnd(parserPtr As Parser.StateType Ptr) As Short
	if state.description <> "" then
		print("  <const name='" & state.constName & "' type='" & state.constType & "'>")
		print("    <description>" & state.description & "</description>")
		print("  </const>")
	else
		print("  <const name='" & state.constName & "' type='" & state.constType & "' />")
	end if

	return true
End Function

function _parseDescription(parserPtr as Parser.StateType ptr, byref source as string) as short
	dim as short typeEnd
	dim as short nameEnd

	typeEnd = ParserLib.parseType(source, state.constType)
	if typeEnd = -1 then
		logError("Error: Missing type delimiter in @const")
		return false
	end if

	state.constType = ParserLib.transformType(@parserPtr->config->typeMappings(0), state.constType)

	nameEnd = ParserLib.parseName(source, state.constName, state.defaultValue, typeEnd - 1)
	if nameEnd = -1 then
		logError("Error: Missing name delimiter in @const")
		return false
	end if

	if nameEnd = 0 then
		nameEnd = ParserLib.parseWord(source, state.constName, typeEnd - 1)
		if nameEnd = 0 then return true
	end if

	ParserLib.parseDescription(source, state.description, nameEnd - 1)

	return true
end function

end namespace
