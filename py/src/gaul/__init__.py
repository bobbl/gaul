import sys

from .convert import *

def main() -> None:
    g = Gaul()
    with open(sys.argv[1], 'r') as f:
        g.load_smj(f.read())
    print(g.dump_as_cii())
