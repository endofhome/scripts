#!/bin/bash

# colours
RED=`tput setaf 1`
RESET=`tput sgr0`

for MP_NAME in $(cat list_of_mps.txt)
do 
  EMPLOYED=$(curl -s https://www.publications.parliament.uk/pa/cm/cmregmem/170220/$MP_NAME.htm | grep 'I employ' | grep -o '>.*<' | tr -d '<>' | sed 's/^span class="highlight"//' | sed 's/\/span//')
  echo "$MP_NAME,\"$EMPLOYED\"" >> mps_employ.csv
  if [[ -z "$EMPLOYED"  ]]; then
    printf "."
  else
    printf "${RED}.${RESET}"
  fi
done

printf "\n"
