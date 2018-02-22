<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">

<xsl:output method="text" indent="no" omit-xml-declaration="yes" />

<xsl:include href="lib/convert-case.xslt" />
<xsl:include href="lib/capitalize.xslt" />

<xsl:template match="module">
	<xsl:text>&#xa;</xsl:text>
	<xsl:text>#include once "../../../../../modules/headers/default/default-v1.bi"&#xa;</xsl:text>
	<xsl:text>&#xa;</xsl:text>

	<xsl:for-each select="requires">
		<xsl:variable name="module-namespace">
			<xsl:call-template name="convertCase">
				<xsl:with-param name="text" select="@module"/>
			</xsl:call-template>
		</xsl:variable>

		<xsl:variable name="module-field">
			<xsl:call-template name="convertCase">
				<xsl:with-param name="text" select="@module"/>
				<xsl:with-param name="pascal" select="1"/>
			</xsl:call-template>
		</xsl:variable>

		<xsl:text>dim shared _</xsl:text>
		<xsl:value-of select="$module-namespace" />
		<xsl:text> as </xsl:text>
		<xsl:value-of select="$module-field" />
		<xsl:text>.Interface ptr</xsl:text>
		<xsl:text>&#xa;</xsl:text>
	</xsl:for-each>
	<xsl:text>&#xa;</xsl:text>

	<xsl:text>type ModuleStateType&#xa;</xsl:text>
	<xsl:text>&#x9;methods as </xsl:text>
	<xsl:value-of select="namespace" />
	<xsl:text>.Interface&#xa;</xsl:text>
	<xsl:text>&#x9;isLoaded as short&#xa;</xsl:text>
	<xsl:text>&#x9;references as integer&#xa;</xsl:text>
	<xsl:text>&#x9;startups as integer&#xa;</xsl:text>
	<xsl:text>end type&#xa;</xsl:text>
	<xsl:text>&#xa;</xsl:text>

	<xsl:if test="/function/throws">
		<xsl:text>type ErrorCodes&#xa;</xsl:text>
		<xsl:for-each select="function/throws">
			<xsl:variable name="err-name">
				<xsl:call-template name="decapitalize">
					<xsl:with-param name="text" select="@type"/>
				</xsl:call-template>
			</xsl:variable>

			<xsl:text>&#x9;</xsl:text>
			<xsl:value-of select="$err-name" />
			<xsl:text> as integer</xsl:text>
			<xsl:text>&#xa;</xsl:text>
		</xsl:for-each>
		<xsl:text>end type&#xa;</xsl:text>
		<xsl:text>&#xa;</xsl:text>
	</xsl:if>

	<xsl:text>dim shared as ModuleStateType moduleState&#xa;</xsl:text>
	<xsl:if test="/function/throws">
		<xsl:text>dim shared as ErrorCodes errors&#xa;</xsl:text>
	</xsl:if>
	<xsl:text>&#xa;</xsl:text>

	<xsl:text>namespace </xsl:text>
	<xsl:value-of select="namespace" />
	<xsl:text>&#xa;&#xa;</xsl:text>

	<xsl:for-each select="function">
		<xsl:choose>
			<xsl:when test="not(private)">
				<xsl:text>declare </xsl:text>
				<xsl:choose>
					<xsl:when test="returns">function </xsl:when>
					<xsl:otherwise>sub </xsl:otherwise>
				</xsl:choose>
				<xsl:value-of select="@name" />
				<xsl:text> cdecl (</xsl:text>
				<xsl:for-each select="param">
					<xsl:choose>
						<xsl:when test="@const='true'">const </xsl:when>
					</xsl:choose>
					<xsl:choose>
						<xsl:when test="@modifier='reference'">byref </xsl:when>
					</xsl:choose>
					<xsl:value-of select="@name" />
					<xsl:text> as </xsl:text>
					<xsl:value-of select="@type" />
					<xsl:choose>
						<xsl:when test="@modifier='pointer'"> ptr</xsl:when>
					</xsl:choose>
					<xsl:choose>
						<xsl:when test="default">
							<xsl:text> = </xsl:text>
							<xsl:value-of select="default" />
						</xsl:when>
					</xsl:choose>
					<xsl:if test="position()!=last()">, </xsl:if>
				</xsl:for-each>
				<xsl:text>)</xsl:text>
				<xsl:choose>
					<xsl:when test="returns">
						<xsl:text> as </xsl:text>
						<xsl:value-of select="returns/@type" />
						<xsl:choose>
							<xsl:when test="returns/@modifier='pointer'"> ptr</xsl:when>
						</xsl:choose>
					</xsl:when>
				</xsl:choose>
				<xsl:text>&#xa;</xsl:text>
			</xsl:when>
		</xsl:choose>
	</xsl:for-each>

	<xsl:text>&#xa;</xsl:text>
	<xsl:text>end namespace&#xa;</xsl:text>
	<xsl:text>&#xa;</xsl:text>
</xsl:template>
</xsl:stylesheet>
