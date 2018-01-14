#include once "../shared/parser.bi"
#include once "../shared/parser-xml-writer.bi"
#include once "commands.bi"

Function main() As Integer
	Dim as String srcLine
	Dim as long lineNum = 1

	Parser.Initialize(@ParserXmlWriter.startup)
	Parser.setDocStart("/''")
	Parser.setDocEnd("'/")
	Parser.setLineStart("'")

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
