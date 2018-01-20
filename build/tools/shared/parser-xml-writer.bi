
#include once "global.bi"
#include once "parser-types.bi"

namespace ParserXmlWriter

declare function startup(parser As Parser.StateType ptr) as short
declare function finish(parser As Parser.StateType ptr) as short

function startup(parser As Parser.StateType ptr) as short
	print (!"<?xml version=\"1.0\" encoding=\"UTF-8\"?>")
	print("<module>")

	return true
end function

function finish(parser As Parser.StateType ptr) as short
	if parser->namespc <> "" then
		print("  <namespace>" & parser->namespc & "</namespace>")
	end if

	if parser->description <> "" then
		print("  <description>" & parser->description & "</description>")
	end if

	print("</module>")

	return true
end function

end namespace