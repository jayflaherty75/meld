<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
	<xsl:output method="text" indent="no" omit-xml-declaration="yes" />
	<xsl:template match="module">
	<xsl:variable name="namespace" select="normalize-space(namespace)" />

	<xsl:text>&#xa;</xsl:text>

	<xsl:text>#include once "</xsl:text>
	<xsl:value-of select="@name" />
	<xsl:text>.bi"</xsl:text>
	<xsl:text>&#xa;&#xa;</xsl:text>

	<xsl:text>namespace </xsl:text>
	<xsl:value-of select="$namespace" />
	<xsl:text>&#xa;&#xa;</xsl:text>

	<xsl:text>declare function testCreate cdecl (it as Tester.itCallback) as short&#xa;</xsl:text>
	<xsl:text>declare sub test1 cdecl (done as Tester.doneFn)&#xa;</xsl:text>
	<xsl:text>&#xa;</xsl:text>

	<xsl:text>function testCreate cdecl (it as Tester.itCallback) as short&#xa;</xsl:text>
	<xsl:text>&#x9;dim as short result = true&#xa;</xsl:text>
	<xsl:text>&#xa;</xsl:text>

	<xsl:text>&#x9;result = result andalso it("performs test 1 successfully", @test1)&#xa;</xsl:text>
	<xsl:text>&#x9;' result = result andalso it("performs test 2 successfully", @test2)&#xa;</xsl:text>
	<xsl:text>&#xa;</xsl:text>

	<xsl:text>&#x9;return result&#xa;</xsl:text>
	<xsl:text>end function&#xa;</xsl:text>
	<xsl:text>&#xa;</xsl:text>

	<xsl:text>sub test1 cdecl (done as Tester.doneFn)&#xa;</xsl:text>
	<xsl:text>&#x9;_tester->expect(true, true, "Invalid result from test1")&#xa;</xsl:text>
	<xsl:text>&#x9;done()&#xa;</xsl:text>
	<xsl:text>end sub&#xa;</xsl:text>
	<xsl:text>&#xa;</xsl:text>

	<xsl:text>end namespace&#xa;</xsl:text>
	<xsl:text>&#xa;</xsl:text>

	</xsl:template>
</xsl:stylesheet>
