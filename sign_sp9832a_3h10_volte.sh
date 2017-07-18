#!/bin/bash
echo $@
unsigned_zip=$1
project=$2
signed_zip=$3
diff_zip=$4
signed_list_file=$5
/mnt/github/ShellTest/shell_test.sh 164 $@
if [ $? -ne 0 ] ; then
    echo "***************************************"
    echo "*********************SIGN ERROR********"
    echo "Sign $project ($unsigned_zip) FAILED"
    echo "***************************************"
    exit 1;
else
    echo "***************************************"
    echo "*********************SIGN ERROR********"
    echo "Sign $project ($unsigned_zip) OK"
    echo "***************************************"
fi

