#!/bin/bash
# function 1:
#   echo "given image.signed & image.unsigned"
#   echo "diff = image.signed - image.unsigned"
#   echo "let image.singed.new = image.unsigned + diff"
#   echo "check if image.singed.new == image_signed"
#   echo "output : diff"
# function 2:
#   if check flag "true" is given
#   check if image signed == image unsigned + image diffed
# function 3:
#   echo "given image.diff & image.unsigned"
#   echo "let image.singed.new = image.unsigned + diff"
#   echo "check if image.singed.new == image_signed"
#   echo "output : image.signed.new"
    # image.singed     image.unsigned
    # part1
    # part2      ==    image.unsigned
    # part3
    #
    # image.signed = part1 + image.unsigned + part3
#run anywhere
    image_signed=$1
    image_unsigned=$2
    image_signed_new=$3

    image_signed_p1_size=$4
    image_signed_1=$5
    image_signed_3=$6
#   check   combine    function
#   true    true      create image.signed & check
#   true    false   2   create image.signed & check
#   false    true   3   create image.signed
#   false    false  1  create diff & check
#
#
#   true    true    3   create image.signed 
#   true    false   2   create image.signed & check
#   true    NULL    2   create image.signed & check
#   false   true        not defined   
#   false   false   1   create diff & check
#   NULL    NULL    1   create diff & check
#   flag "check" define : create diff or not
#   flag "combine" define : (check) or not
#   wont rm image_signed_new
    check=$7
    combine=$8
    
    dat=`date +%Y%m%d_%H%M%S_%N`
    image_unsigned_filename=`basename $image_unsigned`
    image_unsigned_1_and_2="/data/app/sign-zip/sign-zip/tmp/""$image_unsigned_filename""_part12_""$dat"
    image_unsigned_1_and_2_and_3="/data/app/sign-zip/sign-zip/tmp/""$image_unsigned_filename""_part123_""$dat"

    if [ "$check" != "true" ] ; then
        #function 1
        #create $image_signed_1
        echo dd if="$image_signed" of="$image_signed_1" bs=$image_signed_p1_size skip=0 seek=0 count=1
        dd if="$image_signed" of="$image_signed_1" bs=$image_signed_p1_size skip=0 seek=0 count=1
        echo 'after dd $?='$?
    fi
    if [ "$check" != "true" ] ; then
        #function 1
        cat $image_signed_1 $image_unsigned > $image_unsigned_1_and_2
    else
        cat $image_signed_1 $image_unsigned > $image_unsigned_1_and_2
    fi

    size_image_unsigned_1_and_2=`wc -c < $image_unsigned_1_and_2`
    if [ "$check" != "true" ] ; then
        #function 1
        #create $image_signed_3
        echo dd if="$image_signed" of="$image_signed_3" bs=$size_image_unsigned_1_and_2 skip=1 seek=0
        dd if="$image_signed" of="$image_signed_3" bs=$size_image_unsigned_1_and_2 skip=1 seek=0
        echo 'after dd $?='$?
    fi
    if [ "$check" != "true" ] ; then
        #function 1
        cat $image_unsigned_1_and_2 $image_signed_3 > $image_unsigned_1_and_2_and_3
    else
        cat $image_unsigned_1_and_2 $image_signed_3 > $image_unsigned_1_and_2_and_3
    fi
    if [ "$combine" != "true" ] ; then
        diff $image_signed $image_unsigned_1_and_2_and_3
        if [ $? -eq 0 ] ; then
            cp $image_unsigned_1_and_2_and_3 $image_signed_new
            echo "SUCCESS******************"
            echo "     :create $image_signed_new from $image_signed & $image_unsigned"
        else
            echo "ERROR********************"
            echo "     :create $image_signed_new from $image_signed & $image_unsigned failed!"
            #clean
            rm -rf $image_unsigned_1_and_2 $image_unsigned_1_and_2_and_3
            exit 1;
        fi
    else
            cp $image_unsigned_1_and_2_and_3 $image_signed_new
            echo "COMBINE FINISH******************"
            echo "     :create $image_signed_new from $image_unsigned & $image_signed_1 & $image_signed_1"        
    fi
    #clean
    rm -rf $image_unsigned_1_and_2 $image_unsigned_1_and_2_and_3
