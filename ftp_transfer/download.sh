#!/bin/bash

ftpfile=$1
username=$2
filename=`basename $ftpfile`
target="/data/vsftp/dragon/upload/""$filename"

base_path=`dirname $0`
script_folder=`cd $base_path;pwd`
/bin/bash $script_folder"/download_ftp_file.sh" $ftpfile $username $target
