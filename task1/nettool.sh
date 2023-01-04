#!/bin/bash
ARGS=$#
ARG1=$1
ARG2=$2
print_info(){
  echo "Please use one of the keys:"
  echo "-a/--all to scan all hosts in network"
  echo "-t/--target <ip/hostname> to scan open TCP ports"
} 

scan_all(){
  echo "Enter one of your network:"
  ip addr | grep -E -o "([0-9]{1,3}[\.]){3}[0-9]{1,3}\/[0-9]{2}"
  read IPADDRESS
  echo "Active devices:"
  nmap -sn $IPADDRESS | grep -E -o "([0-9]{1,3}[\.]){3}[0-9]{1,3}"
}

scan_target_ports(){
  echo "Open tcp ports on target host:"
  nmap -sT $TARGET_ADDRESS | grep "tcp"
} 

case $ARGS in
  1)
   if [ $ARG1 == "-a" ] ||[ $ARG1 == "--all" ]
     then
       scan_all
     else
       print_info
   fi
   ;;
  2)
   if [ $ARG1 == "-t" ] || [ $ARG1 == "--target" ]
     then
       TARGET_ADDRESS=$ARG2
       scan_target_ports
     else
       print_info
   fi
   ;;
  *)
   print_info
   ;;
esac

