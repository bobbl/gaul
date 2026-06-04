<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
                xmlns:rsm="urn:un:unece:uncefact:data:standard:CrossIndustryInvoice:100"
                xmlns:ram="urn:un:unece:uncefact:data:standard:ReusableAggregateBusinessInformationEntity:100"
                xmlns:qdt="urn:un:unece:uncefact:data:standard:QualifiedDataType:100"
                xmlns:udt="urn:un:unece:uncefact:data:standard:UnqualifiedDataType:100">

<xsl:import href="common.xslt" />
<xsl:output method="text" encoding="utf-8" /> 
<xsl:strip-space elements="*" />


<xsl:template match="rsm:CrossIndustryInvoice">
  <xsl:text>{
  "_meta": {
    "format": "XRechnung Business Terms",
    "version": "0.9",
    "description": "XRechnung invoice condensed to business terms and encoded in JSON"
  },
  "invoice": {
    "BT001": "</xsl:text>
  <xsl:value-of select="rsm:ExchangedDocument/ram:ID" />
  <xsl:text>"</xsl:text>

<!--
  <xsl:if test="">
    <xsl:text>,&#10;    "BT000": "</xsl:text>
    <xsl:value-of select="" />
    <xsl:text>"</xsl:text>
  </xsl:if>
-->

  <xsl:if test="rsm:ExchangedDocument/ram:IssueDateTime/udt:DateTimeString[@format = '102']">
    <xsl:text>,&#10;    "BT002": "</xsl:text>
    <xsl:value-of select="rsm:ExchangedDocument/ram:IssueDateTime/udt:DateTimeString[@format = '102']" />
    <xsl:text>"</xsl:text>
  </xsl:if>
  <xsl:if test="rsm:ExchangedDocument/ram:TypeCode">
    <xsl:text>,&#10;    "BT003": "</xsl:text>
    <xsl:value-of select="rsm:ExchangedDocument/ram:TypeCode" />
    <xsl:text>"</xsl:text>
  </xsl:if>
  <xsl:if test="rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:InvoiceCurrencyCode">
    <xsl:text>,&#10;    "BT005": "</xsl:text>
    <xsl:value-of select="rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:InvoiceCurrencyCode" />
    <xsl:text>"</xsl:text>
  </xsl:if>
  <xsl:if test="rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:TaxCurrencyCode">
    <xsl:text>,&#10;    "BT006": "</xsl:text>
    <xsl:value-of select="rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:TaxCurrencyCode" />
    <xsl:text>"</xsl:text>
  </xsl:if>







  <xsl:text>
  }
}
</xsl:text>
</xsl:template>
</xsl:stylesheet>
