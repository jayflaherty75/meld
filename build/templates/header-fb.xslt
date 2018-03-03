<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">

<xsl:output method="text" indent="no" omit-xml-declaration="yes" />

<xsl:include href="lib/warning-message-fb.xslt" />
<xsl:include href="lib/include-fb.xslt" />
<xsl:include href="lib/property-fb.xslt" />

<xsl:template match="module">
	<xsl:call-template name="warningMessage" />

	<xsl:call-template name="include">
		<xsl:with-param name="module" select="'constants'" />
		<xsl:with-param name="version" select="'1'" />
	</xsl:call-template>
	<xsl:call-template name="include">
		<xsl:with-param name="module" select="'module'" />
		<xsl:with-param name="version" select="'1'" />
	</xsl:call-template>
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
			<xsl:call-template name="property">
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
		<xsl:value-of select="@name" />
		<xsl:text> as </xsl:text>
		<xsl:choose>
			<xsl:when test="@type='function'">
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
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="@type" />
				<xsl:choose>
					<xsl:when test="@modifier='pointer'"> ptr</xsl:when>
				</xsl:choose>
			</xsl:otherwise>
		</xsl:choose>
		<xsl:text>&#xa;&#xa;</xsl:text>
	</xsl:for-each>

	<xsl:text>type Interface&#xa;</xsl:text>
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
