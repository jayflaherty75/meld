<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">

<xsl:output method="text" indent="no" omit-xml-declaration="yes" />

<xsl:include href="lib/convert-case.xslt" />
<xsl:include href="lib/capitalize.xslt" />
<xsl:include href="lib/declare-interface-c.xslt" />
<xsl:include href="lib/warning-message-c.xslt" />
<xsl:include href="lib/type-convert-c.xslt" />
<xsl:include href="lib/function-c.xslt" />
<xsl:include href="lib/include-c.xslt" />

<xsl:template match="module">
	<xsl:variable name="namespace" select="normalize-space(namespace)" />
	<xsl:variable name="version" select="normalize-space(version)" />

	<xsl:call-template name="warningMessage" />

	<xsl:text>#pragma once&#xa;</xsl:text>
	<xsl:text>&#xa;</xsl:text>

	<xsl:text>#ifndef String&#xa;</xsl:text>
	<xsl:text>#define String char*&#xa;</xsl:text>
	<xsl:text>#endif&#xa;</xsl:text>
	<xsl:text>&#xa;</xsl:text>

	<xsl:text>#ifndef NULL&#xa;</xsl:text>
	<xsl:text>#define NULL 0&#xa;</xsl:text>
	<xsl:text>#endif&#xa;</xsl:text>
	<xsl:text>&#xa;</xsl:text>

	<xsl:text>#ifndef FALSE&#xa;</xsl:text>
	<xsl:text>#define FALSE 0&#xa;</xsl:text>
	<xsl:text>#endif&#xa;</xsl:text>
	<xsl:text>&#xa;</xsl:text>

	<xsl:text>#ifndef TRUE&#xa;</xsl:text>
	<xsl:text>#define TRUE -1&#xa;</xsl:text>
	<xsl:text>#endif&#xa;</xsl:text>
	<xsl:text>&#xa;</xsl:text>

	<xsl:if test="@name != 'module'">
		<xsl:call-template name="include">
			<xsl:with-param name="module" select="'module'" />
			<xsl:with-param name="version" select="'0.1.0'" />
		</xsl:call-template>
	</xsl:if>
	<xsl:for-each select="requires">
		<xsl:call-template name="include">
			<xsl:with-param name="module" select="@module" />
			<xsl:with-param name="version" select="@version" />
		</xsl:call-template>
	</xsl:for-each>
	<xsl:call-template name="include">
		<xsl:with-param name="module" select="@name" />
		<xsl:with-param name="version" select="$version" />
	</xsl:call-template>
	<xsl:text>&#xa;</xsl:text>

	<xsl:call-template name="declareInterface">
		<xsl:with-param name="module" select="'module'" />
	</xsl:call-template>
	<xsl:call-template name="declareInterface">
		<xsl:with-param name="module" select="@name" />
	</xsl:call-template>
	<xsl:for-each select="requires">
		<xsl:call-template name="declareInterface">
			<xsl:with-param name="module" select="@module" />
		</xsl:call-template>
	</xsl:for-each>
	<xsl:text>&#xa;</xsl:text>

	<xsl:text>struct ModuleStateType {&#xa;</xsl:text>
	<xsl:text>&#x9;</xsl:text>
	<xsl:value-of select="$namespace" />
	<xsl:text>::Interface methods;&#xa;</xsl:text>
	<xsl:text>&#x9;short isLoaded;&#xa;</xsl:text>
	<xsl:text>&#x9;short isStarted;&#xa;</xsl:text>
	<xsl:text>} moduleState;&#xa;</xsl:text>
	<xsl:text>&#xa;</xsl:text>

	<xsl:if test="count(//throws) &gt; 0">
		<xsl:text>struct ErrorCodes {&#xa;</xsl:text>
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
				<xsl:text>int </xsl:text>
				<xsl:value-of select="$err-name" />
				<xsl:text>&#xa;</xsl:text>
			</xsl:if>
		</xsl:for-each>
		<xsl:text>} errors;&#xa;</xsl:text>
		<xsl:text>&#xa;</xsl:text>
	</xsl:if>

	<xsl:text>namespace </xsl:text>
	<xsl:value-of select="$namespace" />
	<xsl:text> {&#xa;&#xa;</xsl:text>

	<xsl:for-each select="function">
		<xsl:call-template name="function">
			<xsl:with-param name="function" select="." />
			<xsl:with-param name="isStatic" select="1" />
		</xsl:call-template>
		<xsl:text> __attribute__((cdecl));</xsl:text>
		<xsl:text>&#xa;</xsl:text>
	</xsl:for-each>

	<xsl:text>&#xa;</xsl:text>
	<xsl:text>}&#xa;</xsl:text>
	<xsl:text>&#xa;</xsl:text>
</xsl:template>
</xsl:stylesheet>
