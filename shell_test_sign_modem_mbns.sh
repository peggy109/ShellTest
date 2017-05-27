#!/bin/bash
# script
workspace="/tmp/non_hlos_for_nocompany"
BIN=$1
#BIN="/tmp/NON-HLOS_little.bin"
image_path=$2
mbns_signed_path="$workspace""/mbns_signed/"
mount_point="$workspace""/modem"
joined_path="$workspace""/joined"
signed_path="$workspace""/signed"

sign_modem="/mnt/github/ShellTest/shell_test_sign_modem.sh"
sign_mbns="/mnt/github/ShellTest/shell_test_sign_mbns.sh"

if [ ! -f $BIN ] ; then
    echo "They should have been existed: $BIN ."
    echo "**********ERROR**********"
    exit 1
fi
if [ ! -d $image_path ] ; then
    echo "They should have been existed: $image_path ."
    echo "***********ERROR**********"
    exit 1
fi
echo "tyd1111" |sudo -S rm -rf $workspace/*
mkdir -p $mbns_signed_path
mkdir -p $mount_point
mkdir -p $joined_path
mkdir -p $signed_path
if [ ! -d $mbns_signed_path ] || [ ! -d $mount_point ] || [ ! -d $joined_path ] || [ ! -d $signed_path ] ; then 
    echo "They should have been created: $mbns_signed_path $mount_point $joined_path $signed_path ."
    echo "***********ERROR**********"
    exit 1
fi
echo $sign_modem $BIN $workspace
$sign_modem $BIN $workspace
if [ $? -ne 0 ] ; then
    exit -1
    echo "**********ERROR**********"
fi
echo $sign_mbns $image_path $mbns_signed_path 
$sign_mbns $image_path $mbns_signed_path 
if [ $? -ne 0 ] ; then
    exit -1
    echo "**********ERROR**********"
fi
echo "**********FINISH**********"



