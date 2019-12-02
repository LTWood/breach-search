#!/bin/bash

if [ $# -lt 2]; then
	echo "Breach Search"
	echo ""
	echo "Usage: ./breach-search.sh <email or domain to search> <file to output> [data location]"
else
	breachDataLocation="$3"
	fullfile=$2
	fileBaseName=$(basename "$fullfile" | cut -d. -f1)
	master=$fileBaseName.txt
	users=$fileBaseName-users.txt
	passwords=$fileBaseName-passwords.txt

	touch $master
	totalFile=$(find "$breachDataLocation" -type f -not -path '/\.*' | wc -1)
	fileCount=0

	#Stole from github
	function ProgressBar(){
		let _progress=$(((fileCount * 100 / totalFiles * 100) / 100))
		let _done=$(((_progress * 4) / 10))
		let _left=$((40 - _done))

		_fill=$(printf "%${_done}s")
		_empty=$(printf "%${_left}s")

		printf "\rProgress: [${_fill// /\#}${_empty// /-}] ${_progress}%%"
	}

	find "$breachDataLocation" -type f -not -path '*/\.*' -print0 | while read -d $'\0' file; do
		grep -a -E "$1" "$file" >> $master
		((++fileCount))
		ProgressBar ${number} ${totalFiles}
	done
fi

sleep 3

echo
echo "Extracting usernames..."
awk -F':' '{print $1}' $master > $users

sleep 1

echo "Extracting passwords..."
awk -F':' '{print $2}' $master > $passwords
echo
exit 0
