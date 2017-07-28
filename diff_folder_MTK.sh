#!/bin/bash
function get_images_to_sign_for_MTK()
{
    echo "boot.img	logo.bin	   system.img
cache.img	recovery.img  trustzone.bin
lk.bin	secro.img	   userdata.img
preloader_nx18afcl_37lf.bin
preloader_bv303b81t_gb.bin
"
}

# function 1:
#   echo "given folder.signed & folder.unsigned"
#   echo "folder diff = folder.signed - folder.unsigned"
#   echo "let folder.singed.new = folder.unsigned + diff"
#   echo "check if folder.singed.new == folder_signed"
#   echo input : 
#       signed_dir : requested (not empty)
#       unsgined_dir : requested (not empty)
#       diff_folder : requested (empty)
#       signed_new_dir : requested (tmp)
#       check : not requested
#       combine : not requested
#   echo "output :folder diff"
# function 2:
#   if check flag "true" is given
#   check if folder signed == folder unsigned + folder diffed
#   echo input : 
#       signed_dir : requested (not empty)
#       unsgined_dir : requested (not empty)
#       diff_folder : requested (not empty)
#       signed_new_dir : requested (tmp)
#       check : requested ("true")
#       combine : not requested
#   echo output :
#       nothing
# function 3:
#   echo "given folder.diff & folder.unsigned"
#   echo "let folder.singed.new = folder.unsigned + diff"
#   echo "check if folder.singed.new == folder_signed"
#   echo "output : folder.signed.new"
#   echo input : 
#       signed_dir : requested (any string)
#       unsgined_dir : requested (not empty)
#       diff_folder : requested (not empty)
#       signed_new_dir : requested (empty)
#       check : requested ("true")
#       combine : requested ("true")
#   echo output :
#       signed_new_dir
#
#    echo "MTK, bv303b"
#
#   check   combine    function
#   true    true    3   create folder_signed_new 
#   true    false   2   create folder_signed_new & check & rm folder_signed_new
#   true    NULL    2   create folder_signed_new & check & rm folder_signed_new
#   false   true        not defined   
#   false   false   1   create diff & check & rm folder_signed_new
#   NULL    NULL    1   create diff & check & rm folder_signed_new
#   flag "check" define : create diff or not
#   flag "combine" define : (check & rm folder_signed_new) or not
# run anywhere
    signed_dir=$1
    unsigned_dir=$2
    diff_folder=$3
    signed_new_dir=$4
    check=$5
    combine=$6
    files=""
    if [ "$combine" != "true" ] ; then
        # temporary folder
        mkdir -p "$signed_new_dir/"
    fi
    if [ "$check" != "true" ] ; then
        files=$(get_images_to_sign_for_MTK)
        files=`dir "$signed_dir"`
    else
        files=$(get_images_to_sign_for_MTK)
        files=`ls $diff_folder |awk -F "[.]part" '{print $1}'|sort|uniq`
    fi
    echo "files:$files(end)"
    for file in $files
    do  
        image_signed="$signed_dir""/""$file"
        image_unsigned="$unsigned_dir""/""$file"
        image_signed_new="$signed_new_dir""/""$file"
        image_signed_part1="$diff_folder""/""$file"".part1"
        image_signed_part3="$diff_folder""/""$file"".part3"
        ls $image_signed $image_unsigned $image_signed_new $image_signed_part1 $image_signed_part3
        if [ ! -f $image_unsigned ] ; then
            echo "ignore $image_unsigned"
            continue
        fi
        # 0x4040 = 16448
        size_image_signed_part1=16448
        echo $image_signed | grep "preloader_".*".bin"
        if [ $? -eq 0 ] ; then
            echo "special handler for preloader.bin"
            if [ "$check" != "true" ] ; then
                echo "SUCCESS******************"
                echo "     :create $image_signed_part1 from $image_signed"
                echo cp $image_signed $image_signed_part1
                cp $image_signed $image_signed_part1
                echo cp $image_signed $image_signed_part3
                cp $image_signed $image_signed_part3
            else
                if [ "$combine" != "true" ] ; then
                    diff $image_signed_part1 $image_signed
                    if [ $? -ne 0 ] ; then
                        echo "ERROR******************"
                        echo "     :$image_signed_part1 $image_signed are different"
                        exit 1
                    else
                        echo "SUCCESS******************"
                        echo "     :create $image_signed_new from $image_signed & $image_unsigned"
                    fi
                else
                    echo "COMBINE FINISH******************"
                    echo "     :create $image_signed_new from $image_signed_part1"        
                    echo cp $image_signed_part1 $image_signed_new
                    cp $image_signed_part1 $image_signed_new
                fi
            fi
        else
            /bin/bash ./diff_img_style_1.sh $image_signed $image_unsigned $image_signed_new $size_image_signed_part1 $image_signed_part1 $image_signed_part3 $check $combine
            if [ $? -ne 0 ] ; then
                # clean
                if [ "$combine" != "true" ] ; then
                    rm -rf "$signed_new_dir"
                fi
            exit 1;
            fi
        fi
    done
    # clean
    if [ "$combine" != "true" ] ; then
        rm -rf "$signed_new_dir"
    fi
