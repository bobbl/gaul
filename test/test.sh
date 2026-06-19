#!/bin/sh
# Run several tests to check if conversion templates work


help() {
    echo "Usage: $0 <task> ..."
    echo
    echo "  tool    Test command line tool (written in python)"
    echo "  cii     Test convertion to and from CII"
    echo "  smx     Test conversion to and from SMX"
    echo "  kosit   Compare with KoSIT SMX conversion"
    echo "  all     Run all tests"
}

if [ $# -eq 0 ]
then
    help
    exit 1
fi





# Escape sequences for colored output
esc_white="\033[1;37m"
esc_green="\033[32m"
esc_red="\033[31m"
esc_orange="\033[33m"
esc="\033[0m"


# Check if command exists. Otherwise offer installation with apt
# $1 command name
# §2 package name
check_package () {
    if command -v "$1" > /dev/null 2>&1
    then
        echo "Found command '$1'"
    else
        echo "'$1' is missing. You can try 'sudo apt install $2' to install it."
        exit 1
    fi
}


# Check if git repo was already cloned
# $1 URL of git repository
try_git_clone () {
    cd download
    name=$(basename "$1" .git)
    if [ -d $name/.git ]
    then
        echo "Found git repo '$name'"
    else
        echo "Cloning '$1'"
        git clone "$1"
    fi
    cd ..
}


# Check if package dependencies are installed
check_dependencies () {
    check_package xsltproc xsltproc
    #check_package xsec-c14n xml-security-c-utils
}


# Fetch git repositories if necessary
fetch_git () {
    mkdir -p download

    #try_git_clone https://github.com/itplr-kosit/xrechnung-testsuite.git
    try_git_clone https://projekte.kosit.org/xrechnung/xrechnung-testsuite.git

    #try_git_clone https://github.com/itplr-kosit/xrechnung-visualization.git
    try_git_clone https://projekte.kosit.org/xrechnung/xrechnung-visualization.git

    try_git_clone https://github.com/ZUGFeRD/corpus.git

    #try_git_clone git@github.com:phax/en16931-cii2ubl.git
}


# Copy and lint invoice examples to uniform directories
copy_invoices () {

    mkdir -p cii
    rm -f cii/*.xml
    for f in download/xrechnung-testsuite/src/test/business-cases/extension/*_uncefact.xml \
             download/xrechnung-testsuite/src/test/business-cases/standard/*_uncefact.xml \
             download/xrechnung-testsuite/src/test/technical-cases/cius/*_uncefact.xml \
             download/xrechnung-testsuite/src/test/technical-cases/cvd/*_uncefact.xml \
             download/xrechnung-visualization/src/test/instances/*-uncefact.xml \
             other/en16931-cii2ubl/*.xml
    do
        xsltproc pretty.xslt "$f" > cii/$(basename "$f")
        #xmllint --format "$f" > cii/$(basename "$f")
        #xsec-c14n -n  "$f" | xsltproc pretty.xslt - > cii/$(basename "$f")
    done
    count_cii=$(ls cii/*.xml | wc -l)
    echo "Found $count_cii CII invoices"

    mkdir -p ubl
    rm -r ubl/*.xml
    for f in download/xrechnung-testsuite/src/test/business-cases/extension/*_ubl.xml \
             download/xrechnung-testsuite/src/test/business-cases/standard/*_ubl.xml \
             download/xrechnung-testsuite/src/test/technical-cases/cius/*_ubl.xml \
             download/xrechnung-testsuite/src/test/technical-cases/cvd/*_ubl.xml \
             download/xrechnung-visualization/src/test/instances/*_ubl.xml \
             download/xrechnung-visualization/src/test/instances/*_creditnote.xml
    do
        xsltproc pretty.xslt "$f" > ubl/$(basename "$f")
    done
    count_ubl=$(ls ubl/*.xml | wc -l)
    echo "Found $count_ubl UBL invoices"
}


test_cli () {
    back=$(pwd)
    cd ../py
    cp ../test/examples/i003.cii.xml .
    cp ../test/examples/i004.pdf .

    uv run gaul -f CII i003.cii.xml -t BTJ -o i003.btj
    uv run gaul -f CII i003.cii.xml -t SMJ -o i003.smj
    uv run gaul -f CII i003.cii.xml -t SMT -o i003.smt
    uv run gaul -f CII i003.cii.xml -t SMX -o i003.smx

    uv run gaul -f BTJ i003.btj -t CII -o i003.cii2
    uv run gaul -f SMJ i003.smj -t SMX -o i003.smx2
    uv run gaul -f SMT i003.smt -t SMJ -o i003.smj2
    uv run gaul -f SMX i003.smx -t SMT -o i003.smt2

    uv run gaul -f ZUGFeRD i004.pdf -t BTJ -o i004.btj
    uv run gaul -f ZUGFeRD i004.pdf -t CII -o i004.cii

    cd "$back"
}


test_cii_btj_cii () {
    mkdir -p btj
    rm -f btj/*
    mkdir -p cii_from_btj
    rm -f cii_from_btj/*

    for f in cii/*.xml
    do
        echo "CII -> BTJ -> CII': $f"
        btj=btj/$(basename "$f" .xml).btj
        cii_from_btj=cii_from_btj/$(basename "$f")

        xsltproc ../templates/cii2btj.xslt "$f" > "$btj"
        mustache "$btj" ../templates/btj2cii.mustache | \
            xsltproc pretty.xslt - > "$cii_from_btj"
    done

    diff cii/ cii_from_btj/ > tmp.diff
    if diff --color tmp.diff cii_btj_cii.diff
    then
        echo "${esc_white}Acceptable differences${esc}"
    else
        echo "${esc_red}NOT OK${esc}"
        exit
    fi
}


test_btj_smx_btj () {
    mkdir -p smx
    rm -f smx/*
    mkdir -p btj2
    rm -f btj2/*

    for f in btj/*.btj
    do
        echo "BTJ -> SMX -> BTJ': $f"
        smx=smx/$(basename "$f" .btj).smx
        btj2=btj2/$(basename "$f")

        mustache "$f" ../templates/gen/btj2smx.mustache > "$smx"
        xsltproc ../templates/gen/smx2btj.xslt "$smx" > "$btj2"
    done
    if diff --color btj/ btj2/
    then
        echo "${esc_white}No differences${esc}"
    else
        echo "${esc_red}NOT OK${esc}"
        exit
    fi
}


test_kosit_smx () {
    kosit_dir=kosit_smx
    rm -f $kosit_dir/*

    # For the XSLT 2.0 transformation it's easier to call SaxonC HE via Python
    uv run to_smx.py

    for f in $kosit_dir/*.smx
    do
        # remove unnecessary additional attributes from the xr: tags
        # FIXME: if the attribute names appear within content, they are also removed there
        sed 's/xr:src="[^"]*"//; s/scheme_identifier="[^"]*"//; s/scheme_version_identifier="[^"]*"//' "$f" > tmp.noxrsrc

        # pretty print for comparison
        xsltproc pretty.xslt tmp.noxrsrc > $kosit_dir/$(basename $f .xml.smx).smx
        rm "$f"
    done

    diff kosit_smx/ smx/ > tmp.diff
    if diff --color tmp.diff kosit_smx.diff
    then
        echo "${esc_white}Acceptable differences${esc}"
    else
        echo "${esc_red}NOT OK${esc}"
        exit
    fi
}




# Main program

check_dependencies
fetch_git
copy_invoices

back=$(pwd)
cd ../templates
uv run gen.py
cd "$back"

while [ $# -ne 0 ]
do
    case $1 in
        help)   help ;;
        tool)   test_cli ;;
        cii)    test_cii_btj_cii ;;
        smx)    test_btj_smx_btj ;;
        kosit)  test_kosit_smx ;;

        all)
            test_cli
            test_cii_btj_cii
            test_btj_smx_btj
            test_kosit_smx
            ;;

        *)
            echo "Unknown task $1. Stop."
            exit 1
            ;;
    esac
    shift
done


# SPDX-License-Identifier: ISC
