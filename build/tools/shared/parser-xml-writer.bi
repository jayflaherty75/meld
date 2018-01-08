
#include once "global.bi"
#include once "parser-types.bi"
'#include once "libxml/globals.bi"
'#include once "libxml/encoding.bi"
'#include once "libxml/xmlwriter.bi"

namespace ParserXmlWriter

type StateType
	writer as any ptr
'	writer as xmlTextWriterPtr
'	buffer as xmlBufferPtr
end type

dim shared as StateType state

declare function startup(parserState As Parser.StateType ptr) as short
declare function finish(parserState As Parser.StateType ptr) as short

function startup(parserState As Parser.StateType ptr) as short
'	state.buffer = xmlBufferCreate()

	print ("Starting...")
'	if state.buffer = NULL then
'		print ("ParserXmlWrite.startup: Failed to create XML buffer")
'		return false
'	end if

'	state.writer = xmlNewTextWriterMemory(state.buffer, 0)

'	if state.writer = NULL then
'		print ("ParserXmlWrite.startup: Failed to create XML writer")
'		return false
'	end if

'	if not xmlTextWriterStartDocument(state.writer, NULL, "UTF-8", NULL) < 0 then
'		print ("ParserXmlWrite.startup: Failed to create XML document")
'		return false
'	end if

	return true
end function

function finish(parserState As Parser.StateType ptr) as short
'	dim as zstring ptr outputPtr

'	if xmlTextWriterEndDocument(state.writer) < 0 then
'		print ("ParserXmlWrite.finish: Failed to end XML document")
'		return false
'	end if

'	xmlFreeTextWriter(state.writer)

'	outputPtr = state.buffer->content

'	print(*outputPtr)
	print("Finished!")

'	xmlBufferFree(state.buffer)

	return true
end function

end namespace