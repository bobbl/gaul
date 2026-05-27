# /// script
# requires-python = ">=3.12"
# dependencies = [
#     "saxonche>=12.9.0",
# ]
# ///

import os
import sys
import saxonche

# Apply the XSLT 2.0 stylesheet on all files in src_path and store them in
# dest_path
def xslt2_in_dir(xslt_file: str, src_dir: str, dst_dir: str) -> None:
    if not os.path.exists(xslt_file):
        print(f"XSLT file '{xslt_file}' not found")
        sys.exit(1)

    os.makedirs(src_dir, exist_ok=True)
    os.makedirs(dst_dir, exist_ok=True)

    proc = saxonche.PySaxonProcessor(license=False)
    xsltproc = proc.new_xslt30_processor()
    compiled = xsltproc.compile_stylesheet(stylesheet_file=xslt_file)

    for f in os.listdir(src_dir):
        src_filename = src_dir + f
        dst_filename = dst_dir + f + ".smx"
        print(f"Convert to semantic model XML: {src_filename}")
        compiled.transform_to_file(source_file=src_filename, output_file=dst_filename)


if __name__ == "__main__":
    xslt2_in_dir("download/xrechnung-visualization/src/xsl/cii-xr.xsl", "cii/", "smx/")
    #xslt2_in_dir("download/xrechnung-visualization/src/xsl/ubl-invoice-xr.xsl", "ubl/", "smx/")

