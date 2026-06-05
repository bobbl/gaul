#!/usr/bin/env python3

import csv
import os


CARDINALITY_NAME = {
    "?": "0..1",
    "*": "0..*",
    "1": "1..1",
    "+": "1..*",
}

DATATYPE_NAME = {
    "A": "Amount       ",
    "B": "Binary object",
    "C": "Code         ",
    "D": "Date         ",
    "I": "Identifier   ",
    "P": "Percentage   ",
    "Q": "Quantity     ",
    "T": "Text         ",

    "G": "Group        "
}


# Transate the official semantic name to the form in the KoSIT XML format
def smx_name(official_name: str) -> str:

    # Deal with bug 1 in xrechnung-visualization:
    # <xr:Item_price_base_quantity_unit_of_measure> is used as XML tag for
    # BT-150, but in the XRechnung spec the full name has an additional "_code".
    if official_name == "Item price base quantity unit of measure code":
        official_name = "Item price base quantity unit of measure"

    n = official_name.replace(" ", "_")
    return f"xr:{n}"


def smx2btj_recurse(bgno: str, prefix: str, indent: str, bt, bg) -> str:

    # Deal with bug 2 in xrechnung-visualization:
    # <xr:INVOICING_PERIOD> is a child of <xr:INVOICE> but in the XRechnung
    # spec "INVOICING PERIOD" is a child of "DELIVERY INFORMATION", which is
    # a child of "INVOICE"
    if bgno == "14":
        prefix = smx_name(bg[bgno]['Name']) + "/"

    if bgno == "0":
        head = ""
        tail = ""

    elif bg[bgno]['Cardinality'] in ["?", "1"]:

        head = f"""
{indent}  <xsl:variable name="bg-{bgno}">"""
        # test="string($bg-{bgno})" is necessary, see below
        tail = f"""
{indent}  </xsl:variable>
{indent}  <xsl:if test="string($bg-{bgno})">
{indent}    <xsl:text>&#10;{indent}    "BG{bgno.zfill(3)}": {{</xsl:text>
{indent}    <xsl:value-of select="substring($bg-{bgno}, 1, string-length($bg-{bgno}) - 1)" />
{indent}    <xsl:text>&#10;{indent}    }},</xsl:text>
{indent}  </xsl:if>"""
        indent += "  "

    else:
        # Wrap in for-each loop if the group can appear more than once
        #
        # test="string($bg-{bgno})" is required, because an empty for-each loop
        # generates an empty Result Tree Fragment (RTF), that is not false.
        # But when converted to a string this string is empty, which is false.
        head = f"""
{indent}  <xsl:variable name="bg-{bgno}">
{indent}    <xsl:for-each select="{prefix[:-1]}">
{indent}      <xsl:text>&#10;{indent}      {{</xsl:text>"""
        tail = f"""
{indent}      <xsl:text>&#10;{indent}      }},</xsl:text>
{indent}    </xsl:for-each>
{indent}  </xsl:variable>
{indent}  <xsl:if test="string($bg-{bgno})">
{indent}    <xsl:text>&#10;{indent}    "BG{bgno.zfill(3)}": [</xsl:text>
{indent}    <xsl:value-of select="substring($bg-{bgno}, 1, string-length($bg-{bgno}) - 1)" />
{indent}    <xsl:text>&#10;{indent}    ],</xsl:text>
{indent}  </xsl:if>"""
        prefix = ""
        indent += "    "

    r = head
    for i, row in bt.items():
        if row['BG'] == bgno:
            xpath = prefix + smx_name(row['Name'])

            if row['Cardinality'] in ["*", "+"]:
                template_name = "array"
            elif row['Datatype'] == 'B':
                template_name = "binary_object"
            elif row['Datatype'] == 'D':
                template_name = "date_from_iso8601"
            else:
                template_name = "string"
            r += f"""
{indent}  <xsl:call-template name="{template_name}">
{indent}    <xsl:with-param name="xmltag" select="{xpath}"/>
{indent}    <xsl:with-param name="jsonkey" select="'BT{i.zfill(3)}'"/>
{indent}    <xsl:with-param name="indent" select="'{indent}'"/>
{indent}  </xsl:call-template>"""


    for i, row in bg.items():
        if row['BG'] == bgno:
            r += smx2btj_recurse(i, prefix + smx_name(row['Name']) + "/", 
                                 indent, bt, bg)
    return r + tail + "\n"





