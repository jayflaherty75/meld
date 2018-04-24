<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
<xsl:output method="text" indent="no" omit-xml-declaration="yes" />

<xsl:template name="function">
	<xsl:param name="function" />
	<xsl:param name="isStatic" select="0" />

	<xsl:choose>
		<xsl:when test="returns">
			<xsl:call-template name="typeConvert">
				<xsl:with-param name="type" select="returns/@type" />
			</xsl:call-template>
			<xsl:choose>
				<xsl:when test="returns/@modifier='pointer'">*</xsl:when>
				<xsl:when test="returns/@modifier='pointer2'">**</xsl:when>
				<xsl:when test="returns/@modifier='pointer3'">***</xsl:when>
			</xsl:choose>
		</xsl:when>
		<xsl:otherwise>void </xsl:otherwise>
	</xsl:choose>

	<xsl:text> (*</xsl:text>
	<xsl:value-of select="@name" />
	<xsl:text>) (</xsl:text>

	<xsl:for-each select="param">
		<xsl:if test="@const='true'">
			<xsl:text>const </xsl:text>
		</xsl:if>
		<xsl:call-template name="typeConvert">
			<xsl:with-param name="type" select="@type" />
		</xsl:call-template>
		<xsl:choose>
			<xsl:when test="@modifier='reference'">&amp; </xsl:when>
			<xsl:when test="@modifier='pointer'">* </xsl:when>
			<xsl:when test="@modifier='pointer2'">** </xsl:when>
			<xsl:when test="@modifier='pointer3'">*** </xsl:when>
		</xsl:choose>
		<xsl:text> </xsl:text>
		<xsl:value-of select="@name" />
		<xsl:text> </xsl:text>
		<xsl:if test="position()!=last()">, </xsl:if>
	</xsl:for-each>

	<xsl:text>);</xsl:text>
	<xsl:text>&#xa;</xsl:text>
</xsl:template>
</xsl:stylesheet>
