#!/bin/bash
echo $0 $@
brand_company="FaShuo"
odm_company="花烁"
version="N9_V12"
project="N9 N9"
build_time="2017-8-4"
authenticate_time_year="2017"
authenticate_time_month="8"
authenticate_time_day="4"
authentication_code="abcdef9hijklmnopqrstuvwxyz"

souce_authentication_file=$1
target_authentication_file=$2
cp $souce_authentication_file $target_authentication_file
china="1"
if [ "$china" == "1" ] ; then
brand_company=`cat $3`
odm_company=`cat $4`
echo "brand_company : ""$brand_company"
echo "odm_company : ""$odm_company"
#echo sed -i "s/BRAND_COMPANY/$brand_company/g" $target_authentication_file
sed -i "s/BRAND_COMPANY/$brand_company/g" $target_authentication_file
#echo sed "s/ODM_COMPANY/\"$odm_company\"/g" $target_authentication_file
#sed "s/ODM_COMPANY/\"$odm_company\"/g" $target_authentication_file
sed -i "s/ODM_COMPANY/\"$odm_company\"/g" $target_authentication_file
else
sed -i "s/BRAND_COMPANY/$brand_company/g" $target_authentication_file
sed -i "s/ODM_COMPANY/$odm_company/g" $target_authentication_file
fi

sed -i "s/IMAGE_VERSION/$version/g" $target_authentication_file
sed -i "s/PROJECT_NAME/$project/g" $target_authentication_file
sed -i "s/BUILD_TIME/$build_time/g" $target_authentication_file
sed -i "s/AUTHENTICATE_TIME_YEAR/$authenticate_time_year/g" $target_authentication_file
sed -i "s/AUTHENTICATE_TIME_MONTH/$authenticate_time_month/g" $target_authentication_file
sed -i "s/AUTHENTICATE_TIME_DAY/$authenticate_time_day/g" $target_authentication_file
sed -i "s/AUTHENTICATION_CODE/$authentication_code/g" $target_authentication_file


#sed 's/"//g' $target_authentication_file
sed -i 's/"//g' $target_authentication_file

