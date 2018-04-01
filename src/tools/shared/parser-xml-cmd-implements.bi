
#include once "global.bi"
#include once "parser-types.bi"
#include once "parser-lib.bi"

namespace ParserXmlCmdImplements

declare function handler(ByRef cmd As String, ByRef definition As String, parserPtr As Parser.StateType Ptr) As Short

function handler(ByRef cmd As String, ByRef definition As String, parserPtr As Parser.StateType Ptr) As Short
	if cmd = "implements" orelse cmd = "extends" then
		if trim(definition) = "" then
			logError("Error: Missing name in @implements directive")
			return false
		end if

		ParserLib.parseType(definition, parserPtr->implements)
	end if

	return true
end function

end namespace
