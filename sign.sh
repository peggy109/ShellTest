#!/bin/bash

# input
#   unsigned_zip
#   project
#   signed_folder
#   diff_zip
# output :
#   signed_zip
#   diff_zip
echo "sign.sh $@"
unsigned_zip=$1
project=$2

signed_folder=$3
diff_folder=$4

    
zip_folder=`dirname $unsigned_zip`
zip_name=`basename $unsigned_zip`
postfix=`echo $zip_name|awk -F '.' '{print $NF}'`
zip_filename=`echo $zip_name|awk -F "[.]$postfix" '{print $1}'`
signed_zip="$signed_folder""/""$zip_filename""_signed"".""$postfix"
diff_zip="$diff_folder""/""$zip_filename""_diff"".""$postfix"
signed_list_file="$signed_folder""/""$zip_filename""_signed_list.txt"


# clean & mkdir
rm -rf $signed_zip
rm -rf $diff_zip
if [ ! -d $signed_folder ] ; then
    mkdir -p $signed_folder;
fi
if [ ! -d $diff_folder ] ; then
    mkdir -p $diff_folder;
fi


#sign
tool="./sign_""$project"".sh" 
$tool $unsigned_zip $project $signed_zip $diff_zip $signed_list_file
if [ $? -ne 0 ] ; then
    echo "***************************************"
    echo "*********************SIGN ERROR********"
    echo "Sign $project ($unsigned_zip) FAILED"
    echo "***************************************"
    exit 1;
else
    echo "***************************************"
    echo "*********************SIGN OK***********"
    echo "Sign $project ($unsigned_zip) OK"
    echo "***************************************"
    exit 1;
fi

