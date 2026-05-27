<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<!-- Apply JSON escape sequences to an XML string -->
<xsl:template name="escape-json">
  <xsl:param name="text"/>
  <xsl:choose>

    <xsl:when test="contains($text, '&quot;')">
      <xsl:value-of select="substring-before($text, '&quot;')"/>
      <xsl:text>\"</xsl:text>
      <xsl:call-template name="escape-json">
        <xsl:with-param name="text" select="substring-after($text, '&quot;')"/>
      </xsl:call-template>
    </xsl:when>

    <xsl:when test="contains($text, '\')">
      <xsl:value-of select="substring-before($text, '\')"/>
      <xsl:text>\\</xsl:text>
      <xsl:call-template name="escape-json">
        <xsl:with-param name="text" select="substring-after($text, '\')"/>
      </xsl:call-template>
    </xsl:when>

    <xsl:when test="contains($text, '&#9;')">
      <xsl:value-of select="substring-before($text, '&#9;')"/>
      <xsl:text>\t</xsl:text>
      <xsl:call-template name="escape-json">
        <xsl:with-param name="text" select="substring-after($text, '&#9;')"/>
      </xsl:call-template>
    </xsl:when>

    <xsl:when test="contains($text, '&#10;')">
      <xsl:value-of select="substring-before($text, '&#10;')"/>
      <xsl:text>\n</xsl:text>
      <xsl:call-template name="escape-json">
        <xsl:with-param name="text" select="substring-after($text, '&#10;')"/>
      </xsl:call-template>
    </xsl:when>

    <xsl:when test="contains($text, '&#13;')">
      <xsl:value-of select="substring-before($text, '&#13;')"/>
      <!-- just delete -->
      <xsl:call-template name="escape-json">
        <xsl:with-param name="text" select="substring-after($text, '&#13;')"/>
      </xsl:call-template>
    </xsl:when>

    <xsl:otherwise>
      <xsl:value-of select="$text"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

</xsl:stylesheet>