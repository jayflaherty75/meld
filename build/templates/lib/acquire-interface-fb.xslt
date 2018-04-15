<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
<xsl:output method="text" indent="no" omit-xml-declaration="yes" />

<xsl:template name="acquireInterface">
	<xsl:param name="module" />
	<xsl:param name="version" />

	<xsl:variable name="var-name">
		<xsl:call-template name="convertCase">
			<xsl:with-param name="text" select="$module"/>
		</xsl:call-template>
	</xsl:variable>

	<xsl:text>&#x9;&#x9;</xsl:text>
	<xsl:text>_</xsl:text>
	<xsl:value-of select="$var-name" />
	<xsl:text> = modulePtr->require("</xsl:text>
	<xsl:value-of select="$module" />
	<xsl:text>_v</xsl:text>
	<xsl:value-of select="$version" />
	<xsl:text>")&#xa;</xsl:text>
	<xsl:text>&#x9;&#x9;</xsl:text>
	<xsl:text>If _</xsl:text>
	<xsl:value-of select="$var-name" />
	<xsl:text> = NULL then&#xa;</xsl:text>
	<xsl:text>&#x9;&#x9;&#x9;</xsl:text>
	<xsl:text>printf("**** </xsl:text>
	<xsl:value-of select="/module/namespace" />
	<xsl:text>.load: Failed to load </xsl:text>
	<xsl:value-of select="$module" />
	<xsl:text> dependency")&#xa;</xsl:text>
	<xsl:text>&#x9;&#x9;&#x9;</xsl:text>
	<xsl:text>Return false&#xa;</xsl:text>
	<xsl:text>&#x9;&#x9;</xsl:text>
	<xsl:text>End If&#xa;&#xa;</xsl:text>
</xsl:template>
</xsl:stylesheet>
