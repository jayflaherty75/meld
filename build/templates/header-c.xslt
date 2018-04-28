<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">

<xsl:output method="text" indent="no" omit-xml-declaration="yes" />

<xsl:include href="lib/warning-message-c.xslt" />
<xsl:include href="lib/type-c.xslt" />
<xsl:include href="lib/function-c.xslt" />
<xsl:include href="lib/type-convert-c.xslt" />

<xsl:variable name="lifecycle" select="' startup shutdown construct destruct update test '" />

<xsl:template match="module">
	<xsl:variable name="namespace" select="normalize-space(namespace)" />
	<xsl:variable name="version" select="normalize-space(version)" />

	<xsl:call-template name="warningMessage" />

	<xsl:text>#pragma once</xsl:text>
	<xsl:text>&#xa;&#xa;</xsl:text>

	<xsl:text>namespace </xsl:text>
	<xsl:value-of select="$namespace" />
	<xsl:text> {&#xa;&#xa;</xsl:text>

	<xsl:for-each select="typedef">
		<xsl:text>typedef </xsl:text>
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
				<xsl:text>&#xa;</xsl:text>
			</xsl:otherwise>
		</xsl:choose>
		<xsl:text>;&#xa;</xsl:text>
	</xsl:for-each>

	<xsl:for-each select="class">
		<xsl:text>struct </xsl:text>
		<xsl:value-of select="@name" />
		<xsl:text> { &#xa;</xsl:text>
		<xsl:for-each select="property">
			<xsl:text>&#x9;</xsl:text>
			<xsl:call-template name="type">
				<xsl:with-param name="name" select="@name" />
				<xsl:with-param name="type" select="@type" />
				<xsl:with-param name="modifier" select="@modifier" />
			</xsl:call-template>
			<xsl:text>;&#xa;</xsl:text>
		</xsl:for-each>
		<xsl:text>};</xsl:text>
		<xsl:text>&#xa;&#xa;</xsl:text>
	</xsl:for-each>

	<xsl:text>struct Interface {&#xa;</xsl:text>
		<xsl:text>&#x9;short (__cdecl *startup) ();&#xa;</xsl:text>
		<xsl:text>&#x9;short (__cdecl *shutdown) ();&#xa;</xsl:text>
		<xsl:choose>
			<xsl:when test="count(function[@name='construct']) &gt; 0">
				<xsl:text>&#x9;Instance* (*construct) ();&#xa;</xsl:text>
			</xsl:when>
			<xsl:otherwise>
				<xsl:text>&#x9;void* construct;&#xa;</xsl:text>
			</xsl:otherwise>
		</xsl:choose>
		<xsl:choose>
			<xsl:when test="count(function[@name='destruct']) &gt; 0">
				<xsl:text>&#x9;void (*destruct) (Instance* instancePtr);&#xa;</xsl:text>
			</xsl:when>
			<xsl:otherwise>
				<xsl:text>&#x9;void* destruct;&#xa;</xsl:text>
			</xsl:otherwise>
		</xsl:choose>
		<xsl:choose>
			<xsl:when test="count(function[@name='update']) &gt; 0">
				<xsl:text>&#x9;short (*update) (void* instancePtr);&#xa;</xsl:text>
			</xsl:when>
			<xsl:otherwise>
				<xsl:text>&#x9;void* update;&#xa;</xsl:text>
			</xsl:otherwise>
		</xsl:choose>
		<xsl:choose>
			<xsl:when test="count(function[@name='test']) &gt; 0">
				<xsl:text>&#x9;short (*test) (void* describeFn);&#xa;</xsl:text>
			</xsl:when>
			<xsl:otherwise>
				<xsl:text>&#x9;void* test;&#xa;</xsl:text>
			</xsl:otherwise>
		</xsl:choose>
		<xsl:for-each select="function">
			<xsl:choose>
				<xsl:when test="not(private) and not(contains($lifecycle, concat(' ', @name, ' ')))">
					<xsl:text>&#x9;</xsl:text>
					<xsl:call-template name="function">
						<xsl:with-param name="function" select="." />
					</xsl:call-template>
				</xsl:when>
			</xsl:choose>
		</xsl:for-each>
	<xsl:text>};</xsl:text>
	<xsl:text>&#xa;&#xa;</xsl:text>

	<xsl:text>}</xsl:text>
	<xsl:text>&#xa;</xsl:text>
</xsl:template>
</xsl:stylesheet>
