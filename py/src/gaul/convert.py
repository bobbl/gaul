import io
import json
import os
import re
import tomllib                  # toml read

import chevron                  # mustache
from lxml import etree          # xslt
from pypdf import PdfReader
import tomli_w                  # toml write
import yaml

from . import templates




# Use an XSLT file to transform the given string
def xslt_transform(xslt_string: bytes, xml_string: bytes) -> str:
    parsed = etree.fromstring(xslt_string)
    transform = etree.XSLT(parsed)
    xml = etree.fromstring(xml_string)
    return str(transform(xml))





class Gaul:

    def __init__(self):
        self.btstr = None
        self.bttree = None


    SUPPORTED_FORMATS = ["BTJ", "SMJ", "SMT", "SMX", "CII", "ZUGFERD"]

    def format_supported(format_str: str) -> bool:
        return format_str in Gaul.SUPPORTED_FORMATS



    def load_btj(self, s: bytes):
        self.btstr = s
        self.bttree = None
        #self.bttree = yaml.safe_load(s)

    def load_smj(self, s: bytes):

        # swap keys and values
        sm2bt = dict( (sm, bt) for bt, sm in templates.replace_bt2sm.items() )

        # replace semantic model names with BT???
        # sort from longer to shorter names to avoid partial replacement
        self.btstr = re.sub("|".join(sorted(sm2bt, key=len, reverse=True)),
                            lambda x: sm2bt[x.group(0)],
                            s.decode("utf-8"))
        self.bttree = None

    def load_smt(self, s: bytes):
        self.load_smj(json.dumps(tomllib.loads(s.decode("utf-8")), indent=2)
            .encode("utf-8"))

    def load_smx(self, s: bytes):
        self.btstr = xslt_transform(templates.smx2btj_xslt.encode("utf-8"), s)
        self.bttree = None

    def load_cii(self, s: bytes):
        self.btstr = xslt_transform(templates.cii2btj_xslt.encode("utf-8"), s)
        self.bttree = None

    def load_zugferd(self, s: bytes):
        reader = PdfReader(io.BytesIO(s))
        if not "factur-x.xml" in reader.attachments:
            RuntimeError("No attachment named 'factur-x.xml' in PDF")
        content_list = reader.attachments["factur-x.xml"]
        if len(content_list) != 1:
            RuntimeError("Multiple attachments named 'factur-x.xml' in PDF")
        self.load_cii(content_list[0])

    """ Alternative: accept any filename
    def load_zugferd(self, s: bytes):
        reader = PdfReader(io.BytesIO(s))
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
        self.load_cii(content_list[0])
    """

    def load(self, s: bytes, format=""):
        if format == "BTJ":
            self.load_btj(s)
        elif format == "SMJ":
            self.load_smj(s)
        elif format == "SMT":
            self.load_smt(s)
        elif format == "SMX":
            self.load_smx(s)
        elif format == "CII":
            self.load_cii(s)
        elif format == "ZUGFERD":
            self.load_zugferd(s)
        #elif format == "":
        #   self.load_auto(s)
        else:
            ValueError(f"Unknown input format '{format}'")


    def dump_as_btj(self) -> str:
        if self.btstr == None:
            self.btstr = json.dump(self.bttree, indent=2)
        return self.btstr

    def dump_as_smj(self) -> str:
        if not self.btstr:
            self.btstr = json.dump(self.bttree, indent=2)

        # replace BT??? with semantic model name
        s = re.sub("|".join(templates.replace_bt2sm.keys()),
                   lambda x: templates.replace_bt2sm[x.group(0)],
                   self.btstr)
        return s

    def dump_as_smt(self) -> str:
        s = self.dump_as_smj()  # BT JSON string -> SM JSON string
        d = yaml.safe_load(s)   #                -> SM Python dict
        return tomli_w.dumps(d) #                -> SM TOML string

    def dump_as_smx(self) -> str:
        if not self.bttree:
            self.bttree = yaml.safe_load(self.btstr)
        return chevron.render(templates.btj2smx_mustache, self.bttree)

    def dump_as_cii(self) -> str:
        if not self.bttree:
            self.bttree = yaml.safe_load(self.btstr)
        return chevron.render(templates.btj2cii_mustache, self.bttree)

    def dump(self, format):
        if format == "BTJ":
            return self.dump_as_btj()
        if format == "SMJ":
            return self.dump_as_smj()
        if format == "SMT":
            return self.dump_as_smt()
        if format == "SMX":
            return self.dump_as_smx()
        if format == "CII":
            return self.dump_as_cii()
        #lif format == "":
        #    return self.dump_auto(s)
        else:
            ValueError(f"Unknown input format '{format}'")


