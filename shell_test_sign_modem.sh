#!/bin/bash
BIN=$1
path=$2
mount_point="$path""/modem"
image_path="$mount_point""/image"
#image_path="/tmp/non_hlos_little/modem/image/modem_pr/mcfg/configs/mcfg_sw/generic/"
joined_path="$path""/joined"
signed_path="$path""/signed"
if [ ! -d $mount_point ] || [ ! -d $joined_path ] || [ ! -d $signed_path ] ; then
    echo "$mount_point & $joined_path & $signed_path should exists"
    mkdir -p $mount_point
    echo "*****ERROR*****"
    exit -1;
fi
dat=`date +%Y%m%d_%H%M%S`
script="/mnt/github/ShellTest/shell_test.sh"
log="/tmp/log.""$dat"".sign_non_hlos"
echo "tyd1111" |sudo -S mount $BIN $mount_point
echo "tyd1111" |sudo -S $script 132 $image_path $signed_path $joined_path |tee $log
echo "tyd1111" |sudo -S umount $mount_point
echo "*****DONE*****"
exit 0








