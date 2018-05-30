<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">

<xsl:output method="text" indent="no" omit-xml-declaration="yes" />

<xsl:template match="module">
	<xsl:variable name="namespace" select="normalize-space(namespace)" />

	<xsl:text>&#xa;#pragma once</xsl:text>
	<xsl:text>&#xa;&#xa;</xsl:text>

	<xsl:text>&#xa;</xsl:text>
	<xsl:text>namespace </xsl:text>
	<xsl:value-of select="$namespace" />
	<xsl:text> {&#xa;&#xa;</xsl:text>

	<xsl:text>/*&#xa;</xsl:text>
	<xsl:text>void _throwDefaultGeneralError (char *filename, int lineNum) {&#xa;</xsl:text>
	<xsl:text>&#xa;</xsl:text>

	<xsl:text>sub _throwDefaultGeneralError (id as zstring ptr, filename as zstring ptr, lineNum as integer)&#xa;</xsl:text>
	<xsl:text>&#x9;(*_fault->throwErr)(&#xa;</xsl:text>
	<xsl:text>&#x9;&#x9;errors.generalError,&#xa;</xsl:text>
	<xsl:text>&#x9;&#x9;"DefaultGeneralError", "Testing errors",&#xa;</xsl:text>
	<xsl:text>&#x9;&#x9;filename, lineNum&#xa;</xsl:text>
	<xsl:text>&#x9;);&#xa;</xsl:text>
	<xsl:text>}&#xa;</xsl:text>
	<xsl:text>*/&#xa;</xsl:text>
	<xsl:text>&#xa;&#xa;</xsl:text>

	<xsl:text>}&#xa;</xsl:text>
	<xsl:text>&#xa;</xsl:text>
</xsl:template>
</xsl:stylesheet>
