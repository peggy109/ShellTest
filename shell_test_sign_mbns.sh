#!/bin/bash
# sign $image_path and override original mbns
#
image_path=$1
signed_path=$2
if [ ! -d $signed_path ] || [ ! -d $image_path ] ; then
    echo "$signed_path"' & '"$image_path"" should exist"
    echo "*****ERROR*****"
    exit -1;
fi
dat=`date +%Y%m%d_%H%M%S`

base_path=`dirname $0`
script_name=`basename $0`
script_path=`cd $base_path;pwd`
current_script="$script_path""/""$script_name"
echo "current_script : ""$current_script"

script="$script_path""/shell_test.sh"
log="/tmp/log.""$dat"".sign_mbns"
echo "tyd1111" |sudo -S $script 1355 $image_path $signed_path |tee $log
echo "*****DONE*****"
exit 0








