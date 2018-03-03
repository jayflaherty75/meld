<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
<xsl:output method="text" indent="no" omit-xml-declaration="yes" />

<xsl:template name="function">
	<xsl:param name="function" />
	<xsl:param name="isStatic" select="0" />

	<xsl:if test="@name and $isStatic = 0">
		<xsl:value-of select="@name" />
		<xsl:text> as </xsl:text>
	</xsl:if>
	<xsl:choose>
		<xsl:when test="returns">function </xsl:when>
		<xsl:otherwise>sub </xsl:otherwise>
	</xsl:choose>
	<xsl:if test="@name and $isStatic = 1">
		<xsl:value-of select="@name" />
		<xsl:text> </xsl:text>
	</xsl:if>
	<xsl:text>cdecl (</xsl:text>
	<xsl:for-each select="param">
		<xsl:if test="@const='true'">
			<xsl:text>const </xsl:text>
		</xsl:if>
		<xsl:if test="@modifier='reference'">
			<xsl:text>byref </xsl:text>
		</xsl:if>
		<xsl:value-of select="@name" />
		<xsl:text> as </xsl:text>
		<xsl:value-of select="@type" />
		<xsl:if test="@modifier='pointer'">
			<xsl:text> ptr</xsl:text>
		</xsl:if>
		<xsl:if test="default">
			<xsl:text> = </xsl:text>
			<xsl:value-of select="default" />
		</xsl:if>
		<xsl:if test="position()!=last()">, </xsl:if>
	</xsl:for-each>
	<xsl:text>)</xsl:text>
	<xsl:if test="returns">
		<xsl:text> as </xsl:text>
		<xsl:value-of select="returns/@type" />
		<xsl:if test="returns/@modifier='pointer'">
			<xsl:text> ptr</xsl:text>
		</xsl:if>
	</xsl:if>
	<xsl:text>&#xa;</xsl:text>
</xsl:template>
</xsl:stylesheet>
