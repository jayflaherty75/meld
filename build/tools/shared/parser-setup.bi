
#include once "../shared/parser.bi"
#include once "../shared/parser-xml-cmd-namespace.bi"
#include once "../shared/parser-xml-cmd-requires.bi"
#include once "../shared/parser-xml-cmd-function.bi"
#include once "../shared/parser-xml-cmd-param.bi"
#include once "../shared/parser-xml-cmd-returns.bi"
#include once "../shared/parser-xml-cmd-private.bi"

declare sub parserSetup()

sub parserSetup()
	Parser.addCommand(@ParserXmlCmdNamespace.handler)
	Parser.addCommand(@ParserXmlCmdRequires.handler)
	Parser.addCommand(@ParserXmlCmdFunction.handler)
	Parser.addCommand(@ParserXmlCmdParam.handler)
	Parser.addCommand(@ParserXmlCmdReturns.handler)
	Parser.addCommand(@ParserXmlCmdPrivate.handler)
end sub
