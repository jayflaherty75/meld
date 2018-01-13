
#include once "global.bi"
#include once "parser-types.bi"

Namespace Parser

Dim Shared As ConfigType config 
Dim Shared As StateType state

Declare Sub initialize(startup as function(parserState As StateType ptr) as short)
Declare Sub uninitialize(finish as function(parserState As StateType ptr) as short)
Declare Sub setDocStart(ByRef token As ZString)
Declare Sub setDocEnd(ByRef token As ZString)
Declare Sub setLineStart(ByRef token As ZString)
Declare Sub addCommand(interface as CommandInterface Ptr)
Declare Function process(ByVal srcLine As String) As Integer

Declare Function _processContent(ByRef srcLine As String) As Integer
Declare Function _cleanContent(ByRef srcLine As String) As String
Declare Function _getBlock(blockPtr As BlockType Ptr = NULL) As BlockType Ptr
Declare Function _splitCommand(ByRef srcLine As String, ByRef cmd As String, ByRef definition As String) As Short
Declare Sub _cleanup(blockPtr As BlockType Ptr)
Declare Function _setCommandInterface(ByRef cmd As String) As Short
Declare Sub _setDefaultInterface()
Declare Function _defaultParse(ByRef definition As String, parserPtr As StateType Ptr, blockPtr As BlockType Ptr) As Short
Declare Function _defaultRender(parserPtr As StateType Ptr, blockPtr As BlockType Ptr) As Short

Sub initialize(startup as function(parserState As StateType ptr) as short)
	config.docStart = "/**"
	config.docEnd = "*/"
	config.lineStart = "*"
	config.cmdStart = "@"
	config.descStart = "-"
	config.typeStart = "{"
	config.typeEnd = "}"

	state.namespc = ""
	state.description = ""
	state.current = NULL
	state.isDocBlock = false
	state.commandCount = 0

	startup(@state)
End Sub

Sub uninitialize(finish as function(parserState As StateType ptr) as short)
	finish(@state)
	if state.current <> NULL then
		_cleanup(state.current)
		state.current = NULL
	end if
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

Sub addCommand(interface as CommandInterface Ptr)
	Dim As Short index = state.commandCount

	state.commands(index).isCommand = interface->isCommand
	state.commands(index).parse = interface->parse
	state.commands(index).render = interface->render

	state.commandCount = index + 1
End Sub

Function process(ByVal srcLine As String) As Integer
	Dim as String lineCopy = Trim(srcLine)

	if state.commandCount = 0 then
		print("Error: Parser commands have not been configured")
		return false
	end if

	if not state.isDocBlock then
		if instr(lineCopy, config.docStart) > 0 then
			state.isDocBlock = true
			state.current = CAllocate(SizeOf(BlockType))

			if state.current <> NULL then
				state.current->objName = ""
				state.current->description = ""
			else
				print("Error: Failed to allocate block")
			end if
		end if
	else
		if instr(lineCopy, config.docEnd) = 0 then
			if not _processContent(_cleanContent(lineCopy)) then
				return false
			end if
		else
			if state.current <> NULL then
				'state.currentCmd.render(@state, state.current)

				'state.current->child = NULL
				_cleanup(state.current)

				state.current = NULL
			end if

			state.isDocBlock = false
		end if
	end if

	return true
End Function

Function _processContent(ByRef srcLine As String) As Integer
	Dim As BlockType ptr blockPtr = _getBlock()
	Dim As String cmd
	Dim As String definition

	if _splitCommand(srcLine, cmd, definition) then
		_setCommandInterface(cmd)

		if state.currentCmd.parse then
			if not state.currentCmd.parse(definition, @state, blockPtr) then
				print("Error in line: " & srcLine)
				return false
			end if
		end if

		'print(cmd & ": " & definition)
	elseif blockPtr <> NULL then
		'print("     " & srcLine)
		blockPtr->description &= srcLine
	end if

	return true
End Function

Function _cleanContent(ByRef srcLine As String) As String
	Dim As Short commentPos = InStr(srcLine, config.lineStart)

	If commentPos > 0 then
		return trim(mid(srcLine, commentPos + len(config.lineStart)))
	else
		return trim(srcLine)
	end if
End Function

Function _getBlock(blockPtr As BlockType Ptr = NULL) As BlockType Ptr
	If state.current = NULL Then
		return NULL
	ElseIf BlockPtr = NULL Then
		return _getBlock(state.current)
	ElseIf BlockPtr->child <> NULL Then
		return _getBlock(blockPtr->child)
	Else
		return blockPtr
	End If
End Function

Function _splitCommand(ByRef srcLine As String, ByRef cmd As String, ByRef definition As String) As Short
	Dim As Short start = InStr(srcLine, config.cmdStart)
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

Sub _cleanup(blockPtr As BlockType Ptr)
	if blockPtr->child <> NULL then
		_cleanup(blockPtr->child)
		blockPtr->child = NULL
	end if

	Deallocate(blockPtr)
End Sub

Function _setCommandInterface(ByRef cmd As String) As Short
	Dim as Integer i
	Dim as Short result = false

	For i = 0 To state.commandCount - 1
		If state.commands(i).isCommand(cmd) Then
			state.currentCmd.isCommand = state.commands(i).isCommand
			state.currentCmd.parse = state.commands(i).parse
			state.currentCmd.render = state.commands(i).render

			result = true
		End If
	Next

	return result
End Function

Sub _setDefaultInterface()
	state.currentCmd.isCommand = NULL
	state.currentCmd.parse = @_defaultParse
	state.currentCmd.render = @_defaultRender
End Sub

Function _defaultParse(ByRef definition As String, parserPtr As StateType Ptr, blockPtr As BlockType Ptr) As Short
	if blockPtr->description <> "" then
		blockPtr->description &= !"\r\n"
	end if

	blockPtr->description &= definition

	Return true
End Function

Function _defaultRender(parserPtr As StateType Ptr, blockPtr As BlockType Ptr) As Short
	parserPtr->description = blockPtr->description

	print ("Default rendering: " & parserPtr->description)

	Return true
End Function

End Namespace
