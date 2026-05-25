#!/bin/sh

cii2smx=download/xrechnung-visualization/src/xsl/cii-xr.xsl





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
    :
}


# Fetch git repositories if necessary
fetch_git () {
    mkdir -p download

    #try_git_clone https://github.com/itplr-kosit/xrechnung-testsuite.git
    try_git_clone https://projekte.kosit.org/xrechnung/xrechnung-testsuite.git

    #try_git_clone https://github.com/itplr-kosit/xrechnung-visualization.git
    try_git_clone https://projekte.kosit.org/xrechnung/xrechnung-visualization.git
}


# Copy invoice examples to uniform directories
copy_invoices () {
    mkdir -p cii
    cp download/xrechnung-testsuite/src/test/business-cases/extension/*_uncefact.xml cii/
    cp download/xrechnung-testsuite/src/test/business-cases/standard/*_uncefact.xml cii/
    cp download/xrechnung-testsuite/src/test/technical-cases/cius/*_uncefact.xml cii/
    cp download/xrechnung-testsuite/src/test/technical-cases/cvd/*_uncefact.xml cii/
    cp download/xrechnung-visualization/src/test/instances/*-uncefact.xml cii/

    mkdir -p ubl
    cp download/xrechnung-testsuite/src/test/business-cases/extension/*_ubl.xml ubl/
    cp download/xrechnung-testsuite/src/test/business-cases/standard/*_ubl.xml ubl/
    cp download/xrechnung-testsuite/src/test/technical-cases/cius/*_ubl.xml ubl/
    cp download/xrechnung-testsuite/src/test/technical-cases/cvd/*_ubl.xml ubl/
    cp download/xrechnung-visualization/src/test/instances/*_ubl.xml ubl/
    cp download/xrechnung-visualization/src/test/instances/*_creditnote.xml ubl/
}





check_dependencies
fetch_git
copy_invoices



# SPDX-License-Identifier: ISC

