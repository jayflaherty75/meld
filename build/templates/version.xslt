<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">

<xsl:output method="text" indent="no" omit-xml-declaration="yes" />

<xsl:template match="module">
	<xsl:choose>
		<xsl:when test="count(version) &gt; 0">
			<xsl:value-of select="normalize-space(version)" />
		</xsl:when>
		<xsl:otherwise>
			<xsl:text>0.1.0</xsl:text>
		</xsl:otherwise>
	</xsl:choose>
</xsl:template>
</xsl:stylesheet>
