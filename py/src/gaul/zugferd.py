import datetime                 # now()
import io

import pypdf


TEMPLATE_XMP = """
<?xpacket begin="\ufeff" id="W5M0MpCehiHzreSzNTczkc9d"?>
<x:xmpmeta xmlns:x="adobe:ns:meta/">
  <rdf:RDF xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#">
    <rdf:Description rdf:about="" xmlns:pdfaid="http://www.aiim.org/pdfa/ns/id/">
      <pdfaid:part>3</pdfaid:part>
      <pdfaid:conformance>B</pdfaid:conformance>
    </rdf:Description>
    <rdf:Description rdf:about="" xmlns:fx="urn:factur-x:pdfa:CrossIndustryDocument:invoice:1p0#">
      <fx:DocumentFileName>factur-x.xml</fx:DocumentFileName>
      <fx:DocumentType>INVOICE</fx:DocumentType>
      <fx:Version>3.0</fx:Version>
      <fx:ConformanceLevel>XRECHNUNG</fx:ConformanceLevel>
    </rdf:Description>
    <rdf:Description rdf:about="" xmlns:pdfaExtension="http://www.aiim.org/pdfa/ns/extension/" xmlns:pdfaSchema="http://www.aiim.org/pdfa/ns/schema#" xmlns:pdfaProperty="http://www.aiim.org/pdfa/ns/property#">
      <pdfaExtension:schemas>
        <rdf:Bag>
          <rdf:li rdf:parseType="Resource">
            <pdfaSchema:schema>Factur-X PDFA Extension Schema</pdfaSchema:schema>
            <pdfaSchema:namespaceURI>urn:factur-x:pdfa:CrossIndustryDocument:invoice:1p0#</pdfaSchema:namespaceURI>
            <pdfaSchema:prefix>fx</pdfaSchema:prefix>
            <pdfaSchema:property>
              <rdf:Seq>
                <rdf:li rdf:parseType="Resource">
                  <pdfaProperty:name>DocumentFileName</pdfaProperty:name>
                  <pdfaProperty:valueType>Text</pdfaProperty:valueType>
                  <pdfaProperty:category>external</pdfaProperty:category>
                  <pdfaProperty:description>name of the embedded XML document</pdfaProperty:description>
                </rdf:li>
                <rdf:li rdf:parseType="Resource">
                  <pdfaProperty:name>DocumentType</pdfaProperty:name>
                  <pdfaProperty:valueType>Text</pdfaProperty:valueType>
                  <pdfaProperty:category>external</pdfaProperty:category>
                  <pdfaProperty:description>type of the hybrid document</pdfaProperty:description>
                </rdf:li>
                <rdf:li rdf:parseType="Resource">
                  <pdfaProperty:name>Version</pdfaProperty:name>
                  <pdfaProperty:valueType>Text</pdfaProperty:valueType>
                  <pdfaProperty:category>external</pdfaProperty:category>
                  <pdfaProperty:description>actual version of the standard applying to the embedded invoice</pdfaProperty:description>
                </rdf:li>
                <rdf:li rdf:parseType="Resource">
                  <pdfaProperty:name>ConformanceLevel</pdfaProperty:name>
                  <pdfaProperty:valueType>Text</pdfaProperty:valueType>
                  <pdfaProperty:category>external</pdfaProperty:category>
                  <pdfaProperty:description>conformance level of the embedded invoice</pdfaProperty:description>
                </rdf:li>
              </rdf:Seq>
            </pdfaSchema:property>
          </rdf:li>
        </rdf:Bag>
      </pdfaExtension:schemas>
    </rdf:Description>
    <rdf:Description rdf:about="" xmlns:dc="http://purl.org/dc/elements/1.1/">
      <dc:title>
        <rdf:Alt>
          <rdf:li xml:lang="x-default">ZUGFeRD Rechnung</rdf:li>
        </rdf:Alt>
      </dc:title>
    </rdf:Description>
    <rdf:Description rdf:about="" xmlns:pdf="http://ns.adobe.com/pdf/1.3/">
      <pdf:Producer>pypdf</pdf:Producer>
    </rdf:Description>
    <rdf:Description rdf:about="" xmlns:xmp="http://ns.adobe.com/xap/1.0/">
      <xmp:CreatorTool>Gaul</xmp:CreatorTool>
      <xmp:CreateDate>{timestamp}</xmp:CreateDate>
      <xmp:ModifyDate>{timestamp}</xmp:ModifyDate>
    </rdf:Description>
  </rdf:RDF>
</x:xmpmeta>
<?xpacket end="w"?>
"""



"""
def read_cii_from_zugferd(pdf_file):
    reader = pypdf.PdfReader(pdf_file)
    if not "factur-x.xml" in reader.attachments:
        RuntimeError("No attachment named 'factur-x.xml' in PDF")
    content_list = reader.attachments["factur-x.xml"]
    if len(content_list) != 1:
        RuntimeError("Multiple attachments named 'factur-x.xml' in PDF")
    return content_list[0]
"""


