
#include once "global.bi"
#include once "parser-types.bi"
#include once "parser-lib.bi"

namespace ParserXmlCmdVersion

type StateType
	moduleVersion as string
end type

dim shared as StateType state

declare function handler(ByRef cmd As String, ByRef definition As String, parserPtr As Parser.StateType Ptr) As Short

function handler(ByRef cmd As String, ByRef definition As String, parserPtr As Parser.StateType Ptr) As Short
	if cmd = "version" then
		if trim(definition) = "" then
			logError("Error: Incomplete @version directive")
			return false
		end if

		state.moduleVersion = trim(definition)

		print("  <version>" & state.moduleVersion & "</version>")
	end if

	return true
end function

end namespace
