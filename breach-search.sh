#!/usr/bin/env bash

if [ $# -lt 2 ]; then
    echo "Breach Search by Luke Wood"
    echo " "
    echo "Usage: ./breach-parse.sh <domain to search> <file to output> [breach data location]"
    exit 1
else
    breachDataLocation="$3"
    fullfile=$2
    fileBaseName=$(basename "$fullfile" | cut -d. -f1)
    master=$fileBaseName-master.txt
    users=$fileBaseName-users.txt
    passwords=$fileBaseName-passwords.txt

    touch $master
    totalFiles=$(find "$breachDataLocation" -type f -not -path '*/\.*' | wc -l)
    fileCount=0

    # Stole from SatckOverflow
    function ProgressBar() {

        let _progress=$(((fileCount * 100 / totalFiles * 100) / 100))
        let _done=$(((_progress * 4) / 10))
        let _left=$((40 - _done))

        _fill=$(printf "%${_done}s")
        _empty=$(printf "%${_left}s")

        printf "\rProgress : [${_fill// /\#}${_empty// /-}] ${_progress}%%"

    }

    find "$breachDataLocation" -type f -not -path '*/\.*' -print0 | while read -d $'\0' file; do
        grep -a -E "$1" "$file" >>$master
        ((++file_Count))
        ProgressBar ${number} ${totalFiles}

    done
fi

sleep 3

echo # newline
echo "Extracting usernames..."
awk -F':' '{print $1}' $master >$users

sleep 1

echo "Extracting passwords..."
awk -F':' '{print $2}' $master >$passwords
echo
exit 0

