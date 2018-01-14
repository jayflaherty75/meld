
#include once "global.bi"
#include once "parser-types.bi"
#include once "parser-lib.bi"

namespace ParserXmlCmdParam

type StateType
	paramName as string
	paramType as string
	description as string
end type

dim shared as StateType state

declare function handler(ByRef cmd As String, ByRef definition As String, parserPtr As Parser.StateType Ptr) As Short
declare function onExtraLine(ByRef srcLine As String, parserPtr As StateType Ptr) As Short
declare function onDirectiveEnd(parserPtr As Parser.StateType Ptr) As Short

declare function _parseDescription(parserPtr as Parser.StateType ptr, byref source as string) as short

function handler(ByRef cmd As String, ByRef definition As String, parserPtr As Parser.StateType Ptr) As Short
	dim as short position

	if lcase(cmd) = "param" then
		if trim(definition) = "" then
			print("Error: Missing type in param directive")
			return false
		end if

		parserPtr->onExtraLine = @onExtraLine
		parserPtr->onDirectiveEnd = @onDirectiveEnd

		state.paramName = ""
		state.paramType = ""
		state.description = ""

		if not _parseDescription(parserPtr, definition) then
			return false
		end if
	end if

	return true
end function

function onExtraLine(ByRef srcLine As String, parserPtr As StateType Ptr) As Short
	state.description = state.description & trim(" " & srcLine)

	return true
end function

Function onDirectiveEnd(parserPtr As Parser.StateType Ptr) As Short
	if state.description <> "" then
		if state.paramType <> "" then
			print("    <param name='" & state.paramName & "' type='" & state.paramType & "'>")
		else
			print("    <param name='" & state.paramName & "'>")
		end if
		print("      <description>" & state.description & "</description>")
		print("    </param>")
	else
		if state.paramType <> "" then
			print("    <param name='" & state.paramName & "' type='" & state.paramType & "' />")
		else
			print("    <param name='" & state.paramName & "' />")
		end if
	end if

	return true
End Function

function _parseDescription(parserPtr as Parser.StateType ptr, byref source as string) as short
	dim as short typeEnd
	dim as short nameEnd

	typeEnd = ParserLib.parseType(source, state.paramType)
	if typeEnd = 0 then
		print("Error: Missing delimiter in @param")
		return false
	end if

	nameEnd = ParserLib.parseWord(source, state.paramName, typeEnd - 1)
	if nameEnd = 0 then return true

	ParserLib.parseDescription(source, state.description, nameEnd - 1)

	return true
end function

end namespace
