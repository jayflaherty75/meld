
#define PARSER_COMMANDS_MAX		50

Namespace Parser

Type ConfigType
	docStart As String
	docEnd As String
	lineStart As String
	cmdStart As String
	descStart As String
	typeStart As String
	typeEnd As String
End Type

Type BlockType
	objName As String
	objType As Short
	description As String
	dataPtr As Any Ptr
	child As BlockType ptr
End Type

Type StateTypeAlias As StateType

Type CommandInterface
	isCommand As Function(ByRef cmd As String) As Short
	parse As Function(ByRef definition As String, parserPtr As StateTypeAlias Ptr, blockPtr As BlockType Ptr) As Short
	render As Function(parserPtr As StateTypeAlias Ptr, blockPtr As BlockType Ptr) As Short
End Type

Type StateType
	namespc As String
	description As String
	current As BlockType Ptr
	currentCmd As CommandInterface
	isDocBlock As Short
	commands(50) As CommandInterface
	commandCount As Short
End Type

End Namespace
