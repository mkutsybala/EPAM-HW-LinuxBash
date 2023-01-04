#!/bin/bash

SOURCE_FILE=$1

#get statistic about elements frequency in array
element_frequency(){
  ARRAY_NAME=$1[@]
  ARRAY=("${!ARRAY_NAME}")
  RESULTS=$2
  MAX_COUNT=0
  :>$RESULTS
  for ex_element in ${ARRAY[@]}
    do
      COUNT=0
      for int_element in ${ARRAY[@]}
        do
          if [ $ex_element == $int_element ]
            then
             ((COUNT++))
          fi
        done
      if [ $COUNT -gt $MAX_COUNT ]
        then
          MAX_COUNT=$COUNT
          MOST_FREQUENT_ELEMENT=$ex_element
      fi
      echo "$COUNT $ex_element" >> tmpresults
    done
  echo "$MOST_FREQUENT_ELEMENT             $MAX_COUNT"
  cat tmpresults | sort -rn | uniq > $RESULTS
  rm -f tmpresults

}
#print array elements
print_array(){
  ARRAY_NAME=$1[@]
  ARRAY=("${!ARRAY_NAME}")
  for element in ${ARRAY[@]}
  do
    echo $element
  done
 
}
#extract all ip addresses from log file to array
ALL_IP_ADDRESS=($(grep -E -o "([0-9]{1,3}[\.]){3}[0-9]{1,3}" $SOURCE_FILE | sort))

#extract all pages from log file to array
ALL_PAGES=($(grep -E -o "/[a-z].*\.html " $SOURCE_FILE))

#extract non existent pages code 404
NON_EXISTENT_PAGES=($(grep " 404 " $SOURCE_FILE | grep -E -o "/[a-z].*\.html "))

#extract hours from log file
HOURS=($(grep -E -o ":[0-9]{2}:" $SOURCE_FILE | grep -Eo "[0-9]{2}"))

#extract all bot requests from log file to tmp file
grep -E "\+http" $SOURCE_FILE | grep -E "\(.*\)\"" > all_bot_requests_tmp

#extract all bot ip to file
grep -E -o "([0-9]{1,3}[\.]){3}[0-9]{1,3}" all_bot_requests_tmp > all_bot_ip

#extract all boot UA to file
grep -E -o "\(.*\)\"" all_bot_requests_tmp > all_bot_ua

#concatenate bot ip and bot UA to result file
paste all_bot_ip all_bot_ua > bot_results
rm -f all_bot_requests_tmp all_bot_ip all_bot_ua

#Get statistic about elements frequency in IP address array
echo "1. Most frequent IP: "
element_frequency ALL_IP_ADDRESS ip_address_statistic

#Get statistic about elements frequency in page array
echo "2. The most requested page: "
element_frequency ALL_PAGES page_statistic
rm -f page_statistic

echo "3. Requests per IP: "
cat ip_address_statistic
rm -f ip_address_statistic

echo "4. Client reffered to the next non existent pages:"  
print_array NON_EXISTENT_PAGES

#Get statistic about element frequency in hours array
echo "5. We receive most of request at: "
element_frequency HOURS hours_statistic
rm -f hours_statistic

echo "6. The next bots visited our site:"
cat bot_results
rm -f bot_results
