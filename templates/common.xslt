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


<!-- Output JSON key and list of strings
    "BT158": [
      "1001",
      "1002",
      "1003"
    ],
-->
<xsl:template name="array">
  <xsl:param name="xmltag"/>
  <xsl:param name="jsonkey"/>
  <xsl:param name="indent"/>

  <xsl:if test="$xmltag">
    <xsl:text>&#10;</xsl:text>
    <xsl:value-of select="$indent" />
    <xsl:text>    "</xsl:text>
    <xsl:value-of select="$jsonkey" />
    <xsl:text>": [</xsl:text>
    <xsl:for-each select="$xmltag">
      <xsl:text>&#10;</xsl:text>
      <xsl:value-of select="$indent" />
      <xsl:text>      "</xsl:text>
      <xsl:call-template name="escape-json">
        <xsl:with-param name="text" select="."/>
      </xsl:call-template>
      <xsl:text>"</xsl:text>
      <xsl:if test="position()!=last()">,</xsl:if>
    </xsl:for-each>
    <xsl:text>&#10;</xsl:text>
    <xsl:value-of select="$indent" />
    <xsl:text>    ],</xsl:text>
  </xsl:if>
</xsl:template>


<!-- Output JSON key and object for binary data from CII
    "BT125": {
      "mime": "",
      "filename": "",
      "base64": ""
    },
-->
<xsl:template name="binary_object_CII">
  <xsl:param name="xmltag"/>
  <xsl:param name="jsonkey"/>
  <xsl:param name="indent"/>

  <xsl:if test="$xmltag">
    <xsl:text>&#10;</xsl:text>
    <xsl:value-of select="$indent" />
    <xsl:text>    "</xsl:text>
    <xsl:value-of select="$jsonkey" />
    <xsl:text>": {&#10;</xsl:text>
    <xsl:value-of select="$indent" />
    <xsl:text>      "mime": "</xsl:text>
    <xsl:value-of select="$xmltag/@mimeCode" />
    <xsl:text>",&#10;</xsl:text>
    <xsl:value-of select="$indent" />
    <xsl:text>      "filename": "</xsl:text>
    <xsl:value-of select="$xmltag/@filename" />
    <xsl:text>",&#10;</xsl:text>
    <xsl:value-of select="$indent" />
    <xsl:text>      "base64": "</xsl:text>
    <xsl:value-of select="$xmltag/." />
    <xsl:text>"&#10;</xsl:text>
    <xsl:value-of select="$indent" />
    <xsl:text>    },</xsl:text>
  </xsl:if>
</xsl:template>


<!-- Output JSON key and object for binary data from SMX
    "BT125": {
      "mime": "",
      "filename": "",
      "base64": ""
    },
-->
<xsl:template name="binary_object_SMX">
  <xsl:param name="xmltag"/>
  <xsl:param name="jsonkey"/>
  <xsl:param name="indent"/>

  <xsl:if test="$xmltag">
    <xsl:text>&#10;</xsl:text>
    <xsl:value-of select="$indent" />
    <xsl:text>    "</xsl:text>
    <xsl:value-of select="$jsonkey" />
    <xsl:text>": {&#10;</xsl:text>
    <xsl:value-of select="$indent" />
    <xsl:text>      "mime": "</xsl:text>
    <xsl:value-of select="$xmltag/@mime_code" />
    <xsl:text>",&#10;</xsl:text>
    <xsl:value-of select="$indent" />
    <xsl:text>      "filename": "</xsl:text>
    <xsl:value-of select="$xmltag/@filename" />
    <xsl:text>",&#10;</xsl:text>
    <xsl:value-of select="$indent" />
    <xsl:text>      "base64": "</xsl:text>
    <xsl:value-of select="$xmltag/." />
    <xsl:text>"&#10;</xsl:text>
    <xsl:value-of select="$indent" />
    <xsl:text>    },</xsl:text>
  </xsl:if>
</xsl:template>


<!-- Input: 1999-01-31
     Output JSON key and date object
    "BT002": {
      "YYYY": "1999",
      "MM": "01",
      "DD": "31"
    },
-->
<xsl:template name="date_from_iso8601">
  <xsl:param name="xmltag"/>
  <xsl:param name="jsonkey"/>
  <xsl:param name="indent"/>

  <xsl:if test="$xmltag">
    <xsl:text>&#10;</xsl:text>
    <xsl:value-of select="$indent" />
    <xsl:text>    "</xsl:text>
    <xsl:value-of select="$jsonkey" />
    <xsl:text>": {&#10;</xsl:text>
    <xsl:value-of select="$indent" />
    <xsl:text>      "YYYY": "</xsl:text>
    <xsl:value-of select="substring($xmltag, 1, 4)" />
    <xsl:text>",&#10;</xsl:text>
    <xsl:value-of select="$indent" />
    <xsl:text>      "MM": "</xsl:text>
    <xsl:value-of select="substring($xmltag, 6, 2)" />
    <xsl:text>",&#10;</xsl:text>
    <xsl:value-of select="$indent" />
    <xsl:text>      "DD": "</xsl:text>
    <xsl:value-of select="substring($xmltag, 9, 2)" />
    <xsl:text>"&#10;</xsl:text>
    <xsl:value-of select="$indent" />
    <xsl:text>    },</xsl:text>
  </xsl:if>
</xsl:template>


<!-- Input: 19990131
     Output JSON key and date object
    "BT002": {
      "YYYY": "1999",
      "MM": "01",
      "DD": "31"
    },
-->
<xsl:template name="date_from_CCYYMMDD">
  <xsl:param name="xmltag"/>
  <xsl:param name="jsonkey"/>
  <xsl:param name="indent"/>

  <xsl:if test="$xmltag">
    <xsl:text>&#10;</xsl:text>
    <xsl:value-of select="$indent" />
    <xsl:text>    "</xsl:text>
    <xsl:value-of select="$jsonkey" />
    <xsl:text>": {&#10;</xsl:text>
    <xsl:value-of select="$indent" />
    <xsl:text>      "YYYY": "</xsl:text>
    <xsl:value-of select="substring($xmltag, 1, 4)" />
    <xsl:text>",&#10;</xsl:text>
    <xsl:value-of select="$indent" />
    <xsl:text>      "MM": "</xsl:text>
    <xsl:value-of select="substring($xmltag, 5, 2)" />
    <xsl:text>",&#10;</xsl:text>
    <xsl:value-of select="$indent" />
    <xsl:text>      "DD": "</xsl:text>
    <xsl:value-of select="substring($xmltag, 7, 2)" />
    <xsl:text>"&#10;</xsl:text>
    <xsl:value-of select="$indent" />
    <xsl:text>    },</xsl:text>
  </xsl:if>
</xsl:template>


<!-- Output JSON key and value
    "BT001": "123"
 -->
<xsl:template name="string">
  <xsl:param name="xmltag"/>
  <xsl:param name="jsonkey"/>
  <xsl:param name="indent"/>

  <xsl:if test="$xmltag">
    <xsl:text>&#10;</xsl:text>
    <xsl:value-of select="$indent" />
    <xsl:text>    "</xsl:text>
    <xsl:value-of select="$jsonkey" />
    <xsl:text>": "</xsl:text>
    <xsl:call-template name="escape-json">
      <xsl:with-param name="text" select="$xmltag" />
    </xsl:call-template>
    <xsl:text>",</xsl:text>
  </xsl:if>
</xsl:template>


</xsl:stylesheet>
