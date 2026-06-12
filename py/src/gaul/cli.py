import sys

from .convert import Gaul


def help():
    print("""Gaul converter between electronic invoice formats

Usage: gaul [options] [input files]

Options:
  -f FORMAT     specify input format ('auto' for auto detection)
  -t FORMAT     specify output format (default BTJ)
  -o FILENAME   write to file, according to output format

Supported formats:
  CII   Cross-Industry Invoice
  BTJ   Gaul internal format: JSON of business terms from EN 16931
  SMJ   Semantic model from EN 16931 encoded in JSON (defined by Gaul)
  SMX   Semantic model from EN 16931 encoded in XML (defined by KoSIT)
""")



def open_inputfile(filename):
    if filename == "-":
        return sys.stdin
    else:
        return open(filename, "r")

def open_outputfile(filename):
    if filename == "-":
        return sys.stdout
    else:
        return open(filename, "w")



def main():

    argc = len(sys.argv)

    no_input = True
    no_output = True
    format_from = "auto"
    format_to = "BTJ"
    g = Gaul()

    i = 1
    while i < argc:
        arg = sys.argv[i]
        if arg[0] == "-":
            if arg == "-h" or arg == "--help":
                help()

            elif arg[1] == 'f':
                i += 1
                format_from = sys.argv[i].upper()
                if format_from == "AUTO":
                    format_from = ""
                elif not Gaul.format_supported(format_from):
                    sys.exit(f"Unknown input format {format_from}")
                #print(f"Set input format to {format_from}")

            elif arg[1] == 't':
                i += 1
                format_to = sys.argv[i].upper()
                if not Gaul.format_supported(format_to):
                    sys.exit(f"Unknown output format {format_to}")
                #print(f"Set output format to {format_to}")

            elif arg[1] == 'o':
                no_output = False
                transformed = g.dump(format_to)
                i += 1
                with open_outputfile(sys.argv[i]) as f:
                    f.write(transformed)

            else:
                sys.exit(f"Unknown option {arg}")

        else:
            no_input = False
            with open_inputfile(arg) as f:
                input_content = f.read()
                g.load(input_content, format=format_from)

        i += 1


    if no_input:
        help()
        sys.exit("No input files")
    if no_output:
        sys.exit("No output file specified. Use '-o -' for stdout.")




if __name__ == "__main__":
    main()

