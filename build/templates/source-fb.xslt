<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">

<xsl:output method="text" indent="no" omit-xml-declaration="yes" />

<xsl:template match="module">

/''
 ' @requires console
 ' @requires fault
 ' @requires error-handling
 ' @requires tester
 '/

#include once "../../../../../modules/headers/constants/constants-v1.bi"
#include once "module.bi"
#include once "errors.bi"
#include once "test.bi"

/''
 ' @namespace <xsl:value-of select="namespace" />
 '/
namespace <xsl:value-of select="namespace" />

/''
 ' Application main routine.
 ' @function startup
 ' @returns {short}
 '/
function startup cdecl () as short
	_console->logMessage("Starting <xsl:value-of select="@name" /> module")

	return true
end function

/''
 ' Application main routine.
 ' @function shutdown
 ' @returns {short}
 '/
function shutdown cdecl () as short
	_console->logMessage("Shutting down <xsl:value-of select="@name" /> module")

	return true
end function

/''
 ' Standard test runner for modules.
 ' @function test
 ' @param {any ptr} interfacePtr
 ' @param {Tester.describeCallback} describe
 ' @returns {short}
 '/
function test cdecl (interfacePtr as any ptr, describe as Tester.describeCallback) as short
	dim as short result = true

	result = result andalso describe ("The <xsl:value-of select="namespace" /> module", @<xsl:value-of select="namespace" />.testCreate)

	return result
end function

end namespace

</xsl:template>
</xsl:stylesheet>