def read_cii_from_zugferd(pdf_file):
    reader = pypdf.PdfReader(pdf_file)
    a = reader.attachments
    if len(a) == 1:
        # WARNING if name is not factur-x.xml
        content_list = list(a.values())[0]
    elif "factur-x.xml" in reader.attachments:
        content_list = reader.attachments["factur-x.xml"]
    #elif "xrechnung.xml" in reader.attachments:
    #    content_list = reader.attachments["xrechnung.xml"]
    #elif "ZUGFeRD-invoice.xml" in reader.attachments:
    #    content_list = reader.attachments["ZUGFeRD-invoice.xml"]
    else:
        RuntimeError("Multiple embedded files in PDF. Which one is the invoice?")
    if len(content_list) != 1:
        RuntimeError("Embedded filename in PDF refers to multiple file objects. Which one is the invoice?")
    return content_list[0]



def create_zugferd_pdf(
    undecorated_pdf_file,
    cii: bytes
) -> bytes:

    r = pypdf.PdfReader(undecorated_pdf_file)
    w = pypdf.PdfWriter()
    w._header = "%PDF-1.6\r\n%\xc7\xec\x8f\xa2".encode()
    w.append_pages_from_reader(r)

    now = datetime.datetime.now(tz=datetime.timezone.utc)
    timestamp_xmp  = now.strftime("%Y-%m-%dT%H:%M:%S+00:00")
    timestamp_prop = now.strftime("D:%Y%m%d%H%M%SZ")
    obj_timestamp  = pypdf.generic.create_string_object(timestamp_prop)
    obj_filename   = pypdf.generic.create_string_object("factur-x.xml")

    # metadata for the document properties section
    metadata_document_properties =  {
        "/CreationDate": timestamp_prop,
        "/Creator":      "Gaul",
        "/ModDate":      timestamp_prop,
        "/Title":        "ZUGFeRD Rechnung",
    }
    w.add_metadata(metadata_document_properties)

    # metadata for the xmp section
    xmp_str = TEMPLATE_XMP.format(timestamp=timestamp_xmp).encode("utf-8")

    stream_metadata = pypdf.generic.DecodedStreamObject()
    stream_metadata.set_data(xmp_str)
    stream_metadata.update({
        pypdf.generic.NameObject("/Subtype"):
            pypdf.generic.NameObject("/XML"),
        pypdf.generic.NameObject("/Type"):
            pypdf.generic.NameObject("/Metadata"),
    })
    obj_metadata = w._add_object(stream_metadata)

    stream_content = pypdf.generic.DecodedStreamObject()
    stream_content.set_data(cii)
    stream_content.update({
        pypdf.generic.NameObject("/Type"):
            pypdf.generic.NameObject("/EmbeddedFile"),
        pypdf.generic.NameObject("/Subtype"):
            pypdf.generic.NameObject("/text/xml"),
        pypdf.generic.NameObject("/Params"):
            pypdf.generic.DictionaryObject({
                pypdf.generic.NameObject("/ModDate"):
                    obj_timestamp,
                pypdf.generic.NameObject("/CreationDate"):
                    obj_timestamp,
                pypdf.generic.NameObject("/Size"):
                    pypdf.generic.NumberObject(len(cii)),
            }),
    })
    obj_content = w._add_object(stream_content)

    filespec = pypdf.generic.DictionaryObject({
        pypdf.generic.NameObject("/AFRelationship"):
            pypdf.generic.NameObject("/Alternative"),
        pypdf.generic.NameObject("/Type"):
            pypdf.generic.NameObject("/Filespec"),
        pypdf.generic.NameObject("/F"): obj_filename,
        pypdf.generic.NameObject("/UF"): obj_filename,
        pypdf.generic.NameObject("/EF"):
            pypdf.generic.DictionaryObject({
                pypdf.generic.NameObject("/F"): obj_content,
                pypdf.generic.NameObject("/UF"): obj_content,
            }),
    })
    obj_filespec = w._add_object(filespec)

    w._root_object.update({
        pypdf.generic.NameObject("/AF"):
            w._add_object(pypdf.generic.ArrayObject([obj_filespec])),
        pypdf.generic.NameObject("/Metadata"): obj_metadata,
        pypdf.generic.NameObject("/Names"):
            pypdf.generic.DictionaryObject({
                pypdf.generic.NameObject("/EmbeddedFiles"):
                    pypdf.generic.DictionaryObject({
                        pypdf.generic.NameObject("/Names"):
                            pypdf.generic.ArrayObject([obj_filename, obj_filespec])
                    })
            }),
        pypdf.generic.NameObject("/PageMode"):
            pypdf.generic.NameObject("/UseAttachments"),
    })


    # deep copy of /OutputIntents
    if "/Root" in r.trailer:
        root = r.trailer["/Root"]
        if "/OutputIntents" in root:
            modified = []

            for o in root["/OutputIntents"]:
                intent = o.get_object()
                obj_profile = w._add_object(intent["/DestOutputProfile"].get_object())
                intent.update({
                    pypdf.generic.NameObject("/DestOutputProfile"):
                        obj_profile
                })
                obj_intent = w._add_object(intent)
                modified.append(obj_intent)

            w._root_object.update({
                pypdf.generic.NameObject("/OutputIntents"):
                    pypdf.generic.ArrayObject(modified)
            })


    w.generate_file_identifiers()
        # /ID is required by PDF/A validators

    buf = io.BytesIO()
    w.write(buf)
    buf.seek(0)
    return buf.read()


