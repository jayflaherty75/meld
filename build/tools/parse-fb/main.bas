#include once "../shared/parser.bi"
#include once "../shared/parser-xml-writer.bi"

Dim srcLine as String

Parser.Initialize(@ParserXmlWriter.startup)
Parser.setDocStart("/''")
Parser.setDocEnd("'/")
Parser.setLineStart("'")

Open Cons For Input As #1

Do Until EOF(1)
	Line Input #1, srcLine
	Parser.process(srcLine)
Loop

Close #1

Parser.Uninitialize(@ParserXmlWriter.finish)

End
