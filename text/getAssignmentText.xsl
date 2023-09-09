<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
    version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<xsl:output
method="text"
omit-xml-declaration="yes"
indent="no"/>

<!-- code to suppress unwanted default text node output (from xsl's "hidden" default templates) -->
<!-- <xsl:template match="text()|@*"></xsl:template> -->

<xsl:template match="text()|@*"></xsl:template>

<xsl:template match="/html/body">

  <!-- both <p> and other tags hold text, so match any child nodes of <body> -->
  <xsl:for-each select="./*">
    
    <xsl:value-of select="current()" />
    <xsl:text>&#xa;</xsl:text>

  </xsl:for-each>

  
</xsl:template>


</xsl:stylesheet>
