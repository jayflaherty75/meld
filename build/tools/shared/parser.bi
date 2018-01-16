
#include once "global.bi"
#include once "parser-types.bi"
#include once "parser-lib.bi"

Namespace Parser

Dim Shared As ConfigType config 
Dim Shared As StateType state

Declare Sub initialize(startup as function(parserState As StateType ptr) as short)
Declare Sub uninitialize(finish as function(parserState As StateType ptr) as short)
Declare Sub setDocStart(ByRef token As ZString)
Declare Sub setDocEnd(ByRef token As ZString)
Declare Sub setLineStart(ByRef token As ZString)
Declare Sub setParamModifiers(ByRef constParam As ZString, ByRef refParam As ZString, ByRef ptrParam As ZString)
Declare Sub addCommand(handler as Function(ByRef cmd As String, ByRef definition As String, parserPtr As StateType Ptr) As Short)
Declare Function process(ByVal srcLine As String) As Integer

Declare Function _processLine(ByRef srcLine As String) As Integer
Declare Function _directiveEnd() As Short

Sub initialize(startup as function(parserState As StateType ptr) as short)
	config.docStart = "/**"
	config.docEnd = "*/"
	config.lineStart = "*"
	config.cmdStart = "@"
	config.descStart = "-"
	config.nameStart = "["
	config.nameEnd = "]"
	config.defaultDelimiter = "="
	config.typeStart = "{"
	config.typeEnd = "}"
	config.constParam = "const "
	config.refParam = "&"
	config.ptrParam = "*"

	#IFDEF __FB_WIN32__
	config.newline = !"\r\n"
	#ELSE
	config.newline = !"\n"
	#ENDIF

	state.config = @config
	state.namespc = ""
	state.description = ""
	state.blockDesc = ""
	state.isDocBlock = false
	state.directiveCount = 0
	state.onExtraLine = NULL
	state.onDirectiveEnd = NULL
	state.onBlockEnd = NULL

	ParserLib.initialize(@config)

	startup(@state)
End Sub

Sub uninitialize(finish as function(parserState As StateType ptr) as short)
	finish(@state)
End Sub

Sub setDocStart(ByRef token As ZString)
	config.docStart = token
End Sub

Sub setDocEnd(ByRef token As ZString)
	config.docEnd = token
End Sub

Sub setLineStart(ByRef token As ZString)
	config.lineStart = token
End Sub

Sub setParamModifiers(ByRef constParam As ZString, ByRef refParam As ZString, ByRef ptrParam As ZString)
	config.constParam = constParam
	config.refParam = refParam
	config.ptrParam = ptrParam
End Sub

Sub addCommand(handler as Function(ByRef cmd As String, ByRef definition As String, parserPtr As StateType Ptr) As Short)
	Dim As Short index = state.directiveCount

	state.directives(index) = handler

	state.directiveCount = index + 1
End Sub

Function process(ByVal srcLine As String) As Integer
	Dim as String lineCopy = Trim(srcLine)

	if not state.isDocBlock then
		if instr(lineCopy, config.docStart) > 0 then
			state.blockDesc = ""
			state.isDocBlock = true
			state.onExtraLine = NULL
			state.onDirectiveEnd = NULL
			state.onBlockEnd = NULL
		end if
	else
		if instr(lineCopy, config.docEnd) = 0 then
			if not _processLine(ParserLib.decommentify(lineCopy)) then
				return false
			end if
		else
			if not _directiveEnd() then
				return false
			end if

			if state.onBlockEnd <> NULL then
				if not state.onBlockEnd(@state) then
					return false
				end if
			else
				if state.description = "" then
					state.description &= state.blockDesc
				else
					state.description &= config.newline & config.newline & state.blockDesc
				end if
			end if

			state.isDocBlock = false
		end if
	end if

	return true
End Function

Function _processLine(ByRef srcLine As String) As Integer
	Dim As Integer index = 0
	Dim As String cmd
	Dim As String definition

	if ParserLib.parseDirective(srcLine, cmd, definition) then
		if not _directiveEnd() then
			return false
		end if

		state.onExtraLine = NULL
		state.onDirectiveEnd = NULL

		For index = 0 To state.directiveCount - 1
			if not state.directives(index)(cmd, definition, @state) then
				return false
			end if
		Next index
	else
		if state.onExtraLine <> NULL then
			if not state.onExtraLine(srcLine, @state) then
				return false
			end if
		else
			state.blockDesc = trim(state.blockDesc & " " & srcLine)
		end if
	end if

	return true
End Function

Function _directiveEnd() As Short
	if state.onDirectiveEnd <> NULL then
		return state.onDirectiveEnd(@state)
	end if

	return true
End Function

End Namespace
