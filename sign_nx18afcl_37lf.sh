#!/bin/bash
unsigned_zip=$1
project=$2
signed_zip=$3
diff_zip=$4
signed_list_file=$5
signed_md5_file=$6
/mnt/github/ShellTest/shell_test.sh 179 $@
if [ $? -ne 0 ] ; then
    echo "***************************************"
    echo "*********************SIGN ERROR********"
    echo "Sign $project ($unsigned_zip) FAILED"
    echo "***sign_bv303b81t_gb************************************"
    exit 1
else
    echo "***************************************"
    echo "*********************SIGN OK********"
    echo "Sign $project ($unsigned_zip) OK"
    echo "***sign_bv303b81t_gb************************************"
fi

