#!/bin/bash
souce_authentication_html_file="$1"
target_authentication_file="$2"
brand_company_file="$3"
odm_company_file="$4"
echo "$0"" ""$@"
target_authentication_html_file="$souce_authentication_html_file""_temp.htm"
/bin/bash ./authenticate_html.sh $souce_authentication_html_file $target_authentication_html_file $brand_company_file $odm_company_file
echo wkhtmltopdf  $target_authentication_html_file $target_authentication_file
wkhtmltopdf  $target_authentication_html_file $target_authentication_file
rm $target_authentication_html_file
