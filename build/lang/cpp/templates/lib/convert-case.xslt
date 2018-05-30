<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
<xsl:output method="text" indent="no" omit-xml-declaration="yes" />

<xsl:template name="convertCase">
	<xsl:param name="text" />
	<xsl:param name="pascal" />
	<xsl:param name="delimiter" select="'-'" />

	<xsl:variable name="upper-case" select="'ABCDEFGHIJKLMNOPQRSTUVWXYZ'" />
	<xsl:variable name="lower-case" select="'abcdefghijklmnopqrstuvwxyz'" />
	<xsl:variable name="token" select="substring-before(concat($text, $delimiter), $delimiter)" />

	<xsl:choose>
		<xsl:when test="$pascal=1">
			<xsl:value-of select="translate(substring($token, 1, 1), $lower-case, $upper-case)" />
			<xsl:value-of select="translate(substring($token, 2), $upper-case, $lower-case)" />
		</xsl:when>
		<xsl:otherwise>
			<xsl:value-of select="translate($token, $upper-case, $lower-case)" />
		</xsl:otherwise>
	</xsl:choose>

	<xsl:if test="contains($text, $delimiter)">
		<xsl:call-template name="convertCase">
			<xsl:with-param name="text" select="substring-after($text, $delimiter)" />
			<xsl:with-param name="pascal" select="1" />
		</xsl:call-template>
	</xsl:if>
</xsl:template>

</xsl:stylesheet>
