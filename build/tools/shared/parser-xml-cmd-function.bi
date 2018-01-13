
#define PARSER_COMMAND_FUNCTION			1

namespace ParserXmlCmdFunction

declare function isCommand(ByRef cmd As String) As Short
declare function parse(ByRef definition As String, parserPtr As Parser.StateType Ptr, blockPtr As Parser.BlockType Ptr) As Short
declare function render(parserPtr As Parser.StateType Ptr, blockPtr As Parser.BlockType Ptr) As Short

function isCommand(ByRef cmd As String) As Short
	if lcase(cmd) = "function" then
		return true
	end if

	return false
end function

function parse(byref definition As String, parserPtr As Parser.StateType Ptr, blockPtr As Parser.BlockType Ptr) As Short
	dim as short position

	blockPtr->objType = PARSER_COMMAND_FUNCTION

	if definition <> "" then
		if blockPtr->objName = "" then
			position = instr(definition, " ")

			if position = 0 then
				blockPtr->objName = definition
			else
				blockPtr->objName = left(definition, position)
				blockPtr->description = mid(definition, position + 1)
			end if
		else
			blockPtr->description &= definition
		end if
	end if

	return true
end function

function render(parserPtr As Parser.StateType Ptr, blockPtr As Parser.BlockType Ptr) As Short
	print("Function: " & blockPtr->objName & " - " & blockPtr->description)

	return true
end function

end namespace
