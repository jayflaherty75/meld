<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
<xsl:output method="text" indent="no" omit-xml-declaration="yes" />

<xsl:template name="typeConvert">
	<xsl:param name="type" />

	<xsl:choose>
		<xsl:when test="$type='any'">void</xsl:when>
		<xsl:when test="$type='zstring'">char</xsl:when>
		<xsl:when test="$type='byte'">char</xsl:when>
		<xsl:when test="$type='ubyte'">unsigned char</xsl:when>
		<xsl:when test="$type='ushort'">unsigned short</xsl:when>
		<xsl:when test="$type='ulong'">unsigned long</xsl:when>
		<xsl:when test="$type='integer'">int</xsl:when>
		<xsl:when test="$type='uinteger'">unsigned int</xsl:when>
		<xsl:when test="$type='longint'">long long</xsl:when>
		<xsl:when test="$type='ulongint'">unsigned long long</xsl:when>
		<xsl:when test="$type='single'">float</xsl:when>
		<xsl:when test="$type='boolean'">bool</xsl:when>
		<xsl:otherwise>
			<xsl:value-of select="$type" />
		</xsl:otherwise>
	</xsl:choose>
</xsl:template>
</xsl:stylesheet>
