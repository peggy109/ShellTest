#!/bin/bash
echo "given folder1 unsigned & project_name"
    echo "sign unsigned.zip"
    echo "get diff between unsigned.zip & signed.zip"
    echo "create filelist.txt"
    echo "MTK, bv303b"
    echo "/mnt/sign_server/sign_bv303b81t_gb.sh"
    echo "similar with 163"
    echo "run on /mnt/sign_server"
    unsigned_zip=$1
    project=$2
    current_dir=`pwd`
    sign_workspace="/tmp/"
    tmp_path="/data/app/sign-zip/sign-zip/tmp"
    if [ ! -d $tmp_path ] ; then
        mkdir -p $tmp_path
    fi
    
    zip_folder=`dirname $unsigned_zip`
    zip_name=`basename $unsigned_zip`
    postfix=`echo $zip_name|awk -F '.' '{print $NF}'`
    zip_filename=`echo $zip_name|awk -F "[.]$postfix" '{print $1}'`
    #
#   signed_zip="$sign_workspace""/""$zip_filename""_signed"".""$postfix"
#   diff_zip="$sign_workspace""/""$zip_filename""_diff"".""$postfix"
    signed_zip=$3
    diff_zip=$4
    signed_list_file=$5
    signed_md5_file=$6
    # clean & mkdir
    unsigned_unzip="$current_dir""/MTK/mtk_release_$project/sign_image_split/out/target/product/""$project"
    diff_folder="$unsigned_unzip""/diff/"
    signed_new_folder="$unsigned_unzip""/signed_new/"
    rm -rf $signed_list_file
    rm -rf $signed_md5_file
    rm -rf $unsigned_unzip
    rm -rf $diff_folder
    rm -rf $signed_new_folder
    mkdir $unsigned_unzip
    mkdir -p $diff_folder
    mkdir -p $signed_new_folder

    # unzip
    echo x | unzip -j $unsigned_zip -d $unsigned_unzip
    if [ $? -ne 0 ] ; then
#        echo "ERROR***************************"
        echo "unzip $unsigned_zip,"
        echo "it is not allowed to have subdirs more than 1 on $unsigned_zip"
#        rm -rf $tmp_path
#        exit 1;
    fi
    ls -l $unsigned_unzip
    # sign
    cd $current_dir"/MTK/mtk_release_$project/sign_image_split/sign-image"
    echo "cd MTK/mtk_release_$project/sign_image_split/sign-image"
    pwd
    sed -i s/"^MTK_PROJECT_NAME := .*"/"MTK_PROJECT_NAME := $project"/g Android.mk
    sed -i s/"^MTK_PROJECT := .*"/"MTK_PROJECT := $project"/g Android.mk
    make -f Android.mk
    cd $current_dir

    # handle with signed images
    # mv xxx-sign.xxx xxx.xxx
    for file in `dir $unsigned_unzip"/signed_bin"`
    do
        filename=`echo $file|awk -F "-sign" '{print $1$2}'`;
        file_unsigned="$unsigned_unzip""/""$filename"
        file_signed="$unsigned_unzip""/signed_bin/""$file"
        echo $filename >> $signed_list_file
        mv $file_signed "$unsigned_unzip""/signed_bin/""$filename"
    done

    # make diff
    /bin/bash ./diff_folder_MTK.sh "$unsigned_unzip""/signed_bin/" $unsigned_unzip $diff_folder $signed_new_folder
    if [ $? -ne 0 ] ; then
#        rm -rf $unsigned_unzip
#        rm -rf $diff_folder
#        rm -rf $signed_new_folder
        rm -rf $tmp_path
        exit 1;
    fi
    
    cd $diff_folder
    zip $diff_zip ./*
    cd $current_dir

    # override unsigned images with signed ones
    cp "$unsigned_unzip""/signed_bin/"* "$unsigned_unzip""/"

    # clean
    rm -rf $unsigned_unzip"/sig/"
    rm -rf $unsigned_unzip"/signed_bin/"
    rm $unsigned_unzip"/"*"-verified"*
    rm -rf $diff_folder
    rm -rf $signed_new_folder

    cd $unsigned_unzip
    for f in `ls`
    do
        md5sum $f
        md5=`md5sum $f |awk '{print $1}'` 
        
        echo "$md5""   ""$f" |tee -a $signed_md5_file
    done
    zip $signed_zip ./*
    cd $current_dir

    # clean
#    rm -rf $unsigned_unzip
    rm -rf $tmp_path
