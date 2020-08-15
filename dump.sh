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

hashsum() {
    sha1sum "$@" | cut -d' ' -f1
}

mkdir -p dics

aspell dump dicts | cut -d'-' -f1 | sort | uniq | while read -r lang; do
    key="${lang:0:2}"
    mkdir -p "dics/$key"
    dic="dics/$key/$lang.dic"

    echo "INFO: Dumping $lang"

    if [ -f "$dic" ]; then
        old_hash=$(hashsum "$dic")
    fi

    aspell --encoding=UTF-8 --lang="$lang" dump master > "$dic"
    if egrep -iq "/[AMCKLSOZ]" "$dic"; then
        echo "INFO: Expanding affixes in $dic."
        aspell --encoding=UTF-8 expand < "$dic" | tr " " "\n" > "$dic.expanded"
        
        if grep -q "?" "$dic.expanded"; then
            echo "WARN: Failed to expand affixes in $dic"
            rm "$dic.expanded"
        else
            mv "$dic.expanded" "$dic"
        fi
    fi

    new_hash=$(hashsum "$dic" | tee "$dic.sha1")

    if [ "$old_hash" != "$new_hash" ]; then
        echo "UPDATE: $lang dictionary had an update! Recompressing."
        gzip < "$dic" > "$dic.gz" 
        hashsum "$dic.gz" > "$dic.gz.sha1"
    fi
done
