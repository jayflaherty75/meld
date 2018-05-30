<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
<xsl:output method="text" indent="no" omit-xml-declaration="yes" />

<xsl:template name="capitalize">
	<xsl:param name="text" />

	<xsl:variable name="upper-case" select="'ABCDEFGHIJKLMNOPQRSTUVWXYZ'" />
	<xsl:variable name="lower-case" select="'abcdefghijklmnopqrstuvwxyz'" />

	<xsl:value-of select="translate(substring($text, 1, 1), $lower-case, $upper-case)" />
	<xsl:value-of select="substring($text, 2)" />
</xsl:template>

<xsl:template name="decapitalize">
	<xsl:param name="text" />

	<xsl:variable name="upper-case" select="'ABCDEFGHIJKLMNOPQRSTUVWXYZ'" />
	<xsl:variable name="lower-case" select="'abcdefghijklmnopqrstuvwxyz'" />

	<xsl:value-of select="translate(substring($text, 1, 1), $upper-case, $lower-case)" />
	<xsl:value-of select="substring($text, 2)" />
</xsl:template>

</xsl:stylesheet>
