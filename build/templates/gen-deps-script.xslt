<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">

<xsl:output method="text" indent="no" omit-xml-declaration="yes" />

<xsl:template match="module">
	<xsl:variable name="dep">
		<xsl:value-of select="@name" />
	</xsl:variable>

	<xsl:text>#!/bin/bash&#xa;</xsl:text>
	<xsl:text>&#xa;</xsl:text>

	<xsl:for-each select="requires">
		<xsl:variable name="path">
			<xsl:text>./build/d/</xsl:text>
			<xsl:value-of select="@module" />
		</xsl:variable>

		<xsl:text>mkdir -p </xsl:text>
		<xsl:value-of select="$path" />
		<xsl:text>&#xa;</xsl:text>

		<xsl:text>echo "#!/bin/bash" > </xsl:text>
		<xsl:value-of select="$path" />
		<xsl:text>/</xsl:text>
		<xsl:value-of select="$dep" />
		<xsl:text>&#xa;</xsl:text>

		<xsl:text>echo "" >> </xsl:text>
		<xsl:value-of select="$path" />
		<xsl:text>/</xsl:text>
		<xsl:value-of select="$dep" />
		<xsl:text>&#xa;</xsl:text>

		<xsl:text>echo "./build/m/</xsl:text>
		<xsl:value-of select="$dep" />
		<xsl:text>" >> </xsl:text>
		<xsl:value-of select="$path" />
		<xsl:text>/</xsl:text>
		<xsl:value-of select="$dep" />
		<xsl:text>&#xa;&#xa;</xsl:text>
	</xsl:for-each>
	<xsl:text>&#xa;</xsl:text>
</xsl:template>
</xsl:stylesheet>
