#/bin/bash
echo $@
ftpfile=$1
username=$2
source=$3
host=`echo $ftpfile|awk -F "ftp://" '{print $2}'|awk -F "/" '{print $1}'`
base_path=`dirname $0`
script_folder=`cd $base_path;pwd`
password=`/bin/bash $script_folder"/get_ftp_passwd.sh" $host $username`
if [ "$password" == "" ] ; then
    echo "*****************"
    echo "upload  $source to $ftpfile failed"
    echo "host or username not available"
    echo "*****************"
    exit 2010
fi
#echo $password
target=`echo $ftpfile|awk -F "$host" '{print $2}'`
echo "**********"
echo "host:$host"
echo "port:$port"
echo "username:$username"
#echo "password:$password"
echo "source:$source"
echo "target:$target"
echo "**********"

/bin/bash $script_folder"/get_ftp_passwd.sh" $host $username
echo /bin/bash $script_folder"/upload_file.sh" $host $username $password $source $target 
/bin/bash $script_folder"/upload_file.sh" $host $username $password $source $target 1> ~/ftp.txt 2>&1

cat ~/ftp.txt | grep -v "Interactive mode off."
if [ $? -ne 0 ] ; then
    echo "*****************"
    echo "upload  $source to $ftpfile successfully"
    echo "*****************"
    exit 0
else
    echo "*****************"
    echo "upload  $source to $ftpfile failed"
    echo "*****************"
    exit 2020
fi


