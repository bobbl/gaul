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

  <xsl:variable name="bg-3">
    <xsl:for-each select="rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:InvoiceReferencedDocument">
      <xsl:text>&#10;      {</xsl:text>
      <xsl:call-template name="string">
        <xsl:with-param name="xmltag" select="ram:IssuerAssignedID"/>
        <xsl:with-param name="jsonkey" select="'BT025'"/>
        <xsl:with-param name="indent" select="'    '"/>
      </xsl:call-template>
      <xsl:call-template name="date_from_CCYYMMDD">
        <xsl:with-param name="xmltag" select="ram:FormattedIssueDateTime/qdt:DateTimeString[@format = '102']"/>
        <xsl:with-param name="jsonkey" select="'BT026'"/>
        <xsl:with-param name="indent" select="'    '"/>
      </xsl:call-template>
      <xsl:text>&#10;      },</xsl:text>
    </xsl:for-each>
  </xsl:variable>
  <xsl:if test="string($bg-3)">
    <xsl:text>&#10;    "BG003": [</xsl:text>
    <xsl:value-of select="substring($bg-3, 1, string-length($bg-3) - 1)" />
    <xsl:text>&#10;    ],</xsl:text>
  </xsl:if>

  <xsl:variable name="bg-4">
    <xsl:for-each select="rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTradeParty">
      <!-- This element appears only once, but use for-each to have shorter XPaths -->
    <xsl:call-template name="string">
      <xsl:with-param name="xmltag" select="ram:Name"/>
      <xsl:with-param name="jsonkey" select="'BT027'"/>
      <xsl:with-param name="indent" select="'  '"/>
    </xsl:call-template>
    <xsl:call-template name="string">
      <xsl:with-param name="xmltag" select="ram:SpecifiedLegalOrganization/ram:TradingBusinessName"/>
      <xsl:with-param name="jsonkey" select="'BT028'"/>
      <xsl:with-param name="indent" select="'  '"/>
    </xsl:call-template>
    <xsl:call-template name="array">
      <xsl:with-param name="xmltag" select="ram:ID"/>
      <xsl:with-param name="jsonkey" select="'BT029'"/>
      <xsl:with-param name="indent" select="'  '"/>
    </xsl:call-template>

    <!-- TODO: also add all ram:GlobalID[exists(@schemeID)] to BT029 -->

    <xsl:call-template name="string">
      <xsl:with-param name="xmltag" select="./ram:SpecifiedLegalOrganization/ram:ID"/>
      <xsl:with-param name="jsonkey" select="'BT030'"/>
      <xsl:with-param name="indent" select="'  '"/>
    </xsl:call-template>
    <xsl:call-template name="string">
      <xsl:with-param name="xmltag" select="ram:SpecifiedTaxRegistration/ram:ID[@schemeID='VA']"/>
      <xsl:with-param name="jsonkey" select="'BT031'"/>
      <xsl:with-param name="indent" select="'  '"/>
    </xsl:call-template>
    <xsl:call-template name="string">
      <xsl:with-param name="xmltag" select="ram:SpecifiedTaxRegistration/ram:ID[@schemeID='FC']"/>
      <xsl:with-param name="jsonkey" select="'BT032'"/>
      <xsl:with-param name="indent" select="'  '"/>
    </xsl:call-template>
    <xsl:call-template name="string">
      <xsl:with-param name="xmltag" select="ram:Description"/>
      <xsl:with-param name="jsonkey" select="'BT033'"/>
      <xsl:with-param name="indent" select="'  '"/>
    </xsl:call-template>
    <xsl:call-template name="string">
      <xsl:with-param name="xmltag" select="ram:URIUniversalCommunication/ram:URIID"/>
      <xsl:with-param name="jsonkey" select="'BT034'"/>
      <xsl:with-param name="indent" select="'  '"/>
    </xsl:call-template>
    <xsl:variable name="bg-5">
      <xsl:call-template name="string">
        <xsl:with-param name="xmltag" select="ram:PostalTradeAddress/ram:LineOne"/>
        <xsl:with-param name="jsonkey" select="'BT035'"/>
        <xsl:with-param name="indent" select="'    '"/>
      </xsl:call-template>
      <xsl:call-template name="string">
        <xsl:with-param name="xmltag" select="ram:PostalTradeAddress/ram:LineTwo"/>
        <xsl:with-param name="jsonkey" select="'BT036'"/>
        <xsl:with-param name="indent" select="'    '"/>
      </xsl:call-template>
      <xsl:call-template name="string">
        <xsl:with-param name="xmltag" select="ram:PostalTradeAddress/ram:LineThree"/>
        <xsl:with-param name="jsonkey" select="'BT162'"/>
        <xsl:with-param name="indent" select="'    '"/>
      </xsl:call-template>
      <xsl:call-template name="string">
        <xsl:with-param name="xmltag" select="ram:PostalTradeAddress/ram:CityName"/>
        <xsl:with-param name="jsonkey" select="'BT037'"/>
        <xsl:with-param name="indent" select="'    '"/>
      </xsl:call-template>
      <xsl:call-template name="string">
        <xsl:with-param name="xmltag" select="ram:PostalTradeAddress/ram:PostcodeCode"/>
        <xsl:with-param name="jsonkey" select="'BT038'"/>
        <xsl:with-param name="indent" select="'    '"/>
      </xsl:call-template>
      <xsl:call-template name="string">
        <xsl:with-param name="xmltag" select="ram:PostalTradeAddress/ram:CountrySubDivisionName"/>
        <xsl:with-param name="jsonkey" select="'BT039'"/>
        <xsl:with-param name="indent" select="'    '"/>
      </xsl:call-template>
      <xsl:call-template name="string">
        <xsl:with-param name="xmltag" select="ram:PostalTradeAddress/ram:CountryID"/>
        <xsl:with-param name="jsonkey" select="'BT040'"/>
        <xsl:with-param name="indent" select="'    '"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:if test="string($bg-5)">
      <xsl:text>&#10;      "BG005": {</xsl:text>
      <xsl:value-of select="substring($bg-5, 1, string-length($bg-5) - 1)" />
      <xsl:text>&#10;      },</xsl:text>
    </xsl:if>

    <xsl:variable name="bg-6">
      <!-- BT-41 is 1..1 => in a valid CII there is either PersonName or DepartmentName -->
      <xsl:call-template name="string">
        <xsl:with-param name="xmltag" select="ram:DefinedTradeContact/ram:PersonName"/>
        <xsl:with-param name="jsonkey" select="'BT041'"/>
        <xsl:with-param name="indent" select="'    '"/>
      </xsl:call-template>
      <xsl:call-template name="string">
        <xsl:with-param name="xmltag" select="ram:DefinedTradeContact/ram:DepartmentName"/>
        <xsl:with-param name="jsonkey" select="'BT041'"/>
        <xsl:with-param name="indent" select="'    '"/>
      </xsl:call-template>
      <xsl:call-template name="string">
        <xsl:with-param name="xmltag" select="ram:DefinedTradeContact/ram:TelephoneUniversalCommunication/ram:CompleteNumber"/>
        <xsl:with-param name="jsonkey" select="'BT042'"/>
        <xsl:with-param name="indent" select="'    '"/>
      </xsl:call-template>
      <xsl:call-template name="string">
        <xsl:with-param name="xmltag" select="ram:DefinedTradeContact/ram:EmailURIUniversalCommunication/ram:URIID"/>
        <xsl:with-param name="jsonkey" select="'BT043'"/>
        <xsl:with-param name="indent" select="'    '"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:if test="string($bg-6)">
      <xsl:text>&#10;      "BG006": {</xsl:text>
      <xsl:value-of select="substring($bg-6, 1, string-length($bg-6) - 1)" />
      <xsl:text>&#10;      },</xsl:text>
    </xsl:if>
    </xsl:for-each>
  </xsl:variable>
  <xsl:if test="string($bg-4)">
    <xsl:text>&#10;    "BG004": {</xsl:text>
    <xsl:value-of select="substring($bg-4, 1, string-length($bg-4) - 1)" />
    <xsl:text>&#10;    },</xsl:text>
  </xsl:if>

  <xsl:variable name="bg-7">
    <xsl:for-each select="rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerTradeParty">
      <!-- This element appears only once, but use for-each to have shorter XPaths -->
    <xsl:call-template name="string">
      <xsl:with-param name="xmltag" select="ram:Name"/>
      <xsl:with-param name="jsonkey" select="'BT044'"/>
      <xsl:with-param name="indent" select="'  '"/>
    </xsl:call-template>
    <xsl:call-template name="string">
      <xsl:with-param name="xmltag" select="ram:SpecifiedLegalOrganization/ram:TradingBusinessName"/>
      <xsl:with-param name="jsonkey" select="'BT045'"/>
      <xsl:with-param name="indent" select="'  '"/>
    </xsl:call-template>

    <!-- BT-46 is 0..1 => in a valid CII at most one of ID or GlobalID is present -->
    <xsl:call-template name="string">
      <xsl:with-param name="xmltag" select="ram:ID"/>
      <xsl:with-param name="jsonkey" select="'BT046'"/>
      <xsl:with-param name="indent" select="'  '"/>
    </xsl:call-template>
    <xsl:call-template name="string">
      <xsl:with-param name="xmltag" select="ram:GlobalID[exists(@schemeID)]"/>
      <xsl:with-param name="jsonkey" select="'BT046'"/>
      <xsl:with-param name="indent" select="'  '"/>
    </xsl:call-template>

    <xsl:call-template name="string">
      <xsl:with-param name="xmltag" select="ram:SpecifiedLegalOrganization/ram:ID"/>
      <xsl:with-param name="jsonkey" select="'BT047'"/>
      <xsl:with-param name="indent" select="'  '"/>
    </xsl:call-template>
    <xsl:call-template name="string">
      <xsl:with-param name="xmltag" select="ram:SpecifiedTaxRegistration/ram:ID[@schemeID='VA' or @schemeID='VAT']"/>
      <xsl:with-param name="jsonkey" select="'BT048'"/>
      <xsl:with-param name="indent" select="'  '"/>
    </xsl:call-template>
    <xsl:call-template name="string">
      <xsl:with-param name="xmltag" select="ram:URIUniversalCommunication/ram:URIID"/>
      <xsl:with-param name="jsonkey" select="'BT049'"/>
      <xsl:with-param name="indent" select="'  '"/>
    </xsl:call-template>
    <xsl:variable name="bg-8">
      <xsl:call-template name="string">
        <xsl:with-param name="xmltag" select="ram:PostalTradeAddress/ram:LineOne"/>
        <xsl:with-param name="jsonkey" select="'BT050'"/>
        <xsl:with-param name="indent" select="'    '"/>
      </xsl:call-template>
      <xsl:call-template name="string">
        <xsl:with-param name="xmltag" select="ram:PostalTradeAddress/ram:LineTwo"/>
        <xsl:with-param name="jsonkey" select="'BT051'"/>
        <xsl:with-param name="indent" select="'    '"/>
      </xsl:call-template>
      <xsl:call-template name="string">
        <xsl:with-param name="xmltag" select="ram:PostalTradeAddress/ram:LineThree"/>
        <xsl:with-param name="jsonkey" select="'BT163'"/>
        <xsl:with-param name="indent" select="'    '"/>
      </xsl:call-template>
      <xsl:call-template name="string">
        <xsl:with-param name="xmltag" select="ram:PostalTradeAddress/ram:CityName"/>
        <xsl:with-param name="jsonkey" select="'BT052'"/>
        <xsl:with-param name="indent" select="'    '"/>
      </xsl:call-template>
      <xsl:call-template name="string">
        <xsl:with-param name="xmltag" select="ram:PostalTradeAddress/ram:PostcodeCode"/>
        <xsl:with-param name="jsonkey" select="'BT053'"/>
        <xsl:with-param name="indent" select="'    '"/>
      </xsl:call-template>
      <xsl:call-template name="string">
        <xsl:with-param name="xmltag" select="ram:PostalTradeAddress/ram:CountrySubDivisionName"/>
        <xsl:with-param name="jsonkey" select="'BT054'"/>
        <xsl:with-param name="indent" select="'    '"/>
      </xsl:call-template>
      <xsl:call-template name="string">
        <xsl:with-param name="xmltag" select="ram:PostalTradeAddress/ram:CountryID"/>
        <xsl:with-param name="jsonkey" select="'BT055'"/>
        <xsl:with-param name="indent" select="'    '"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:if test="string($bg-8)">
      <xsl:text>&#10;      "BG008": {</xsl:text>
      <xsl:value-of select="substring($bg-8, 1, string-length($bg-8) - 1)" />
      <xsl:text>&#10;      },</xsl:text>
    </xsl:if>
    <xsl:variable name="bg-9">

      <!-- BT-56 is 0..1 => in a valid CII at most one of PersonName or DepartmentName is present -->
      <xsl:call-template name="string">
        <xsl:with-param name="xmltag" select="ram:DefinedTradeContact/ram:PersonName"/>
        <xsl:with-param name="jsonkey" select="'BT056'"/>
        <xsl:with-param name="indent" select="'    '"/>
      </xsl:call-template>
      <xsl:call-template name="string">
        <xsl:with-param name="xmltag" select="ram:DefinedTradeContact/ram:DepartmentName"/>
        <xsl:with-param name="jsonkey" select="'BT056'"/>
        <xsl:with-param name="indent" select="'    '"/>
      </xsl:call-template>

      <xsl:call-template name="string">
        <xsl:with-param name="xmltag" select="ram:DefinedTradeContact/ram:TelephoneUniversalCommunication/ram:CompleteNumber"/>
        <xsl:with-param name="jsonkey" select="'BT057'"/>
        <xsl:with-param name="indent" select="'    '"/>
      </xsl:call-template>
      <xsl:call-template name="string">
        <xsl:with-param name="xmltag" select="ram:DefinedTradeContact/ram:EmailURIUniversalCommunication/ram:URIID"/>
        <xsl:with-param name="jsonkey" select="'BT058'"/>
        <xsl:with-param name="indent" select="'    '"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:if test="string($bg-9)">
      <xsl:text>&#10;      "BG009": {</xsl:text>
      <xsl:value-of select="substring($bg-9, 1, string-length($bg-9) - 1)" />
      <xsl:text>&#10;      },</xsl:text>
    </xsl:if>
    </xsl:for-each>
  </xsl:variable>
  <xsl:if test="string($bg-7)">
    <xsl:text>&#10;    "BG007": {</xsl:text>
    <xsl:value-of select="substring($bg-7, 1, string-length($bg-7) - 1)" />
    <xsl:text>&#10;    },</xsl:text>
  </xsl:if>

  <xsl:variable name="bg-10">
    <xsl:call-template name="string">
      <xsl:with-param name="xmltag" select="rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:PayeeTradeParty/ram:Name"/>
      <xsl:with-param name="jsonkey" select="'BT059'"/>
      <xsl:with-param name="indent" select="'  '"/>
    </xsl:call-template>

    <!-- BT-60 is 0..1 => in a valid CII at most one of ID or GlobalID is present -->
    <xsl:call-template name="string">
      <xsl:with-param name="xmltag" select="rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:PayeeTradeParty/ram:ID"/>
      <xsl:with-param name="jsonkey" select="'BT060'"/>
      <xsl:with-param name="indent" select="'  '"/>
    </xsl:call-template>
    <xsl:call-template name="string">
      <xsl:with-param name="xmltag" select="rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:PayeeTradeParty/ram:ID"/>
      <xsl:with-param name="jsonkey" select="'BT060'"/>
      <xsl:with-param name="indent" select="'  '"/>
    </xsl:call-template>

    <xsl:call-template name="string">
      <xsl:with-param name="xmltag" select="rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:PayeeTradeParty/ram:SpecifiedLegalOrganization/ram:ID"/>
      <xsl:with-param name="jsonkey" select="'BT061'"/>
      <xsl:with-param name="indent" select="'  '"/>
    </xsl:call-template>
  </xsl:variable>
  <xsl:if test="string($bg-10)">
    <xsl:text>&#10;    "BG010": {</xsl:text>
    <xsl:value-of select="substring($bg-10, 1, string-length($bg-10) - 1)" />
    <xsl:text>&#10;    },</xsl:text>
  </xsl:if>

  <xsl:variable name="bg-11">
    <xsl:for-each select="rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTaxRepresentativeTradeParty">
      <!-- This element appears only once, but use for-each to have shorter XPaths -->
    <xsl:call-template name="string">
      <xsl:with-param name="xmltag" select="ram:Name"/>
      <xsl:with-param name="jsonkey" select="'BT062'"/>
      <xsl:with-param name="indent" select="'  '"/>
    </xsl:call-template>
    <xsl:call-template name="string">
      <xsl:with-param name="xmltag" select="ram:SpecifiedTaxRegistration/ram:ID"/>
      <xsl:with-param name="jsonkey" select="'BT063'"/>
      <xsl:with-param name="indent" select="'  '"/>
    </xsl:call-template>
    <xsl:variable name="bg-12">
      <xsl:call-template name="string">
        <xsl:with-param name="xmltag" select="ram:PostalTradeAddress/ram:LineOne"/>
        <xsl:with-param name="jsonkey" select="'BT064'"/>
        <xsl:with-param name="indent" select="'    '"/>
      </xsl:call-template>
      <xsl:call-template name="string">
        <xsl:with-param name="xmltag" select="ram:PostalTradeAddress/ram:LineTwo"/>
        <xsl:with-param name="jsonkey" select="'BT065'"/>
        <xsl:with-param name="indent" select="'    '"/>
      </xsl:call-template>
      <xsl:call-template name="string">
        <xsl:with-param name="xmltag" select="ram:PostalTradeAddress/ram:LineThree"/>
        <xsl:with-param name="jsonkey" select="'BT164'"/>
        <xsl:with-param name="indent" select="'    '"/>
      </xsl:call-template>
      <xsl:call-template name="string">
        <xsl:with-param name="xmltag" select="ram:PostalTradeAddress/ram:CityName"/>
        <xsl:with-param name="jsonkey" select="'BT066'"/>
        <xsl:with-param name="indent" select="'    '"/>
      </xsl:call-template>
      <xsl:call-template name="string">
        <xsl:with-param name="xmltag" select="ram:PostalTradeAddress/ram:PostcodeCode"/>
        <xsl:with-param name="jsonkey" select="'BT067'"/>
        <xsl:with-param name="indent" select="'    '"/>
      </xsl:call-template>
      <xsl:call-template name="string">
        <xsl:with-param name="xmltag" select="ram:PostalTradeAddress/ram:CountrySubDivisionName"/>
        <xsl:with-param name="jsonkey" select="'BT068'"/>
        <xsl:with-param name="indent" select="'    '"/>
      </xsl:call-template>
      <xsl:call-template name="string">
        <xsl:with-param name="xmltag" select="ram:PostalTradeAddress/ram:CountryID"/>
        <xsl:with-param name="jsonkey" select="'BT069'"/>
        <xsl:with-param name="indent" select="'    '"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:if test="string($bg-12)">
      <xsl:text>&#10;      "BG012": {</xsl:text>
      <xsl:value-of select="substring($bg-12, 1, string-length($bg-12) - 1)" />
      <xsl:text>&#10;      },</xsl:text>
    </xsl:if>
    </xsl:for-each>
  </xsl:variable>
  <xsl:if test="string($bg-11)">
    <xsl:text>&#10;    "BG011": {</xsl:text>
    <xsl:value-of select="substring($bg-11, 1, string-length($bg-11) - 1)" />
    <xsl:text>&#10;    },</xsl:text>
  </xsl:if>

  <xsl:variable name="bg-13">
    <xsl:call-template name="string">
      <xsl:with-param name="xmltag" select="ram:Name"/>
      <xsl:with-param name="jsonkey" select="'BT070'"/>
      <xsl:with-param name="indent" select="'  '"/>
    </xsl:call-template>

    <!-- BT-71 is 0..1 => in a valid CII at most one of ID or GlobalID is present -->
    <xsl:call-template name="string">
      <xsl:with-param name="xmltag" select="rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeDelivery/ram:ShipToTradeParty/ram:ID"/>
      <xsl:with-param name="jsonkey" select="'BT071'"/>
      <xsl:with-param name="indent" select="'  '"/>
    </xsl:call-template>
    <xsl:call-template name="string">
      <xsl:with-param name="xmltag" select="rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeDelivery/ram:ShipToTradeParty/ram:GlobalID[exists(@schemeID)]"/>
      <xsl:with-param name="jsonkey" select="'BT071'"/>
      <xsl:with-param name="indent" select="'  '"/>
    </xsl:call-template>

    <xsl:call-template name="date_from_CCYYMMDD">
      <xsl:with-param name="xmltag" select="rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeDelivery/ram:ActualDeliverySupplyChainEvent/ram:OccurrenceDateTime/udt:DateTimeString[@format = '102']"/>
      <xsl:with-param name="jsonkey" select="'BT072'"/>
      <xsl:with-param name="indent" select="'  '"/>
    </xsl:call-template>
    <xsl:variable name="bg-14">
      <xsl:call-template name="date_from_CCYYMMDD">
        <xsl:with-param name="xmltag" select="rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:BillingSpecifiedPeriod/ram:StartDateTime/udt:DateTimeString[@format = '102']"/>
        <xsl:with-param name="jsonkey" select="'BT073'"/>
        <xsl:with-param name="indent" select="'    '"/>
      </xsl:call-template>
      <xsl:call-template name="date_from_CCYYMMDD">
        <xsl:with-param name="xmltag" select="rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:BillingSpecifiedPeriod/ram:EndDateTime/udt:DateTimeString[@format = '102']"/>
        <xsl:with-param name="jsonkey" select="'BT074'"/>
        <xsl:with-param name="indent" select="'    '"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:if test="string($bg-14)">
      <xsl:text>&#10;      "BG014": {</xsl:text>
      <xsl:value-of select="substring($bg-14, 1, string-length($bg-14) - 1)" />
      <xsl:text>&#10;      },</xsl:text>
    </xsl:if>

    <xsl:variable name="bg-15">
      <xsl:for-each select="rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeDelivery/ram:ShipToTradeParty/ram:PostalTradeAddress">
      <!-- This element appears only once, but use for-each to have shorter XPaths -->
      <xsl:call-template name="string">
        <xsl:with-param name="xmltag" select="ram:LineOne"/>
        <xsl:with-param name="jsonkey" select="'BT075'"/>
        <xsl:with-param name="indent" select="'    '"/>
      </xsl:call-template>
      <xsl:call-template name="string">
        <xsl:with-param name="xmltag" select="ram:LineTwo"/>
        <xsl:with-param name="jsonkey" select="'BT076'"/>
        <xsl:with-param name="indent" select="'    '"/>
      </xsl:call-template>
      <xsl:call-template name="string">
        <xsl:with-param name="xmltag" select="ram:LineThree"/>
        <xsl:with-param name="jsonkey" select="'BT165'"/>
        <xsl:with-param name="indent" select="'    '"/>
      </xsl:call-template>
      <xsl:call-template name="string">
        <xsl:with-param name="xmltag" select="ram:CityName"/>
        <xsl:with-param name="jsonkey" select="'BT077'"/>
        <xsl:with-param name="indent" select="'    '"/>
      </xsl:call-template>
      <xsl:call-template name="string">
        <xsl:with-param name="xmltag" select="ram:PostcodeCode"/>
        <xsl:with-param name="jsonkey" select="'BT078'"/>
        <xsl:with-param name="indent" select="'    '"/>
      </xsl:call-template>
      <xsl:call-template name="string">
        <xsl:with-param name="xmltag" select="ram:CountrySubDivisionName"/>
        <xsl:with-param name="jsonkey" select="'BT079'"/>
        <xsl:with-param name="indent" select="'    '"/>
      </xsl:call-template>
      <xsl:call-template name="string">
        <xsl:with-param name="xmltag" select="ram:CountryID"/>
        <xsl:with-param name="jsonkey" select="'BT080'"/>
        <xsl:with-param name="indent" select="'    '"/>
      </xsl:call-template>
      </xsl:for-each>
    </xsl:variable>
    <xsl:if test="string($bg-15)">
      <xsl:text>&#10;      "BG015": {</xsl:text>
      <xsl:value-of select="substring($bg-15, 1, string-length($bg-15) - 1)" />
      <xsl:text>&#10;      },</xsl:text>
    </xsl:if>
  </xsl:variable>
  <xsl:if test="string($bg-13)">
    <xsl:text>&#10;    "BG013": {</xsl:text>
    <xsl:value-of select="substring($bg-13, 1, string-length($bg-13) - 1)" />
    <xsl:text>&#10;    },</xsl:text>
  </xsl:if>

