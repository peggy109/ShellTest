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
    # image.singed image.unsigned
    # part1      !=     part1
    # part2      ==     part2
    # part3
    #
    # image.signed = image.signed.part1 + image.unsigned.part2 + image.signed.part3
# run anywhere
    image_signed=$1
    image_unsigned=$2
    image_signed_new=$3
    image_signed_p1_size=$4
    # output
    image_signed_1=$5
    image_signed_3=$6

    check=$7
    combine=$8

    dat=`date +%Y%m%d_%H%M%S_%N`
    image_unsigned_filename=`basename $image_unsigned`
    image_unsigned_1_and_2="/data/app/sign-zip/sign-zip/tmp/""$image_unsigned_filename""_part12_""$dat"
    image_unsigned_1_and_2_and_3="/data/app/sign-zip/sign-zip/tmp/""$image_unsigned_filename""_part123_""$dat"

    # by local 
    #cp $image_unsigned $image_unsigned_1_and_2
    #dd if="$image_signed" of="$image_unsigned_1_and_2" bs=$image_signed_p1_size count=1
    
    if [ "$check" != "true" ] ; then
        #function 1
        # will create image_signed_1
        dd if="$image_signed" of="$image_signed_1" bs=$image_signed_p1_size count=1
    fi
    cp $image_unsigned $image_unsigned_1_and_2
    if [ "$check" != "true" ] ; then
        dd if="$image_signed_1" of="$image_unsigned_1_and_2" bs=$image_signed_p1_size count=1 conv=notrunc
    else
        dd_if=$image_signed_1
        dd_of=$image_unsigned_1_and_2
        size_if=`wc -c < $dd_if`
        size_of=`wc -c < $dd_of`
        echo /mnt/github/c_test/dd "$dd_if" "$dd_of" 1 0 0 $size_if
        /mnt/github/c_test/dd "$dd_if" "$dd_of" 1 0 0 $size_if
        if [ $? -ne 0 ] ; then
            rm -rf $image_unsigned_1_and_2 $image_unsigned_1_and_2_and_3
            exit 1;
        fi
    fi

    # 
    size_image_unsigned_1_and_2=`wc -c < $image_unsigned_1_and_2`
    if [ "$check" != "true" ] ; then
        #function 1
        # will create image_signed_3
        dd if="$image_signed" of="$image_signed_3" bs=$size_image_unsigned_1_and_2 skip=1
    fi
    if [ "$check" != "true" ] ; then
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
            echo "ERROR******************"
            echo "     :create $image_signed_new from $image_signed & $image_unsigned"
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
