<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
<xsl:output method="text" indent="no" omit-xml-declaration="yes" />

<xsl:template name="type">
	<xsl:param name="name" />
	<xsl:param name="type" />
	<xsl:param name="modifier" />

	<xsl:call-template name="typeConvert">
		<xsl:with-param name="type" select="$type" />
	</xsl:call-template>

	<xsl:choose>
		<xsl:when test="$modifier='pointer'">*</xsl:when>
		<xsl:when test="$modifier='pointer2'">**</xsl:when>
		<xsl:when test="$modifier='pointer3'">***</xsl:when>
	</xsl:choose>
	<xsl:text> </xsl:text>
	<xsl:value-of select="$name" />
</xsl:template>
</xsl:stylesheet>
