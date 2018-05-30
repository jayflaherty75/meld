<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
<xsl:output method="text" indent="no" omit-xml-declaration="yes" />

<xsl:template name="declareInterface">
	<xsl:param name="module" />

	<xsl:variable name="module-namespace">
		<xsl:call-template name="convertCase">
			<xsl:with-param name="text" select="$module"/>
			<xsl:with-param name="pascal" select="1"/>
		</xsl:call-template>
	</xsl:variable>

	<xsl:variable name="module-field">
		<xsl:call-template name="convertCase">
			<xsl:with-param name="text" select="$module"/>
		</xsl:call-template>
	</xsl:variable>

	<xsl:value-of select="$module-namespace" />
	<xsl:text>::Interface* _</xsl:text>
	<xsl:value-of select="$module-field" />
	<xsl:text>;&#xa;</xsl:text>
</xsl:template>
</xsl:stylesheet>
