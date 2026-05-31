<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
<!-- Remove comments and pretty print.
     Source: https://stackoverflow.com/a/1465366/10226927 -->

<xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>

<!-- Match on Attributes, Elements, text nodes, and Processing Instructions-->
<xsl:template match="@*| * | text()[normalize-space()!=''] | processing-instruction()">
  <xsl:copy>
    <xsl:apply-templates select="@*|node()"/>
  </xsl:copy>
</xsl:template>

<!-- Empty template prevents comments from being copied into the output -->
<xsl:template match="comment()"/>

<!-- Prevent whitespace only nodes from beeing copied -->
<xsl:template match="text()[normalize-space()='']"/>

</xsl:stylesheet>
