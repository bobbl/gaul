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
  "invoice": {</xsl:text>

  <xsl:call-template name="string">
    <xsl:with-param name="xmltag" select="rsm:ExchangedDocument/ram:ID"/>
    <xsl:with-param name="jsonkey" select="'BT001'"/>
    <xsl:with-param name="indent" select="''"/>
  </xsl:call-template>
  <xsl:call-template name="date_from_CCYYMMDD">
    <xsl:with-param name="xmltag" select="rsm:ExchangedDocument/ram:IssueDateTime/udt:DateTimeString[@format = '102']"/>
    <xsl:with-param name="jsonkey" select="'BT002'"/>
    <xsl:with-param name="indent" select="''"/>
  </xsl:call-template>
  <xsl:call-template name="string">
    <xsl:with-param name="xmltag" select="rsm:ExchangedDocument/ram:TypeCode"/>
    <xsl:with-param name="jsonkey" select="'BT003'"/>
    <xsl:with-param name="indent" select="''"/>
  </xsl:call-template>
  <xsl:call-template name="string">
    <xsl:with-param name="xmltag" select="rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:InvoiceCurrencyCode"/>
    <xsl:with-param name="jsonkey" select="'BT005'"/>
    <xsl:with-param name="indent" select="''"/>
  </xsl:call-template>
  <xsl:call-template name="string">
    <xsl:with-param name="xmltag" select="rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:TaxCurrencyCode"/>
    <xsl:with-param name="jsonkey" select="'BT006'"/>
    <xsl:with-param name="indent" select="''"/>
  </xsl:call-template>
  <xsl:call-template name="date_from_CCYYMMDD">
    <xsl:with-param name="xmltag" select="rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:ApplicableTradeTax[1]/ram:TaxPointDate/udt:DateString[@format = '102']"/>
    <xsl:with-param name="jsonkey" select="'BT007'"/>
    <xsl:with-param name="indent" select="''"/>
  </xsl:call-template>
  <xsl:call-template name="string">
    <xsl:with-param name="xmltag" select="rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:ApplicableTradeTax[1]/ram:DueDateTypeCode"/>
    <xsl:with-param name="jsonkey" select="'BT008'"/>
    <xsl:with-param name="indent" select="''"/>
  </xsl:call-template>
  <xsl:call-template name="date_from_CCYYMMDD">
    <xsl:with-param name="xmltag" select="rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradePaymentTerms/ram:DueDateDateTime/udt:DateTimeString[@format = '102']"/>
    <xsl:with-param name="jsonkey" select="'BT009'"/>
    <xsl:with-param name="indent" select="''"/>
  </xsl:call-template>
  <xsl:call-template name="string">
    <xsl:with-param name="xmltag" select="ram:ApplicableHeaderTradeAgreement/ram:BuyerReference"/>
    <xsl:with-param name="jsonkey" select="'BT010'"/>
    <xsl:with-param name="indent" select="''"/>
  </xsl:call-template>
  <xsl:call-template name="string">
    <xsl:with-param name="xmltag" select="rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SpecifiedProcuringProject/ram:ID"/>
    <xsl:with-param name="jsonkey" select="'BT011'"/>
    <xsl:with-param name="indent" select="''"/>
  </xsl:call-template>
  <xsl:call-template name="string">
    <xsl:with-param name="xmltag" select="rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:ContractReferencedDocument/ram:IssuerAssignedID"/>
    <xsl:with-param name="jsonkey" select="'BT012'"/>
    <xsl:with-param name="indent" select="''"/>
  </xsl:call-template>
  <xsl:call-template name="string">
    <xsl:with-param name="xmltag" select="rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerOrderReferencedDocument/ram:IssuerAssignedID"/>
    <xsl:with-param name="jsonkey" select="'BT013'"/>
    <xsl:with-param name="indent" select="''"/>
  </xsl:call-template>
  <xsl:call-template name="string">
    <xsl:with-param name="xmltag" select="rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerOrderReferencedDocument/ram:IssuerAssignedID"/>
    <xsl:with-param name="jsonkey" select="'BT014'"/>
    <xsl:with-param name="indent" select="''"/>
  </xsl:call-template>
  <xsl:call-template name="string">
    <xsl:with-param name="xmltag" select="rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeDelivery/ram:ReceivingAdviceReferencedDocument/ram:IssuerAssignedID"/>
    <xsl:with-param name="jsonkey" select="'BT015'"/>
    <xsl:with-param name="indent" select="''"/>
  </xsl:call-template>
  <xsl:call-template name="string">
    <xsl:with-param name="xmltag" select="rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeDelivery/ram:DespatchAdviceReferencedDocument/ram:IssuerAssignedID"/>
    <xsl:with-param name="jsonkey" select="'BT016'"/>
    <xsl:with-param name="indent" select="''"/>
  </xsl:call-template>
  <xsl:call-template name="string">
    <xsl:with-param name="xmltag" select="rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:AdditionalReferencedDocument/ram:IssuerAssignedID[following-sibling::ram:TypeCode='50']"/>
    <xsl:with-param name="jsonkey" select="'BT017'"/>
    <xsl:with-param name="indent" select="''"/>
  </xsl:call-template>
  <xsl:call-template name="string">
    <xsl:with-param name="xmltag" select="rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:AdditionalReferencedDocument/ram:IssuerAssignedID[following-sibling::ram:TypeCode='130']"/>
    <xsl:with-param name="jsonkey" select="'BT018'"/>
    <xsl:with-param name="indent" select="''"/>
  </xsl:call-template>
  <xsl:call-template name="string">
    <xsl:with-param name="xmltag" select="rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:ReceivableSpecifiedTradeAccountingAccount/ram:ID"/>
    <xsl:with-param name="jsonkey" select="'BT019'"/>
    <xsl:with-param name="indent" select="''"/>
  </xsl:call-template>
  <xsl:call-template name="string">
    <xsl:with-param name="xmltag" select="rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradePaymentTerms/ram:Description"/>
    <xsl:with-param name="jsonkey" select="'BT020'"/>
    <xsl:with-param name="indent" select="''"/>
  </xsl:call-template>

  <xsl:variable name="bg-1">
    <xsl:for-each select="rsm:ExchangedDocument/ram:IncludedNote">
      <xsl:text>&#10;      {</xsl:text>
      <xsl:call-template name="string">
        <xsl:with-param name="xmltag" select="ram:SubjectCode"/>
        <xsl:with-param name="jsonkey" select="'BT021'"/>
        <xsl:with-param name="indent" select="'    '"/>
      </xsl:call-template>
      <xsl:call-template name="string">
        <xsl:with-param name="xmltag" select="ram:Content"/>
        <xsl:with-param name="jsonkey" select="'BT022'"/>
        <xsl:with-param name="indent" select="'    '"/>
      </xsl:call-template>
      <xsl:text>&#10;      },</xsl:text>
    </xsl:for-each>
  </xsl:variable>
  <xsl:if test="$bg-1">
    <xsl:text>&#10;    "BG001": [</xsl:text>
    <xsl:value-of select="substring($bg-1, 1, string-length($bg-1) - 1)" />
    <xsl:text>&#10;    ],</xsl:text>
  </xsl:if>

  <xsl:variable name="bg-2">
    <xsl:call-template name="string">
      <xsl:with-param name="xmltag" select="rsm:ExchangedDocumentContext/ram:BusinessProcessSpecifiedDocumentContextParameter/ram:ID"/>
      <xsl:with-param name="jsonkey" select="'BT023'"/>
      <xsl:with-param name="indent" select="'  '"/>
    </xsl:call-template>
    <xsl:call-template name="string">
      <xsl:with-param name="xmltag" select="rsm:ExchangedDocumentContext/ram:GuidelineSpecifiedDocumentContextParameter/ram:ID"/>
      <xsl:with-param name="jsonkey" select="'BT024'"/>
      <xsl:with-param name="indent" select="'  '"/>
    </xsl:call-template>
  </xsl:variable>
  <xsl:if test="$bg-2">
    <xsl:text>&#10;    "BG002": {</xsl:text>
    <xsl:value-of select="substring($bg-2, 1, string-length($bg-2) - 1)" />
    <xsl:text>&#10;    },</xsl:text>
  </xsl:if>





  <xsl:text>
  }
}
</xsl:text>
</xsl:template>
</xsl:stylesheet>
