import sys

from .convert import Gaul, guess_format


def help():
    print("""Gaul converter between electronic invoice formats

Usage: gaul [options] [input files ...]

Options:
  -f FORMAT     specify input format ('auto' for auto detection)
  -t FORMAT     specify output format (default BTJ)
  -z PDFFILE    add PDF file and generate ZUGFeRD invoice
  -o FILENAME   write to file, according to output format
  -g FILENAME   guess invoice format of the file

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
        return open(filename, "rb")

def open_outputfile(filename):
    if filename == "-":
        return sys.stdout
    else:
        return open(filename, "wb")



def main():

    argc = len(sys.argv)

    no_input = True
    no_output = True
    output_filename = ""
    zugferd_filename = ""
    format_from = "auto"
    format_to = "BTJ"
    g = Gaul()

    i = 1
    while i < argc:
        arg = sys.argv[i]
        if arg[0] == "-":
            if arg == "-h" or arg == "--help":
                help()

            elif arg == "-f" or arg == "--from":
                i += 1
                if i >= argc:
                    sys.exit("Input format expected")
                format_from = sys.argv[i].upper()
                if format_from == "AUTO":
                    format_from = ""
                elif not Gaul.format_supported(format_from):
                    sys.exit(f"Unknown input format {format_from}")
                #print(f"Set input format to {format_from}")

            elif arg == "-t" or arg == "--to":
                i += 1
                if i >= argc:
                    sys.exit("Output format expected")
                format_to = sys.argv[i].upper()
                if format_to == "ZUGFERD":
                    sys.exit("Use -z to add PDF and generate ZUGFeRD invoice")
                if not Gaul.format_supported(format_to):
                    sys.exit(f"Unknown output format {format_to}")
                #print(f"Set output format to {format_to}")

            elif arg == "-z" or arg == "--zugferd":
                i += 1
                if i >= argc:
                    sys.exit("PDF filename for ZUGFeRD invoice expected")
                zugferd_filename = sys.argv[i]
                format_to = "ZUGFERD"

            elif arg == "-o" or arg == "--output":
                i += 1
                if i >= argc:
                    sys.exit("Output filename expected")
                output_filename = sys.argv[i]
                no_output = False

            elif arg == "-g" or arg == "--guess":
                i += 1
                if i >= argc:
                    sys.exit("Filename expected")
                with open_inputfile(sys.argv[i]) as f:
                    content = f.read()
                print(guess_format(content))

            else:
                sys.exit(f"Unknown option {arg}")

        else:
            no_input = False
            with open_inputfile(arg) as f:
                input_content = f.read()
                g.load(input_content, format=format_from)

        i += 1


    if no_output:
        if no_input:
            # nothing to do
            pass
        else:
            sys.exit("No output file specified. Use '-o -' for stdout.")
    else:
        if no_input:
            help()
            sys.exit("No input files")
        else:
            if format_to == "ZUGFERD":
                transformed = g.dump_as_zugferd(zugferd_filename)
            else:
                transformed = g.dump(format_to)
            with open_outputfile(output_filename) as f:
                f.write(transformed)




if __name__ == "__main__":
    main()

