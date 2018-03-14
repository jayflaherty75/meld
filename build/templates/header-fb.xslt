<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">

<xsl:output method="text" indent="no" omit-xml-declaration="yes" />

<xsl:include href="lib/warning-message-fb.xslt" />
<xsl:include href="lib/include-fb.xslt" />
<xsl:include href="lib/type-fb.xslt" />
<xsl:include href="lib/function-fb.xslt" />

<xsl:template match="module">
	<xsl:call-template name="warningMessage" />

	<xsl:call-template name="include">
		<xsl:with-param name="module" select="'constants'" />
		<xsl:with-param name="version" select="'1'" />
	</xsl:call-template>
	<xsl:if test="@name != 'module'">
		<xsl:call-template name="include">
			<xsl:with-param name="module" select="'module'" />
			<xsl:with-param name="version" select="'1'" />
		</xsl:call-template>
	</xsl:if>
	<xsl:for-each select="requires">
		<xsl:call-template name="include">
			<xsl:with-param name="module" select="@module" />
			<xsl:with-param name="version" select="@version" />
		</xsl:call-template>
	</xsl:for-each>
	<xsl:text>&#xa;</xsl:text>

	<xsl:text>namespace </xsl:text>
	<xsl:value-of select="namespace" />
	<xsl:text>&#xa;&#xa;</xsl:text>

	<xsl:for-each select="class">
		<xsl:text>type </xsl:text>
		<xsl:value-of select="@name" />
		<xsl:text>&#xa;</xsl:text>
		<xsl:for-each select="property">
			<xsl:text>&#x9;</xsl:text>
			<xsl:call-template name="type">
				<xsl:with-param name="name" select="@name" />
				<xsl:with-param name="type" select="@type" />
				<xsl:with-param name="modifier" select="@modifier" />
			</xsl:call-template>
		</xsl:for-each>
		<xsl:text>end type</xsl:text>
		<xsl:text>&#xa;&#xa;</xsl:text>
	</xsl:for-each>

	<xsl:for-each select="typedef">
		<xsl:text>type </xsl:text>
		<xsl:choose>
			<xsl:when test="@type='function'">
				<xsl:call-template name="function">
					<xsl:with-param name="function" select="." />
				</xsl:call-template>
			</xsl:when>
			<xsl:otherwise>
				<xsl:call-template name="type">
					<xsl:with-param name="name" select="@name" />
					<xsl:with-param name="type" select="@type" />
					<xsl:with-param name="modifier" select="@modifier" />
				</xsl:call-template>
			</xsl:otherwise>
		</xsl:choose>
		<xsl:text>&#xa;</xsl:text>
	</xsl:for-each>

	<xsl:text>type Interface&#xa;</xsl:text>
	<xsl:for-each select="function">
		<xsl:choose>
			<xsl:when test="not(private)">
				<xsl:text>&#x9;</xsl:text>
				<xsl:call-template name="function">
					<xsl:with-param name="function" select="." />
				</xsl:call-template>
			</xsl:when>
		</xsl:choose>
	</xsl:for-each>
	<xsl:text>end type</xsl:text>
	<xsl:text>&#xa;&#xa;</xsl:text>

	<xsl:text>end namespace</xsl:text>
	<xsl:text>&#xa;</xsl:text>
</xsl:template>
</xsl:stylesheet>
