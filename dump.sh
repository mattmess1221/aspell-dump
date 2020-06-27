#!/bin/bash

# Dumps all the installed aspell dictionaries to the dics directory. There will
# also be a gzipped copy.

# Install the following packages first.
# ubuntu
# sudo apt-get install aspell*
#
# centos 7
# sudo yum install apsell*
#
# fedora + centos 8
# sudo dnf install aspell*

mkdir -p dics
rm -rf dics/*

aspell dump dicts | while read -r lang; do
    key="${lang:0:2}"
    mkdir -p "dics/$key"
    dic="dics/$key/$lang.dic"

    echo "Dumping $dic"

    aspell --encoding=UTF-8 --lang="$lang" dump master | tee "$dic" | gzip > "$dic.gz"
done
