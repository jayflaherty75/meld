<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
<xsl:output method="text" indent="no" omit-xml-declaration="yes" />

<xsl:template name="warningMessage">
	<xsl:text>&#xa;</xsl:text>
	<xsl:text>/'&#xa;</xsl:text>
 	<xsl:text> ' Generated by Meld Framework, do not modify.  Any changes will be overwritten&#xa;</xsl:text>
 	<xsl:text> ' during the next build.&#xa;</xsl:text>
 	<xsl:text> '/&#xa;</xsl:text>
	<xsl:text>&#xa;</xsl:text>
</xsl:template>
</xsl:stylesheet>
