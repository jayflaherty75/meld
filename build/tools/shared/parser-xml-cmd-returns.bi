
#include once "global.bi"
#include once "parser-types.bi"
#include once "parser-lib.bi"

namespace ParserXmlCmdReturns

type StateType
	returnType as string
	description as string
end type

dim shared as StateType state

declare function handler(ByRef cmd As String, ByRef definition As String, parserPtr As Parser.StateType Ptr) As Short
declare function onExtraLine(ByRef srcLine As String, parserPtr As Parser.StateType Ptr) As Short
declare function onDirectiveEnd(parserPtr As Parser.StateType Ptr) As Short

declare function _parseDescription(parserPtr as Parser.StateType ptr, byref source as string) as short

function handler(ByRef cmd As String, ByRef definition As String, parserPtr As Parser.StateType Ptr) As Short
	dim as short position

	if lcase(cmd) = "returns" then
		if trim(definition) = "" then
			print("Error: Missing type in @returns directive")
			return false
		end if

		parserPtr->onExtraLine = @onExtraLine
		parserPtr->onDirectiveEnd = @onDirectiveEnd

		state.returnType = ""
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
		print("    <returns type='" & state.returnType & "'>")
		print("      <description>" & state.description & "</description>")
		print("    </returns>")
	else
		print("    <returns type='" & state.returnType & "' />")
	end if

	return true
End Function

function _parseDescription(parserPtr as Parser.StateType ptr, byref source as string) as short
	dim as short typeEnd

	typeEnd = ParserLib.parseType(source, state.returnType)
	if typeEnd = 0 then
		print("Error: Missing delimiter in @returns")
		return false
	end if

	ParserLib.parseDescription(source, state.description, typeEnd)

	return true
end function

end namespace
