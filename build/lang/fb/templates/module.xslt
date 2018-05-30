<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">

<xsl:output method="text" indent="no" omit-xml-declaration="yes" />

<xsl:include href="lib/convert-case.xslt" />
<xsl:include href="lib/capitalize.xslt" />
<xsl:include href="includes/acquire-interface.xslt" />
<xsl:include href="includes/warning-message.xslt" />

<xsl:template match="module">
	<xsl:variable name="module" select="@name" />
	<xsl:variable name="namespace" select="normalize-space(namespace)" />
	<xsl:variable name="version" select="normalize-space(version)" />

	<xsl:call-template name="warningMessage" />
#include once "crt.bi"
#include once "headers/<xsl:value-of select="$module" />_v<xsl:value-of select="$version" />.bi"
#include once "<xsl:value-of select="$module" />.bi"

dim shared _moduleLocal as Module.Interface

Function exports cdecl Alias "exports" () As any ptr export
	<xsl:text>&#xa;</xsl:text>
	<xsl:for-each select="function">
		<xsl:choose>
			<xsl:when test="not(private)">
				<xsl:text>&#x9;</xsl:text>
				<xsl:text>moduleState.methods.</xsl:text>
				<xsl:value-of select="@name" />
				<xsl:text> = @</xsl:text>
				<xsl:value-of select="$namespace" />
				<xsl:text>.</xsl:text>
				<xsl:value-of select="@name" />
				<xsl:text>&#xa;</xsl:text>
			</xsl:when>
		</xsl:choose>
	</xsl:for-each>
	return @moduleState.methods
End Function

Function load cdecl Alias "load" (modulePtr As Module.Interface ptr) As short export
	If modulePtr = NULL Then
		printf(!"**** <xsl:value-of select="$namespace" />.load: Invalid Module interface pointer\n")
		return false
	End If

	If not moduleState.isLoaded Then
		moduleState.isStarted = false
		moduleState.isLoaded = true

		_moduleLocal = *modulePtr
		_module = @_moduleLocal

		<xsl:text>_</xsl:text>
		<xsl:call-template name="convertCase">
			<xsl:with-param name="text" select="@name" />
		</xsl:call-template>
		<xsl:text> = exports()&#xa;</xsl:text>
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
					<xsl:text> = _fault->getCode("</xsl:text>
					<xsl:value-of select="@type" />
					<xsl:text>")&#xa;</xsl:text>
					<xsl:text>&#x9;&#x9;</xsl:text>
					<xsl:text>If errors.</xsl:text>
					<xsl:value-of select="$err-name" />
					<xsl:text> = NULL then&#xa;</xsl:text>
					<xsl:text>&#x9;&#x9;&#x9;</xsl:text>
					<xsl:text>printf(!"**** </xsl:text>
					<xsl:value-of select="$namespace" />
					<xsl:text>.load: Missing error definition for </xsl:text>
					<xsl:value-of select="@type" />
					<xsl:text>\n")&#xa;</xsl:text>
					<xsl:text>&#x9;&#x9;&#x9;</xsl:text>
					<xsl:text>Return false&#xa;</xsl:text>
					<xsl:text>&#x9;&#x9;</xsl:text>
					<xsl:text>End If&#xa;&#xa;</xsl:text>
				</xsl:if>
			</xsl:for-each>
		</xsl:if>
	End If

	return true
End Function

Function unload cdecl Alias "unload" () As short export

	If moduleState.isStarted Then
		If moduleState.methods.shutdown &lt;&gt; NULL Then
			If not moduleState.methods.shutdown() Then
				printf(!"**** <xsl:value-of select="$namespace" />.unload: Module shutdown handler failed\n")
				return false
			End If
		End If

		moduleState.isStarted = false
	End If

	moduleState.isLoaded = false

	return true
End Function

<xsl:if test="count(requires[@module='tester']) &gt; 0 or $namespace='Tester'">
Function test cdecl Alias "test" () As short export
	dim As <xsl:value-of select="$namespace" />.Interface ptr interfacePtr = exports()
	dim As Tester.testModule tests(1)

	If interfacePtr-&gt;test = NULL Then return true

	tests(0) = interfacePtr-&gt;test

	If not _tester-&gt;run(@tests(0), 1) Then
		return false
	End If

	return true
End Function
</xsl:if>

Function startup cdecl Alias "startup" () As short export
	If not moduleState.isStarted Then
		If moduleState.methods.startup &lt;&gt; NULL Then
			If not moduleState.methods.startup() Then
				printf(!"**** <xsl:value-of select="$namespace" />.startup: Module startup handler failed\n")
				return false
			End If
		End If

		moduleState.isStarted = true
	End If

	return true
End Function

Function shutdown cdecl Alias "shutdown" () As short export
	If moduleState.isStarted Then
		If moduleState.methods.shutdown &lt;&gt; NULL Then
			If not moduleState.methods.shutdown() Then
				printf(!"**** <xsl:value-of select="$namespace" />.shutdown: Module shutdown handler failed\n")
			End If
		End If

		moduleState.isStarted = false
	End If

	return true
End Function
</xsl:template>
</xsl:stylesheet>
