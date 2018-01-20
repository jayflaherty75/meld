
#include once "global.bi"
#include once "parser-types.bi"
#include once "parser-lib.bi"

namespace ParserXmlCmdNamespace

declare function handler(ByRef cmd As String, ByRef definition As String, parserPtr As Parser.StateType Ptr) As Short

function handler(ByRef cmd As String, ByRef definition As String, parserPtr As Parser.StateType Ptr) As Short
	if lcase(cmd) = "namespace" orelse lcase(cmd) = "module" then
		if trim(definition) = "" then
			logError("Error: Missing name in @namespace directive")
			return false
		end if

		ParserLib.parseWord(definition, parserPtr->namespc)
	end if

	return true
end function

end namespace
