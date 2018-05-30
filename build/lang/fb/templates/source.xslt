<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">

<xsl:output method="text" indent="no" omit-xml-declaration="yes" />

<xsl:template match="module">
	<xsl:variable name="namespace" select="normalize-space(namespace)" />
/''
 ' @requires console_v0.*
 ' @requires fault_v0.*
 ' @requires tester_v0.*
 '/

#include once "module.bi"
#include once "errors.bi"
#include once "test.bi"

/''
 ' @namespace <xsl:value-of select="$namespace" />
 ' @version 0.1.0
 '/
namespace <xsl:value-of select="$namespace" />

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
 ' @param {any ptr} describeFn
 ' @returns {short}
 '/
function test cdecl (describeFn as any ptr) as short
	dim as Tester.describeCallback describePtr = describeFn
	dim as short result = true

	result = result andalso describePtr ("The <xsl:value-of select="$namespace" /> module", @testCreate)

	return result
end function

end namespace

</xsl:template>
</xsl:stylesheet>
