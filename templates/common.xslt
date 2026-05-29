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


<xsl:template name="array">
  <xsl:param name="xmltag"/>
  <xsl:param name="bt"/>
  <xsl:param name="indent"/>

  <xsl:if test="$xmltag">
    <xsl:text>&#10;</xsl:text>
    <xsl:value-of select="$indent" />
    <xsl:text>    "</xsl:text>
    <xsl:value-of select="$bt" />
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

<!--
            elif row['Datatype'] == 'B':
                r += f"""
{indent}  <xsl:if test="{xpath}">
{indent}    <xsl:text>&#10;{indent}    "BT{i.zfill(3)}": {{&#10;{indent}      "mime": "</xsl:text>
{indent}    <xsl:value-of select="{xpath}/@mime_code" />
{indent}    <xsl:text>",&#10;{indent}      "filename": "</xsl:text>
{indent}    <xsl:value-of select="{xpath}/@filename" />
{indent}    <xsl:text>",&#10;{indent}      "base64": "</xsl:text>
{indent}    <xsl:value-of select="{xpath}/." />
{indent}    <xsl:text>"&#10;{indent}    }},</xsl:text>
{indent}  </xsl:if>"""
            else:
                r += f"""
{indent}  <xsl:if test="{xpath}">
{indent}    <xsl:text>&#10;{indent}    "BT{i.zfill(3)}": "</xsl:text>
{indent}    <xsl:call-template name="escape-json">
{indent}      <xsl:with-param name="text" select="{xpath}" />
{indent}    </xsl:call-template>
{indent}    <xsl:text>",</xsl:text>
{indent}  </xsl:if>"""

-->


</xsl:stylesheet>