<!--
  <xsl:variable name="bg-16">
    <xsl:call-template name="string">
      <xsl:with-param name="xmltag" select="xr:PAYMENT_INSTRUCTIONS/xr:Payment_means_type_code"/>
      <xsl:with-param name="jsonkey" select="'BT081'"/>
      <xsl:with-param name="indent" select="'  '"/>
    </xsl:call-template>
    <xsl:call-template name="string">
      <xsl:with-param name="xmltag" select="xr:PAYMENT_INSTRUCTIONS/xr:Payment_means_text"/>
      <xsl:with-param name="jsonkey" select="'BT082'"/>
      <xsl:with-param name="indent" select="'  '"/>
    </xsl:call-template>
    <xsl:call-template name="string">
      <xsl:with-param name="xmltag" select="xr:PAYMENT_INSTRUCTIONS/xr:Remittance_information"/>
      <xsl:with-param name="jsonkey" select="'BT083'"/>
      <xsl:with-param name="indent" select="'  '"/>
    </xsl:call-template>
    <xsl:variable name="bg-17">
      <xsl:for-each select="xr:PAYMENT_INSTRUCTIONS/xr:CREDIT_TRANSFER">
        <xsl:text>&#10;        {</xsl:text>
        <xsl:call-template name="string">
          <xsl:with-param name="xmltag" select="xr:Payment_account_identifier"/>
          <xsl:with-param name="jsonkey" select="'BT084'"/>
          <xsl:with-param name="indent" select="'      '"/>
        </xsl:call-template>
        <xsl:call-template name="string">
          <xsl:with-param name="xmltag" select="xr:Payment_account_name"/>
          <xsl:with-param name="jsonkey" select="'BT085'"/>
          <xsl:with-param name="indent" select="'      '"/>
        </xsl:call-template>
        <xsl:call-template name="string">
          <xsl:with-param name="xmltag" select="xr:Payment_service_provider_identifier"/>
          <xsl:with-param name="jsonkey" select="'BT086'"/>
          <xsl:with-param name="indent" select="'      '"/>
        </xsl:call-template>
        <xsl:text>&#10;        },</xsl:text>
      </xsl:for-each>
    </xsl:variable>
    <xsl:if test="string($bg-17)">
      <xsl:text>&#10;      "BG017": [</xsl:text>
      <xsl:value-of select="substring($bg-17, 1, string-length($bg-17) - 1)" />
      <xsl:text>&#10;      ],</xsl:text>
    </xsl:if>

    <xsl:variable name="bg-18">
      <xsl:call-template name="string">
        <xsl:with-param name="xmltag" select="xr:PAYMENT_INSTRUCTIONS/xr:PAYMENT_CARD_INFORMATION/xr:Payment_card_primary_account_number"/>
        <xsl:with-param name="jsonkey" select="'BT087'"/>
        <xsl:with-param name="indent" select="'    '"/>
      </xsl:call-template>
      <xsl:call-template name="string">
        <xsl:with-param name="xmltag" select="xr:PAYMENT_INSTRUCTIONS/xr:PAYMENT_CARD_INFORMATION/xr:Payment_card_holder_name"/>
        <xsl:with-param name="jsonkey" select="'BT088'"/>
        <xsl:with-param name="indent" select="'    '"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:if test="string($bg-18)">
      <xsl:text>&#10;      "BG018": {</xsl:text>
      <xsl:value-of select="substring($bg-18, 1, string-length($bg-18) - 1)" />
      <xsl:text>&#10;      },</xsl:text>
    </xsl:if>

    <xsl:variable name="bg-19">
      <xsl:call-template name="string">
        <xsl:with-param name="xmltag" select="xr:PAYMENT_INSTRUCTIONS/xr:DIRECT_DEBIT/xr:Mandate_reference_identifier"/>
        <xsl:with-param name="jsonkey" select="'BT089'"/>
        <xsl:with-param name="indent" select="'    '"/>
      </xsl:call-template>
      <xsl:call-template name="string">
        <xsl:with-param name="xmltag" select="xr:PAYMENT_INSTRUCTIONS/xr:DIRECT_DEBIT/xr:Bank_assigned_creditor_identifier"/>
        <xsl:with-param name="jsonkey" select="'BT090'"/>
        <xsl:with-param name="indent" select="'    '"/>
      </xsl:call-template>
      <xsl:call-template name="string">
        <xsl:with-param name="xmltag" select="xr:PAYMENT_INSTRUCTIONS/xr:DIRECT_DEBIT/xr:Debited_account_identifier"/>
        <xsl:with-param name="jsonkey" select="'BT091'"/>
        <xsl:with-param name="indent" select="'    '"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:if test="string($bg-19)">
      <xsl:text>&#10;      "BG019": {</xsl:text>
      <xsl:value-of select="substring($bg-19, 1, string-length($bg-19) - 1)" />
      <xsl:text>&#10;      },</xsl:text>
    </xsl:if>

  </xsl:variable>
  <xsl:if test="string($bg-16)">
    <xsl:text>&#10;    "BG016": {</xsl:text>
    <xsl:value-of select="substring($bg-16, 1, string-length($bg-16) - 1)" />
    <xsl:text>&#10;    },</xsl:text>
  </xsl:if>

  <xsl:variable name="bg-20">
    <xsl:for-each select="xr:DOCUMENT_LEVEL_ALLOWANCES">
      <xsl:text>&#10;      {</xsl:text>
      <xsl:call-template name="string">
        <xsl:with-param name="xmltag" select="xr:Document_level_allowance_amount"/>
        <xsl:with-param name="jsonkey" select="'BT092'"/>
        <xsl:with-param name="indent" select="'    '"/>
      </xsl:call-template>
      <xsl:call-template name="string">
        <xsl:with-param name="xmltag" select="xr:Document_level_allowance_base_amount"/>
        <xsl:with-param name="jsonkey" select="'BT093'"/>
        <xsl:with-param name="indent" select="'    '"/>
      </xsl:call-template>
      <xsl:call-template name="string">
        <xsl:with-param name="xmltag" select="xr:Document_level_allowance_percentage"/>
        <xsl:with-param name="jsonkey" select="'BT094'"/>
        <xsl:with-param name="indent" select="'    '"/>
      </xsl:call-template>
      <xsl:call-template name="string">
        <xsl:with-param name="xmltag" select="xr:Document_level_allowance_VAT_category_code"/>
        <xsl:with-param name="jsonkey" select="'BT095'"/>
        <xsl:with-param name="indent" select="'    '"/>
      </xsl:call-template>
      <xsl:call-template name="string">
        <xsl:with-param name="xmltag" select="xr:Document_level_allowance_VAT_rate"/>
        <xsl:with-param name="jsonkey" select="'BT096'"/>
        <xsl:with-param name="indent" select="'    '"/>
      </xsl:call-template>
      <xsl:call-template name="string">
        <xsl:with-param name="xmltag" select="xr:Document_level_allowance_reason"/>
        <xsl:with-param name="jsonkey" select="'BT097'"/>
        <xsl:with-param name="indent" select="'    '"/>
      </xsl:call-template>
      <xsl:call-template name="string">
        <xsl:with-param name="xmltag" select="xr:Document_level_allowance_reason_code"/>
        <xsl:with-param name="jsonkey" select="'BT098'"/>
        <xsl:with-param name="indent" select="'    '"/>
      </xsl:call-template>
      <xsl:text>&#10;      },</xsl:text>
    </xsl:for-each>
  </xsl:variable>
  <xsl:if test="string($bg-20)">
    <xsl:text>&#10;    "BG020": [</xsl:text>
    <xsl:value-of select="substring($bg-20, 1, string-length($bg-20) - 1)" />
    <xsl:text>&#10;    ],</xsl:text>
  </xsl:if>

  <xsl:variable name="bg-21">
    <xsl:for-each select="xr:DOCUMENT_LEVEL_CHARGES">
      <xsl:text>&#10;      {</xsl:text>
      <xsl:call-template name="string">
        <xsl:with-param name="xmltag" select="xr:Document_level_charge_amount"/>
        <xsl:with-param name="jsonkey" select="'BT099'"/>
        <xsl:with-param name="indent" select="'    '"/>
      </xsl:call-template>
      <xsl:call-template name="string">
        <xsl:with-param name="xmltag" select="xr:Document_level_charge_base_amount"/>
        <xsl:with-param name="jsonkey" select="'BT100'"/>
        <xsl:with-param name="indent" select="'    '"/>
      </xsl:call-template>
      <xsl:call-template name="string">
        <xsl:with-param name="xmltag" select="xr:Document_level_charge_percentage"/>
        <xsl:with-param name="jsonkey" select="'BT101'"/>
        <xsl:with-param name="indent" select="'    '"/>
      </xsl:call-template>
      <xsl:call-template name="string">
        <xsl:with-param name="xmltag" select="xr:Document_level_charge_VAT_category_code"/>
        <xsl:with-param name="jsonkey" select="'BT102'"/>
        <xsl:with-param name="indent" select="'    '"/>
      </xsl:call-template>
      <xsl:call-template name="string">
        <xsl:with-param name="xmltag" select="xr:Document_level_charge_VAT_rate"/>
        <xsl:with-param name="jsonkey" select="'BT103'"/>
        <xsl:with-param name="indent" select="'    '"/>
      </xsl:call-template>
      <xsl:call-template name="string">
        <xsl:with-param name="xmltag" select="xr:Document_level_charge_reason"/>
        <xsl:with-param name="jsonkey" select="'BT104'"/>
        <xsl:with-param name="indent" select="'    '"/>
      </xsl:call-template>
      <xsl:call-template name="string">
        <xsl:with-param name="xmltag" select="xr:Document_level_charge_reason_code"/>
        <xsl:with-param name="jsonkey" select="'BT105'"/>
        <xsl:with-param name="indent" select="'    '"/>
      </xsl:call-template>
      <xsl:text>&#10;      },</xsl:text>
    </xsl:for-each>
  </xsl:variable>
  <xsl:if test="string($bg-21)">
    <xsl:text>&#10;    "BG021": [</xsl:text>
    <xsl:value-of select="substring($bg-21, 1, string-length($bg-21) - 1)" />
    <xsl:text>&#10;    ],</xsl:text>
  </xsl:if>

  <xsl:variable name="bg-22">
    <xsl:call-template name="string">
      <xsl:with-param name="xmltag" select="xr:DOCUMENT_TOTALS/xr:Sum_of_Invoice_line_net_amount"/>
      <xsl:with-param name="jsonkey" select="'BT106'"/>
      <xsl:with-param name="indent" select="'  '"/>
    </xsl:call-template>
    <xsl:call-template name="string">
      <xsl:with-param name="xmltag" select="xr:DOCUMENT_TOTALS/xr:Sum_of_allowances_on_document_level"/>
      <xsl:with-param name="jsonkey" select="'BT107'"/>
      <xsl:with-param name="indent" select="'  '"/>
    </xsl:call-template>
    <xsl:call-template name="string">
      <xsl:with-param name="xmltag" select="xr:DOCUMENT_TOTALS/xr:Sum_of_charges_on_document_level"/>
      <xsl:with-param name="jsonkey" select="'BT108'"/>
      <xsl:with-param name="indent" select="'  '"/>
    </xsl:call-template>
    <xsl:call-template name="string">
      <xsl:with-param name="xmltag" select="xr:DOCUMENT_TOTALS/xr:Invoice_total_amount_without_VAT"/>
      <xsl:with-param name="jsonkey" select="'BT109'"/>
      <xsl:with-param name="indent" select="'  '"/>
    </xsl:call-template>
    <xsl:call-template name="string">
      <xsl:with-param name="xmltag" select="xr:DOCUMENT_TOTALS/xr:Invoice_total_VAT_amount"/>
      <xsl:with-param name="jsonkey" select="'BT110'"/>
      <xsl:with-param name="indent" select="'  '"/>
    </xsl:call-template>
    <xsl:call-template name="string">
      <xsl:with-param name="xmltag" select="xr:DOCUMENT_TOTALS/xr:Invoice_total_VAT_amount_in_accounting_currency"/>
      <xsl:with-param name="jsonkey" select="'BT111'"/>
      <xsl:with-param name="indent" select="'  '"/>
    </xsl:call-template>
    <xsl:call-template name="string">
      <xsl:with-param name="xmltag" select="xr:DOCUMENT_TOTALS/xr:Invoice_total_amount_with_VAT"/>
      <xsl:with-param name="jsonkey" select="'BT112'"/>
      <xsl:with-param name="indent" select="'  '"/>
    </xsl:call-template>
    <xsl:call-template name="string">
      <xsl:with-param name="xmltag" select="xr:DOCUMENT_TOTALS/xr:Paid_amount"/>
      <xsl:with-param name="jsonkey" select="'BT113'"/>
      <xsl:with-param name="indent" select="'  '"/>
    </xsl:call-template>
    <xsl:call-template name="string">
      <xsl:with-param name="xmltag" select="xr:DOCUMENT_TOTALS/xr:Rounding_amount"/>
      <xsl:with-param name="jsonkey" select="'BT114'"/>
      <xsl:with-param name="indent" select="'  '"/>
    </xsl:call-template>
    <xsl:call-template name="string">
      <xsl:with-param name="xmltag" select="xr:DOCUMENT_TOTALS/xr:Amount_due_for_payment"/>
      <xsl:with-param name="jsonkey" select="'BT115'"/>
      <xsl:with-param name="indent" select="'  '"/>
    </xsl:call-template>
  </xsl:variable>
  <xsl:if test="string($bg-22)">
    <xsl:text>&#10;    "BG022": {</xsl:text>
    <xsl:value-of select="substring($bg-22, 1, string-length($bg-22) - 1)" />
    <xsl:text>&#10;    },</xsl:text>
  </xsl:if>

  <xsl:variable name="bg-23">
    <xsl:for-each select="xr:VAT_BREAKDOWN">
      <xsl:text>&#10;      {</xsl:text>
      <xsl:call-template name="string">
        <xsl:with-param name="xmltag" select="xr:VAT_category_taxable_amount"/>
        <xsl:with-param name="jsonkey" select="'BT116'"/>
        <xsl:with-param name="indent" select="'    '"/>
      </xsl:call-template>
      <xsl:call-template name="string">
        <xsl:with-param name="xmltag" select="xr:VAT_category_tax_amount"/>
        <xsl:with-param name="jsonkey" select="'BT117'"/>
        <xsl:with-param name="indent" select="'    '"/>
      </xsl:call-template>
      <xsl:call-template name="string">
        <xsl:with-param name="xmltag" select="xr:VAT_category_code"/>
        <xsl:with-param name="jsonkey" select="'BT118'"/>
        <xsl:with-param name="indent" select="'    '"/>
      </xsl:call-template>
      <xsl:call-template name="string">
        <xsl:with-param name="xmltag" select="xr:VAT_category_rate"/>
        <xsl:with-param name="jsonkey" select="'BT119'"/>
        <xsl:with-param name="indent" select="'    '"/>
      </xsl:call-template>
      <xsl:call-template name="string">
        <xsl:with-param name="xmltag" select="xr:VAT_exemption_reason_text"/>
        <xsl:with-param name="jsonkey" select="'BT120'"/>
        <xsl:with-param name="indent" select="'    '"/>
      </xsl:call-template>
      <xsl:call-template name="string">
        <xsl:with-param name="xmltag" select="xr:VAT_exemption_reason_code"/>
        <xsl:with-param name="jsonkey" select="'BT121'"/>
        <xsl:with-param name="indent" select="'    '"/>
      </xsl:call-template>
      <xsl:text>&#10;      },</xsl:text>
    </xsl:for-each>
  </xsl:variable>
  <xsl:if test="string($bg-23)">
    <xsl:text>&#10;    "BG023": [</xsl:text>
    <xsl:value-of select="substring($bg-23, 1, string-length($bg-23) - 1)" />
    <xsl:text>&#10;    ],</xsl:text>
  </xsl:if>

  <xsl:variable name="bg-24">
    <xsl:for-each select="xr:ADDITIONAL_SUPPORTING_DOCUMENTS">
      <xsl:text>&#10;      {</xsl:text>
      <xsl:call-template name="string">
        <xsl:with-param name="xmltag" select="xr:Supporting_document_reference"/>
        <xsl:with-param name="jsonkey" select="'BT122'"/>
        <xsl:with-param name="indent" select="'    '"/>
      </xsl:call-template>
      <xsl:call-template name="string">
        <xsl:with-param name="xmltag" select="xr:Supporting_document_description"/>
        <xsl:with-param name="jsonkey" select="'BT123'"/>
        <xsl:with-param name="indent" select="'    '"/>
      </xsl:call-template>
      <xsl:call-template name="string">
        <xsl:with-param name="xmltag" select="xr:External_document_location"/>
        <xsl:with-param name="jsonkey" select="'BT124'"/>
        <xsl:with-param name="indent" select="'    '"/>
      </xsl:call-template>
      <xsl:call-template name="binary_object">
        <xsl:with-param name="xmltag" select="xr:Attached_document"/>
        <xsl:with-param name="jsonkey" select="'BT125'"/>
        <xsl:with-param name="indent" select="'    '"/>
      </xsl:call-template>
      <xsl:text>&#10;      },</xsl:text>
    </xsl:for-each>
  </xsl:variable>
  <xsl:if test="string($bg-24)">
    <xsl:text>&#10;    "BG024": [</xsl:text>
    <xsl:value-of select="substring($bg-24, 1, string-length($bg-24) - 1)" />
    <xsl:text>&#10;    ],</xsl:text>
  </xsl:if>

  <xsl:variable name="bg-25">
    <xsl:for-each select="xr:INVOICE_LINE">
      <xsl:text>&#10;      {</xsl:text>
      <xsl:call-template name="string">
        <xsl:with-param name="xmltag" select="xr:Invoice_line_identifier"/>
        <xsl:with-param name="jsonkey" select="'BT126'"/>
        <xsl:with-param name="indent" select="'    '"/>
      </xsl:call-template>
      <xsl:call-template name="string">
        <xsl:with-param name="xmltag" select="xr:Invoice_line_note"/>
        <xsl:with-param name="jsonkey" select="'BT127'"/>
        <xsl:with-param name="indent" select="'    '"/>
      </xsl:call-template>
      <xsl:call-template name="string">
        <xsl:with-param name="xmltag" select="xr:Invoice_line_object_identifier"/>
        <xsl:with-param name="jsonkey" select="'BT128'"/>
        <xsl:with-param name="indent" select="'    '"/>
      </xsl:call-template>
      <xsl:call-template name="string">
        <xsl:with-param name="xmltag" select="xr:Invoiced_quantity"/>
        <xsl:with-param name="jsonkey" select="'BT129'"/>
        <xsl:with-param name="indent" select="'    '"/>
      </xsl:call-template>
      <xsl:call-template name="string">
        <xsl:with-param name="xmltag" select="xr:Invoiced_quantity_unit_of_measure_code"/>
        <xsl:with-param name="jsonkey" select="'BT130'"/>
        <xsl:with-param name="indent" select="'    '"/>
      </xsl:call-template>
      <xsl:call-template name="string">
        <xsl:with-param name="xmltag" select="xr:Invoice_line_net_amount"/>
        <xsl:with-param name="jsonkey" select="'BT131'"/>
        <xsl:with-param name="indent" select="'    '"/>
      </xsl:call-template>
      <xsl:call-template name="string">
        <xsl:with-param name="xmltag" select="xr:Referenced_purchase_order_line_reference"/>
        <xsl:with-param name="jsonkey" select="'BT132'"/>
        <xsl:with-param name="indent" select="'    '"/>
      </xsl:call-template>
      <xsl:call-template name="string">
        <xsl:with-param name="xmltag" select="xr:Invoice_line_Buyer_accounting_reference"/>
        <xsl:with-param name="jsonkey" select="'BT133'"/>
        <xsl:with-param name="indent" select="'    '"/>
      </xsl:call-template>
      <xsl:variable name="bg-26">
        <xsl:call-template name="date_from_iso8601">
          <xsl:with-param name="xmltag" select="xr:INVOICE_LINE_PERIOD/xr:Invoice_line_period_start_date"/>
          <xsl:with-param name="jsonkey" select="'BT134'"/>
          <xsl:with-param name="indent" select="'      '"/>
        </xsl:call-template>
        <xsl:call-template name="date_from_iso8601">
          <xsl:with-param name="xmltag" select="xr:INVOICE_LINE_PERIOD/xr:Invoice_line_period_end_date"/>
          <xsl:with-param name="jsonkey" select="'BT135'"/>
          <xsl:with-param name="indent" select="'      '"/>
        </xsl:call-template>
      </xsl:variable>
      <xsl:if test="string($bg-26)">
        <xsl:text>&#10;        "BG026": {</xsl:text>
        <xsl:value-of select="substring($bg-26, 1, string-length($bg-26) - 1)" />
        <xsl:text>&#10;        },</xsl:text>
      </xsl:if>

      <xsl:variable name="bg-27">
        <xsl:for-each select="xr:INVOICE_LINE_ALLOWANCES">
          <xsl:text>&#10;          {</xsl:text>
          <xsl:call-template name="string">
            <xsl:with-param name="xmltag" select="xr:Invoice_line_allowance_amount"/>
            <xsl:with-param name="jsonkey" select="'BT136'"/>
            <xsl:with-param name="indent" select="'        '"/>
          </xsl:call-template>
          <xsl:call-template name="string">
            <xsl:with-param name="xmltag" select="xr:Invoice_line_allowance_base_amount"/>
            <xsl:with-param name="jsonkey" select="'BT137'"/>
            <xsl:with-param name="indent" select="'        '"/>
          </xsl:call-template>
          <xsl:call-template name="string">
            <xsl:with-param name="xmltag" select="xr:Invoice_line_allowance_percentage"/>
            <xsl:with-param name="jsonkey" select="'BT138'"/>
            <xsl:with-param name="indent" select="'        '"/>
          </xsl:call-template>
          <xsl:call-template name="string">
            <xsl:with-param name="xmltag" select="xr:Invoice_line_allowance_reason"/>
            <xsl:with-param name="jsonkey" select="'BT139'"/>
            <xsl:with-param name="indent" select="'        '"/>
          </xsl:call-template>
          <xsl:call-template name="string">
            <xsl:with-param name="xmltag" select="xr:Invoice_line_allowance_reason_code"/>
            <xsl:with-param name="jsonkey" select="'BT140'"/>
            <xsl:with-param name="indent" select="'        '"/>
          </xsl:call-template>
          <xsl:text>&#10;          },</xsl:text>
        </xsl:for-each>
      </xsl:variable>
      <xsl:if test="string($bg-27)">
        <xsl:text>&#10;        "BG027": [</xsl:text>
        <xsl:value-of select="substring($bg-27, 1, string-length($bg-27) - 1)" />
        <xsl:text>&#10;        ],</xsl:text>
      </xsl:if>

      <xsl:variable name="bg-28">
        <xsl:for-each select="xr:INVOICE_LINE_CHARGES">
          <xsl:text>&#10;          {</xsl:text>
          <xsl:call-template name="string">
            <xsl:with-param name="xmltag" select="xr:Invoice_line_charge_amount"/>
            <xsl:with-param name="jsonkey" select="'BT141'"/>
            <xsl:with-param name="indent" select="'        '"/>
          </xsl:call-template>
          <xsl:call-template name="string">
            <xsl:with-param name="xmltag" select="xr:Invoice_line_charge_base_amount"/>
            <xsl:with-param name="jsonkey" select="'BT142'"/>
            <xsl:with-param name="indent" select="'        '"/>
          </xsl:call-template>
          <xsl:call-template name="string">
            <xsl:with-param name="xmltag" select="xr:Invoice_line_charge_percentage"/>
            <xsl:with-param name="jsonkey" select="'BT143'"/>
            <xsl:with-param name="indent" select="'        '"/>
          </xsl:call-template>
          <xsl:call-template name="string">
            <xsl:with-param name="xmltag" select="xr:Invoice_line_charge_reason"/>
            <xsl:with-param name="jsonkey" select="'BT144'"/>
            <xsl:with-param name="indent" select="'        '"/>
          </xsl:call-template>
          <xsl:call-template name="string">
            <xsl:with-param name="xmltag" select="xr:Invoice_line_charge_reason_code"/>
            <xsl:with-param name="jsonkey" select="'BT145'"/>
            <xsl:with-param name="indent" select="'        '"/>
          </xsl:call-template>
          <xsl:text>&#10;          },</xsl:text>
        </xsl:for-each>
      </xsl:variable>
      <xsl:if test="string($bg-28)">
        <xsl:text>&#10;        "BG028": [</xsl:text>
        <xsl:value-of select="substring($bg-28, 1, string-length($bg-28) - 1)" />
        <xsl:text>&#10;        ],</xsl:text>
      </xsl:if>

      <xsl:variable name="bg-29">
        <xsl:call-template name="string">
          <xsl:with-param name="xmltag" select="xr:PRICE_DETAILS/xr:Item_net_price"/>
          <xsl:with-param name="jsonkey" select="'BT146'"/>
          <xsl:with-param name="indent" select="'      '"/>
        </xsl:call-template>
        <xsl:call-template name="string">
          <xsl:with-param name="xmltag" select="xr:PRICE_DETAILS/xr:Item_price_discount"/>
          <xsl:with-param name="jsonkey" select="'BT147'"/>
          <xsl:with-param name="indent" select="'      '"/>
        </xsl:call-template>
        <xsl:call-template name="string">
          <xsl:with-param name="xmltag" select="xr:PRICE_DETAILS/xr:Item_gross_price"/>
          <xsl:with-param name="jsonkey" select="'BT148'"/>
          <xsl:with-param name="indent" select="'      '"/>
        </xsl:call-template>
        <xsl:call-template name="string">
          <xsl:with-param name="xmltag" select="xr:PRICE_DETAILS/xr:Item_price_base_quantity"/>
          <xsl:with-param name="jsonkey" select="'BT149'"/>
          <xsl:with-param name="indent" select="'      '"/>
        </xsl:call-template>
        <xsl:call-template name="string">
          <xsl:with-param name="xmltag" select="xr:PRICE_DETAILS/xr:Item_price_base_quantity_unit_of_measure"/>
          <xsl:with-param name="jsonkey" select="'BT150'"/>
          <xsl:with-param name="indent" select="'      '"/>
        </xsl:call-template>
      </xsl:variable>
      <xsl:if test="string($bg-29)">
        <xsl:text>&#10;        "BG029": {</xsl:text>
        <xsl:value-of select="substring($bg-29, 1, string-length($bg-29) - 1)" />
        <xsl:text>&#10;        },</xsl:text>
      </xsl:if>

      <xsl:variable name="bg-30">
        <xsl:call-template name="string">
          <xsl:with-param name="xmltag" select="xr:LINE_VAT_INFORMATION/xr:Invoiced_item_VAT_category_code"/>
          <xsl:with-param name="jsonkey" select="'BT151'"/>
          <xsl:with-param name="indent" select="'      '"/>
        </xsl:call-template>
        <xsl:call-template name="string">
          <xsl:with-param name="xmltag" select="xr:LINE_VAT_INFORMATION/xr:Invoiced_item_VAT_rate"/>
          <xsl:with-param name="jsonkey" select="'BT152'"/>
          <xsl:with-param name="indent" select="'      '"/>
        </xsl:call-template>
      </xsl:variable>
      <xsl:if test="string($bg-30)">
        <xsl:text>&#10;        "BG030": {</xsl:text>
        <xsl:value-of select="substring($bg-30, 1, string-length($bg-30) - 1)" />
        <xsl:text>&#10;        },</xsl:text>
      </xsl:if>

      <xsl:variable name="bg-31">
        <xsl:call-template name="string">
          <xsl:with-param name="xmltag" select="xr:ITEM_INFORMATION/xr:Item_name"/>
          <xsl:with-param name="jsonkey" select="'BT153'"/>
          <xsl:with-param name="indent" select="'      '"/>
        </xsl:call-template>
        <xsl:call-template name="string">
          <xsl:with-param name="xmltag" select="xr:ITEM_INFORMATION/xr:Item_description"/>
          <xsl:with-param name="jsonkey" select="'BT154'"/>
          <xsl:with-param name="indent" select="'      '"/>
        </xsl:call-template>
        <xsl:call-template name="string">
          <xsl:with-param name="xmltag" select="xr:ITEM_INFORMATION/xr:Item_Sellers_identifier"/>
          <xsl:with-param name="jsonkey" select="'BT155'"/>
          <xsl:with-param name="indent" select="'      '"/>
        </xsl:call-template>
        <xsl:call-template name="string">
          <xsl:with-param name="xmltag" select="xr:ITEM_INFORMATION/xr:Item_Buyers_identifier"/>
          <xsl:with-param name="jsonkey" select="'BT156'"/>
          <xsl:with-param name="indent" select="'      '"/>
        </xsl:call-template>
        <xsl:call-template name="string">
          <xsl:with-param name="xmltag" select="xr:ITEM_INFORMATION/xr:Item_standard_identifier"/>
          <xsl:with-param name="jsonkey" select="'BT157'"/>
          <xsl:with-param name="indent" select="'      '"/>
        </xsl:call-template>
        <xsl:call-template name="array">
          <xsl:with-param name="xmltag" select="xr:ITEM_INFORMATION/xr:Item_classification_identifier"/>
          <xsl:with-param name="jsonkey" select="'BT158'"/>
          <xsl:with-param name="indent" select="'      '"/>
        </xsl:call-template>
        <xsl:call-template name="string">
          <xsl:with-param name="xmltag" select="xr:ITEM_INFORMATION/xr:Item_country_of_origin"/>
          <xsl:with-param name="jsonkey" select="'BT159'"/>
          <xsl:with-param name="indent" select="'      '"/>
        </xsl:call-template>
        <xsl:variable name="bg-32">
          <xsl:for-each select="xr:ITEM_INFORMATION/xr:ITEM_ATTRIBUTES">
            <xsl:text>&#10;            {</xsl:text>
            <xsl:call-template name="string">
              <xsl:with-param name="xmltag" select="xr:Item_attribute_name"/>
              <xsl:with-param name="jsonkey" select="'BT160'"/>
              <xsl:with-param name="indent" select="'          '"/>
            </xsl:call-template>
            <xsl:call-template name="string">
              <xsl:with-param name="xmltag" select="xr:Item_attribute_value"/>
              <xsl:with-param name="jsonkey" select="'BT161'"/>
              <xsl:with-param name="indent" select="'          '"/>
            </xsl:call-template>
            <xsl:text>&#10;            },</xsl:text>
          </xsl:for-each>
        </xsl:variable>
        <xsl:if test="string($bg-32)">
          <xsl:text>&#10;          "BG032": [</xsl:text>
          <xsl:value-of select="substring($bg-32, 1, string-length($bg-32) - 1)" />
          <xsl:text>&#10;          ],</xsl:text>
        </xsl:if>

      </xsl:variable>
      <xsl:if test="string($bg-31)">
        <xsl:text>&#10;        "BG031": {</xsl:text>
        <xsl:value-of select="substring($bg-31, 1, string-length($bg-31) - 1)" />
        <xsl:text>&#10;        },</xsl:text>
      </xsl:if>

      <xsl:text>&#10;      },</xsl:text>
    </xsl:for-each>
  </xsl:variable>
  <xsl:if test="string($bg-25)">
    <xsl:text>&#10;    "BG025": [</xsl:text>
    <xsl:value-of select="substring($bg-25, 1, string-length($bg-25) - 1)" />
    <xsl:text>&#10;    ],</xsl:text>
  </xsl:if>


-->

























  <xsl:text>
  }
}
</xsl:text>
</xsl:template>
</xsl:stylesheet>
