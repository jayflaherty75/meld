<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">

<xsl:output method="text" indent="no" omit-xml-declaration="yes" />

<xsl:template match="module">
	<xsl:for-each select="requires">
		<xsl:value-of select="@module" />
		<xsl:text>_v</xsl:text>
		<xsl:value-of select="@version" />
		<xsl:text>&#xa;</xsl:text>
	</xsl:for-each>
</xsl:template>
</xsl:stylesheet>
