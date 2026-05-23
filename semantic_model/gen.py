#!/usr/bin/env python3

import csv


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

    # Bug in xrechnung-visualization:
    # <xr:Item_price_base_quantity_unit_of_measure> is used as XML tag for
    # BT-150, but in the XRechnung spec the full name has an additional "_code".
    if official_name == "Item price base quantity unit of measure code":
        official_name = "Item price base quantity unit of measure"

    n = official_name.replace(" ", "_")
    return f"xr:{n}"


def smx2btj_recurse(bgno: str, prefix: str, indent: str, bt, bg) -> str:
    head = ""
    tail = ""

    # Wrap in for-each loop if the group can appear more than once
    if bg[bgno]['Cardinality'] in ["*", "+"]:
        head = f"""
{indent}  <xsl:if test="{prefix[:-1]}">
{indent}    <xsl:text>
{indent}    "BG{bgno.zfill(3)}": [</xsl:text>
{indent}    <xsl:for-each select="{prefix[:-1]}">
{indent}      <xsl:text>
{indent}      {{</xsl:text>"""
        tail = f"""{indent}    <xsl:text>
{indent}        "_": "mask trailing comma"
{indent}      }}</xsl:text>
{indent}      <xsl:if test="position()!=last()">,</xsl:if>
{indent}    </xsl:for-each>
{indent}    <xsl:text>
{indent}    ],</xsl:text>
{indent}  </xsl:if>
"""
        prefix = ""
        indent += "    "

    r = "\n"
    for i, row in bt.items():
        if row['BG'] == bgno:
            xpath = prefix + smx_name(row['Name'])

            if row['Cardinality'] in ["*", "+"]:
                r += f"""{indent}  <xsl:if test="{xpath}">
{indent}    "BT{i.zfill(3)}": [<xsl:for-each select="{xpath}">
{indent}      "<xsl:value-of select="." />",</xsl:for-each>
{indent}    ],</xsl:if>
"""
            elif row['Datatype'] == 'B':
                r += f"""{indent}  <xsl:if test="{xpath}">
{indent}    "BT{i.zfill(3)}": {{
{indent}      "mime": "<xsl:value-of select="{xpath}/@mime_code" />",
{indent}      "filename": "<xsl:value-of select="{xpath}/@filename" />",
{indent}      "base64": "<xsl:value-of select="{xpath}/." />"
{indent}    }},</xsl:if>
"""
            else:
                r += f"""{indent}  <xsl:if test="{xpath}">
{indent}    "BT{i.zfill(3)}": "<xsl:value-of select="{xpath}" />",</xsl:if>
"""

    for i, row in bg.items():
        if row['BG'] == bgno:
            r += smx2btj_recurse(i, prefix + smx_name(row['Name']) + "/", 
                                 indent, bt, bg)
    return head + r + tail





def btj2smx_recurse(bgno: str, indent: str, bt, bg) -> str:
    tag = smx_name(bg[bgno]['Name'])
    head = f'{indent}<{tag} xr:id="BG-{bgno}">'
    tail = f"{indent}</{tag}>\n"

    # wrap in for-each loop if the group can appear more than once
    if bg[bgno]['Cardinality'] in ["*", "+"]:
        bgtag = f"BG{bgno.zfill(3)}"
        head = f"{indent}{{{{#{bgtag}}}}}\n" + head
        tail = tail + f"{indent}{{{{/{bgtag}}}}}\n"
    elif bgno == "0":
        # special case for root element
        head = '''{{#invoice}}
<xr:invoice xmlns:xr="urn:ce.eu:en16931:2017:xoev-de:kosit:standard:xrechnung-1">'''
        tail = '''</xr:invoice>
{{/invoice}}'''

    indent += "  "
    r = "\n"
    for i, row in bt.items():
        if row['BG'] == bgno:
            xmltag = smx_name(row['Name'])
            bttag = f"BT{i.zfill(3)}"
            r += f"""{indent}{{{{#{bttag}}}}}
{indent}<{xmltag} xr:id="BT-{i}">{{{{{bttag}}}}}</{xmltag}>
{indent}{{{{/{bttag}}}}}
"""

    for i, row in bg.items():
        if row['BG'] == bgno:
            r += btj2smx_recurse(i, indent, bt, bg)
    return head + r + tail







def main():

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

    with open("bt_table.gen.md", "w") as f:
        print("| Name                                            | ID     | Container | Data type | Cardinality |", file=f)
        print("| ----------------------------------------------- | ------ | ----- | ------------- | ---- |", file=f)
        for row in sorted(sm_rows, key=lambda x: x['Name']):
            print(f"| {row['Name'].ljust(47)} "
                  f"| {row['Terminal']}-{row['BT'].ljust(3)} "
                  f"| BG-{row['BG'].ljust(2)} "
                  f"| {DATATYPE_NAME[row['Datatype']]} "
                  f"| {CARDINALITY_NAME[row['Cardinality']]} |", file=f)




    # XSLT script to convert the KoSIT semantic model XML to JSON business terms

    with open("smx2btj.gen.xslt", "w") as f:
        print("""<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
                xmlns:xr="urn:ce.eu:en16931:2017:xoev-de:kosit:standard:xrechnung-1">

<!-- Generated by gaul/semantic_model/gen.py from bt_semantic_model.csv
     RECOMMENDATION: post process result to remove "_" element and trailing comma -->

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
    "_": "mask trailing comma"
  }
}
</xsl:text>
</xsl:template>
</xsl:stylesheet>""", file=f)




    # mustache script to convert JSON business terms to the KoSIT semantic model

    with open("btj2smx.gen.mustache", "w") as f:
        print('<?xml version="1.0" encoding="UTF-8"?>', file=f)
        print(btj2smx_recurse("0", "", bt, bg), file=f)



if __name__ == "__main__":
    main()