def btj2smx_recurse(bgno: str, indent: str, bt, bg) -> str:
    tag = smx_name(bg[bgno]['Name'])
    head = f'{indent}<{tag} xr:id="BG-{bgno}">'
    tail = f"{indent}</{tag}>\n"

    if bgno == "0":
        # special case for root element
        head = '''{{#invoice}}
<xr:invoice xmlns:xr="urn:ce.eu:en16931:2017:xoev-de:kosit:standard:xrechnung-1">'''
        tail = '''</xr:invoice>
{{/invoice}}'''
    else:
        # wrap in for-each loop anyway
        bgtag = f"BG{bgno.zfill(3)}"
        head = f"{indent}{{{{#{bgtag}}}}}\n" + head
        tail = tail + f"{indent}{{{{/{bgtag}}}}}\n"

    indent += "  "
    r = "\n"
    for i, row in bt.items():
        if row['BG'] == bgno:
            xmltag = smx_name(row['Name'])
            bttag = f"BT{i.zfill(3)}"

            if row['Datatype'] == 'B':
                content = f' mime_code="{{{{mime}}}}" filename="{{{{filename}}}}">{{{{base64}}}}'
            elif row['Datatype'] == 'D':
                content = f'>{{{{YYYY}}}}-{{{{MM}}}}-{{{{DD}}}}'
            else:
                content = f'>{{{{.}}}}'

            r += f"""{indent}{{{{#{bttag}}}}}
{indent}<{xmltag} xr:id="BT-{i}"{content}</{xmltag}>
{indent}{{{{/{bttag}}}}}
"""


    # Deal with bug in xrechnung-visualization:
    # <xr:INVOICING_PERIOD> is a child of <xr:INVOICE> but in the XRechnung
    # spec "INVOIING PERIOD" is a child of "DELIVERY INFORMATION", which is
    # a child of "INVOICE"
    #
    # Solution: when in BT-13 recurse only in BT-15 and append BT-14 after the
    #           end tag of BT-13
    if bgno == "13":   # BG-13 DELIVERY_INFORMATION
        r += btj2smx_recurse("15", indent, bt, bg) # BG-15 DELIVER_TO_ADDRESS
        appendix = btj2smx_recurse("14", indent, bt, bg)
        return (head + r + tail +
            "  {{#BG013}}\n" +
            btj2smx_recurse("14", "  ", bt, bg) +  # BG-14 INVOICE_PERIOD
            "  {{/BG013}}\n")

    for i, row in bg.items():
        if row['BG'] == bgno:
            r += btj2smx_recurse(i, indent, bt, bg)
    return head + r + tail







def main():

    os.makedirs('gen', exist_ok=True)

    with open('bt_semantic_model.csv', newline='') as f:
        reader = csv.DictReader(f)
        sm_rows = []
        bt = {}
        bg = {'0': {'Terminal': "BG",
                    'BT': "0",
                    'BG': "X",
                    'Cardinality': "1",
                    'Datatype': "G",
                    'Name': "INVOICE"
                   }
             }

        for row in reader:
            sm_rows.append(row)
            if row['Terminal'] == "BT":
                bt[row['BT']] = row
            else:
                bg[row['BT']] = row



    # Markdown table of the business terms

    with open("gen/bt_table.md", "w") as f:
        print("| Name                                            | ID     | Container | Data type | Cardinality |", file=f)
        print("| ----------------------------------------------- | ------ | ----- | ------------- | ---- |", file=f)
        for row in sorted(sm_rows, key=lambda x: x['Name']):
            print(f"| {row['Name'].ljust(47)} "
                  f"| {row['Terminal']}-{row['BT'].ljust(3)} "
                  f"| BG-{row['BG'].ljust(2)} "
                  f"| {DATATYPE_NAME[row['Datatype']]} "
                  f"| {CARDINALITY_NAME[row['Cardinality']]} |", file=f)




    # XSLT script to convert the KoSIT semantic model XML to JSON business terms

    with open("gen/smx2btj.xslt", "w") as f:
        print("""<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
                xmlns:xr="urn:ce.eu:en16931:2017:xoev-de:kosit:standard:xrechnung-1">

<!-- Generated by gaul/semantic_model/gen.py from bt_semantic_model.csv
     CAUTION: Does not produce valid JSON because of trailing commas in objects.
              Parse result with JSON5 or Hjson or take it as valid YAML. -->

<xsl:import href="../common.xslt" />
<xsl:output method="text" encoding="utf-8" /> 
<xsl:strip-space elements="*" />


<xsl:template match="xr:invoice">
  <xsl:text>{
  "_meta": {
    "format": "XRechnung Business Terms",
    "version": "0.9",
    "description": "XRechnung invoice condensed to business terms and encoded in JSON"
  },
  "invoice": {</xsl:text>""", file=f)

        print(smx2btj_recurse("0", "", "", bt, bg), file=f)
        print("""  <xsl:text>
  }
}
</xsl:text>
</xsl:template>
</xsl:stylesheet>""", file=f)




    # mustache script to convert JSON business terms to the KoSIT semantic model

    with open("gen/btj2smx.mustache", "w") as f:
        print('<?xml version="1.0" encoding="UTF-8"?>', file=f)
        print(btj2smx_recurse("0", "", bt, bg), file=f)



if __name__ == "__main__":
    main()
