
#include once "global.bi"
#include once "parser-types.bi"

namespace ParserXmlCmdPrivate

declare function handler(ByRef cmd As String, ByRef definition As String, parserPtr As Parser.StateType Ptr) As Short

function handler(ByRef cmd As String, ByRef definition As String, parserPtr As Parser.StateType Ptr) As Short
	dim as short position

	if cmd = "private" then
		print("    <private />")
	end if

	return true
end function

end namespace
