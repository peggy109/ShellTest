#!/bin/bash
ip=$1
username=$2
password=$3
source=$4
target=$5
host=`echo $ip | awk -F ":" '{print $1}'`
port=`echo $ip | awk -F ":" '{print $2}'`
echo "**********"
echo "host:$host"
echo "port:$port"
echo "username:$username"
#echo "password:$password"
echo "source:$source"
echo "target:$target"
echo "**********"
ftp -n <<!
open $host $port
user $username $password
prompt 
put $source $target
close
bye
!

