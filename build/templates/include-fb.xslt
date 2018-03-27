<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">

<xsl:output method="text" indent="no" omit-xml-declaration="yes" />

<xsl:include href="lib/convert-case.xslt" />
<xsl:include href="lib/capitalize.xslt" />
<xsl:include href="lib/declare-interface-fb.xslt" />
<xsl:include href="lib/warning-message-fb.xslt" />
<xsl:include href="lib/function-fb.xslt" />

<xsl:template match="module">
	<xsl:variable name="namespace" select="normalize-space(namespace)" />
	<xsl:variable name="version" select="normalize-space(version)" />

	<xsl:call-template name="warningMessage" />

	<xsl:text>#include once "headers/</xsl:text>
	<xsl:value-of select="@name" />
	<xsl:text>_v</xsl:text>
	<xsl:choose>
		<xsl:when test="categoryName != ''">
			<xsl:value-of select="$version" />
		</xsl:when>
		<xsl:otherwise>
			<xsl:text>0.1.0</xsl:text>
		</xsl:otherwise>
	</xsl:choose>
	<xsl:text>.bi"&#xa;</xsl:text>
	<xsl:text>&#xa;</xsl:text>

	<xsl:text>#define NULL 0&#xa;</xsl:text>
	<xsl:text>&#xa;</xsl:text>

	<xsl:call-template name="declareInterface">
		<xsl:with-param name="module" select="'module'" />
	</xsl:call-template>
	<xsl:call-template name="declareInterface">
		<xsl:with-param name="module" select="$namespace" />
	</xsl:call-template>
	<xsl:for-each select="requires">
		<xsl:call-template name="declareInterface">
			<xsl:with-param name="module" select="@module" />
		</xsl:call-template>
	</xsl:for-each>
	<xsl:text>&#xa;</xsl:text>

	<xsl:text>type ModuleStateType&#xa;</xsl:text>
	<xsl:text>&#x9;methods as </xsl:text>
	<xsl:value-of select="$namespace" />
	<xsl:text>.Interface&#xa;</xsl:text>
	<xsl:text>&#x9;isLoaded as short&#xa;</xsl:text>
	<xsl:text>&#x9;isStarted as short&#xa;</xsl:text>
	<xsl:text>end type&#xa;</xsl:text>
	<xsl:text>&#xa;</xsl:text>

	<xsl:if test="count(//throws) &gt; 0">
		<xsl:text>type ErrorCodes&#xa;</xsl:text>
		<xsl:for-each select="function/throws">
			<xsl:sort select="@type" />

			<xsl:variable name="original-name" select="@type" />

			<xsl:if test="generate-id(.) = generate-id(//throws[@type=$original-name][1])">
				<xsl:variable name="err-name">
					<xsl:call-template name="decapitalize">
						<xsl:with-param name="text" select="@type"/>
					</xsl:call-template>
				</xsl:variable>

				<xsl:text>&#x9;</xsl:text>
				<xsl:value-of select="$err-name" />
				<xsl:text> as integer</xsl:text>
				<xsl:text>&#xa;</xsl:text>
			</xsl:if>
		</xsl:for-each>
		<xsl:text>end type&#xa;</xsl:text>
		<xsl:text>&#xa;</xsl:text>
	</xsl:if>

	<xsl:text>dim shared as ModuleStateType moduleState&#xa;</xsl:text>
	<xsl:if test="count(//throws) &gt; 0">
		<xsl:text>dim shared as ErrorCodes errors&#xa;</xsl:text>
	</xsl:if>
	<xsl:text>&#xa;</xsl:text>

	<xsl:text>namespace </xsl:text>
	<xsl:value-of select="$namespace" />
	<xsl:text>&#xa;&#xa;</xsl:text>

	<xsl:for-each select="function">
		<xsl:text>declare </xsl:text>
		<xsl:call-template name="function">
			<xsl:with-param name="function" select="." />
			<xsl:with-param name="isStatic" select="1" />
		</xsl:call-template>
	</xsl:for-each>

	<xsl:text>&#xa;</xsl:text>
	<xsl:text>end namespace&#xa;</xsl:text>
	<xsl:text>&#xa;</xsl:text>
</xsl:template>
</xsl:stylesheet>
