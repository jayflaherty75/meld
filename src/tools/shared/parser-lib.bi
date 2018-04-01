
#include once "parser-types.bi"

namespace ParserLib

Dim Shared As Parser.ConfigType Ptr config

Declare Sub initialize(configPtr As Parser.ConfigType Ptr)
Declare Function stripNonAlphaNum(ByRef srcLine As String) As String
Declare Function decommentify(ByRef srcLine As String) As String
Declare Function parseDirective(ByRef srcLine As String, ByRef cmd As String, ByRef definition As String) As Short
Declare Function parseType(ByRef source As String, ByRef result As String, start as short = 1) As Short
Declare Function parseWord(ByRef source As String, ByRef result As String, start as short = 1) As Short
Declare Sub parseDescription(ByRef source As String, ByRef result As String, start as short = 1)
Declare Function parseMultiples(ByRef source As String, ByRef result As String, start as short = 1) As Short

Sub initialize(configPtr As Parser.ConfigType Ptr)
	config = configPtr
End Sub

Function stripNonAlphaNum(ByRef srcLine As String) As String
	Dim as String result = ""
	Dim as Short srcIndex, dstIndex
	Dim as UByte char

	For srcIndex = 1 to Len(srcLine)
		char = Asc(Mid(srcLine, srcIndex, 1))

		If	(char >= 97 AndAlso char <= 122) OrElse _
			(char >= 65 AndAlso char <= 90) OrElse _
			(char >= 48 AndAlso char <= 57) _
		Then
			result = result & chr(char)
		End If
	Next

	return result
End Function

Function decommentify(ByRef srcLine As String) As String
	Dim As Short commentPos = InStr(srcLine, config->lineStart)

	If commentPos > 0 then
		return trim(mid(srcLine, commentPos + len(config->lineStart)))
	else
		return trim(srcLine)
	end if
End Function

Function parseDirective(ByRef srcLine As String, ByRef cmd As String, ByRef definition As String) As Short
	Dim As Short start = InStr(srcLine, config->cmdStart)
	Dim As Short finish

	If start = 0 Then Return false

	finish = Instr(start + 1, srcLine, " ")

	If finish > 0 Then
		cmd = Trim(Mid(srcLine, start + 1, finish - 1))
		definition = Trim(Mid(srcLine, finish + 1))
	Else
		cmd = Trim(Mid(srcLine, start + 1))
	End If

	Return true
End Function

Function parseType(ByRef source As String, ByRef result As String, start as short = 1) As Short
	dim as short typeStart
	dim as short typeEnd

	' Types are always required
	typeStart = instr(start, source, config->typeStart)
	if typeStart = 0 then return -1

	typeEnd = instr(start, source, config->typeEnd)
	if typeEnd = 0 then return -1

	result = trim(mid(source, typeStart + 1, typeEnd - typeStart - 1))

	return typeEnd
End Function

Function parseName(ByRef source As String, ByRef result As String, ByRef defaultValue As String, start as short = 1) As Short
	dim as short nameStart
	dim as short nameEnd
	dim as short defaultStart

	' Name may not be required so return zero
	nameStart = instr(start, source, config->nameStart)
	if nameStart = 0 then return 0

	' The ending delimiter is requred when name is present, return error
	nameEnd = instr(start, source, config->nameEnd)
	if nameEnd = 0 then return -1

	result = trim(mid(source, nameStart + 1, nameEnd - nameStart - 1))

	defaultStart = instr(result, config->defaultDelimiter)

	if defaultStart > 0 then
		defaultValue = trim(mid(result, defaultStart + 1))
		result = trim(left(result, defaultStart - 1))
	end if

	return nameEnd
End Function

Function parseWord(ByRef source As String, ByRef result As String, start as short = 1) As Short
	dim as short wordStart
	dim as short wordEnd

	wordStart = instr(start, source, " ")
	wordEnd = instr(wordStart + 1, source, " ")

	if wordEnd = 0 then
		result = trim(mid(source, wordStart + 1))
	else
		result = trim(mid(source, wordStart + 1, wordEnd - wordStart - 1))
	end if

	return wordEnd
End Function

Sub parseDescription(ByRef source As String, ByRef result As String, start as short = 1)
	dim as short descStart = instr(start, source, config->descStart)

	if descStart = 0 orelse descStart - start > 3 then
		descStart = start
	end if

	result = trim(mid(source, descStart + 1))
End Sub

Function parseMultiples(ByRef source As String, ByRef result As String, start as short = 1) As Short
	dim as short multiEnd

	' Clear the result, if nothing found it will return empty
	result = ""

	multiEnd = instr(start + 1, source, "|")

	if multiEnd = 0 then
		result = trim(mid(source, start + 1))
	else
		result = trim(mid(source, start + 1, multiEnd - start - 1))
	end if

	return multiEnd
End Function

end namespace
