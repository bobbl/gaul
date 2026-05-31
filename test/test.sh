#!/bin/sh
# Run several tests to check if conversion templates work


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
}


# Fetch git repositories if necessary
fetch_git () {
    mkdir -p download

    #try_git_clone https://github.com/itplr-kosit/xrechnung-testsuite.git
    try_git_clone https://projekte.kosit.org/xrechnung/xrechnung-testsuite.git

    #try_git_clone https://github.com/itplr-kosit/xrechnung-visualization.git
    try_git_clone https://projekte.kosit.org/xrechnung/xrechnung-visualization.git
}


# Copy and lint invoice examples to uniform directories
copy_invoices () {

    mkdir -p cii
    rm cii/*.xml
    for f in download/xrechnung-testsuite/src/test/business-cases/extension/*_uncefact.xml \
             download/xrechnung-testsuite/src/test/business-cases/standard/*_uncefact.xml \
             download/xrechnung-testsuite/src/test/technical-cases/cius/*_uncefact.xml \
             download/xrechnung-testsuite/src/test/technical-cases/cvd/*_uncefact.xml \
             download/xrechnung-visualization/src/test/instances/*-uncefact.xml
    do
        xsltproc pretty.xslt "$f" | \
            sed -f pretty_cii.sed > cii/$(basename "$f")
    done
    count_cii=$(ls cii/*.xml | wc -l)
    echo "Found $count_cii CII invoices"

    mkdir -p ubl
    rm ubl/*.xml
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
    echo "Found $count_cii UBL invoices"
}


# Generate SMX with KoSIT XSLT 2.0 template
gen_smx_with_kosit () {
    if [ -d smx ]
    then
        count_smx=$(ls smx/*.smx | wc -l)
    else
        count_smx=0
    fi
    if [ $count_smx -lt $count_cii ]
    then
        # For the XSLT 2.0 transformation it's easier to call SaxonC HE via Python
        uv run to_smx.py

        for f in smx/*.smx
        do
            # remove unnecessary additional attributes from the xr: tags
            # FIXME: if the attribute names appear within content, they are also removed there
            sed 's/xr:src="[^"]*"//; s/scheme_identifier="[^"]*"//; s/scheme_version_identifier="[^"]*"//' "$f" > tmp.noxrsrc

            # pretty print for comparison
            xsltproc pretty.xslt tmp.noxrsrc > smx/$(basename $f .xml.smx).smx
            rm "$f"
        done
    fi
}


# Test 01: SMX -> BTJ -> SMX'
test01_smx () {
    mkdir -p btj
    rm btj/*
    mkdir -p smx2
    rm smx2/*

    for f in smx/*.smx
    do
        echo "SMX -> BTJ -> SMX': $f"
        btj=btj/$(basename "$f" .smx).btj
        smx2=smx2/$(basename "$f")

        xsltproc ../templates/gen/smx2btj.xslt "$f" > "$btj"
        mustache "$btj" ../templates/gen/btj2smx.mustache > "$smx2"
    done
    diff smx/ smx2/ > tmp.diff
    if diff --color tmp.diff smx_smx2.diff
    then
        echo "${esc_white}Acceptable differences${esc} (&quot; and empty <xr:DELIVERY_INFORMATION>)"
    else
        echo "${esc_red}NOT OK${esc}"
    fi
}


# Test 02: [CII -> SMX -> BTJ] -> CII'
# uses files generated in Test 02
test02_cii () {
    mkdir -p cii2
    rm cii2/*

    for f in btj/*.btj
    do
        echo "BTJ -> CII': $f"
        cii2=cii2/$(basename "$f" .btj).xml

        mustache "$f" ../templates/btj2cii.mustache > "$cii2"
        #diff "$f" "$smx2"
    done

    diff cii/ cii2/ > tmp.diff
    if diff --color tmp.diff cii_cii2.diff
    then
        echo "${esc_white}Acceptable differences${esc}"
    else
        echo "${esc_red}NOT OK${esc}"
    fi
}




# Main program

check_dependencies
fetch_git
copy_invoices
gen_smx_with_kosit

back=$(pwd)
cd ../templates
uv run gen.py
cd "$back"

test01_smx
test02_cii




# SPDX-License-Identifier: ISC

