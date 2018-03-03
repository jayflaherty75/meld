<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
<xsl:output method="text" indent="no" omit-xml-declaration="yes" />

<xsl:template name="type">
	<xsl:param name="name" />
	<xsl:param name="type" />
	<xsl:param name="modifier" />

	<xsl:value-of select="$name" />
	<xsl:text> as </xsl:text>
	<xsl:value-of select="$type" />
	<xsl:choose>
		<xsl:when test="$modifier='pointer'"> ptr</xsl:when>
	</xsl:choose>
	<xsl:text>&#xa;</xsl:text>
</xsl:template>
</xsl:stylesheet>
