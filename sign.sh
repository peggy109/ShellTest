#!/bin/bash

# input
#   unsigned_zip
#   project
#   signed_folder
#   diff_zip
# output :
#   signed_zip
#   diff_zip
function get_prop_from_config()
{
    config=$1
    key=$2
    for l in `cat $config`
    do
        l_key=`echo $l|awk -F '=' '{print $1}'`
        l_value=`echo $l|awk -F '=' '{print $2}'`
        if [ "$key" == "$l_key" ] ; then
            echo $l_value
            return 0;
        fi
    done
    return 1;
}

echo "sign.sh $@"
unsigned_zip=$1
project=$2

signed_folder=$3
diff_folder=$4


unsigned_folder=`dirname $unsigned_zip`
zip_name=`basename $unsigned_zip`
postfix=`echo $zip_name|awk -F '.' '{print $NF}'`
zip_filename=`echo $zip_name|awk -F "[.]$postfix" '{print $1}'`
signed_zip="$signed_folder""/""$zip_filename""_signed"".""$postfix"
diff_zip="$diff_folder""/""$zip_filename""_diff"".""$postfix"
signed_list_file="$signed_folder""/""$zip_filename""_signed_list.txt"


signed_zip=$3
diff_zip=$4
signed_folder=`dirname $signed_zip`
diff_folder=`dirname $diff_zip`
signed_list_file="$signed_folder""/""$zip_filename""_signed_list.txt"
signed_md5_file="$signed_folder""/""$zip_filename""_signed_md5.txt"


# clean & mkdir
rm -rf $signed_zip
rm -rf $diff_zip
ls -l $signed_folder
ls -l $diff_folder
if [ ! -d $signed_folder ] ; then
    mkdir -p $signed_folder;
fi
if [ ! -d $diff_folder ] ; then
    mkdir -p $diff_folder;
fi


#sign
tool="./sign_""$project"".sh" 
dat=`date +%Y%m%d_%H%M%S_%N`
LOG_PATH=$(get_prop_from_config ./config "LOG_PATH")
if [ ! -d $LOG_PATH ] ; then
    mkdir -p $LOG_PATH
fi
LOG_PATH="$LOG_PATH""/""$project""_""$zip_name""_""$dat"".log"
echo "LOG_PATH="$LOG_PATH
if [ ! -f $unsigned_zip ] ; then
    echo "$unsigned_zip is not found!" 2>&1 | tee  -a $LOG_PATH
    echo "***************************************" 2>&1 | tee  -a $LOG_PATH
    echo "*********************SIGN ERROR********" 2>&1 | tee  -a $LOG_PATH
    echo "Sign $project ($unsigned_zip) FAILED" 2>&1 | tee  -a $LOG_PATH
    echo "log is stored in $LOG_PATH" 2>&1 | tee  -a $LOG_PATH
    echo "***************************************" 2>&1 | tee  -a $LOG_PATH
    exit 1;
fi
$tool "$unsigned_zip" "$project" "$signed_zip" "$diff_zip" "$signed_list_file" "$signed_md5_file" 1> $LOG_PATH 2>&1
if [ $? -ne 0 ] ; then
    echo "***************************************" 2>&1 | tee  -a $LOG_PATH
    echo "*********************SIGN ERROR********" 2>&1 | tee  -a $LOG_PATH
    echo "Sign $project ($unsigned_zip) FAILED" 2>&1 | tee  -a $LOG_PATH
    echo "log is stored in $LOG_PATH" 2>&1 | tee  -a $LOG_PATH
    echo "***************************************" 2>&1 | tee  -a $LOG_PATH
    exit 1;
else
    echo "***************************************" 2>&1 | tee  -a $LOG_PATH
    echo "*********************SIGN OK***********" 2>&1 | tee  -a $LOG_PATH
    echo "Sign $project ($unsigned_zip) OK" 2>&1 | tee  -a $LOG_PATH
    echo "***************************************" 2>&1 | tee  -a $LOG_PATH
fi

exit 0;
