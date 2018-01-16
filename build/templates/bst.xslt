<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
	<xsl:output indent="yes" omit-xml-declaration="yes" />
	<xsl:template match="module">
	#include once "../constants/constants-v1.bi"
	#include once "../core/core-v1.bi"
	#include once "../fault/fault-v1.bi"
	#include once "../iterator/iterator-v1.bi"

	namespace <xsl:value-of select="namespace" />

	type Node
		rightPtr as Bst.Node ptr
		leftPtr as Bst.Node ptr
		parent as Bst.Node ptr
		element as any ptr
	end type

	type Instance
		id as zstring*64
		root as Bst.Node ptr
		length as integer
		compare as function(criteria as any ptr, element as any ptr) as integer
	end type

	type Interface
		' TODO: Move lifecycle functions into a shared type definition
		load as function cdecl (corePtr as Core.Interface ptr) as integer
		unload as sub cdecl ()
		register as function () as integer
		unregister as sub ()
<xsl:for-each select="function">
			<xsl:choose>
				<xsl:when test="not(private)">
					<xsl:text>&#x9;&#x9;</xsl:text>
					<xsl:value-of select="@name" />
					<xsl:text> as </xsl:text>
					<xsl:choose>
						<xsl:when test="returns">function</xsl:when>
						<xsl:otherwise>sub</xsl:otherwise>
					</xsl:choose>
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
	end type

	end namespace
	</xsl:template>
</xsl:stylesheet>
