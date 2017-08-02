#/bin/bash
echo $@
ftpfile=$1
username=$2
source=$3
host=`echo $ftpfile|awk -F "ftp://" '{print $2}'|awk -F "/" '{print $1}'`
base_path=`dirname $0`
script_folder=`cd $base_path;pwd`
password=`/bin/bash $script_folder"/get_ftp_passwd.sh" $host $username`
#echo $password
target=`echo $ftpfile|awk -F "$host" '{print $2}'`
echo "source: ""$host"
echo "username: "$username
echo "source: "$source
echo "target: "$target
/bin/bash $script_folder"/get_ftp_passwd.sh" $host $username >> /home/server/get_ftp_passwd_result
/bin/bash $script_folder"/upload_file.sh" $host $username $password $source $target


