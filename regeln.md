

BT-7 und BT-8
=============
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







