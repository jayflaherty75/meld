<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">

<xsl:output method="text" indent="no" omit-xml-declaration="yes" />

<xsl:template match="module">
	<xsl:variable name="namespace" select="normalize-space(namespace)" />
/**
 * @requires sys_v0.1.0
 * @requires console_v0.1.0
 * @requires fault_v0.1.0
 * @requires tester_v0.1.0
 */

#include "module.h"
#include "<xsl:value-of select="@name" />.h"
#include "errors.h"
#include "test.h"

/**
 * @namespace <xsl:value-of select="$namespace" />
 * @version 0.1.0
 */
namespace <xsl:value-of select="$namespace" /> {

/**
 * Application main routine.
 * @function startup
 * @returns {short}
 */
short startup () {
	_console->logMessage("Starting <xsl:value-of select="@name" /> module");

	return TRUE;
}

/**
 * Application main routine.
 * @function shutdown
 * @returns {short}
 */
short shutdown () {
	_console->logMessage("Shutting down <xsl:value-of select="@name" /> module");

	return TRUE;
}

/**
 * Standard test runner for modules.
 * @function test
 * @param {void *} describeFn
 * @returns {short}
 */
short test (void *describeFn) {
	Tester::describeCallback describePtr = reinterpret_cast&lt;Tester::describeCallback&gt;(describeFn);
	short result = TRUE;

	result = result &amp;&amp; describePtr ("The <xsl:value-of select="$namespace" /> module", testCreate);

	return result;
}

}
</xsl:template>
</xsl:stylesheet>
