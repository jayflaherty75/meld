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

	<xsl:variable name="namespace">
		<xsl:call-template name="convertCase">
			<xsl:with-param name="text" select="$module" />
			<xsl:with-param name="pascal" select="1" />
		</xsl:call-template>
	</xsl:variable>

	<xsl:text>&#x9;&#x9;</xsl:text>
	<xsl:text>_</xsl:text>
	<xsl:value-of select="$var-name" />
	<xsl:text> = static_cast&lt;</xsl:text>
	<xsl:value-of select="$namespace" />
	<xsl:text>::Interface*&gt;((*modulePtr->require)("</xsl:text>
	<xsl:value-of select="$module" />
	<xsl:text>_v</xsl:text>
	<xsl:value-of select="$version" />
	<xsl:text>"));&#xa;</xsl:text>
	<xsl:text>&#x9;&#x9;</xsl:text>
	<xsl:text>if (_</xsl:text>
	<xsl:value-of select="$var-name" />
	<xsl:text> = NULL) {&#xa;</xsl:text>
	<xsl:text>&#x9;&#x9;&#x9;</xsl:text>
	<xsl:text>printf("**** </xsl:text>
	<xsl:value-of select="/module/namespace" />
	<xsl:text>.load: Failed to load </xsl:text>
	<xsl:value-of select="$module" />
	<xsl:text> dependency\n");&#xa;</xsl:text>
	<xsl:text>&#x9;&#x9;&#x9;</xsl:text>
	<xsl:text>return FALSE;&#xa;</xsl:text>
	<xsl:text>&#x9;&#x9;</xsl:text>
	<xsl:text>}&#xa;&#xa;</xsl:text>
</xsl:template>
</xsl:stylesheet>
