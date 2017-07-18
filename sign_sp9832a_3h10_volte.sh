#!/bin/bash
echo $@
/mnt/github/ShellTest/shell_test.sh 164 $@
if [ $? -ne 0 ] ; then
    exit 1;
fi

