#!/bin/bash
function get_images_to_sign_BSC_BIN_sprd()
{
    rootdir=$1
    cat $rootdir"/sprd_secure_boot_tool/sig_bin.ini"|grep 'BSC_BIN='| awk -F'BSC_BIN=' '{print $2}'
}
function get_images_to_sign_VLR_BIN_sprd()
{
    rootdir=$1
    cat $rootdir"/sprd_secure_boot_tool/sig_bin.ini"|grep 'VLR_BIN='| awk -F'VLR_BIN=' '{print $2}'
}
function get_images_to_sign_VLR_OTHER_BIN_sprd()
{
    rootdir=$1
    cat $rootdir"/sprd_secure_boot_tool/sig_bin.ini"|grep 'VLR_OTHER_BIN='| awk -F'VLR_OTHER_BIN=' '{print $2}'
}
function get_signature_filelist_sprd()
{
    rootdir=$1
    get_images_to_sign_BSC_BIN_sprd $rootdir
    get_images_to_sign_VLR_BIN_sprd $rootdir
    get_images_to_sign_VLR_OTHER_BIN_sprd $rootdir
}

function handle_signed_images()
{
    echo "spreadtrum,mv signed images to <path>/signed/override"
    echo "similar with 155"
    echo "spreadtrum"
    signed="signed"
    override=$signed"/override"
    mkdir $signed
    mkdir $override
    rootdir=$1
    echo "rootdir:$rootdir"
    images=$(get_signature_filelist_sprd $rootdir)
    echo "images:$images(end)"
    for image in $images
    do
        postfix=`echo $image|awk -F '.' '{print $NF}'`
        file_name=`echo $image|awk -F "[.]$postfix" '{print $1}'`
        signed_file_name="$file_name""-sign"".""$postfix"
        mv $signed_file_name $signed"/"$signed_file_name
        cp $signed"/"$signed_file_name "$override""/""$image"
    done
}
echo "spreadtrum,mv signed images to <path>/signed/override"
    echo "similar with 155"
    echo "spreadtrum"
    path=$2
    signed=$path"/signed"
    override=$signed"/override"
    mkdir $signed
    mkdir $override
    rootdir=$1
    echo "rootdir:$rootdir"
    echo "path:$path"
    images=$(get_signature_filelist_sprd $rootdir)
    echo "images:$images(end)"
    for image in $images
    do
        postfix=`echo $image|awk -F '.' '{print $NF}'`
        file_name=`echo $image|awk -F "[.]$postfix" '{print $1}'`
        signed_file_name="$file_name""-sign"".""$postfix"
        mv $path"/"$signed_file_name $signed"/"$signed_file_name
        cp $signed"/"$signed_file_name "$override""/""$image"
    done
