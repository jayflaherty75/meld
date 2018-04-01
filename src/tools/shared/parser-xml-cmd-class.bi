
#include once "global.bi"
#include once "parser-types.bi"

namespace ParserXmlCmdClass

declare function handler(ByRef cmd As String, ByRef definition As String, parserPtr As Parser.StateType Ptr) As Short
declare Function onBlockEnd(parserPtr As Parser.StateType Ptr) As Short

function handler(ByRef cmd As String, ByRef definition As String, parserPtr As Parser.StateType Ptr) As Short
	dim as short position
	dim as string objName

	if cmd = "class" then
		if trim(definition) = "" then
			logError("Error: Missing name in @class directive")
			return false
		end if

		parserPtr->onBlockEnd = @onBlockEnd

		position = instr(definition, " ")

		if position = 0 then
			objName = definition
		else
			objName = left(definition, position)
		end if

		print("  <class name='" & objName & "'>")
	end if

	return true
end function

Function onBlockEnd(parserPtr As Parser.StateType Ptr) As Short
	if parserPtr->blockDesc <> "" then
		print("    <description>" & parserPtr->blockDesc & "</description>")
	end if

	print("  </class>")

	return true
End Function

end namespace
