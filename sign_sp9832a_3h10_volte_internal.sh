#!/bin/bash
echo "given folder1 unsigned & project_name"
    echo "sign unsigned.zip"
    echo "get diff between unsigned.zip & signed.zip"
    echo "create filelist.txt"
    echo "SPRD, bv303c"
    echo "/mnt/sign_server/sign_sp9832a_3h10_volte.sh"
    echo "run on /mnt/sign_server"
    unsigned_zip=$1
    project=$2

    current_dir=`pwd`
    sign_workspace="/tmp"
    tmp_path="/data/app/sign-zip/sign-zip/tmp"
    if [ ! -d $tmp_path ] ; then
        mkdir -p $tmp_path
    fi
    sign_workspace="$tmp_path""/workspace"
    if [ ! -d $sign_workspace ] ; then
        mkdir -p $sign_workspace
    fi
    zip_folder=`dirname $unsigned_zip`
    zip_name=`basename $unsigned_zip`
    postfix=`echo $zip_name|awk -F '.' '{print $NF}'`
    zip_filename=`echo $zip_name|awk -F "[.]$postfix" '{print $1}'`

#    signed_zip="$sign_workspace""/""$zip_filename""_signed"".""$postfix"
#    diff_zip="$sign_workspace""/""$zip_filename""_diff"".""$postfix"
#    signed_list_file="$sign_workspace""/""$zip_filename""_signed_list.txt"
    signed_zip=$3
    diff_zip=$4
    signed_list_file=$5
    signed_md5_file=$6

    # clean & mkdir
    unsigned_unzip="$sign_workspace""/""$zip_name""_unzip/"
    diff_folder="$sign_workspace""/""$zip_name""_diff/"
    signed_new_folder="$sign_workspace""/""$zip_name""_singed_new/"
    rm -rf $signed_list_file
    rm -rf $signed_md5_file
    rm -rf $unsigned_unzip
    rm -rf $diff_folder
    rm -rf $signed_new_folder
    mkdir -p $unsigned_unzip
    mkdir -p $diff_folder
    mkdir -p $signed_new_folder

    #unzip
    echo x | unzip -j $unsigned_zip -d $unsigned_unzip
    if [ $? -ne 0 ] ; then
#        echo "ERROR***************************"
        echo "unzip $unsigned_zip,"
        echo "it is not allowed to have subdirs more than 1 on $unsigned_zip"
#        rm -rf $tmp_path
#        exit 1;
    fi

    project_path=$current_dir"/sprd/sp9832a_3h10_volte"
#    $script 158 $unsigned_unzip $diff_folder
##############################################
#    echo "sign unsigned/ ,overide unsigned/"
#    echo "spreadtrum,sp9832a_3h10_volte"
    # absolute path
#    cd $project_path    
    store_path=$unsigned_unzip
#    diff_folder=$diff_folder
#    current_dir=`pwd`


    # sign
#    sprd_secure_boot_tool_path="$current_dir""/sprd_secure_boot_tool/"
    sprd_secure_boot_tool_path="$project_path""/sprd_secure_boot_tool/"

    cd "$sprd_secure_boot_tool_path"
    /bin/bash ./sig_script.sh $store_path
    #
 #   cd $store_path
    cd $current_dir
    /bin/bash ./sp9832a_3h10_volte_handle_signed_imgs.sh $project_path $store_path
#    cd $project_path

    dir $store_path"/signed/override/" > $signed_list_file

    # make diff
    /bin/bash ./diff_folder_sp9832a_3h10_volte.sh $store_path"/signed/override/" $store_path $diff_folder $signed_new_folder
    if [ $? -ne 0 ] ; then
        #clean
        rm -rf $diff_folder
        rm -rf $signed_new_folder
        rm -rf $unsigned_unzip
        rm -rf $tmp_path
        exit 1;
    fi

    cp $store_path"/signed/override/"* $store_path
    rm -rf $store_path"/signed/"
##############################################

    cd $diff_folder
    zip $diff_zip ./*
    cd $current_dir

    #clean
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

    #clean
    rm -rf $unsigned_unzip
    rm -rf $tmp_path
