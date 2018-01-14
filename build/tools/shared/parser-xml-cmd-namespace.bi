
#include once "global.bi"
#include once "parser-types.bi"

namespace ParserXmlCmdNamespace

declare function handler(ByRef cmd As String, ByRef definition As String, parserPtr As Parser.StateType Ptr) As Short

function handler(ByRef cmd As String, ByRef definition As String, parserPtr As Parser.StateType Ptr) As Short
	dim as short position

	if lcase(cmd) = "namespace" then
		if trim(definition) = "" then
			logError("Error: Missing name in @namespace directive")
			return false
		end if

		position = instr(definition, " ")

		if position = 0 then
			parserPtr->namespc = definition
		else
			parserPtr->namespc = left(definition, position)
		end if
	end if

	return true
end function

end namespace
