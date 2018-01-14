
#include once "global.bi"
#include once "parser-types.bi"

namespace ParserXmlCmdFunction

declare function handler(ByRef cmd As String, ByRef definition As String, parserPtr As Parser.StateType Ptr) As Short
declare Function onBlockEnd(parserPtr As Parser.StateType Ptr) As Short

function handler(ByRef cmd As String, ByRef definition As String, parserPtr As Parser.StateType Ptr) As Short
	dim as short position
	dim as string objName

	if lcase(cmd) = "function" then
		if trim(definition) = "" then
			print("Error: Missing name in function directive")
			return false
		end if

		parserPtr->onBlockEnd = @onBlockEnd

		position = instr(definition, " ")

		if position = 0 then
			objName = definition
		else
			objName = left(definition, position)
		end if

		print("  <function name='" & objName & "'>")
	end if

	return true
end function

Function onBlockEnd(parserPtr As Parser.StateType Ptr) As Short
	if parserPtr->blockDesc <> "" then
		print("    <description>" & parserPtr->blockDesc & "</description>")
	end if

	print("  </function>")

	return true
End Function

end namespace
