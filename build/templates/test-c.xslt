<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
	<xsl:output method="text" indent="no" omit-xml-declaration="yes" />
	<xsl:template match="module">
	<xsl:variable name="namespace" select="normalize-space(namespace)" />

	<xsl:text>&#xa;</xsl:text>

	<xsl:text>#include once "</xsl:text>
	<xsl:value-of select="@name" />
	<xsl:text>.h"</xsl:text>
	<xsl:text>&#xa;&#xa;</xsl:text>

	<xsl:text>namespace </xsl:text>
	<xsl:value-of select="$namespace" />
	<xsl:text> {&#xa;&#xa;</xsl:text>

	<xsl:text>short testCreate (Tester::itCallback it) __attribute__((cdecl));&#xa;</xsl:text>
	<xsl:text>void test1 (Tester::doneFn done) __attribute__((cdecl));&#xa;</xsl:text>
	<xsl:text>&#xa;</xsl:text>

	<xsl:text>short testCreate (Tester::itCallback it) {&#xa;</xsl:text>
	<xsl:text>&#x9;short result = TRUE;&#xa;</xsl:text>
	<xsl:text>&#xa;</xsl:text>

	<xsl:text>&#x9;result = result &amp;&amp; it("performs test 1 successfully", &amp;test1);&#xa;</xsl:text>
	<xsl:text>&#x9;// result = result &amp;&amp; it("performs test 2 successfully", &amp;test2);&#xa;</xsl:text>
	<xsl:text>&#xa;</xsl:text>

	<xsl:text>&#x9;return result;&#xa;</xsl:text>
	<xsl:text>}&#xa;</xsl:text>
	<xsl:text>&#xa;</xsl:text>

	<xsl:text>void test1 (Tester::doneFn done) {&#xa;</xsl:text>
	<xsl:text>&#x9;_tester->expect(TRUE, TRUE, "Invalid result from test1");&#xa;</xsl:text>
	<xsl:text>&#x9;done();&#xa;</xsl:text>
	<xsl:text>}&#xa;</xsl:text>
	<xsl:text>&#xa;</xsl:text>

	<xsl:text>}&#xa;</xsl:text>
	<xsl:text>&#xa;</xsl:text>

	</xsl:template>
</xsl:stylesheet>
