
#define PARSER_COMMANDS_MAX		50

Namespace Parser

Type ConfigType
	docStart As String
	docEnd As String
	lineStart As String
	cmdStart As String
	descStart As String
	nameStart As String
	nameEnd As String
	defaultDelimiter As String
	typeStart As String
	typeEnd As String
	constParam As String
	refParam As String
	ptrptrptrParam As String
	ptrptrParam As String
	ptrParam As String
	newline as String
End Type

Type StateType
	config as ConfigType Ptr
	moduleName As String
	namespc As String
	implements As String
	description As String
	blockDesc as String
	isDocBlock As Short
	directives(50) As Function(ByRef cmd As String, ByRef definition As String, parserPtr As StateType Ptr) As Short
	directiveCount As Short
	onExtraLine As Function(ByRef srcLine As String, parserPtr As StateType Ptr) As Short
	onDirectiveEnd As Function(parserPtr As StateType Ptr) As Short
	onBlockEnd As Function(parserPtr As StateType Ptr) As Short
End Type

End Namespace
