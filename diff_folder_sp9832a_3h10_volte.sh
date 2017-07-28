#!/bin/bash
function get_images_to_sign_BSC_BIN_for_sprd_V4()
{
    echo "fdl1.bin
u-boot-spl-16k.bin  
"
}
function get_images_to_sign_VLR_BIN_for_sprd_V4()
{
    echo "
fdl2.bin  
u-boot.bin   
"
}
function get_images_to_sign_VLR_OTHER_BIN_for_sprd_V4()
{
    echo "
ltemodem.bin   
ltedsp.bin   
ltegdsp.bin 
ltewarm.bin  
pmsys.bin   
boot.img    
recovery.img          
"
}
function get_images_to_sign_for_sprd_V4()
{
get_images_to_sign_BSC_BIN_for_sprd_V4
get_images_to_sign_VLR_BIN_for_sprd_V4
get_images_to_sign_VLR_OTHER_BIN_for_sprd_V4
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
#   echo "output : nothing"
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
#   echo "output : signed_new_dir"
#
#    echo "sprd, bv303c"
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
#BSC_BIN
#VLR_BIN
#VLR_OTHER_BIN
    signed_dir=$1
    unsigned_dir=$2
    diff_folder=$3
    signed_new_dir=$4
    check=$5
    combine=$6

    if [ "$combine" != "true" ] ; then
        # temporary folder
        mkdir -p "$signed_new_dir"
    fi

    images_bsc_bin=$(get_images_to_sign_BSC_BIN_for_sprd_V4)
    # 0x304
    size_image_signed_part1="772"
    for file in $images_bsc_bin
    do  
        image_signed="$signed_dir""/""$file"
        image_unsigned="$unsigned_dir""/""$file"
        image_signed_new="$signed_new_dir""/""$file"
            image_signed_part1="$diff_folder""/""$file"".part1"
            image_signed_part3="$diff_folder""/""$file"".part3"
            /bin/bash ./diff_img_style_2.sh $image_signed $image_unsigned $image_signed_new  $size_image_signed_part1 $image_signed_part1 $image_signed_part3 $check $combine
            if [ $? -ne 0 ] ; then
                # clean
                if [ "$combine" != "true" ] ; then
                    rm -rf "$signed_new_dir"
                fi
                exit 1;
            fi
    done
    images_vlr_bin=$(get_images_to_sign_VLR_BIN_for_sprd_V4)
    # 0x600 
    size_image_signed_part1="1536"
    for file in $images_vlr_bin
    do  
        image_signed="$signed_dir""/""$file"
        image_unsigned="$unsigned_dir""/""$file"
        image_signed_new="$signed_new_dir""/""$file"
            image_signed_part1="$diff_folder""/""$file"".part1"
            image_signed_part3="$diff_folder""/""$file"".part3"
            /bin/bash ./diff_img_style_1.sh $image_signed $image_unsigned $image_signed_new  $size_image_signed_part1 $image_signed_part1 $image_signed_part3 $check $combine
            if [ $? -ne 0 ] ; then
                # clean
                if [ "$combine" != "true" ] ; then
                    rm -rf "$signed_new_dir"
                fi
                exit 1;
            fi
    done
    images_vlr_bin=$(get_images_to_sign_VLR_OTHER_BIN_for_sprd_V4)
    # 0x400 
    size_image_signed_part1="1024"
    for file in $images_vlr_bin
    do  
        image_signed="$signed_dir""/""$file"
        image_unsigned="$unsigned_dir""/""$file"
        image_signed_new="$signed_new_dir""/""$file"
            image_signed_part1="$diff_folder""/""$file"".part1"
            image_signed_part3="$diff_folder""/""$file"".part3"
            /bin/bash ./diff_img_style_1.sh $image_signed $image_unsigned $image_signed_new  $size_image_signed_part1 $image_signed_part1 $image_signed_part3 $check $combine
            if [ $? -ne 0 ] ; then
                # clean
                if [ "$combine" != "true" ] ; then
                    rm -rf "$signed_new_dir"
                fi
                exit 1;
            fi
    done

    # clean
    if [ "$combine" != "true" ] ; then
        rm -rf "$signed_new_dir"
    fi
