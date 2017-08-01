ftpfile=$1
username=$2
target=$3
host=`echo $ftpfile|awk -F "ftp://" '{print $2}'|awk -F "/" '{print $1}'`
echo $host
echo $username
base_path=`dirname $0`
script_folder=`cd $base_path;pwd`
password=`/bin/bash $script_folder"/get_ftp_passwd.sh" $host $username`
#echo $password
source=`echo $ftpfile|awk -F "$host" '{print $2}'`
echo $source

/bin/bash $script_folder"/download_file.sh" $host $username $password $source $target


