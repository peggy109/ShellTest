#!/bin/bash
echo $@
unsigned_zip=$1
project=$2
signed_zip=$3
diff_zip=$4
signed_list_file=$5
signed_md5_file=$6
/bin/bash ./sign_ragentek_internal.sh $unsigned_zip $signed_zip
if [ $? -ne 0 ] ; then
    echo "***************************************"
    echo "*********************SIGN ERROR********"
    echo "Sign $project ($unsigned_zip) FAILED"
    echo "***sign_sp9832a_3h10_volte************************************"
    exit 1;
else
    echo "***************************************"
    echo "*********************SIGN OK********"
    echo "Sign $project ($unsigned_zip) OK"
    echo "***sign_sp9832a_3h10_volte************************************"
fi

