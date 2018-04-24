
#include once "global.bi"
#include once "parser-types.bi"

namespace ParserXmlCmdTypedef

type StateType
	defName as string
	defType as string
	description as string
	modifier as string
end type

dim shared as StateType state

declare function handler(ByRef cmd As String, ByRef definition As String, parserPtr As Parser.StateType Ptr) As Short
declare function onExtraLine(ByRef srcLine As String, parserPtr As Parser.StateType Ptr) As Short
declare function onDirectiveEnd(parserPtr As Parser.StateType Ptr) As Short
declare Function onBlockEnd(parserPtr As Parser.StateType Ptr) As Short

declare function _parseDescription(parserPtr as Parser.StateType ptr, byref source as string) as short
declare function _parseTypeModifiers(parserPtr as Parser.StateType ptr, byref defType as string) as short

function handler(ByRef cmd As String, ByRef definition As String, parserPtr As Parser.StateType Ptr) As Short
	if cmd = "typedef" then
		if trim(definition) = "" then
			logError("Error: Missing name and type in @typedef directive")
			return false
		end if

		parserPtr->onExtraLine = @onExtraLine
		parserPtr->onDirectiveEnd = @onDirectiveEnd
		parserPtr->onBlockEnd = @onBlockEnd

		state.defName = ""
		state.defType = ""
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
	print("  <typedef name='" & state.defName & "' type='" & state.defType & "' modifier='" & state.modifier & "'>")

	return true
End Function

Function onBlockEnd(parserPtr As Parser.StateType Ptr) As Short
	dim as string description = parserPtr->blockDesc

	if state.description <> "" then
		if description <> "" then
			description &= parserPtr->config->newline & parserPtr->config->newline
		end if

		description &= state.description
	end if

	if description <> "" then
		print("    <description>" & description & "</description>")
	end if

	print("  </typedef>")

	return true
End Function

function _parseDescription(parserPtr as Parser.StateType ptr, byref source as string) as short
	dim as short typeEnd
	dim as short nameEnd
	dim as string unusedDefVal

	typeEnd = ParserLib.parseType(source, state.defType)
	if typeEnd = -1 then
		logError("Error: Missing type delimiter in @typedef")
		return false
	end if

	_parseTypeModifiers(parserPtr, state.defType)

	state.defType = ParserLib.transformType(@parserPtr->config->typeMappings(0), state.defType)

	nameEnd = ParserLib.parseName(source, state.defName, unusedDefVal, typeEnd - 1)
	if nameEnd = -1 then
		logError("Error: Missing name delimiter in @typedef")
		return false
	end if

	if nameEnd = 0 then
		nameEnd = ParserLib.parseWord(source, state.defName, typeEnd - 1)
		if nameEnd = 0 then return true
	end if

	ParserLib.parseDescription(source, state.description, nameEnd - 1)

	return true
end function

function _parseTypeModifiers(parserPtr as Parser.StateType ptr, byref defType as string) as short
	dim as short refPos = instr(defType, parserPtr->config->refParam)
	dim as short ptrptrptrPos = instrrev(defType, parserPtr->config->ptrptrptrParam)
	dim as short ptrptrPos = instrrev(defType, parserPtr->config->ptrptrParam)
	dim as short ptrPos = instrrev(defType, parserPtr->config->ptrParam)

	if refPos > 0 then
		state.modifier = "reference"
		mid(defType, 1, refPos + len(parserPtr->config->refParam)) = space(len(parserPtr->config->refParam))
	elseif ptrptrptrPos > 0 then
		state.modifier = "pointer3"
		mid(defType, ptrptrptrPos) = space(len(parserPtr->config->ptrptrptrParam))
	elseif ptrptrPos > 0 then
		state.modifier = "pointer2"
		mid(defType, ptrptrPos) = space(len(parserPtr->config->ptrptrParam))
	elseif ptrPos > 0 then
		state.modifier = "pointer"
		mid(defType, ptrPos) = space(len(parserPtr->config->ptrParam))
	end if

	defType = trim(defType)

	return true
end function

end namespace
