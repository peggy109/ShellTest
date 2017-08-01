#!/bin/bash
t_host=`echo $1 | awk -F ":" '{print $1}'`
t_port=`echo $1 | awk -F ":" '{print $2}'`
t_username=$2
if [ "$t_port" == "" ] ; then
    t_port="21"
fi
base_path=`dirname $0`
script_folder=`cd $base_path;pwd`

cat "/home/server/ftp_host_user_passwd.cfg" | while read l
do
#    echo "l:"$l
    host=`echo $l |awk '{print $1}'`
    port=`echo $l |awk '{print $2}'`
    username=`echo $l |awk '{print $3}'`
    passwd=`echo $l |awk '{print $4}'`
    if [ "$t_host" == "$host" ] && [ "$t_port" == "$port" ] && [ "$t_username" == "$username" ] ; then
        # echo "passwd:$passwd"
        echo "$passwd"
        break;
    fi
done
