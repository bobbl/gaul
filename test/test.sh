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
    #check_package xsec-c14n xml-security-c-utils
}


# Fetch git repositories if necessary
fetch_git () {
    mkdir -p download

    #try_git_clone https://github.com/itplr-kosit/xrechnung-testsuite.git
    try_git_clone https://projekte.kosit.org/xrechnung/xrechnung-testsuite.git

    #try_git_clone https://github.com/itplr-kosit/xrechnung-visualization.git
    try_git_clone https://projekte.kosit.org/xrechnung/xrechnung-visualization.git

    #try_git_clone git@github.com:phax/en16931-cii2ubl.git
}


# Copy and lint invoice examples to uniform directories
copy_invoices () {

    mkdir -p cii
    rm cii/*.xml
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
    echo "Found $count_ubl UBL invoices"
}


# Generate SMX with KoSIT XSLT 2.0 template
gen_smx_with_kosit () {
    kosit_dir=kosit_smx

    if [ -d $kosti_dir ]
    then
        count_smx=$(ls $kosit_dir/*.smx | wc -l)
    else
        mkdir -p $kosit_dir
        count_smx=0
    fi
    if [ $count_smx -ne $count_cii ]
    then
        rm $kosit_dir/*

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
        mustache "$btj" ../templates/gen/btj2smx.mustache | \
            xsltproc pretty.xslt - > "$smx2"
    done
    diff smx/ smx2/ > tmp.diff
    if diff --color tmp.diff smx_smx2.diff
    then
        echo "${esc_white}Acceptable differences${esc} (&quot; and empty <xr:DELIVERY_INFORMATION>)"
    else
        echo "${esc_red}NOT OK${esc}"
        exit
    fi
}


# Test 02: [CII -> SMX -> BTJ] -> CII'
# uses files generated in Test 01
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
        exit
    fi
}


# Test 03: compare KoSIT CII -> SMX with Gaul CII -> BTJ -> SMX
test03_smx () {
    mkdir -p btj
    rm btj/*
    mkdir -p smx3
    rm smx3/*

    for f in cii/*.xml
    do
        echo "Gaul CII -> BTJ -> SMX': $f"
        btj=btj/$(basename "$f" .xml).btj
        smx3=smx3/$(basename "$f" .xml).smx

        xsltproc ../templates/cii2btj.xslt "$f" > "$btj"
        mustache "$btj" ../templates/gen/btj2smx.mustache > "$smx3"
    done

    diff smx/ smx3/ > tmp.diff
    if diff --color tmp.diff smx_smx3.diff
    then
        echo "${esc_white}Acceptable differences${esc} (&quot; and empty <xr:DELIVERY_INFORMATION>)"
    else
        echo "${esc_red}NOT OK${esc}"
        exit
    fi
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






# Main program

check_dependencies
fetch_git
copy_invoices
gen_smx_with_kosit

back=$(pwd)
cd ../templates
uv run gen.py
cd "$back"

#test01_smx
#test02_cii
#test03_smx

test_cii_btj_cii
test_btj_smx_btj


# SPDX-License-Identifier: ISC

