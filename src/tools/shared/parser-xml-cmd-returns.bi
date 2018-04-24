
#include once "global.bi"
#include once "parser-types.bi"
#include once "parser-lib.bi"

namespace ParserXmlCmdReturns

type StateType
	returnType as string
	description as string
	modifier as string
end type

dim shared as StateType state

declare function handler(ByRef cmd As String, ByRef definition As String, parserPtr As Parser.StateType Ptr) As Short
declare function onExtraLine(ByRef srcLine As String, parserPtr As Parser.StateType Ptr) As Short
declare function onDirectiveEnd(parserPtr As Parser.StateType Ptr) As Short

declare function _parseDescription(parserPtr as Parser.StateType ptr, byref source as string) as short
declare function _parseTypeModifiers(parserPtr as Parser.StateType ptr, byref returnType as string) as short

function handler(ByRef cmd As String, ByRef definition As String, parserPtr As Parser.StateType Ptr) As Short
	dim as short position

	if cmd = "returns" then
		if trim(definition) = "" then
			logError("Error: Missing type in @returns directive")
			return false
		end if

		parserPtr->onExtraLine = @onExtraLine
		parserPtr->onDirectiveEnd = @onDirectiveEnd

		state.returnType = ""
		state.description = ""
		state.modifier = "value"

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
		print("    <returns type='" & state.returnType & "' modifier='" & state.modifier & "'>")
		print("      <description>" & state.description & "</description>")
		print("    </returns>")
	else
		print("    <returns type='" & state.returnType & "' modifier='" & state.modifier & "' />")
	end if

	return true
End Function

function _parseDescription(parserPtr as Parser.StateType ptr, byref source as string) as short
	dim as short typeEnd

	typeEnd = ParserLib.parseType(source, state.returnType)
	if typeEnd = -1 then
		logError("Error: Missing delimiter in @returns")
		return false
	end if

	_parseTypeModifiers(parserPtr, state.returnType)

	state.returnType = ParserLib.transformType(@parserPtr->config->typeMappings(0), state.returnType)

	ParserLib.parseDescription(source, state.description, typeEnd)

	return true
end function

function _parseTypeModifiers(parserPtr as Parser.StateType ptr, byref returnType as string) as short
	dim as short refPos = instr(returnType, parserPtr->config->refParam)
	dim as short ptrptrptrPos = instrrev(returnType, parserPtr->config->ptrptrptrParam)
	dim as short ptrptrPos = instrrev(returnType, parserPtr->config->ptrptrParam)
	dim as short ptrPos = instrrev(returnType, parserPtr->config->ptrParam)

	if refPos > 0 then
		state.modifier = "reference"
		mid(returnType, 1, refPos + len(parserPtr->config->refParam)) = space(len(parserPtr->config->refParam))
	elseif ptrptrptrPos > 0 then
		state.modifier = "pointer3"
		mid(returnType, ptrptrptrPos) = space(len(parserPtr->config->ptrptrptrParam))
	elseif ptrptrPos > 0 then
		state.modifier = "pointer2"
		mid(returnType, ptrptrPos) = space(len(parserPtr->config->ptrptrParam))
	elseif ptrPos > 0 then
		state.modifier = "pointer"
		mid(returnType, ptrPos) = space(len(parserPtr->config->ptrParam))
	end if

	returnType = trim(returnType)

	return true
end function

end namespace
