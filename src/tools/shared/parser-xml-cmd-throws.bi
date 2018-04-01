
#include once "global.bi"
#include once "parser-types.bi"
#include once "parser-lib.bi"

namespace ParserXmlCmdThrows

declare function handler(ByRef cmd As String, ByRef definition As String, parserPtr As Parser.StateType Ptr) As Short
declare function onExtraLine(ByRef srcLine As String, parserPtr As Parser.StateType Ptr) As Short

declare function _parseDescription(parserPtr as Parser.StateType ptr, byref source as string) as short
declare function _render(parserPtr As Parser.StateType Ptr, byref errorType as string) As Short

function handler(ByRef cmd As String, ByRef definition As String, parserPtr As Parser.StateType Ptr) As Short
	dim as short position

	if cmd = "throws" then
		if trim(definition) = "" then
			logError("Error: Missing type in @throws directive")
			return false
		end if

		if not _parseDescription(parserPtr, definition) then
			return false
		end if
	end if

	return true
end function

function _parseDescription(parserPtr as Parser.StateType ptr, byref source as string) as short
	dim as short typeEnd
	dim as string allTypes
	dim as string errorType

	typeEnd = ParserLib.parseType(source, allTypes)
	if typeEnd = -1 then
		logError("Error: Missing type delimiter in @throws")
		return false
	end if

	typeEnd = ParserLib.parseMultiples(allTypes, errorType, 0)

	do while errorType <> ""
		_render(parserPtr, errorType)
		if typeEnd = 0 then typeEnd = len(allTypes)
		typeEnd = ParserLib.parseMultiples(allTypes, errorType, typeEnd)
	loop

	return true
end function

Function _render(parserPtr As Parser.StateType Ptr, byref errorType as string) As Short
	print("    <throws type='" & errorType & "' />")

	return true
End Function

end namespace
