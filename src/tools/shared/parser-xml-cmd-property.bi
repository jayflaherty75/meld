
#include once "global.bi"
#include once "parser-types.bi"
#include once "parser-lib.bi"

namespace ParserXmlCmdProperty

type StateType
	propertyName as string
	propertyType as string
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
declare function _parseTypeModifiers(parserPtr as Parser.StateType ptr, byref propertyType as string) as short

function handler(ByRef cmd As String, ByRef definition As String, parserPtr As Parser.StateType Ptr) As Short
	if cmd = "property" orelse cmd = "member" then
		if trim(definition) = "" then
			logError("Error: Missing type in @" & cmd & " directive")
			return false
		end if

		parserPtr->onExtraLine = @onExtraLine
		parserPtr->onDirectiveEnd = @onDirectiveEnd

		state.propertyName = ""
		state.propertyType = ""
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
		if state.propertyName <> "" then
			print("    <property name='" & state.propertyName & "' type='" & state.propertyType & "' modifier='" & state.modifier & "' const='" & state.isConst & "'>")
		else
			print("    <property type='" & state.propertyType & "' modifier='" & state.modifier & "' const='" & state.isConst & "'>")
		end if
		if state.description <> "" then
			print("      <description>" & state.description & "</description>")
		end if
		if state.defaultValue <> "" then
			print("      <default>" & state.defaultValue & "</default>")
		end if
		print("    </property>")
	else
		if state.propertyName <> "" then
			print("    <property name='" & state.propertyName & "' type='" & state.propertyType & "' modifier='" & state.modifier & "' const='" & state.isConst & "' />")
		else
			print("    <property type='" & state.propertyType & "' modifier='" & state.modifier & "' const='" & state.isConst & "' />")
		end if
	end if

	return true
End Function

function _parseDescription(parserPtr as Parser.StateType ptr, byref source as string) as short
	dim as short typeEnd
	dim as short nameEnd

	typeEnd = ParserLib.parseType(source, state.propertyType)
	if typeEnd = -1 then
		logError("Error: Missing type delimiter in @property")
		return false
	end if

	_parseTypeModifiers(parserPtr, state.propertyType)

	nameEnd = ParserLib.parseName(source, state.propertyName, state.defaultValue, typeEnd - 1)
	if nameEnd = -1 then
		logError("Error: Missing name delimiter in @property")
		return false
	end if

	if nameEnd = 0 then
		nameEnd = ParserLib.parseWord(source, state.propertyName, typeEnd - 1)
		if nameEnd = 0 then return true
	end if

	ParserLib.parseDescription(source, state.description, nameEnd)

	return true
end function

function _parseTypeModifiers(parserPtr as Parser.StateType ptr, byref propertyType as string) as short
	dim as short constPos = instr(propertyType, parserPtr->config->constParam)
	dim as short refPos = instr(propertyType, parserPtr->config->refParam)
	dim as short ptrptrptrPos = instrrev(propertyType, parserPtr->config->ptrptrptrParam)
	dim as short ptrptrPos = instrrev(propertyType, parserPtr->config->ptrptrParam)
	dim as short ptrPos = instrrev(propertyType, parserPtr->config->ptrParam)

	if constPos > 0 then
		state.isConst = "true"
		mid(propertyType, 1, constPos + len(parserPtr->config->constParam)) = space(len(parserPtr->config->constParam))
	end if

	if refPos > 0 then
		state.modifier = "reference"
		mid(propertyType, 1, refPos + len(parserPtr->config->refParam)) = space(len(parserPtr->config->refParam))
	elseif ptrptrptrPos > 0 then
		state.modifier = "pointer3"
		mid(propertyType, ptrptrptrPos) = space(len(parserPtr->config->ptrptrptrParam))
	elseif ptrptrPos > 0 then
		state.modifier = "pointer2"
		mid(propertyType, ptrptrPos) = space(len(parserPtr->config->ptrptrParam))
	elseif ptrPos > 0 then
		state.modifier = "pointer"
		mid(propertyType, ptrPos) = space(len(parserPtr->config->ptrParam))
	end if

	propertyType = trim(propertyType)

	return true
end function

end namespace
