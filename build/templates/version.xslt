<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">

<xsl:output method="text" indent="no" omit-xml-declaration="yes" />

<xsl:template match="module">
	<xsl:variable name="version" select="normalize-space(version)" />
	<xsl:value-of select="$version" />
</xsl:template>
</xsl:stylesheet>
