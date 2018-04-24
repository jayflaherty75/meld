#include once "../shared/parser.bi"
#include once "../shared/parser-xml-writer.bi"
#include once "../shared/parser-setup.bi"

Function main() As Integer
	Dim as string moduleName = command(1)
	Dim as String srcLine
	Dim as long lineNum = 1

	Parser.Initialize(moduleName, @ParserXmlWriter.startup)
	Parser.addTypeMapping("void", "any")
	Parser.addTypeMapping("char", "byte")
	Parser.addTypeMapping("unsigned char", "ubyte")
	Parser.addTypeMapping("unsigned short", "ushort")
	Parser.addTypeMapping("unsigned long", "ulong")
	Parser.addTypeMapping("int", "integer")
	Parser.addTypeMapping("unsigned int", "uinteger")
	Parser.addTypeMapping("long long", "longint")
	Parser.addTypeMapping("unsigned long long", "ulongint")
	Parser.addTypeMapping("float", "single")
	Parser.addTypeMapping("bool", "boolean")

	parserSetup()

	Open Cons For Input As #1

	Do Until EOF(1)
		Line Input #1, srcLine

		if not Parser.process(srcLine) then
			print(" -> Line " & lineNum & ": " & srcLine)
			return 1
		end if

		lineNum += 1
	Loop

	Close #1

	Parser.Uninitialize(@ParserXmlWriter.finish)

	return 0
End Function

End main()
