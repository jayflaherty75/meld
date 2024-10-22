
#include once "../shared/parser.bi"
#include once "../shared/parser-xml-cmd-namespace.bi"
#include once "../shared/parser-xml-cmd-requires.bi"
#include once "../shared/parser-xml-cmd-function.bi"
#include once "../shared/parser-xml-cmd-param.bi"
#include once "../shared/parser-xml-cmd-returns.bi"
#include once "../shared/parser-xml-cmd-private.bi"
#include once "../shared/parser-xml-cmd-deprecated.bi"
#include once "../shared/parser-xml-cmd-throws.bi"
#include once "../shared/parser-xml-cmd-const.bi"
#include once "../shared/parser-xml-cmd-implements.bi"
#include once "../shared/parser-xml-cmd-typedef.bi"
#include once "../shared/parser-xml-cmd-class.bi"
#include once "../shared/parser-xml-cmd-property.bi"
#include once "../shared/parser-xml-cmd-version.bi"

declare sub parserSetup()

sub parserSetup()
	Parser.addCommand(@ParserXmlCmdNamespace.handler)
	Parser.addCommand(@ParserXmlCmdRequires.handler)
	Parser.addCommand(@ParserXmlCmdFunction.handler)
	Parser.addCommand(@ParserXmlCmdParam.handler)
	Parser.addCommand(@ParserXmlCmdReturns.handler)
	Parser.addCommand(@ParserXmlCmdPrivate.handler)
	Parser.addCommand(@ParserXmlCmdDeprecated.handler)
	Parser.addCommand(@ParserXmlCmdThrows.handler)
	Parser.addCommand(@ParserXmlCmdConst.handler)
	Parser.addCommand(@ParserXmlCmdImplements.handler)
	Parser.addCommand(@ParserXmlCmdTypedef.handler)
	Parser.addCommand(@ParserXmlCmdClass.handler)
	Parser.addCommand(@ParserXmlCmdProperty.handler)
	Parser.addCommand(@ParserXmlCmdVersion.handler)
end sub
