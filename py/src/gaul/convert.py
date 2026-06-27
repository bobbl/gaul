import io
import json
import os
import re
import tomllib                  # toml read

import chevron                  # mustache
from lxml import etree          # xslt
import tomli_w                  # toml write
import yaml

from . import templates
from . import zugferd



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
        sm2bt = dict( (sm, bt) for bt, sm in templates.REPLACE_BT2SM.items() )

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
        self.btstr = xslt_transform(templates.SMX2BTJ_XSLT.encode("utf-8"), s)
        self.bttree = None

    def load_cii(self, s: bytes):
        self.btstr = xslt_transform(templates.CII2BTJ_XSLT.encode("utf-8"), s)
        self.bttree = None

    def load_zugferd(self, s: bytes):
        self.load_cii(zugferd.read_cii_from_zugferd(io.BytesIO(s)))

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


    def dump_as_btj(self) -> bytes:
        if self.btstr == None:
            self.btstr = json.dump(self.bttree, indent=2)
        return self.btstr.encode("utf-8")

    def dump_as_smj(self) -> bytes:
        if not self.btstr:
            self.btstr = json.dump(self.bttree, indent=2)

        # replace BT??? with semantic model name
        s = re.sub("|".join(templates.REPLACE_BT2SM.keys()),
                   lambda x: templates.REPLACE_BT2SM[x.group(0)],
                   self.btstr)
        return s.encode("utf-8")

    def dump_as_smt(self) -> bytes:
        s = self.dump_as_smj()  # BT JSON string -> SM JSON string
        d = yaml.safe_load(s)   #                -> SM Python dict
        return tomli_w.dumps(d).encode("utf-8") #                -> SM TOML string

    def dump_as_smx(self) -> bytes:
        if not self.bttree:
            self.bttree = yaml.safe_load(self.btstr)
        return chevron.render(templates.BTJ2SMX_MUSTACHE, self.bttree).encode("utf-8")

    def dump_as_cii(self) -> bytes:
        if not self.bttree:
            self.bttree = yaml.safe_load(self.btstr)
        return chevron.render(templates.BTJ2CII_MUSTACHE, self.bttree).encode("utf-8")

    def dump(self, format) -> bytes:
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
        else:
            ValueError(f"Unknown output format '{format}'")

    def dump_as_zugferd(self, pdf_filename: str) -> bytes:
        return zugferd.create_zugferd_pdf(
            pdf_filename,
            self.dump_as_cii()
        )

