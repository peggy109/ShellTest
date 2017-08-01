#!/bin/bash
host=$1
username=$2
password=$3
source=$4
target=$5
operate=$6
ftp -n <<!
open $host
user $username $password
prompt 
$operate $source $target
close
bye
!

