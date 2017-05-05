#!/bin/bash
#return 1,if time2 > time1
function usage()
{
	echo "script argu1 [argus]"
}
function request_args_2()
{
#    echo '$@:'"$@"
#    echo '$#:'"$#"
    if [ $# -lt 2 ] ; then
        return 1
    else
        return 0
    fi
}
function force_args_2()
{
    request_args_2 "$@"
    result=$?
#    echo '$?:'$result
    if [ $result -ne 0 ] ; then
        echo "ERROR : request 2 args!"' $@='"$@"
        exit 1
    fi
}
echo '$@:'"$@"
echo '$#:'"$#"
base_path=`dirname $0`
log_path="$base_path""/""$1"
echo "base_path:"$base_path
echo "log_path:"$log_path
if [ ! -d $log_path ] ; then
	mkdir $log_path
fi
#echo 'arg0:'$0'arg1:'$1
case $1 in
1) echo "script arg1 <keys folder>"
    echo "generate keys to sign *.mbn for qualcomm"
   echo "run on the sectools/"
force_args_2 "$@"
#keypath="/mnt/keys/"
keypath=$2
if [ ! -d $keypath ] ; then
    mkdir -p $keypath
fi
openssl genrsa -out ${keypath}/rootca.key -3 2048
openssl req -new -key ${keypath}/rootca.key -x509 -out ${keypath}/rootca.crt ${DIGEST} -subj /C=CN/ST="ShangHai"/L="ShangHai"/OU="General Use Test Key (for testing only)"/OU="NoTeam"/O="NoCompany"/CN="NoCompany Root CA 1" -days 7300 -set_serial 1 -config resources/openssl/opensslroot.cfg
openssl x509 -in ${keypath}/rootca.crt -inform PEM -out ${keypath}/rootca.cer -outform DER

openssl genrsa -out ${keypath}/attestca.key -3 2048
openssl req -new -key ${keypath}/attestca.key -out ${keypath}/attestca.csr ${DIGEST} -subj /C=CN/ST="ShangHai"/L="ShangHai"/OU="NoTeam"/O="NoCompany"/CN="NoCompany Attestation CA" -days 7300 -config resources/openssl/opensslroot.cfg
openssl x509 -req -in ${keypath}/attestca.csr -CA ${keypath}/rootca.crt -CAkey ${keypath}/rootca.key -out ${keypath}/attestca.crt ${DIGEST} -set_serial 5 -days 7300 -extfile resources/openssl/v3.ext
openssl x509 -in ${keypath}/attestca.crt -inform PEM -out ${keypath}/attestca.cer -outform DER

openssl genrsa -out ${keypath}/attest.key -3 2048
	;;
2) echo "script arg1 <keys folder>"
    echo "generate keys to sign *.mbn for qualcomm"
   echo "version 2"
   echo "run on the sectools/"
force_args_2 "$@"
#keypath="/mnt/keys/"
keypath=$2
if [ ! -d $keypath ] ; then
    mkdir -p $keypath
fi
openssl genrsa -out ${keypath}/rootca.key -3 2048
openssl req -new -key ${keypath}/rootca.key -x509 -out ${keypath}/rootca.crt ${DIGEST} -subj /C=CN/ST="ShangHai"/L="ShangHai"/OU="Keys for Releasing"/OU="NoTeam"/O="NoCompany"/CN="NoCompany Root CA 1" -days 7300 -set_serial 1 -config resources/data_prov_assets/General_Assets/Signing/openssl/opensslroot.cfg
openssl x509 -in ${keypath}/rootca.crt -inform PEM -out ${keypath}/rootca.cer -outform DER

openssl genrsa -out ${keypath}/attestca.key -3 2048
openssl req -new -key ${keypath}/attestca.key -out ${keypath}/attestca.csr ${DIGEST} -subj /C=CN/ST="ShangHai"/L="ShangHai"/OU="NoTeam"/O="NoCompany"/CN="NoCompany Attestation CA" -days 7300 -config resources/data_prov_assets/General_Assets/Signing/openssl/opensslroot.cfg
openssl x509 -req -in ${keypath}/attestca.csr -CA ${keypath}/rootca.crt -CAkey ${keypath}/rootca.key -out ${keypath}/attestca.crt ${DIGEST} -set_serial 5 -days 7300 -extfile resources/data_prov_assets/General_Assets/Signing/openssl/v3.ext
openssl x509 -in ${keypath}/attestca.crt -inform PEM -out ${keypath}/attestca.cer -outform DER

openssl genrsa -out ${keypath}/attest.key -3 2048
	;;
*) echo "others"
	;;
esac
exit
##script argu1 argu2
