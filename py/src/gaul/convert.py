import os
import re

import chevron                  # mustache
from lxml import etree          # xslt
import yaml

from . import templates




# Use an XSLT file to transform the given string
def xslt_transform(xslt_string: str, xml_string: str) -> str:
    parsed = etree.fromstring(xslt_string.encode())
    transform = etree.XSLT(parsed)
    xml = etree.fromstring(xml_string.encode())
    return str(transform(xml))





class Gaul:

    def __init__(self):
        self.btstr = None
        self.bttree = None



    def load_btj(self, s: str):
        self.btstr = s
        self.bttree = None
        #self.bttree = yaml.safe_load(s)

    def load_smj(self, s: str):

        # swap keys and values
        sm2bt = dict( (sm, bt) for bt, sm in templates.replace_bt2sm.items() )

        # replace semantic model names with BT???
        # sort from longer to shorter names to avoid partial replacement
        self.btstr = re.sub("|".join(sorted(sm2bt, key=len, reverse=True)),
                            lambda x: sm2bt[x.group(0)],
                            s)
        self.bttree = None

    def load_smx(self, s: str) -> str:
        self.btstr = xslt_transform(templates.smx2btj_xslt, s)
        self.bttree = None

    def load_cii(self, s: str) -> str:
        self.btstr = xslt_transform(templates.cii2btj_xslt, s)
        self.bttree = None



    def dump_as_btj(self) -> str:
        if not self.btstr:
            self.btstr = yaml.dump(self.bttree)
        return self.btstr

    def dump_as_smj(self) -> str:
        if not self.btstr:
            self.btstr = yaml.dump(self.bttree)

        # replace BT??? with semantic model name
        s = re.sub("|".join(templates.replace_bt2sm.keys()),
                   lambda x: templates.replace_bt2sm[x.group(0)],
                   self.btstr)
        return s

    def dump_as_smx(self) -> str:
        if not self.bttree:
            self.bttree = yaml.safe_load(self.btstr)
        return chevron.render(templates.btj2smx_mustache, self.bttree)

    def dump_as_cii(self) -> str:
        if not self.bttree:
            self.bttree = yaml.safe_load(self.btstr)
        return chevron.render(templates.btj2cii_mustache, self.bttree)


