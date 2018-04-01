
#include once "global.bi"
#include once "parser-types.bi"
#include once "parser-lib.bi"

namespace ParserXmlCmdParam

type StateType
	paramName as string
	paramType as string
	description as string
	modifier as string
	isConst as string
	defaultValue as string
end type

dim shared as StateType state

declare function handler(ByRef cmd As String, ByRef definition As String, parserPtr As Parser.StateType Ptr) As Short
declare function onExtraLine(ByRef srcLine As String, parserPtr As Parser.StateType Ptr) As Short
declare function onDirectiveEnd(parserPtr As Parser.StateType Ptr) As Short

declare function _parseDescription(parserPtr as Parser.StateType ptr, byref source as string) as short
declare function _parseTypeModifiers(parserPtr as Parser.StateType ptr, byref paramType as string) as short

function handler(ByRef cmd As String, ByRef definition As String, parserPtr As Parser.StateType Ptr) As Short
	if cmd = "param" orelse cmd = "arg" orelse cmd = "argument" then
		if trim(definition) = "" then
			logError("Error: Missing type in @param directive")
			return false
		end if

		parserPtr->onExtraLine = @onExtraLine
		parserPtr->onDirectiveEnd = @onDirectiveEnd

		state.paramName = ""
		state.paramType = ""
		state.description = ""
		state.modifier = "value"
		state.isConst = "false"
		state.defaultValue = ""

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
	if state.description <> ""  orelse state.defaultValue <> "" then
		if state.paramName <> "" then
			print("    <param name='" & state.paramName & "' type='" & state.paramType & "' modifier='" & state.modifier & "' const='" & state.isConst & "'>")
		else
			print("    <param type='" & state.paramType & "' modifier='" & state.modifier & "' const='" & state.isConst & "'>")
		end if
		if state.description <> "" then
			print("      <description>" & state.description & "</description>")
		end if
		if state.defaultValue <> "" then
			print("      <default>" & state.defaultValue & "</default>")
		end if
		print("    </param>")
	else
		if state.paramName <> "" then
			print("    <param name='" & state.paramName & "' type='" & state.paramType & "' modifier='" & state.modifier & "' const='" & state.isConst & "' />")
		else
			print("    <param type='" & state.paramType & "' modifier='" & state.modifier & "' const='" & state.isConst & "' />")
		end if
	end if

	return true
End Function

function _parseDescription(parserPtr as Parser.StateType ptr, byref source as string) as short
	dim as short typeEnd
	dim as short nameEnd

	typeEnd = ParserLib.parseType(source, state.paramType)
	if typeEnd = -1 then
		logError("Error: Missing type delimiter in @param")
		return false
	end if

	_parseTypeModifiers(parserPtr, state.paramType)

	nameEnd = ParserLib.parseName(source, state.paramName, state.defaultValue, typeEnd - 1)
	if nameEnd = -1 then
		logError("Error: Missing name delimiter in @param")
		return false
	end if

	if nameEnd = 0 then
		nameEnd = ParserLib.parseWord(source, state.paramName, typeEnd - 1)
		if nameEnd = 0 then return true
	end if

	ParserLib.parseDescription(source, state.description, nameEnd)

	return true
end function

function _parseTypeModifiers(parserPtr as Parser.StateType ptr, byref paramType as string) as short
	dim as short constPos = instr(paramType, parserPtr->config->constParam)
	dim as short refPos = instr(paramType, parserPtr->config->refParam)
	dim as short ptrPos = instrrev(paramType, parserPtr->config->ptrParam)

	if constPos > 0 then
		state.isConst = "true"
		mid(paramType, 1, constPos + len(parserPtr->config->constParam)) = space(len(parserPtr->config->constParam))
	end if

	if refPos > 0 then
		state.modifier = "reference"
		mid(paramType, 1, refPos + len(parserPtr->config->refParam)) = space(len(parserPtr->config->refParam))
	elseif ptrPos > 0 then
		state.modifier = "pointer"
		mid(paramType, ptrPos) = space(len(parserPtr->config->ptrParam))
	end if

	paramType = trim(paramType)

	return true
end function

end namespace
