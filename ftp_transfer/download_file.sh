#!/bin/bash
ip=$1
username=$2
password=$3
source=$4
target=$5
host=`echo $ip | awk -F ":" '{print $1}'`
port=`echo $ip | awk -F ":" '{print $2}'`
ftp -n <<!
open $host $port
user $username $password
binary
prompt 
get $source $target
close
bye
!


