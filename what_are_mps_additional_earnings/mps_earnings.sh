#!/bin/bash

# colours
RED=`tput setaf 1`
NC=`tput sgr0`

TOTAL_MPS=$(wc -l < list_of_mps.txt | tr -d ' ') && let "TOTAL_MPS++"
COUNTER=1
MPS_FOUND=0
OUTPUT_FILE="mps_earnings.csv"
ERROR_FILE="errors_mps_earnings.csv"
ERRORS=false

function main {
  cleanUp

  for MP_NAME in $(cat list_of_mps.txt | stripDOSLineEndings )
  do
    MP_URL="https://www.publications.parliament.uk/pa/cm/cmregmem/170306/$MP_NAME.htm"
    MP_HTML_PAGE=$(curl -s $MP_URL)
    checkForAndLogIfError
     
    local EARNINGS=$(echo "$MP_HTML_PAGE" | awk '/Employment/{flag=1;next}/<strong>/{flag=0}flag' | grep -o '>.*<' | sed $'s/<p>/\\n/g' | tr -d '<>' | sed 's/^span class="highlight"//' | sed 's/\/span//' | sed -E '/Previous/,$ d')

    if [[ -n "$EARNINGS"  ]]; then
      let "MPS_FOUND++"
    fi

    IFS=$'\n'
    for ENTRY in $EARNINGS
    do
      echo "$MP_NAME,\"$ENTRY\"" >> $OUTPUT_FILE
      MP_NAME=""
    done

    printf "Checked $COUNTER/$TOTAL_MPS MPs. Found ${RED}$MPS_FOUND${NC} MPs who have declared additional earnings.\r"
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
