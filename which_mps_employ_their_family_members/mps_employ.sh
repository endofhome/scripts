#!/bin/bash

# colours
RED=`tput setaf 1`
RESET=`tput sgr0`

TOTAL_MPS=$(wc -l < list_of_mps.txt | tr -d ' ') && let "TOTAL_MPS++"
COUNTER=1
MPS_FOUND=0
OUTPUT_FILE="mps_employ.csv"

echo "Scanning MP list..."

for MP_NAME in $(cat list_of_mps.txt | sed 's/^M$//')
do 
  EMPLOYED=$(curl -s https://www.publications.parliament.uk/pa/cm/cmregmem/170220/$MP_NAME.htm | grep 'I employ' | grep -o '>.*<' | tr -d '<>' | sed 's/^span class="highlight"//' | sed 's/\/span//')
  if [[ -n "$EMPLOYED"  ]]; then
    let "MPS_FOUND++"
  fi
  echo "$MP_NAME,\"$EMPLOYED\"" >> $OUTPUT_FILE
  printf "Checked $COUNTER/$TOTAL_MPS MPs. Found ${RED}$MPS_FOUND${RESET} MPs who employ their family members.\r"
  let "COUNTER++"
done

printf "\n"
echo "CSV report saved at $OUTPUT_FILE"
