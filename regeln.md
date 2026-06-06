

BT-7 und BT-8
-------------
BT-7 ist das Datum, an dem die Umsatzsteuer abrechnungsrelevant wird.
BT-8 ist ein Code für diesen Zeitpunkt
Nur eines von beiden darf vorhanden sein.

Außerdem gibt es nur ein Datum bzw. einen Code pro XRechnung, in CII wird beides
aber pro Umsatzsteuersatz angegeben (mehrere <ram:ApplicableTradeTax> Tags).
Diese müssen also alle übereinstimmen.

BT-7
/rsm:CrossIndustryInvoice
  /rsm:SupplyChainTradeTransaction
    /ram:ApplicableHeaderTradeSettlement
      /ram:ApplicableTradeTax                   [1]
        /ram:TaxPointDate
          /udt:DateString[@format = '102'])

BT-8
/rsm:CrossIndustryInvoice
  /rsm:SupplyChainTradeTransaction
    /ram:ApplicableHeaderTradeSettlement
      /ram:ApplicableTradeTax                   [1]
        /ram:DueDateTypeCode






CII Kardinalitäten prüfen
=========================

BT-29 0..*
/rsm:CrossIndustryInvoice
  /rsm:SupplyChainTradeTransaction
    /ram:ApplicableHeaderTradeAgreement
      /ram:SellerTradeParty
        /ram:ID
        /ram:GlobalID[exists(@schemeID)]
werden beide zu einer Liste kombiniert

BT-41 1..1
/rsm:CrossIndustryInvoice
  /rsm:SupplyChainTradeTransaction
    /ram:ApplicableHeaderTradeAgreement
      /ram:SellerTradeParty
        /ram:DefinedTradeContact
          /ram:DepartmentName
          /ram:PersonName
genau eins davon muss es geben

BT-46 0..1
/rsm:CrossIndustryInvoice
  /rsm:SupplyChainTradeTransaction
    /ram:ApplicableHeaderTradeAgreement
      /ram:BuyerTradeParty
        /ram:ID
        /ram:GlobalID[exists(@schemeID)]
höchstens eins davon darf es geben

BT-56 0..1
/rsm:CrossIndustryInvoice
  /rsm:SupplyChainTradeTransaction
    /ram:ApplicableHeaderTradeAgreement
      /ram:BuyerTradeParty
        /ram:DefinedTradeContact
          /ram:DepartmentName
          /ram:PersonName
höchstens eins davon darf es geben

BT-60 0..1
/rsm:CrossIndustryInvoice
  /rsm:SupplyChainTradeTransaction
    /ram:ApplicableHeaderTradeSettlement
      /ram:PayeeTradeParty
        /ram:ID
        /ram:GlobalID[exists(@schemeID)]
höchstens eins davon darf es geben

BT-71 0..1

BT-84 1..1
/rsm:CrossIndustryInvoice
  /rsm:SupplyChainTradeTransaction
    /ram:ApplicableHeaderTradeSettlement
      /ram:SpecifiedTradeSettlementPaymentMeans
        /ram:PayeePartyCreditorFinancialAccount
           /ram:ProprietaryID
           /ram:IBANID
genau eins davon muss es geben (je ram:PayeePartyCreditorFinancialAccount)







