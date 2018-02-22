<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">

<xsl:output method="text" indent="no" omit-xml-declaration="yes" />

<xsl:template match="module">
	<xsl:text>&#xa;</xsl:text>
	<xsl:text>namespace </xsl:text>
	<xsl:value-of select="namespace" />
	<xsl:text>&#xa;&#xa;</xsl:text>

	<xsl:text>/'&#xa;</xsl:text>
	<xsl:text>declare sub _throwDefaultGeneralError (byref id as zstring, byref filename as zstring, lineNum as integer)&#xa;</xsl:text>
	<xsl:text>&#xa;</xsl:text>

	<xsl:text>sub _throwDefaultGeneralError (byref id as zstring, byref filename as zstring, lineNum as integer)&#xa;</xsl:text>
	<xsl:text>&#x9;_fault->throw(_&#xa;</xsl:text>
	<xsl:text>&#x9;&#x9;errors.generalError, _&#xa;</xsl:text>
	<xsl:text>&#x9;&#x9;"DefaultGeneralError", "Testing errors: " &amp; id, _&#xa;</xsl:text>
	<xsl:text>&#x9;&#x9;filename, lineNum _&#xa;</xsl:text>
	<xsl:text>&#x9;)&#xa;</xsl:text>
	<xsl:text>end sub&#xa;</xsl:text>
	<xsl:text>'/&#xa;</xsl:text>
	<xsl:text>&#xa;</xsl:text>

	<xsl:text>end namespace&#xa;</xsl:text>
	<xsl:text>&#xa;</xsl:text>
</xsl:template>
</xsl:stylesheet>
