<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
	<xsl:output method="text" indent="no" omit-xml-declaration="yes" />
	<xsl:template match="module">

	<xsl:text>&#xa;</xsl:text>
	<xsl:for-each select="requires">
		<xsl:text>#include once "../</xsl:text>
		<xsl:value-of select="@module" />
		<xsl:text>/</xsl:text>
		<xsl:value-of select="@module" />
		<xsl:text>-v</xsl:text>
		<xsl:value-of select="@version" />
		<xsl:text>.bi"</xsl:text>
		<xsl:text>&#xa;</xsl:text>
	</xsl:for-each>
	<xsl:text>&#xa;</xsl:text>

	<xsl:text>namespace </xsl:text>
	<xsl:value-of select="namespace" />
	<xsl:text>&#xa;&#xa;</xsl:text>

	<xsl:text>type Interface&#xa;</xsl:text>
		<xsl:comment>TODO: Move lifecycle functions into a shared type definition&#xa;</xsl:comment>
		<xsl:text>&#x9;load as function cdecl (corePtr as Core.Interface ptr) as integer&#xa;</xsl:text>
		<xsl:text>&#x9;unload as sub cdecl ()&#xa;</xsl:text>
		<xsl:text>&#x9;register as function () as integer&#xa;</xsl:text>
		<xsl:text>&#x9;unregister as sub ()&#xa;</xsl:text>
		<xsl:for-each select="function">
			<xsl:choose>
				<xsl:when test="not(private)">
					<xsl:text>&#x9;</xsl:text>
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
	<xsl:text>end type</xsl:text>
	<xsl:text>&#xa;&#xa;</xsl:text>

	<xsl:text>end namespace</xsl:text>
	<xsl:text>&#xa;</xsl:text>
	</xsl:template>
</xsl:stylesheet>
