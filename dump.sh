#!/bin/sh

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

mkdir dics
rm -rf dics/*

aspell dump dicts | while read lang; do
    echo "$lang.dic"
    aspell --encoding=UTF-8 --lang="$lang" dump master | tee "dics/$lang.dic" | gzip > "dics/$lang.dic.gz"
done
