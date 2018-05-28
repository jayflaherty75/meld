<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">

<xsl:output method="text" indent="no" omit-xml-declaration="yes" />

<xsl:include href="lib/convert-case.xslt" />
<xsl:include href="lib/capitalize.xslt" />
<xsl:include href="lib/acquire-interface-c.xslt" />
<xsl:include href="lib/warning-message-c.xslt" />

<xsl:template match="module">
	<xsl:variable name="module" select="@name" />
	<xsl:variable name="namespace" select="normalize-space(namespace)" />
	<xsl:variable name="version" select="normalize-space(version)" />

	<xsl:call-template name="warningMessage" />
#include &lt;stdio.h&gt;
#include once "headers/<xsl:value-of select="$module" />_v<xsl:value-of select="$version" />.bi"
#include once "<xsl:value-of select="$module" />.bi"

Module::Interface _moduleLocal;

extern "C" void* exports () __attribute__((cdecl));
extern "C" short load (Module::Interface * modulePtr) __attribute__((cdecl));
extern "C" short unload () __attribute__((cdecl));
<xsl:if test="count(requires[@module='tester']) &gt; 0 or $namespace='Tester'">
extern "C" short test () __attribute__((cdecl));
</xsl:if>
extern "C" short startup () __attribute__((cdecl));
extern "C" short shutdown () __attribute__((cdecl));

extern "C" void* exports () {
	<xsl:text>&#xa;</xsl:text>
	<xsl:for-each select="function">
		<xsl:choose>
			<xsl:when test="not(private)">
				<xsl:text>&#x9;</xsl:text>
				<xsl:text>moduleState.methods.</xsl:text>
				<xsl:value-of select="@name" />
				<xsl:text> = </xsl:text>
				<xsl:value-of select="$namespace" />
				<xsl:text>::</xsl:text>
				<xsl:value-of select="@name" />
				<xsl:text>;&#xa;</xsl:text>
			</xsl:when>
		</xsl:choose>
	</xsl:for-each>
	return &amp;moduleState.methods;
}

extern "C" short load (Module::Interface * modulePtr) {
	if (modulePtr == NULL) {
		printf("**** <xsl:value-of select="$namespace" />::load: Invalid Module interface pointer\n");
		return FALSE;
	}

	if (!moduleState.isLoaded) {
		moduleState.isStarted = FALSE;
		moduleState.isLoaded = TRUE;

		_moduleLocal = *modulePtr;
		_module = &amp;_moduleLocal;

		<xsl:text>_</xsl:text>
		<xsl:call-template name="convertCase">
			<xsl:with-param name="text" select="@name" />
		</xsl:call-template>
		<xsl:text> = static_cast&lt;</xsl:text>
		<xsl:value-of select="$namespace" />
		<xsl:text>::Interface*&gt;(exports());&#xa;</xsl:text>
		<xsl:text>&#xa;</xsl:text>

		<xsl:for-each select="requires">
			<xsl:call-template name="acquireInterface">
				<xsl:with-param name="module" select="@module" />
				<xsl:with-param name="version" select="@version" />
			</xsl:call-template>
		</xsl:for-each>
		<xsl:text>&#xa;</xsl:text>

		<xsl:if test="count(//throws) &gt; 0">
			<xsl:for-each select="function/throws">
				<xsl:sort select="@type" />

				<xsl:variable name="original-name" select="@type" />

				<xsl:if test="generate-id(.) = generate-id(//throws[@type=$original-name][1])">
					<xsl:variable name="err-name">
						<xsl:call-template name="decapitalize">
							<xsl:with-param name="text" select="@type"/>
						</xsl:call-template>
					</xsl:variable>

					<xsl:text>&#x9;&#x9;</xsl:text>
					<xsl:text>errors.</xsl:text>
					<xsl:value-of select="$err-name" />
					<xsl:text> = _fault-&gt;getCode("</xsl:text>
					<xsl:value-of select="@type" />
					<xsl:text>");&#xa;</xsl:text>
					<xsl:text>&#x9;&#x9;</xsl:text>
					<xsl:text>if (errors.</xsl:text>
					<xsl:value-of select="$err-name" />
					<xsl:text> == 0) {&#xa;</xsl:text>
					<xsl:text>&#x9;&#x9;&#x9;</xsl:text>
					<xsl:text>printf("**** </xsl:text>
					<xsl:value-of select="$namespace" />
					<xsl:text>.load: Missing error definition for </xsl:text>
					<xsl:value-of select="@type" />
					<xsl:text>\n")&#xa;</xsl:text>
					<xsl:text>&#x9;&#x9;&#x9;</xsl:text>
					<xsl:text>return FALSE;&#xa;</xsl:text>
					<xsl:text>&#x9;&#x9;</xsl:text>
					<xsl:text>}&#xa;&#xa;</xsl:text>
				</xsl:if>
			</xsl:for-each>
		</xsl:if>
	}

	return TRUE;
}

extern "C" short unload () {
	if (moduleState.isStarted) {
		if (moduleState.methods.shutdown != NULL) {
			if (!moduleState.methods.shutdown()) {
				printf("**** <xsl:value-of select="$namespace" />::unload: Module shutdown handler failed\n");
				return FALSE;
			}
		}

		moduleState.isStarted = FALSE;
	}

	moduleState.isLoaded = FALSE;

	return TRUE;
}

<xsl:if test="count(requires[@module='tester']) &gt; 0 or $namespace='Tester'">
extern "C" short test () {
	<xsl:value-of select="$namespace" />::Interface *interfacePtr = _consoleC;
	Tester::testModule tests[1];

	if (interfacePtr-&gt;test == NULL) {
		return TRUE;
	}

	tests[0] = interfacePtr-&gt;test;

	if (!_tester-&gt;run(tests, 1)) {
		return FALSE;
	}

	return TRUE;
}
</xsl:if>

extern "C" short startup () {
	if (!moduleState.isStarted) {
		if (moduleState.methods.startup != NULL) {
			if (!moduleState.methods.startup()) {
				printf("**** <xsl:value-of select="$namespace" />::startup: Module startup handler failed\n");
				return FALSE;
			}
		}

		moduleState.isStarted = TRUE;
	}

	return TRUE;
}

extern "C" short shutdown () {
	if (moduleState.isStarted) {
		if (moduleState.methods.shutdown != NULL) {
			if (!moduleState.methods.shutdown()) {
				printf("**** <xsl:value-of select="$namespace" />::shutdown: Module shutdown handler failed\n");
			}
		}

		moduleState.isStarted = FALSE;
	}

	return TRUE;
}
</xsl:template>
</xsl:stylesheet>
