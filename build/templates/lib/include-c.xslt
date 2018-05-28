<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
<xsl:output method="text" indent="no" omit-xml-declaration="yes" />

<xsl:template name="include">
	<xsl:param name="module" />
	<xsl:param name="version" />

	<xsl:text>#include "headers/</xsl:text>
	<xsl:value-of select="$module" />
	<xsl:text>_v</xsl:text>
	<xsl:choose>
		<xsl:when test="$version != ''">
			<xsl:value-of select="$version" />
		</xsl:when>
		<xsl:otherwise>
			<xsl:text>0.1.0</xsl:text>
		</xsl:otherwise>
	</xsl:choose>
	<xsl:text>.h"</xsl:text>
	<xsl:text>&#xa;</xsl:text>
</xsl:template>
</xsl:stylesheet>
