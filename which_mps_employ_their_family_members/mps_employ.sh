#!/bin/bash

# colours
RED=`tput setaf 1`
NC=`tput sgr0`

TOTAL_MPS=$(wc -l < list_of_mps.txt | tr -d ' ') && let "TOTAL_MPS++"
COUNTER=1
MPS_FOUND=0
OUTPUT_FILE="mps_employ.csv"
ERROR_FILE="errors_mps_employ.csv"
ERRORS=false

function main {
  cleanUp

  for MP_NAME in $(cat list_of_mps.txt | stripDOSLineEndings )
  do
    MP_URL="https://www.publications.parliament.uk/pa/cm/cmregmem/170306/$MP_NAME.htm"
    MP_HTML_PAGE=$(curl -s $MP_URL)
    checkForAndLogIfError
    local EMPLOYMENT=$(echo "$MP_HTML_PAGE" | grep 'I employ ' | grep -o '>.*<' | tr -d '<>' | sed 's/^span class="highlight"//' | sed 's/\/span//')

    if [[ -n "$EMPLOYMENT"  ]]; then
      let "MPS_FOUND++"
    fi

    echo "$MP_NAME,\"$EMPLOYMENT\"" >> $OUTPUT_FILE
    printf "Checked $COUNTER/$TOTAL_MPS MPs. Found ${RED}$MPS_FOUND${NC} MPs who employ their family members.\r"
    let "COUNTER++"
  done

  printf "\n"
  echo "CSV report saved at $OUTPUT_FILE"
  reportAnyErrors
}

function cleanUp {
  if [[ -s $OUTPUT_FILE ]]; then
    rm $OUTPUT_FILE
  fi

  if [[ -s $ERROR_FILE ]]; then
    rm $ERROR_FILE
  fi
}

function stripDOSLineEndings {
  sed 's/^M$//'
}

function checkForAndLogIfError {
  if [[ -n $(echo "$MP_HTML_PAGE" | grep "<meta property=\"og:title\" content=\"Page cannot be found\"/>") ]]; then
    echo "$MP_NAME,$MP_URL" >> $ERROR_FILE
    ERRORS=true
  fi
}

function reportAnyErrors {
  if [[ $ERRORS = true ]]; then
    echo "Errors were found. Please check $ERROR_FILE."
  fi
}

main
