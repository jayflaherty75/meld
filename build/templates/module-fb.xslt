<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">

<xsl:output method="text" indent="no" omit-xml-declaration="yes" />

<xsl:include href="lib/convert-case.xslt" />
<xsl:include href="lib/capitalize.xslt" />
<xsl:include href="lib/acquire-interface-fb.xslt" />
<xsl:include href="lib/warning-message-fb.xslt" />

<xsl:template match="module">
	<xsl:variable name="module" select="@name" />
	<xsl:variable name="namespace" select="namespace" />

	<xsl:call-template name="warningMessage" />
#include once "../../../../../modules/headers/<xsl:value-of select="$module" />/<xsl:value-of select="$module" />-v1.bi"
#include once "<xsl:value-of select="$module" />.bi"

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
		print("**** <xsl:value-of select="namespace" />.load: Invalid Module interface pointer")
		return false
	End If

	If not moduleState.isLoaded Then
		moduleState.references = 0
		moduleState.startups = 0
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
					<xsl:text>print("**** </xsl:text>
					<xsl:value-of select="/module/namespace" />
					<xsl:text>.load: Missing error definition for </xsl:text>
					<xsl:value-of select="@type" />
					<xsl:text>")&#xa;</xsl:text>
					<xsl:text>&#x9;&#x9;&#x9;</xsl:text>
					<xsl:text>Return false&#xa;</xsl:text>
					<xsl:text>&#x9;&#x9;</xsl:text>
					<xsl:text>End If&#xa;&#xa;</xsl:text>
				</xsl:if>
			</xsl:for-each>
		</xsl:if>
	End If

	moduleState.references += 1

	return true
End Function

Function unload cdecl Alias "unload" () As short export
	moduleState.references -= 1

	If moduleState.references &lt;= 0 Then
		moduleState.references = 0
		moduleState.startups = 0
		moduleState.isLoaded = false
	End If

	return moduleState.isLoaded
End Function

<xsl:if test="count(requires[@module='tester']) &gt; 0 or namespace='Tester'">
Function test () As short export
	dim As <xsl:value-of select="namespace" />.Interface ptr interfacePtr = exports()
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
	If moduleState.startups = 0 Then
		If moduleState.methods.startup &lt;&gt; NULL Then
			If not moduleState.methods.startup() Then
				print("**** <xsl:value-of select="namespace" />.startup: Module startup handler failed")
				return false
			<xsl:if test="count(requires[@module='tester']) &gt; 0 or namespace='Tester'">
			ElseIf not test() Then
				' TODO: Remove test from startup and move startup function to
				' end of boilerplate
				print("**** <xsl:value-of select="namespace" />.start: Unit test failed")
				return false
			</xsl:if>
			End If
		End If
	End If

	moduleState.startups += 1

	return true
End Function

Function shutdown cdecl Alias "shutdown" () As short export
	moduleState.startups -= 1

	If moduleState.startups &lt;= 0 Then
		moduleState.startups = 0

		If moduleState.methods.shutdown &lt;&gt; NULL Then
			If not moduleState.methods.shutdown() Then
				print("**** <xsl:value-of select="namespace" />.startup: Module shutdown handler failed")
			End If
		End If
	End If

	return true
End Function
</xsl:template>
</xsl:stylesheet>
