#!/bin/bash

#return 1,if time2 > time1
function usage()
{
	echo "script $1 [$2]"
}
function fDiffTime()
{
	echo "$1 , $2" ;
	h_1=`echo $1|awk -F ':' '{print $1}'`
	m_1=`echo $1|awk -F ':' '{print $2}'`
	s_1=`echo $1|awk -F ':' '{print $3}'`
	h_2=`echo $2|awk -F ':' '{print $1}'`
	m_2=`echo $2|awk -F ':' '{print $2}'`
	s_2=`echo $2|awk -F ':' '{print $3}'`
	echo "$h_1 $m_1 $s_1 $h_2 $m_2 $s_2"
	if [ $h_2 -eq 0 ] && [ $h_1 -lt $h_2 ] ; then
		h_2=24
	fi
	seconds_1=$(($h_1*60*60+$m_1*60+$s_1))
	seconds_2=$(($h_2*60*60+$m_2*60+$s_2))
	if [ $seconds_1 -lt $seconds_2 ] ; then
		echo "$1($seconds_1) < $2($seconds_2)"
		return 1
	else
		echo "$1($seconds_1) >= $2($seconds_2)"
		return 0
	fi
}
#return true if time2-time1 > <para 3> seconds
function fDiffTimeThreadsHold()
{
	echo "$1 , $2 , $3" ;
	h_1=`echo $1|awk -F ':' '{print $1}'`
	m_1=`echo $1|awk -F ':' '{print $2}'`
	s_1=`echo $1|awk -F ':' '{print $3}'`
	h_2=`echo $2|awk -F ':' '{print $1}'`
	m_2=`echo $2|awk -F ':' '{print $2}'`
	s_2=`echo $2|awk -F ':' '{print $3}'`
	threadshold=$3
	echo "$h_1 $m_1 $s_1 $h_2 $m_2 $s_2"
	#09 should be treated as D9
	#08 should be treated as D8
	if [ "$s_1" == "09" -o "$s_1" == "08" ] ; then
		s_1=`echo ${s_1:1:1}` ; fi
	if [ "$s_2" == "09" -o "$s_2" == "08" ] ; then
		s_2=`echo ${s_2:1:1}` ; fi
	if [ "$m_1" == "09" -o "$m_1" == "08" ] ; then
		m_1=`echo ${m_1:1:1}` ; fi
	if [ "$m_2" == "09" -o "$m_2" == "08" ] ; then
		m_2=`echo ${m_2:1:1}` ; fi
	if [ "$h_1" == "09" -o "$h_1" == "08" ] ; then
		h_1=`echo ${h_1:1:1}` ; fi
	if [ "$h_2" == "09" -o "$h_2" == "08" ] ; then
		h_2=`echo ${h_2:1:1}` ; fi
	if [ $h_2 -eq 0 ] && [ $h_1 -gt $h_2 ] ; then
		h_2=24
	fi

	seconds_1=$(($h_1*60*60+$m_1*60+$s_1))
	seconds_2=$(($h_2*60*60+$m_2*60+$s_2))
	diff=$(($seconds_2-$seconds_1))
	#echo "diff $diff"
	if [ $diff -gt $threadshold ] ; then
		echo "diff($diff)gianter then threadshold($threadshold)!"
		return 1
	else
		#echo "diff($diff)litter then threadshold($threadshold)!"
		return 0
	fi
}

function get_images_to_sign()
{
	echo "fdl1.bin
u-boot-spl-16k.bin 

fdl2.bin    
u-boot.bin          

boot.img                     
recovery.img         

SC9600_sharkls_3593_CUST_Base_NV_MIPI.dat  
LTE_DSP.bin  
PM_sharkls_arm7.bin  
SC9600_sharkl_wphy_5mod_volte_zc.bin       
SHARKL_DM_DSP.bin                         
fdl1.bin(1)  
EXEC_KERNEL_IMAGE0.bin  
"
}
function get_images_to_sign_BSC_BIN_for_sprd_V4()
{
    echo "fdl1.bin
u-boot-spl-16k.bin  
"
}
function get_images_to_sign_VLR_BIN_for_sprd_V4()
{
    echo "
fdl2.bin  
u-boot.bin   
"
}
function get_images_to_sign_VLR_OTHER_BIN_for_sprd_V4()
{
    echo "
ltemodem.bin   
ltedsp.bin   
ltegdsp.bin 
ltewarm.bin  
pmsys.bin   
boot.img    
recovery.img          
"
}
function get_images_to_sign_for_sprd_V4()
{
get_images_to_sign_BSC_BIN_for_sprd_V4
get_images_to_sign_VLR_BIN_for_sprd_V4
get_images_to_sign_VLR_OTHER_BIN_for_sprd_V4
}
function get_images_to_sign_BSC_BIN_sprd()
{
    rootdir=$1
    cat $rootdir"/sprd_secure_boot_tool/sig_bin.ini"|grep 'BSC_BIN='| awk -F'BSC_BIN=' '{print $2}'
}
function get_images_to_sign_VLR_BIN_sprd()
{
    rootdir=$1
    cat $rootdir"/sprd_secure_boot_tool/sig_bin.ini"|grep 'VLR_BIN='| awk -F'VLR_BIN=' '{print $2}'
}
function get_images_to_sign_VLR_OTHER_BIN_sprd()
{
    rootdir=$1
    cat $rootdir"/sprd_secure_boot_tool/sig_bin.ini"|grep 'VLR_OTHER_BIN='| awk -F'VLR_OTHER_BIN=' '{print $2}'
}
function get_signature_filelist_sprd()
{
    rootdir=$1
    get_images_to_sign_BSC_BIN_sprd $rootdir
    get_images_to_sign_VLR_BIN_sprd $rootdir
    get_images_to_sign_VLR_OTHER_BIN_sprd $rootdir
}
function get_images_to_override()
{
get_images_to_sign
echo "
SharkLSGLobalMarlinAndroid5.1.xml  
system.img          
userdata.img
cache.img               
nvitem.bin   
prodnv.img                    
welcome_720x1280.bmp
persist.img  
sysinfo.img                        
welcome_720x1280.bmp(1)
"
}
function get_images_to_override_for_sprd_V4()
{
get_images_to_sign_for_sprd_V4
echo "ltenvitem.bin  
prodnv.img  
system.img
userdata.img 
logo1.bmp  
logo2.bmp 
cache.img  
persist.img  
sysinfo.img 
wcnfdl.bin
wcnmodem.bin
SharkLS5ModeMarlinAndroid5.1.xml
"
}

function get_images_to_sign_for_MTK()
{
    echo "boot.img	logo.bin	   system.img
cache.img	recovery.img  trustzone.bin
lk.bin	secro.img	   userdata.img
"
}

echo '$@:'"$@"' $#:'"$#"
#echo '$0:'"$0"' $1:'"$1"
base_path=`dirname $0`
script_name=`basename $0`
script_path=`cd $base_path;pwd`
script="$script_path""/""$script_name"
#echo "script : ""$script"
log_path="$script_path""/""$1"
#echo "script_path:"$script_path
#echo "log_path:"$log_path
if [ ! -d $log_path ] ; then
	mkdir $log_path
fi

case $1 in
1) echo "111" 
	cat ~/disk_3/me102a/src/external/sepolicy/property_contexts |awk '{print $2}'|awk -F : '{print $3}'
	for property in `cat ~/disk_3/me102a/src/external/sepolicy/property_contexts |awk '{print $2}'|awk -F : '{print $3}'|grep -v ^$`
	do
		echo "property:$property"
		find ~/disk_3/me102a/src/external/sepolicy |xargs grep -e $property 2>/dev/null
	done ;;
2) echo "/external/sepolicy/  class test"
	echo "number="
#92
	cat ~/disk_3/bsp_me176c/src/external/sepolicy/security_classes |grep class|awk '{print $2}' |wc -l
	for class in `cat ~/disk_3/bsp_me176c/src/external/sepolicy/security_classes |grep class|awk '{print $2}'` 
	do
		echo "class:"$class
	#	cat ~/disk_3/bsp_me176c/src/external/sepolicy/access_vectors |grep $class
	done
	;;
3)	echo "object type defined in kernel"
	echo "number="
	#50
	cat ~/disk_3/bsp_me176c/src/linux/kernel/security/selinux/include/classmap.h |grep "{ \""|grep -v "  { \"" |awk -F \" '{print $2}'|wc -l
	for object_type in `cat ~/disk_3/bsp_me176c/src/linux/kernel/security/selinux/include/classmap.h |grep "{ \""|grep -v "  { \"" |awk -F \" '{print $2}'`
	do
		echo "object_type:"$object_type
		cat ~/disk_3/bsp_me176c/src/external/sepolicy/access_vectors |grep $object_type
		if [ $? -ne 0 ] ; then
			echo "not found in access_vectors!!!"
		fi
	done
	;;
4)	echo "object type defined access_vectors"
	echo "number="
	#84
	cat ~/disk_3/bsp_me176c/src/external/sepolicy/access_vectors |grep "^class" |awk '{print $2}'
	for class2 in `cat ~/disk_3/bsp_me176c/src/external/sepolicy/access_vectors |grep "^class" |awk '{print $2}'`
	do
		echo "class:"$class2
		cat ~/disk_3/bsp_me176c/src/external/sepolicy/security_classes |grep $class2
		if [ $? -ne 0 ] ; then
			echo "not found in security_classes!!!"
		fi
	done
	;;
5) echo "install and uninstall apk 40 times" 
	#for (( i=1 ; $i <= 100; i++ )) ；
	#do
    #     echo $i;
	#done
#android not ok. seq: not found
#for i in($toolbox seq 1 45) ; ok
	for i in $(seq 1 45); 
	do
        echo "i:"$i		
		adb uninstall jp.akemd.android.tools.akmon
		adb install '/media/peggy/软件/data/ubuntu/AKmon__NoCentification.apk'
	done 
	;;
6) echo "output date and user and write the mesgs into file"
	date |tee ~/tee.txt
	who |tee -a ~/tee.txt
	;;
7) echo "replace path test"
	replace_path=~/xiu/cang
	dir_files=$(dir $replace_path)
	echo "dir replace_path"
	dir $replace_path
	echo "end"
	ls -l $replace_path |sort 
	echo "\$dir_files=$dir_files"
	
#addsuffix invalid
#wildcard invalid
	
	;;
8)	echo  "notdir test"
	path=~/xiu/cang/hua
	dir_files=$(dir $path)
	echo "\$dir_files=$dir_files"
	for file in $dir_files
	do
		echo "file=$file"
	done
	path2="~/xiu/cang/hua/a5.txt ~/xiu/cang/hua/d4.txt ~/xiu/cang/hua/d5.txt"
	echo "path2:"$path2
#notdir invallid
 #   notdir_files=$(notdir $path2)
	;;
9) echo "\$(if test"
	path1=$(dir ~/xiu)
	echo "path1:$path1"
	path2=$(dir ~/xiu/cang)
	echo "path2:$path2"
	#path3=$(echo "i love you")
	var=$(if $(path1),$(path2))
	echo $var
	;;
10) echo "Find  folder named with digital"
	ll /proc/ |busybox awk '{print $6}'|grep "[0-9]"|grep -v ":" 
	;;
11) echo "file exists?"
	if [ -f /home/peggy/unsafe.txt ];then
		echo "exist!"
	else 
		echo "not exists!"
	fi
	;;
12) echo "sleep 1s "
	while   true
	do
   	echo "Hello, world"
#in android sleep 1s will fail sleep: syntax error: Invalid argument '1s'
   sleep 1s
#in android , ok
#	sleep 1
	done
	;;
13) echo "while cycle"
	count=0
	while true
	do
		let "count+=1"
		echo "count:"$count
		if [ $count -eq 20 ]; then
			break
		fi
	done
	;;
14) echo "xml awk"
	
	;;
15)  echo "read from blacklist $2,create blacklist2 $3,to match source $4"
#creadte blacklist2
	cp ~/xiu/blacklist ~/xiu/blacklist2
#.  -> \.
		sed -i "s/\./\\\./g" ~/xiu/blacklist2
#* -> .8
		sed -i "s/\*/\.\*/g" ~/xiu/blacklist2
	#match
	for source in `cat ~/xiu/source`
	do
		for pattern in `cat ~/xiu/blacklist2`
		do
			echo $source |grep $pattern >/dev/null
			if [ $? -eq 0 ] ; then
				echo "source $source match pattern $pattern"
				break
			fi
		done
	done
	;;
16)  echo "read from blacklist $2,create blacklist2 $3,to match source $4"
#creadte blacklist2
	blacklist=$2
	blacklist2=$3
	string=$4
	cp $blacklist $blacklist2
		sed -i "s/\./\\\./g" $blacklist2
		sed -i "s/\*/\.\*/g" $blacklist2
	#match
		for pattern in `cat ~/xiu/blacklist2`
		do
			echo $string |grep $pattern >/dev/null
			if [ $? -eq 0 ] ; then
				echo "source $string match pattern $pattern"
				break
			fi
		done
	;;
17)  echo "read from blacklist $2,to match source $3"
	blacklist=$2
	string=$3
	#match
		for pattern in `cat $blacklist`
		do
			echo $string |grep $pattern
			if [ $? -eq 0 ] ; then
				echo "source $string match pattern $pattern"
				break
			fi
		done
	;;
18 ) echo "71 com.nocompany.*,but 69 packages are not installed,why"
#show package's codepath 71,
	cat ~/packages.xml |grep "<package " |grep "com.nocompany" |grep flags |awk -F " " '{print $3}' |awk -F "\"" '{print $2}'
	echo "num of com.nocompany.* in packages.xml:"
	cat ~/packages.xml |grep "<package " |grep "com.nocompany" |grep flags |awk -F " " '{print $3}' |awk -F "\"" '{print $2}' |wc -l
	
    cat ~/logcat.txt |grep -e "==false,will not install" |awk -F "(" '{print $4}'|awk -F ")" '{print $1}'
	echo "num of packages uninstalled:"
	cat ~/logcat.txt |grep -e "==false,will not install" |awk -F "(" '{print $4}'|awk -F ")" '{print $1}' |wc -l
	
	for uninstalledpkg in `cat ~/packages.xml |grep "<package " |grep "com.nocompany" |grep flags |awk -F " " '{print $3}' |awk -F "\"" '{print $2}'`
	do
		cat ~/logcat.txt |grep -e "==false,will not install" |awk -F "(" '{print $4}'|awk -F ")" '{print $1}' |grep $uninstalledpkg
		if [ $? -eq 0 ] ; then
			echo ""
		else
			echo "$uninstalledpkg not matched "
		fi
	
	done
	;;
19) echo "does every package in packages.xml(dev) come up in .mk"
	#like /system/app/XXX.apk
#	for apkname in `cat ~/packages.xml |grep "<package "|awk -F " " '{print $3}'|awk -F "\"" '{print $2}'`
#like XXX
	for apkname in `cat ~/packages.xml|grep "<package "|awk -F " " '{print $3}'|awk -F "\"" '{print $2}'|awk -F "/" '{print $4}'|awk -F "." '{print $1}'`
	do
	#	echo "$apkname start"
#		grep -r "$apkname" /home/peggy/disk_t/dev_me176c/src/vendor/amax |grep -v ".xml:" >/dev/null
#		grep -r "$apkname" /home/peggy/disk_t/dev_me176c/src/device/intel/baytrail/K013 |grep -v ".xml:"
		grep -r "$apkname" /home/peggy/disk_t/dev_me176c/src/vendor/amax |grep -v ".xml:"
		if [ $? -ne 0 ] ; then
			echo "apkname $apkname not in /vendor/amax"
		fi
	#	echo "$apkname end"
	done
#like com.nocompany.xxx
	for pkgname in `cat ~/packages.xml |grep "<package "|awk -F " " '{print $2}'|awk -F "\"" '{print $2}'`
	do
		grep -r "$pkgname" /home/peggy/disk_t/dev_me176c/src/vendor/amax |grep -v ".xml:" >/dev/null
#		grep -r "$pkgname" /home/peggy/disk_t/dev_me176c/src/device/intel/baytrail/K013 |grep -v ".xml:" 
		if [ $? -ne 0 ] ; then
			echo "pkgname $pkgname not in /vendor/amax"
		fi		
	done
	;;
20) echo "does every package in packages.xml(dev) come up in .mk"
	#like /system/app/XXX.apk
#	for apkname in `cat ~/packages.xml |grep "<package "|awk -F " " '{print $3}'|awk -F "\"" '{print $2}'`
#like XXX
	for apkname in `cat ~/packages.xml|grep "<package "|awk -F " " '{print $3}'|awk -F "\"" '{print $2}'|awk -F "/" '{print $4}'|awk -F "." '{print $1}'`
	do
	#	echo "$apkname start"
		grep -r "$apkname" /home/peggy/disk_t/dev_me176c/src/vendor/amax*/ |grep -v ".xml:"
		if [ $? -ne 0 ] ; then
		  grep -r "$apkname" /home/peggy/disk_t/dev_me176c/src/vendor/3rd_party/ |grep -v ".xml:"
		  if [ $? -ne 0 ] ; then
			#echo "apkname $apkname not in /vendor/amax"
			grep -r "$apkname" /home/peggy/disk_t/dev_me176c/src/packages/ |grep -v ".xml:"
			if [ $? -ne 0 ] ; then
				grep -r "$apkname" /home/peggy/disk_t/dev_me176c/src/frameworks/base/ |grep -v ".xml:"
				if [ $? -ne 0 ] ; then
					grep -r "$apkname" /home/peggy/disk_t/dev_me176c/src/development/tools/ |grep -v ".xml:"
					if [ $? -ne 0 ] ; then
						echo "$apkname not in amax* or packages or base or tools"
					fi
				fi
			fi
		  fi
		fi
	#	echo "$apkname end"
	done
	;;
21) echo "does every package (com.google.*)in blacklist.google come up in .mk"
	#like /system/app/XXX.apk
#	for apkname in `cat ~/packages.xml |grep "<package "|awk -F " " '{print $3}'|awk -F "\"" '{print $2}'`
#like XXX
	for apkname in `cat ~/blacklist.google |awk -F "/" '{print $4}'|awk -F "." '{print $1}'`
	do
		grep -r "$apkname" /home/peggy/disk_t/dev_me176c/src/vendor/google/ 
	done
	;;
22) echo "does every package (non-com.google.* & non-com.nocompany.*)in blacklist.other come up in .mk"
	#like /system/app/XXX.apk
#	for apkname in `cat ~/packages.xml |grep "<package "|awk -F " " '{print $3}'|awk -F "\"" '{print $2}'`
#like XXX
	for apkname in `cat ~/blacklist.other|grep -v "#/system" |awk -F "/" '{print $4}'|awk -F "." '{print $1}'`
	do
		grep -r "$apkname" /home/peggy/disk_t/dev_me176c/src/vendor/
	done
	;;


23) 
	# echo "/1/2/3//5" |awk -F "/" '{print $5}'
	#can print $0-$6
	;;
24) echo "find mk apkname(nocompany) stays in for 176 dev"
	for apkname in DeskClock nocompanyMirror Mynocompany nocompanyGalleryBurst QuickMemoService nocompanyGalleryIncidental LogUploader nocompanyInputDevices
	do
		grep -r "$apkname" /home/peggy/disk_t/dev_me176c/src/vendor/3rd_party/
		grep -r "$apkname" /home/peggy/disk_t/dev_me176c/src/packages/
		grep -r "$apkname" /home/peggy/disk_t/dev_me176c/src/frameworks/base/
		grep -r "$apkname" /home/peggy/disk_t/dev_me176c/src/development/tools/
	done
	for apkname in AudioWizard
	do
		grep -r "$apkname" /home/peggy/disk_t/dev_me176c/src/packages/
		grep -r "$apkname" /home/peggy/disk_t/dev_me176c/src/frameworks/base/
		grep -r "$apkname" /home/peggy/disk_t/dev_me176c/src/development/tools/		
	done
	;;
25) echo "delete 45(44 indeed,1 in .sh) apk(com.nocompany.*) filtered in /vendor/amax/products"
	# git diff |grep -e "+#" -e "+ #" |awk -F "#" '{print $2}' |awk -F " " '{print $1}' >~/blacklist.nocompany2_mk_amax_45s 
	for apk in `cat ~/blacklist.nocompany2_mk_amax_45s`
	do
		cat ~/pkgname2path |grep /${apk}.apk >/dev/null
		if [ $? -eq 0 ] ; then
			apkpath=`cat ~/pkgname2path |grep /${apk}.apk|awk -F "\"" '{print $4}'`
			echo "apk name:$apk apkpath:$apkpath"
			rm /home/peggy/disk_t/dev_me176c/src/out/target/product/K013$apkpath
			odexpath_no_apk=`echo $apkpath |awk -F "apk" '{print $1}'`
			odexpath=${odexpath_no_apk}odex
			rm /home/peggy/disk_t/dev_me176c/src/out/target/product/K013$odexpath
		fi
	done
	;;
26)	echo "check if 44 apks are created after build_debug with nocompanyCalendar replaced with #nocompanyCalendar in amax.mk"
	for apk in `cat ~/blacklist.nocompany2_mk_amax_45s`
	do
		cat ~/pkgname2path |grep /${apk}.apk >/dev/null
		if [ $? -eq 0 ] ; then
			apkpath=`cat ~/pkgname2path |grep /${apk}.apk|awk -F "\"" '{print $4}'`
			echo "apk name:$apk apkpath:$apkpath"
			ls /home/peggy/disk_t/dev_me176c/src/out/target/product/K013$apkpath
			#xxx.apk -> xxx.
			odexpath_no_apk=`echo $apkpath |awk -F "apk" '{print $1}'`
			odexpath=${odexpath_no_apk}odex
			ls /home/peggy/disk_t/dev_me176c/src/out/target/product/K013$odexpath
		fi
	done
	;;
27) echo "delete 27 apk(com.google.*) filtered in /vendor/google/products/gms.mk"
	#like /system/app/XXX.apk
	for apk in `cat ~/blacklist.google`
	do
			apkpath=$apk
			rm /home/peggy/disk_t/dev_me176c/src/out/target/product/K013$apkpath
			odexpath_no_apk=`echo $apkpath |awk -F "apk" '{print $1}'`
			odexpath=${odexpath_no_apk}odex
			rm /home/peggy/disk_t/dev_me176c/src/out/target/product/K013$odexpath
	done
	;;
28)	echo "check if 27 apks are created after build_debug with REMOVE_PACKAGES_TMP"
	for apk in `cat ~/blacklist.google`
	do
			apkpath=$apk
			echo "apk name:$apk apkpath:$apkpath"
			ls /home/peggy/disk_t/dev_me176c/src/out/target/product/K013$apkpath
			#xxx.apk -> xxx.odex
			odexpath_no_apk=`echo $apkpath |awk -F "apk" '{print $1}'`
			odexpath=${odexpath_no_apk}odex
			ls /home/peggy/disk_t/dev_me176c/src/out/target/product/K013$odexpath
	done
	;;
29) echo "Function \"filter-out\" "
#can not work ,should in .mk
	products := aaa bbb ccc ddd eee
	remove_products := ccc	\
		ddd
	$(warning $products)	
	;;
30) echo "delete all nocompany apk(com.nocompany.*) in blacklist_v2_dev"
	#like /system/app/XXX.apk
	for apk in `cat ~/blacklist_v2_dev |head -n 71 |grep "^/system"`
	do
			apkpath=$apk
			rm /home/peggy/disk_t/dev_me176c/src/out/target/product/K013$apkpath
			odexpath_no_apk=`echo $apkpath |awk -F "apk" '{print $1}'`
			odexpath=${odexpath_no_apk}odex
			rm /home/peggy/disk_t/dev_me176c/src/out/target/product/K013$odexpath
	done
	;;
31)	echo "check if all nocompany apks are created after build_debug with REMOVE_PACKAGES_TMP"
	for apk in `cat ~/blacklist_v2_dev |head -n 71 |grep "^/system"`
	do
			apkpath=$apk
			echo "apk name:$apk apkpath:$apkpath"
			ls /home/peggy/disk_t/dev_me176c/src/out/target/product/K013$apkpath
			#xxx.apk -> xxx.odex
			odexpath_no_apk=`echo $apkpath |awk -F "apk" '{print $1}'`
			odexpath=${odexpath_no_apk}odex
			ls /home/peggy/disk_t/dev_me176c/src/out/target/product/K013$odexpath
	done
	;;
32)	echo "rm or ls($ 2) all apk or nocompany apk or google apk ,depending on $ 3 "
	apks2=
	case $3 in
	all) 
		echo "num=:"`cat ~/blacklist_v2_dev  |grep "^/system"|wc -l`
		apks=`cat ~/blacklist_v2_dev  |grep "^/system"`
		;;
	nocompany) echo "num=:"`cat ~/blacklist_v2_dev |head -n 71 |grep "^/system"|wc -l`
		apks=`cat ~/blacklist_v2_dev |head -n 71 |grep "^/system"`
		;;
	google) echo "num=:"`cat ~/blacklist_v2_dev |tail -n 98 |head -n 27 |grep "^/system"|wc -l`
		apks=`cat ~/blacklist_v2_dev |tail -n 98 |head -n 27 |grep "^/system"`
		;;
	*)
		;;
	esac
	for apk in $apks
	do
			apkpath=$apk
			echo "apk name:$apk apkpath:$apkpath"
			#xxx.apk -> xxx.odex
			odexpath_no_apk=`echo $apkpath |awk -F "apk" '{print $1}'`
			odexpath=${odexpath_no_apk}odex
			if [ $2 == "rm" ] ; then
			rm /home/peggy/disk_t/dev_me176c/src/out/target/product/K013$apkpath
			rm /home/peggy/disk_t/dev_me176c/src/out/target/product/K013$odexpath
			else
			ls /home/peggy/disk_t/dev_me176c/src/out/target/product/K013$apkpath
			ls /home/peggy/disk_t/dev_me176c/src/out/target/product/K013$odexpath
			fi
	done
	;;
33) echo "create blacklist like out/target/.../xxx.apk to be used in main.mk"
	apks=`cat ~/blacklist_v2_dev  |grep "^/system"`
	for apk in $apks
	do
		cat /home/peggy/blacklist_in_main_mk |grep $apk 2>&1 > /dev/null
		if [ $? -ne 0 ] ; then
		#not exists
			echo "out/target/product/K013$apk" >> /home/peggy/blacklist_in_main_mk
		fi		
	done
	;;
34)
	#grep -ir def.*stat path
	#defXXXXXstat matches
	;;
35) echo "ls -l with files found via grep"
	grep -r "struct block_device_operations " ./linux/kernel/ |awk -F : '{print $1}'|xargs ls -l
	;;
36) echo "get pkg name and path from packages.xml"
	echo '$2:'"path of packages.xml,name=XXX codePath=XXXX"
	xmlpath=$2
	outpath=$2.name.path
	num=$(cat $xmlpath |grep "<package "|awk -F " " '{print $2" "$3}' |wc -l)
	echo "pkg num : $num ." > $outpath
	cat $xmlpath |grep "<package "|awk -F " " '{print $2" "$3}' >> $outpath
	;;
37) echo 'get pkg name COM.XXX from packages.xml ,sort them'
	echo '$2:packages.xml'
	xmlpath=$2
	outpath=$2_pkgname
	pkgpath=$2_pkgpath
#	num=$(cat $xmlpath |grep "<package "|awk -F " " '{print $2" "$3}' |wc -l)
#	echo "pkg num : $num ." > $outpath
	cat $xmlpath |grep "<package "|awk -F "\"" '{print $2}' |sort> $outpath
	cat $xmlpath |grep "<package "|awk -F "\"" '{print $2" "$4}'|sort|awk -F " " '{print $2}' > $pkgpath
	;;
38) echo 'every pkgname on $2 is on $3'
	echo 'pkg on $3 should be quoted'
	pkgs_1=$2
	pkgs_2=$3
	ty=$4
	apks_1=`cat $pkgs_1`
	apks_2=`cat $pkgs_2`
	if [ $ty == "f_in_s" ] ; then	
	rm ~/550_shipping_image/factory_in_shipping
	rm ~/550_shipping_image/factory_notin_shipping
	else 
	rm ~/550_shipping_image/shipping_notin_factory
	rm ~/550_shipping_image/shipping_in_factory
	fi
	for pkgname in $apks_1
	do
		echo "pkgname:$pkgname end"
		cat $pkgs_2 |grep "\"$pkgname\""
		if [ $? -eq 0 ] ; then
			if [ $ty == "f_in_s" ] ; then
			echo $pkgname >> ~/550_shipping_image/factory_in_shipping
			else
			echo $pkgname >> ~/550_shipping_image/shipping_in_factory
			fi
		else
			if [ $ty == "f_in_s" ] ; then
			echo $pkgname >> ~/550_shipping_image/factory_notin_shipping
			else
			echo $pkgname >> ~/550_shipping_image/shipping_notin_factory
			fi
		fi
	done
	;;
39) echo 'create path from com.XXX ,will be build'
	pkgs_1=$2
	pkgs_shipping=$3
	ty=$4
	apks_1=`cat $pkgs_1`
	apks_2=`cat $pkgs_shipping`	
	cat $pkgs_shipping
#	cp $2 $2_copied
#
#	cat $2_copied  |sed -e '/^M$/d' > $2_copied 
#	cat $2_copied  |sed -e '/^$/d' > $2_copied 
#	for pkgname in $apks_1
#	for pkgname in `cat $pkgs_1`

	rm  ~/550_shipping_image/apks_will_be_filtered.*
	rm ~/hellotest.txt
	rm ~/hellotest2.txt
	for pkgname in `cat $2`
	do
#pkgname:XXXX 
# end
#		echo "pkgname:$pkgname end" >>~/hellotest.txt
#\s not void char,bus s char !
#		pkgname_no_tr=`echo $pkgname |awk -F "\s" '{print "0:"$0",1:"$1",2:"$2}'`
#		echo "pkgname_no_tr:$pkgname_no_tr end" >>~/hellotest.txt

#cat $3 ok
#		cat $3
#ok grep ok
		cat $3 | grep "\""$pkgname"\""

		if [ $? -eq 0 ] ; then

		#	if [ $ty == "f_in_s" ] ; then
			echo "pkgname:$pkgname filted"
			cat $3 |grep "\""$pkgname"\"" >> ~/550_shipping_image/apks_will_be_filtered.name.path
			cat $3 |grep "\""$pkgname"\"" |awk -F "\"" '{print $2}'>> ~/550_shipping_image/apks_will_be_filtered.name
			path=`cat $3 |grep "\""$pkgname"\"" |awk -F "\"" '{print $4}'`
			out_product_path=`echo "out/target/product/K013$path"`
			echo $path>> ~/550_shipping_image/apks_will_be_filtered.path
			echo $out_product_path>> ~/550_shipping_image/apks_will_be_filtered.outproduct.path
		#	else
		#	echo $pkgname >> ~/550_shipping_image/shipping_in_factory
		#	fi

		else
			echo "pkgname:$pkgname not"
		#	if [ $ty == "f_in_s" ] ; then
		#	echo $pkgname >> ~/550_shipping_image/apks_will_not_be_filtered
		#	else
		#	echo $pkgname >> ~/550_shipping_image/shipping_notin_factory
		#	fi
		fi
	done
	cat $2 |while read line
	do
	echo "line:$line end">>~/hellotest2.txt
	done
	;;

40) echo 'get name.path from name'
	for pkgname in `cat $2`
	do
		cat $3 |grep "\""$pkgname"\""
	done
	;;
41) echo 'for 550 filter apks blacklist,change /.../XX to /.../XX/XX.apk'
	for original in `cat $2`
	do
	#out/target/product/K013/system/priv-app/GoogleBackupTransport
		path=`echo $original |awk -F "/" '{print $1"/"$2"/"$3"/"$4"/"$5"/"$6}' `
		name=`echo $original |awk -F "/" '{print $7}'`
		newpath=`echo $path"/"$name"/"$name".apk"`
		echo $newpath >> $2.androidl
	done
	;;
42) echo 'difference between file $1 & file $2,result:$3'
	file1=$2
	file2=$3
	file_ret=$4
	file_tmp_1_notin_2=`echo "$file_ret"_1_not_2`
	file_tmp_2_notin_1=`echo "$file_ret"_2_not_1`
	file_tmp_1_in_2=`echo "$file_ret"_1_in_2`
	file_tmp_2_in_1=`echo "$file_ret"_2_in_1`
	rm $file_tmp_1_notin_2
	rm $file_tmp_2_notin_1
	rm $file_tmp_1_in_2
	rm $file_tmp_2_in_1

	echo "peggy"
	for item in `cat $file1`
	do
		echo "$file1 item:$item end"
		echo "cat $file2 |grep $item"
		cat $file2 |grep "^$item$"

		if [ $? -eq 0 ] ; then
		#ok
			echo "-eq 0,grep ok"
			echo $item >> $file_tmp_1_in_2
		else
			echo "-eq non-0,grep fail"
			echo $item >> $file_tmp_1_notin_2
		fi
	done

	for item in `cat $file2`
	do
		echo "$file2 item:$item end"
		echo "cat $file1 |grep $item"
		cat $file1 |grep "^$item$"
		if [ $? -eq 0 ] ; then
		#ok
			echo "-eq 0,grep ok"
			echo $item >> $file_tmp_2_in_1
		else
			echo "-eq non-0,grep fail"
			echo $item >> $file_tmp_2_notin_1
		fi
	done
	num_file_tmp_1_notin_2=`cat  $file_tmp_1_notin_2|wc -l`
	num_file_tmp_2_notin_1=`cat  $file_tmp_2_notin_1|wc -l`
	num_file_tmp_1_in_2=`cat  $file_tmp_1_in_2|wc -l`
	num_file_tmp_2_in_1=`cat  $file_tmp_2_in_1|wc -l`
	if [ $num_file_tmp_1_in_2 -ne $num_file_tmp_2_in_1 ] ; then
		echo "error num of $file_tmp_1_in_2 and num of $file_tmp_2_in_1"
		echo "num of $file_tmp_1_in_2:$num_file_tmp_1_in_2"
		echo "num of $file_tmp_2_in_1:$num_file_tmp_2_in_1"
		exit
	fi
	
	;;
43) echo 'adb pull all things unrecursively,$2=inpath,ends with non-/,$3=outpath,ends with non-/'
	inpath=$2
	outpath=$3
	items=`adb shell ls $inpath/`
	for item in $items
	do
		echo $item
		orignal_file=$inpath/$item
#contain \r
#/logs/aplog\r
#( ends )aplog
#		echo "A:"$orignal_file"( ends )"
#		echo "B:"$target_file"( ends )"
		target_file=$outpath/$item
#		echo "A:"$orignal_file"( ends )"
#		echo "B:"$target_file"( ends )"
		orignal_file=`echo $orignal_file |awk -F "\r" '{print $1}'`
		target_file=`echo $target_file |awk -F "\r" '{print $1}'`
#sed will stuck
#		cat $original_file | sed 's/[\r]*$//g'
		echo "A:"$orignal_file"( ends )"
		echo "B:"$target_file"( ends )"
		adb shell ls -l $orignal_file |grep "^d"
		if [ $? -eq 0 ] ; then 
			echo "ignore directory:$orignal_file"	
		else
			adb pull $orignal_file $target_file
		fi
#		if [ -d $orignal_file ] ; then
#				echo "ignore directory:$orignal_file"
#		else
#				adb pull $orignal_file $target_file	
#		fi
	done
	echo $items
	;;
44) echo 'ls -l every file in $2'
for path in `cat $2`
do
#	echo "path($path)end"
	adb shell ls -l $path
done	
	;;
45) echo 'word count in file $2'
	for word in `cat $2|uniq`
	do
		num=`cat $2|grep $word|wc -l`
		echo "num:$num,word:$word,"
	done
	;;
46) echo '46:echo -n'
	echo "Hello," 
	echo "World."
	echo -n "Hello," 
	echo "World."
	base_path=`dirname $0`
	out_path=`echo $base_path`/$1
	echo "out_path:$out_path"
	if [ ! -d $out_path ] ;then
		mkdir $out_path
	fi
	echo "Hello," >> $out_path/out_46
	echo "World." >> $out_path/out_46
	echo -n "Hello," >> $out_path/out_46
	echo "World." >> $out_path/out_46
#   fruit:Apple,(end)
	fruit=`echo "Apple,"`
	echo "fruit:$fruit(end)"
	;;
47) echo 'list every line only for ubuntu'
	for item in `cat $2`
	do
		echo "item:$item(end)" 
		#>>$2.out
	done
	;;
48) echo $2':list every line for windows & ubuntu'
	sed 's/\r//g' $2 > $2.no0d
	for item in `cat $2.no0d`
	do
		echo "item:$item(end)" 
		#>>$2.out
	done
	rm $2.nood
	;;
49) echo '$pwd,./,path1/path2/file3'
	rm -rf $log_path/path1
	mkdir -p $log_path/path1/path2
	echo "hello" >$log_path/path1/path2/f
	echo "pwd:"
	pwd
	echo "ls ./:"
	ls ./
	echo "ls 49/path1/path2/"
	ls 49/path1/path2/
	;;
50) echo 'call python.py,if output in .py will be showed in terminal?yes'
	direc=`dirname $0`
	echo "direc=$direc"
	python $direc/hello.py
	if [ $# -eq 2 ] ; then
	file_py=$2
	python $file_py
	fi
	;;
51) echo 'pwd in .py means what?dir where we call s_test'
	direc=`dirname $0`
	python $direc/pwd/pwd.py
	;;
52) echo ""
    for((i=1;i<=7;i++));
    do 
#      echo  -e "\0377\0377" >>~/hello
		
		cat ~/1.txt ~/1.txt >~/2.txt
		cat ~/2.txt ~/2.txt >~/1.txt
    done
#	sed 's/\r//g' ~/hello > ~/hello.no0d
#	sed 's/\n//g' ~/hello > ~/hello.no0d

 	;;
53) echo '$@'
#s_test 53 hello
#$@:53 hello
#$#:2
	echo '$@:'$@
	echo '$#:'$#
	;;
54) echo 'string to digital,echo 0x17 instead of 0 x 1 7 '
	dig=24817920
	he=17AB100
awk 'BEGIN{
	for(i=0;i<100;i++)
		printf "%c",0xab
	}' |od -tx1
	echo -e "\0136530400" >$log_path/8
	hexdump -C $log_path/8
	#10->16
	echo "obase=16;${dig}"|bc
	dig_16=`echo "obase=16;${dig}"|bc`
	echo "dig_16:$dig_16"
	
	echo "dig:$dig"
	echo $dig >$log_path/24817920
#invain
	hexdump -C $log_path/24817920
	echo "0x017ab100"
	echo "obase=16;${dig}"|bc > $log_path/24817920_base16
	hexdump -C $log_path/24817920_base16

###dd: 打开"24817920" 失败: 没有那个文件或目录
#	dd if=$dig of=$log_path/24817920_dd
#	hexdump -C $log_path/24817920_dd
#in vain
	echo -e $dig > $log_path/24817920_e
	hexdump -C $log_path/24817920_e
#in vain
	echo  "$((${dig}+0))" > $log_path/24817920_add_0
	hexdump -C $log_path/24817920_add_0
	echo "hello"
echo 'ibase=16;31323334'|bc|awk '{printf("%c%c%c%c",$0/0x1000000,$0/0x10000,$0/0x100,$0)}'|   od -tx1
awk 'BEGIN{for(i=0;i<100;i++)printf "%c",0xab}' >$log_path/24817920_0xab
	hexdump -C $log_path/24817920_0xab
#	awk 'BEGIN{for(i=0;i<2;i++)printf "%c",0xab}'|od -x
#	echo "obase=10;${he}"|bc
#	echo "obase=16;${dig}"|bc
#	echo 'ibase=16;17ab1001'|bc|awk '{printf("%c%c%c%c",$0/0x1000000,$0/0x10000,$0/0x100,$0)}'|   od -tx1
	hexdump -C $log_path/24817920_awk
	;;
55) echo 'adb -s XX shell cat /proc/*/oom_score /proc/*/cmdline,$2 550/500'
	product=$2
	serial=""
	if [ $product -eq 550 ] ; then
		serial=`echo -n "-s 140514120004"`
	elif [ $product -eq 500 ] ; then 
		serial=`echo -n "-s F5AZCY04U002"`
	else 
		serial=""
	fi
	mv $log_path/$serial.cmdline $log_path/$serial.cmdline.bac
	adb $serial shell "ls  /proc/" |grep "[0-9]" > $log_path/$serial.procs
	sed 's/\r//g' $log_path/$serial.procs > $log_path/$serial.procs.no0d
	adb $serial shell "cat /proc/*/oom_score" |sort -n|tail -n 40 > $log_path/$serial.oom_scores
	sed 's/\r//g' $log_path/$serial.oom_scores > $log_path/$serial.oom_scores.no0d
	for proc in `cat $log_path/$serial.procs.no0d`
	do
	cmdline=`adb $serial shell cat /proc/$proc/cmdline`
	oom_adj=`adb $serial shell cat /proc/$proc/oom_adj`
	
	adb $serial shell cat /proc/$proc/oom_score > $log_path/$serial.oom_score
	sed 's/\r//g' $log_path/$serial.oom_score> $log_path/$serial.oom_score.no0d
	
	oom_score_adj=`adb $serial shell cat /proc/$proc/oom_score_adj`

	for score in `cat $log_path/$serial.oom_score.no0d`
	do
	#echo "score:$score()"
	cat $log_path/$serial.oom_scores |grep "^$score" > /dev/null
	if [ $? -eq 0 ] ;then
		echo "proc:$proc   ---  $cmdline" >> $log_path/$serial.cmdline
		echo "        oom_adj:$oom_adj " >> $log_path/$serial.cmdline
		echo "        oom_score:$score " >> $log_path/$serial.cmdline
		echo "        oom_score_adj:$oom_score_adj " >> $log_path/$serial.cmdline
	fi
		
	done
#	
	done
	echo "madhead:"
	adb $serial shell "ps"|grep -ie tencent
	madhead=`adb $serial shell "ps"|grep -ie madhead|busybox awk '{print $2}'`
	adb $serial shell "cat /proc/$madhead/oom_*"
	echo "ps:"
	mv $log_path/$serial.ps $log_path/$serial.ps.bac
	adb $serial shell "ps" > $log_path/$serial.ps
	
	adb $serial shell "ps"|grep u0|wc -l
	echo "meminfo:"
	mv $log_path/$serial.meminfo $log_path/$serial.meminfo.bac
	adb $serial shell "dumpsys meminfo" > $log_path/$serial.meminfo
	adb $serial shell "dumpsys meminfo com.tencent.tmgp.madhead.tos" >> $log_path/$serial.meminfo

	;;
56) echo "for vars in cat file,splited by space ?"
#splited by space,without newline,
##vars:hello(end
	for var in `cat $2`
	do
		echo "vars:$var(end)"
	done
	;;
57) echo "kill com.qualcomm.telephony"
	adb shell ps |grep com.qualcomm.telephony
	;;
58) echo "show msg when onStop-onPause>30s OR onDestroy-onStop>30s,arg2:srcfile"
	echo "LINE FORMAT:time item"
	srcfile=$2
	dbg=0
	item_pause="onPause()..."
	item_stop="onStop()..."
	item_destroy="onDestroy()..."
	t_pause=""
	t_stop=""
	t_destroy=""
	will_check=0

	sed 's/\r//g' $srcfile > $base_path/tmp_logcat_source_without_0d.txt
	cat $base_path/tmp_logcat_source_without_0d.txt | while read LINE
	do
		#echo "line:$LINE(end)"
		time=`echo $LINE|awk  '{print $1}'`
		item=`echo $LINE|awk  '{print $2}'`	
		if [ $dbg -eq 1 ] ; then
			echo "time:$time,item:$item" ;fi
		if [ $item == $item_pause ] ; then
			#echo "receive $item."
			t_pause=$time
			t_stop=""
			t_destroy=""
		elif [ $item == $item_stop ] ; then
			if [ $t_pause != "" ] ; then
				#echo "receive $item."
				t_stop=$time
			#else
				#exit 1 ;
			fi
		elif [ $item == $item_destroy ] ; then
			#echo "receive $item."
			if [ $t_pause != "" ] && [ $t_stop != "" ] ; then
				
				t_destroy=$time
				will_check=1
			#else
				#exit 1 ;
			fi
		#else 
			#echo "receive $item."
			#echo $item|hexdump -C
			
		fi
		if [ $will_check -eq 1 ] ; then
			will_check=0
			#echo "will check time!"
			fDiffTimeThreadsHold $(echo $t_pause|awk -F '.' '{print $1}') $(echo $t_stop|awk -F '.' '{print $1}') 30
			result=$?
			#echo "result $result"
			if [ $result -eq 1 ] ;then
				#onStop-onPause > 30s
				echo "Find LINE:$LINE"
				#exit 1
			fi
			fDiffTimeThreadsHold $(echo $t_stop|awk -F '.' '{print $1}') $(echo $t_destroy|awk -F '.' '{print $1}') 30
			result=$?
			#echo "result $result"
			if [ $result -eq 1 ] ;then
				#onStop-onPause > 30s
				echo "Find LINE:$LINE"
				#exit 1
			fi
			t_pause=""

		fi
		
			
	done
	;;
59) echo "given a firmware list,check"
#lists id/XXX
#lists2 mounted/XXX
	list_path=`echo $base_path/check_list`
	
	echo "list:$list_path"
	sed 's/\r//g' $base_path/check_list > $base_path/check_list_without_0d
	cat $base_path/check_list_without_0d | while read LINE
	do
		echo "Line:$LINE(end)"
		echo $LINE | grep "^$"
		if [ $? -ne 0 ] ; then
			echo "not void"
			filepath=`echo $base_path/lists2/$LINE`
			echo "file_path:$filepath" 	
			if [ -f $filepath ] ; then
				echo "file exits"
				sourcefilepath=`echo $base_path/lists/$LINE`
				echo "file_path2:$sourcefilepath" 	
				diff $filepath $sourcefilepath >> /dev/null
				if [ $? -ne 0 ] ; then
					echo "$LINE changed!"
					#exit 1
				fi
			else
				echo "file not exits ,ignore"
				#exit 1
			fi
		fi
	done
	;;
60) echo "check if wifi media keymaster widiwine are loaded ok"
	adb root
	#1 expected
	echo $(`adb shell getprop atd.keybox.ready`)end
	widevine=`adb shell getprop atd.keybox.ready`
	widevine=`echo ${widevine:0:1}`
	if [ "$widevine" = "1" ] ; then
		echo " expected "
	else 
		echo "not expected "
	fi
	echo "$? widevine $widevine(end)"

	#true expected
	keymaster=`adb shell getprop sys.keymaster.loaded`
	keymaster=`echo ${keymaster:0:4}`
	if [ "$keymaster" = "true" ] ; then
		echo "expected "
	else 
		echo "not expected"
	fi
	echo "$? keymaster $keymaster(end)"
	
	#CNSS-PR-2-0-1-1-c1-00011 expected
	#wifi=`adb shell getprop wifi.version.driver`
	count=`adb shell getprop wifi.version.driver|wc -c`
	if [ $count -gt 2 ] ; then
		echo "expected"
	else 
		echo "not expected"
	fi
	echo "$? wifi $wifi(end)"
	#venus: venus: loading from
	#venus: venus: venus: Brought out of reset
	#adb shell grep -r "venus: loading from" /data/logcat_log/ 
	#echo "$? "
	#adb shell grep -r "venus: venus: Brought out of reset" /data/logcat_log/ 
	#echo "$? "
	adb shell "dmesg|grep -e 'venus: loading from'"
	adb shell "dmesg|grep -e 'venus: venus: Brought out of reset'"
	count=`adb shell "dmesg|grep -e 'venus: loading from'"|wc -c`
	echo $count
	if [ $count -gt 0 ] ; then
		echo "expected"
	else 
		echo "not expected"
	fi
	count=`adb shell "dmesg|grep -e 'venus: venus: Brought out of reset'"|wc -c`
	echo $count
	if [ $count -gt 0 ] ; then
		echo "expected"
	else 
		echo "not expected"
	fi
	;;
61) echo "	#grep onPause onStop onDestroy,arg2:file arg3:outfile"
	srcfile=$2
	outfile=$3
	rm "$base_path"/"$outfile"
	cat $srcfile|grep -e "onStop().*com.nocompany.nocompanyincallui.InCallActivity" -e "onPause().*com.nocompany.nocompanyincallui.InCallActivity" -e "onDestroy().*com.nocompany.nocompanyincallui.InCallActivity" > "$base_path"/tmp_src_onPause
	cat "$base_path"/tmp_src_onPause | while read LINE
	do
		#echo "Line:$LINE(end)"
		echo $LINE | grep "^$"
		if [ $? -ne 0 ] ; then
			#echo "not void"
			time=`echo $LINE|awk -F ' ' '{print $2}'`
			item=`echo $LINE|awk -F ' ' '{print $6}'`
			#echo "time:$time(end)"
			if [ $item == - ] ;then
				item=`echo $LINE|awk -F ' ' '{print $7}'`
			#else
				#echo "item:$item"
			fi
			echo "$time $item" >> "$base_path"/"$outfile"
		fi
	done
	;;
62) echo "search android /proc/pid arg3:74828000-7506d000 or 73d6e000-745b6000 or void"
	size=$2
	adb shell ls /proc |grep "[0-9]" > "$base_path"/tmp.source
	sed 's/\r//g' "$base_path"/tmp.source > "$base_path"/tmp.source.no0d
	for pid in `cat "$base_path"/tmp.source.no0d`
	do
#		echo "pid:$pid(end)"
		adb shell "cat /proc/$pid/maps" |grep "dalvik-non mov"|grep -e "$size" #> /dev/null
		if [ $? -eq 0 ] ; then
			#echo "pid:$pid"
			adb shell ps |grep $pid
		else
			echo "pid:$pid"
		fi		
	done
	rm "$base_path"/tmp.source
	rm "$base_path"/tmp.source.no0d
	;;
63) echo "adb shell,do somethings all the time"
    for((i=1;i<=1000;i++));
    do 
		echo "peggy" 
#		adb shell dumpsys meminfo |grep "Free RAM"
#		adb shell dmesg|grep denied
#		adb shell ps
		
#		for item in `adb shell top -t |grep system/bin/mediaserver|head -n 6`
#		do
#			echo "item:$item"
#		done
	
		adb shell pull /storage/emulated/0/Download/ ~/gts_download/
		if [ $? -eq 0 ] ; then
			break;
		fi		
    done
	;;
64) echo "dd blockes from 500"
	cat "$base_path""/partition_dev" | while read LINE
	do
		echo "" 
		echo "Line:$LINE(end)"
		echo $LINE | grep "^$"
		if [ $? -ne 0 ] ; then
			partition=`echo $LINE|awk -F ' ' '{print $1}'`
			dev=`echo $LINE|awk -F ' ' '{print $2}'|awk -F '/' '{print $4}'` 
			echo "partition:$partition(end)"
			echo "dev:$dev(end)"
			cat "$base_path""/500_partitions" |grep "$dev$" > /dev/null
			if [ $? -eq 0 ] ;then
				sectors=`cat "$base_path""/500_partitions" |grep "$dev$" |awk -F ' ' '{print $3}'`
				echo "adb shell dd if=/dev/block/bootdevice/by-name/${partition} of=/sdcard/${partition}.bac bs=512 count=${sectors}"
				adb shell dd if=/dev/block/bootdevice/by-name/${partition} of=/sdcard/${partition}.bac bs=512 count=${sectors}
				echo "sectors:$sectors(end)"
			fi
		fi
	done
#	


	;;
65) echo "" 
	for file in `ls ./`
	do
		echo "file:$file(end)"
		line=`hexdump -C $file | wc -l `
		echo "line:$line(end)"
	done
	;;
66) echo "argu2:path"
	path=$2
	files=`dir $path`
	for file in $files
	do
		echo "file:$file"
		apk="$path""/""$file"
		adb install $apk
	done
	;;
67) echo "generate verity.pk8 verity.x509.pem for 8937"
	echo "argu2:keypath"
	keypath=$2
	openssl genrsa -out ${keypath}/nocompany_rootca.key -3 2048
openssl req -new -key ${keypath}/nocompany_rootca.key -x509 -out ${keypath}/nocompany_rootca.crt ${DIGEST} -subj /C=CN/ST="JiangSu"/L="SuZhou"/OU="General Use Test Key (for testing only)"/OU="ATSZ"/O="nocompany"/CN="nocompany Root CA 1" -days 7300 -set_serial 1 -config resources/openssl/opensslroot.cfg
openssl x509 -in ${keypath}/nocompany_rootca.crt -inform PEM -out ${keypath}/nocompany_rootca.cer -outform DER

openssl genrsa -out ${keypath}/nocompany_attestca.key -3 2048
openssl req -new -key ${keypath}/nocompany_attestca.key -out ${keypath}/nocompany_attestca.csr ${DIGEST} -subj /C=CN/ST="JiangSu"/L="SuZhou"/OU="ATSZ"/O="nocompany"/CN="nocompany Attestation CA" -days 7300 -config resources/openssl/opensslroot.cfg
openssl x509 -req -in ${keypath}/nocompany_attestca.csr -CA ${keypath}/nocompany_rootca.crt -CAkey ${keypath}/nocompany_rootca.key -out ${keypath}/nocompany_attestca.crt ${DIGEST} -set_serial 5 -days 7300 -extfile resources/openssl/v3.ext
openssl x509 -in ${keypath}/nocompany_attestca.crt -inform PEM -out ${keypath}/nocompany_attestca.cer -outform DER

openssl genrsa -out ${keypath}/nocompany_attest.key -3 2048

	;;
68) echo "re-generate nocompanyrootca.crt for 8917&8953"
DIGEST="-SHA1"
#in
nocompany_rootca_key="/home/nobody/100g/items/sectools_old/resources/key_for_8937/nocompany_rootca_8937.key"
nocompany_attestca_key="/home/nobody/100g/items/sectools_old/resources/key_for_8937/nocompany_attestca_8937.key"
nocompany_attest_key="/home/nobody/100g/items/sectools_old/resources/key_for_8937/nocompany_attest_8937.key"
#out
nocompany_rootca_crt="/home/nobody/100g/items/sectools_old/resources/key_for_8937/nocompany_rootca_8937.crt.20160411"
nocompany_attestca_csr="/home/nobody/100g/items/sectools_old/resources/key_for_8937/nocompany_attestca_8937.csr.20160411"
nocompany_attestca_crt="/home/nobody/100g/items/sectools_old/resources/key_for_8937/nocompany_attestca_8937.crt.20160411"
nocompany_attest_csr="/home/nobody/100g/items/sectools_old/resources/key_for_8937/nocompany_attest_8937.csr.20160411"
nocompany_attest_crt="/home/nobody/100g/items/sectools_old/resources/key_for_8937/nocompany_attest_8937.crt.20160411"
openssl req -new -key ${nocompany_rootca_key} -x509 -out ${nocompany_rootca_crt} ${DIGEST} -subj /C=CN/ST="JiangSu"/L="SuZhou"/OU="General Use Test Key (for testing only)"/OU="ATSZ"/O="nocompany"/CN="nocompany Root CA 1" -days 7300 -set_serial 1 -config resources/openssl/opensslroot.cfg

openssl req -new -key ${nocompany_attestca_key} -out ${nocompany_attestca_csr} ${DIGEST} -subj /C=CN/ST="JiangSu"/L="SuZhou"/OU="ATSZ"/O="nocompany"/CN="nocompany Attestation CA" -days 7300 -config resources/openssl/opensslroot.cfg

openssl x509 -req -in ${nocompany_attestca_csr} -CA ${nocompany_rootca_crt} -CAkey ${nocompany_rootca_key} -out ${nocompany_attestca_crt} ${DIGEST} -set_serial 5 -days 7300 -extfile resources/openssl/v3.ext


openssl req -new -key ${nocompany_attest_key} -out ${nocompany_attest_csr} ${DIGEST} -subj /C=CN/ST="JiangSu"/L="SuZhou"/emailAddress=Yuchao_Yan@nocompany.com/OU="07 0001 DIGEST"/OU="06 0001 MODEL_ID"/OU="05 00002000 SW_SIZE"/OU="04 0001 OEM_ID"/OU="03 000000000000000F DEBUG"/OU="02 007180E100010001 HW_ID"/OU="01 0000000000000000 SW_ID"/O="nocompany"/CN="nocompany Attestation Cert" -days 7300 -config resources/openssl/opensslroot.cfg

openssl x509 -req -in ${nocompany_attest_csr} -CA ${nocompany_attestca_crt} -CAkey ${nocompany_attestca_key} -out ${nocompany_attest_crt} ${DIGEST} -set_serial 7 -days 7300 -extfile resources/openssl/v3_attest.ext
	;;
69) echo "getprop null.bluetooth.status"
	var=`./s_test 70`
	echo "(begin)" $var "(end)"
	;;
70) echo ""
	echo ""
	echo ""
	
	;;
71) echo "bluetooth.status"
	var=`getprop atd.keybox.ready`
	echo "keybox.ready:" "(begin)" $var "(end)"
	var=`getprop atd.keybox.null`
	echo "keybox.null:" "(begin)" $var "(end)"
	;;
72) echo ""
	var1="abc"
	if [ $var1 == "abc" ] ; then
		echo "=="
	else
		echo "!=="
	fi
	if [ $var1 == "" ] ; then
		echo "==void"
	else
		echo "!==void"
	fi
	if [ "$var1" == "abc" ] ; then
		echo "=="
	else
		echo "!=="
	fi
	if [ "$var1" == "" ] ; then
		echo "==void"
	else
		echo "!==void"
	fi
	;;
73) echo "get files list in argu2,store then in argu3"
	if [ ! -d $3 ] ; then
		mkdir $3
	fi
	for file in `cat $2`
	do
		echo "file:$file(end)"
		cp $file $3/
	done
	;;
74) echo "if"
a=2
b=2
c=2
	if [ $a -eq $b ] ; then 
		echo "a==b";
		if [ $b -eq $c ] ; then
			echo "b==c"
		fi;
		echo "a==b"
	else
		echo "a!=b"
	fi;
	;;
75) echo "-o"
fruit=="apple"
animal="bird"
bird="robin"
	if [ $fruit == "apple" -o $animal == "bird" -o $bird == "robin" ] ; then
		echo "apple or bird or robin"
	fi
num1=1
num2=0

	if [ -z "$num1" -o -z "$num3" ] ; then
		echo "1 or 2 or 3 not exist"
	fi
	if [ -z $num5 ] ; then
		echo "5 not exist"
	fi
	if [ -z $num4 ] ; then
		echo "4 not exist"
	fi
	;;
76) echo "let"
	echo '1+2='1+2
	echo 'expr 1 + 2 = '`expr 1 + 2 `
	let a=1+2
	echo '$$[1+2]='$[1+2]
	echo '$a=1+2 = '$a
	a=2
	b=3
#	echo `expr $a**$b`
	echo '$[a+b]='$[a+b]
    c=$a+$b
    echo 'c=$a+$b='$c
    let c=$a+$b
    echo 'let c=$a+$b='$c
	;;
77) echo "expression"
	x=1 
	y=1
	s=0
	t=`expr $x \* $y`
	t=`expr 1 \* 1`
	t=$[3*t]
	s=$[s+t]
	echo "s:$s"
	t=$[x*x]
	t=$[4*t]
	s=$[s+t]
	echo "s:$s"
	t=$[5*y]
	s=$[s+t]	
	echo "s:$s"
	t=6
	s=$[s+t]	
	echo "s:$s"
	;;
78) echo "echo"
	echo "start"
	echo -e "ccc\ccccccc"
	echo -e "nnn\nnnn"
	echo -e "ttt\tttt"
	echo "end"
	;;
79) echo "read"
#	read a
#	echo $a
#	read b c
#	echo $b
#	echo $c
#	read d e f
#	echo $d 
#	echo $e 
#	echo $f 
	echo "love2 love3 love4" > /home/nobody/love
	echo "love1" >> /home/nobody/love
	read a1 a2 a3 < /home/nobody/love
	echo $a1 
	echo $a2	 
	echo $a3 
	;;
80) echo "find makefile"
	export GREP_OPTIONS='--color=always'
	item=$2
	dir=`pwd`
	echo "pwd:$dir"
	find device/ -name "*.mk" |xargs grep -C 0 $2|grep -C 0 $2
	find build/ -name "*.mk" |xargs grep -C 0 $2|grep -C 0 $2
	find bootable/bootloader/lk/ -name "*.mk" |xargs grep -C 0 $2|grep -C 0 $2
	find vendor/ -name "*.mk" |xargs grep -C 0 $2|grep -C 0 $2
echo "device:"
	find device/ -name "Makefile" |xargs grep -C 0 $2|grep -C 0 $2
echo "build"
	find build/ -name "Makefile" |xargs grep -C 0 $2|grep -C 0 $2
echo "bootable:"
	find bootable/bootloader/lk -name "Makefile" |xargs grep -C 0 $2|grep -C 0 $2
echo "vendor:"
	find vendor/ -name "Makefile" |xargs grep -C 0 $2|grep -C 0 $2
	;;
800) echo "find makefile"
	export GREP_OPTIONS='--color=always'
	item=$2
echo	"grep -r $2 device/ |grep -ie \"mk:\" -ie \"makefile:\"|grep $2"
#	grep -r $2 device/ |grep -ie "mk:" -ie "makefile:"|grep $2
#	grep -r $2 build/ |grep -ie "mk:" -ie "makefile:"|grep $2
#	grep -r $2 bootable/ |grep -ie "mk:" -ie "makefile:"|grep $2
#	grep -r $2 vendor/ |grep -ie "mk:" -ie "makefile:"|grep $2
	grep -r $2 device/
	grep -r $2 build/ | grep -ie "mk" -ie "makefile"
	;;
81) echo "call 80 to find makefile"
	$0 80 gensecimage_target
	;;	
82) echo "2>&1 "
#	ls -l /home/nobody/null
#	ls -l /home/nobody/null >> /dev/null
#	ls -l /home/nobody/null 2>> /dev/null
#will show nothing
#	ls -l /home/nobody/null >> /dev/null 2>&1
#will show error
	ls -l /home/nobody/null 2>&1 >> /dev/null
	
	;;
83) echo "re directory"
	tr '[a-z]' '[A-Z]' < /home/nobody/love  > /home/nobody/love2
	cat /home/nobody/love2
	;;
84) echo "test"
	mkdir /home/nobody/dir_ok
	test -d /home/nobody/dir_ok
	echo "-d:ok:$?"
	test -d /home/nobody/dir_fail
	echo "-d:fail:$?"
	touch /home/nobody/file_ok
	test -f /home/nobody/file_ok
	echo "-f:ok:$?"
	test -f /home/nobody/file_fail
	echo "-f:fail:$?"
	test -s /home/nobody/file_ok
	echo "-s:ok:$?"
	test -s /home/nobody/file_fail
	echo "-s:fail:$?"
	test -s /home/nobody/dir_ok
	echo "-s:ok:$?"
	test -s /home/nobody/dir_fail
	echo "-s:fail:$?"
	v4=4
	v3=3
	test $v4 -eq $v3
	echo "-eq:4 & 3 :$?"
	test $v4 -ne $v3
	echo "-ne:4 & 3 :$?"
	test $v4 -le $v3
	echo "-le:4 & 3 :$?"
	test $v4 -ge $v3
	echo "-ge:4 & 3 :$?"
	test $v4 -lt $v3
	echo "-lt:4 & 3 :$?"
	test $v4 -gt $v3
	echo "-gt:4 & 3 :$?"
	[ $v4 -eq $v3 ]
	echo "-eq:4 & 3 :$?"
	[ $v4 -ne $v3 ]
	echo "-ne:4 & 3 :$?"
	[ $v4 -le $v3 ]
	echo "-le:4 & 3 :$?"
	[ $v4 -ge $v3 ]
	echo "-ge:4 & 3 :$?"
	[ $v4 -lt $v3 ]
	echo "-lt:4 & 3 :$?"
	[ $v4 -gt $v3 ]
	echo "-gt:4 & 3 :$?"
	s1="robin"
	test -z "$s1"
	echo "-z:non-zero:$?"
	test -n "$s1"
	echo "-n:non-zero:$?"
	s1=""
	test -n "$s1"
	echo "-n:zero:$?"
	test -n ""
	echo "-n:zero:$?"
	test -z "$s1"
	echo "-z:zero:$?"
	test -z ""
	echo "-z:zero:$?"
	test -n "$s2"
	echo "-n:null:$?"
	[ -n "$s2" ]
	echo "-n:null:$?"
	test -z "$s2"
	echo "-z:null:$?"
	[ -z "$s2" ]
	echo "-z:null:$?"

	str1=robin
	str2=ingale
	str3=ingale
	[ "$str1" = "$str2" ]
	echo "$str1" = "$str2" : "$?"
	cmd="\"$str1\" = \"$str2\""
	[ $cmd ]
	echo "$cmd" : "$?"
	cmd="\"$str1\" != \"$str2\""
	[ $cmd ]
	echo "$cmd" : "$?"
	cmd="\"$str2\" = \"$str3\""
	[ $cmd ]
	echo "$cmd" : "$?"
	cmd="\"$str2\" != \"$str3\""
	[ $cmd ]
	echo "$cmd" : "$?"

	cmd="\"$str1\" = \"$str2\""
echo	test $cmd 
	test $cmd 
	echo "$cmd" : "$?"
	cmd="\"$str1\" != \"$str2\""
	test $cmd
	echo "$cmd" : "$?"
	cmd="\"$str2\" = \"$str3\""
	test $cmd
	echo "$cmd" : "$?"
	cmd="\"$str2\" != \"$str3\""
	test $cmd
	echo "$cmd" : "$?"

	bird="swallow"
	fruit="orange"
	cmd="\"$bird\" = \"swallow\""
	test $cmd
	echo "$cmd" : "$?"
	cmd2="\"$fruit\" = \"orange\""
	test $cmd2
	echo "$cmd2" : "$?"
	[ "$cmd" ]
	echo "$cmd" : "$?"
	[ "$cmd" -a "$cmd2" ]
	echo "-a:$?"
	[ "$cmd" -o "$cmd2" ]
	echo "-o:$?"
	[ ! "$cmd" -a "$cmd2" ]
	echo "!:$?"

	;;
85) echo "shell"
	adb shell "ls -l /hello 
		 echo $?"
	;;
86) echo "call another shell"
	echo "s_test1:$$"
	./test
	echo "s_test2:$$"
	;;
87) echo "if"
	bird="swallow"
	if [ "$bird" = "robin" ] ;then 	echo "robin";
	elif [ "$bird" = "ingale" ] ; then 	echo "ingale"
	else echo "other"
	fi
	color="red"
	if [ "$bird" = "robin" -o "$bird" = "aswallow" ] ; then echo "robin or swallow";
	elif [ "$bird" = "swallow" -a "$color" = "red" ] ; then echo "and";
	fi
	if [ ! "$bird" = "swallow" ] ; then echo  "!swallow";
	fi
	if [ ! "$bird" != "swallow" ] ; then echo  "!!swallow";
	fi
	;;
88) echo "-f"
	ls -l ~/love
	path='/home/nobody/love'
	[ -f $path ]
	echo $path:$?
	ls -l $path
	path='~/love'
	[ -f $path ]
	echo $path:$?
	ls -l "\~/love"
echo 	ls -l $path
#invalid
	ls -l "$path"
#invalid
	ls -l $path
#invalid
	ls -l '~/love'
#invalid
	ls -l "~/love"
#invalid
cmd="ls -l $path"
echo cmd:$cmd
echo -e `$cmd`

path="~/love"
	[ -a "$path" ] 
#	[ -f ~/love ] 
	echo "-a:$?"

path="~/love"
base=`basename $path`
dir=`dirname $path`
echo "basename:"$base
echo "dirname:"$dir
[ -d $base ] 
echo "d:$?"
path="~/"
cd "~/"
echo "pwd:"`pwd`
	;;
89) echo "export certificates"
	infile=$2
	start=$3
	echo start:$start
	start=`echo $((16#$start))`
	echo start:$start
	cert1="$infile"_cert1
	cert2="$infile"_cert2
	cert3="$infile"_cert3

	cert1_start=4520

	#cert_start=4520	
	cert_start=$start
	cert=$cert1
	echo `printf "%x" $cert_start`
 	dd if=$infile of=$cert bs=1 count=4 skip=$cert_start
	size_high=`hexdump -C $cert |awk -F ' ' '{print $4}'`
	size_low=`hexdump -C $cert |awk -F ' ' '{print $5}'`
	size="$size_high""$size_low"
#	echo "size:$size_high end"
#	echo "size:$size_low end"
	echo "size:$size end"
	size=`echo $((16#$size))`
	echo "size:$size end"
	size_dd=`expr $size + 4`
	echo "size_dd:$size_dd end"
 	dd if=$infile of=$cert bs=1 count=$size_dd skip=$cert_start

	cert_start=`expr $cert_start + $size_dd`
	echo "cert2_start:$cert_start end"
	echo `printf "%x" $cert_start`
	cert=$cert2
 	dd if=$infile of=$cert bs=1 count=4 skip=$cert_start
	size_high=`hexdump -C $cert |awk -F ' ' '{print $4}'`
	size_low=`hexdump -C $cert |awk -F ' ' '{print $5}'`
	size="$size_high""$size_low"
#	echo "size:$size_high end"
#	echo "size:$size_low end"
	echo "size:$size end"
	size=`echo $((16#$size))`
	echo "size:$size end"
	size_dd=`expr $size + 4`
	echo "size_dd:$size_dd end"
 	dd if=$infile of=$cert bs=1 count=$size_dd skip=$cert_start

	cert_start=`expr $cert_start + $size_dd`
	echo "cert3_start:$cert_start end"
	echo `printf "%x" $cert_start`
	cert=$cert3
 	dd if=$infile of=$cert bs=1 count=4 skip=$cert_start
	size_high=`hexdump -C $cert |awk -F ' ' '{print $4}'`
	size_low=`hexdump -C $cert |awk -F ' ' '{print $5}'`
	size="$size_high""$size_low"
#	echo "size:$size_high end"
#	echo "size:$size_low end"
	echo "size:$size end"
	size=`echo $((16#$size))`
	echo "size:$size end"
	size_dd=`expr $size + 4`
	echo "size_dd:$size_dd end"
 	dd if=$infile of=$cert bs=1 count=$size_dd skip=$cert_start
	;;
90) echo "for str"
	for args
	do
		echo "argu:""$args"
	done
	;;
91) echo "until"
	count=1
	sum=0
	until [ "$count" -gt 10 ]
	do
		echo "count:""$count"
		sum=`expr $sum + $count`
		echo "sum:$sum"
		count=`expr $count + 1`
	done
	;;
92) echo "export"
	export
	;;
93) echo "choose bigger one"
	read a b
	if [ $a -gt $b ] ; then echo "$a > $b";
	elif [ $a -eq $b ] ; then echo "$a = $b";
	else echo "$a < $b";
	fi
	;;
94) 
	ls /home/nobody/unlock 
	echo ?:$?
	ls /home/ok/ 
	echo ?:$?
	;;
95) echo ""
#	echo 1234 >> /home/nobody/1
#	echo "<appname 1234" >> /home/nobody/1
#	echo 1234 >> /home/nobody/1
	cat /home/nobody/1 |grep "^<"
	;;
96) echo ""
	echo "date:"
	date 
	date +%m-%d-%H-%M
	;;
97) echo ""
python /home/nobody/disk3_2/8917-evb-fc/vendor/qcom/proprietary/common/scripts/pil-splitter.py 32 /home/nobody/100g/msm8953/WW-MSM8953-1.2.0.79-fac-eng-20160605152837-test/modem/ZS550KL/image/adsp
python /home/nobody/disk3_2/8917-evb-fc/vendor/qcom/proprietary/common/scripts/pil-splitter.py 32 /home/nobody/100g/msm8953/WW-MSM8953-1.2.0.79-fac-eng-20160605152837-test/modem/ZS550KL/image/cmnlib
python /home/nobody/disk3_2/8917-evb-fc/vendor/qcom/proprietary/common/scripts/pil-splitter.py 32 /home/nobody/100g/msm8953/WW-MSM8953-1.2.0.79-fac-eng-20160605152837-test/modem/ZS550KL/image/cpe_9335
python /home/nobody/disk3_2/8917-evb-fc/vendor/qcom/proprietary/common/scripts/pil-splitter.py 32 /home/nobody/100g/msm8953/WW-MSM8953-1.2.0.79-fac-eng-20160605152837-test/modem/ZS550KL/image/dhsecapp
python /home/nobody/disk3_2/8917-evb-fc/vendor/qcom/proprietary/common/scripts/pil-splitter.py 32 /home/nobody/100g/msm8953/WW-MSM8953-1.2.0.79-fac-eng-20160605152837-test/modem/ZS550KL/image/gptest
python /home/nobody/disk3_2/8917-evb-fc/vendor/qcom/proprietary/common/scripts/pil-splitter.py 32 /home/nobody/100g/msm8953/WW-MSM8953-1.2.0.79-fac-eng-20160605152837-test/modem/ZS550KL/image/modem
python /home/nobody/disk3_2/8917-evb-fc/vendor/qcom/proprietary/common/scripts/pil-splitter.py 32 /home/nobody/100g/msm8953/WW-MSM8953-1.2.0.79-fac-eng-20160605152837-test/modem/ZS550KL/image/isdbtmm
python /home/nobody/disk3_2/8917-evb-fc/vendor/qcom/proprietary/common/scripts/pil-splitter.py 32 /home/nobody/100g/msm8953/WW-MSM8953-1.2.0.79-fac-eng-20160605152837-test/modem/ZS550KL/image/qmpsecap
python /home/nobody/disk3_2/8917-evb-fc/vendor/qcom/proprietary/common/scripts/pil-splitter.py 32 /home/nobody/100g/msm8953/WW-MSM8953-1.2.0.79-fac-eng-20160605152837-test/modem/ZS550KL/image/smplap32
python /home/nobody/disk3_2/8917-evb-fc/vendor/qcom/proprietary/common/scripts/pil-splitter.py 32 /home/nobody/100g/msm8953/WW-MSM8953-1.2.0.79-fac-eng-20160605152837-test/modem/ZS550KL/image/venus
python /home/nobody/disk3_2/8917-evb-fc/vendor/qcom/proprietary/common/scripts/pil-splitter.py 32 /home/nobody/100g/msm8953/WW-MSM8953-1.2.0.79-fac-eng-20160605152837-test/modem/ZS550KL/image/wcnss

python /home/nobody/disk3_2/8917-evb-fc/vendor/qcom/proprietary/common/scripts/pil-splitter.py 64 /home/nobody/100g/msm8953/WW-MSM8953-1.2.0.79-fac-eng-20160605152837-test/modem/ZS550KL/image/cmnlib64
python /home/nobody/disk3_2/8917-evb-fc/vendor/qcom/proprietary/common/scripts/pil-splitter.py 64 /home/nobody/100g/msm8953/WW-MSM8953-1.2.0.79-fac-eng-20160605152837-test/modem/ZS550KL/image/cppf
python /home/nobody/disk3_2/8917-evb-fc/vendor/qcom/proprietary/common/scripts/pil-splitter.py 64 /home/nobody/100g/msm8953/WW-MSM8953-1.2.0.79-fac-eng-20160605152837-test/modem/ZS550KL/image/mdtp
python /home/nobody/disk3_2/8917-evb-fc/vendor/qcom/proprietary/common/scripts/pil-splitter.py 64 /home/nobody/100g/msm8953/WW-MSM8953-1.2.0.79-fac-eng-20160605152837-test/modem/ZS550KL/image/securemm
python /home/nobody/disk3_2/8917-evb-fc/vendor/qcom/proprietary/common/scripts/pil-splitter.py 64 /home/nobody/100g/msm8953/WW-MSM8953-1.2.0.79-fac-eng-20160605152837-test/modem/ZS550KL/image/smplap64
python /home/nobody/disk3_2/8917-evb-fc/vendor/qcom/proprietary/common/scripts/pil-splitter.py 64 /home/nobody/100g/msm8953/WW-MSM8953-1.2.0.79-fac-eng-20160605152837-test/modem/ZS550KL/image/widevine

#MSM8953-1.2.0.79-fac-eng-20160605152837-test/modem/ZS550KL/image/adsp
	;;
98) echo ""
mv /home/nobody/100g/msm8953/WW-MSM8953-1.2.0.79-fac-eng-20160605152837-test/modem/ZS550KL/image/adsp_join.mbn  /home/nobody/100g/msm8953/WW-MSM8953-1.2.0.79-fac-eng-20160605152837-test/modem/ZS550KL/image/adsp.mbn 
mv /home/nobody/100g/msm8953/WW-MSM8953-1.2.0.79-fac-eng-20160605152837-test/modem/ZS550KL/image/cmnlib_join.mbn  /home/nobody/100g/msm8953/WW-MSM8953-1.2.0.79-fac-eng-20160605152837-test/modem/ZS550KL/image/cmnlib.mbn 
mv /home/nobody/100g/msm8953/WW-MSM8953-1.2.0.79-fac-eng-20160605152837-test/modem/ZS550KL/image/cpe_9335_join.mbn  /home/nobody/100g/msm8953/WW-MSM8953-1.2.0.79-fac-eng-20160605152837-test/modem/ZS550KL/image/cpe_9335.mbn 
mv /home/nobody/100g/msm8953/WW-MSM8953-1.2.0.79-fac-eng-20160605152837-test/modem/ZS550KL/image/dhsecapp_join.mbn  /home/nobody/100g/msm8953/WW-MSM8953-1.2.0.79-fac-eng-20160605152837-test/modem/ZS550KL/image/dhsecapp.mbn 
mv /home/nobody/100g/msm8953/WW-MSM8953-1.2.0.79-fac-eng-20160605152837-test/modem/ZS550KL/image/gptest_join.mbn  /home/nobody/100g/msm8953/WW-MSM8953-1.2.0.79-fac-eng-20160605152837-test/modem/ZS550KL/image/gptest.mbn 
mv /home/nobody/100g/msm8953/WW-MSM8953-1.2.0.79-fac-eng-20160605152837-test/modem/ZS550KL/image/modem_join.mbn  /home/nobody/100g/msm8953/WW-MSM8953-1.2.0.79-fac-eng-20160605152837-test/modem/ZS550KL/image/modem.mbn 
mv /home/nobody/100g/msm8953/WW-MSM8953-1.2.0.79-fac-eng-20160605152837-test/modem/ZS550KL/image/isdbtmm_join.mbn  /home/nobody/100g/msm8953/WW-MSM8953-1.2.0.79-fac-eng-20160605152837-test/modem/ZS550KL/image/isdbtmm.mbn 
mv /home/nobody/100g/msm8953/WW-MSM8953-1.2.0.79-fac-eng-20160605152837-test/modem/ZS550KL/image/qmpsecap_join.mbn  /home/nobody/100g/msm8953/WW-MSM8953-1.2.0.79-fac-eng-20160605152837-test/modem/ZS550KL/image/qmpsecap.mbn 
mv /home/nobody/100g/msm8953/WW-MSM8953-1.2.0.79-fac-eng-20160605152837-test/modem/ZS550KL/image/venus_join.mbn  /home/nobody/100g/msm8953/WW-MSM8953-1.2.0.79-fac-eng-20160605152837-test/modem/ZS550KL/image/venus.mbn 
mv /home/nobody/100g/msm8953/WW-MSM8953-1.2.0.79-fac-eng-20160605152837-test/modem/ZS550KL/image/smplap32_join.mbn  /home/nobody/100g/msm8953/WW-MSM8953-1.2.0.79-fac-eng-20160605152837-test/modem/ZS550KL/image/smplap32.mbn 
mv /home/nobody/100g/msm8953/WW-MSM8953-1.2.0.79-fac-eng-20160605152837-test/modem/ZS550KL/image/wcnss_join.mbn  /home/nobody/100g/msm8953/WW-MSM8953-1.2.0.79-fac-eng-20160605152837-test/modem/ZS550KL/image/wcnss.mbn 

mv /home/nobody/100g/msm8953/WW-MSM8953-1.2.0.79-fac-eng-20160605152837-test/modem/ZS550KL/image/cmnlib64_join.mbn  /home/nobody/100g/msm8953/WW-MSM8953-1.2.0.79-fac-eng-20160605152837-test/modem/ZS550KL/image/cmnlib64.mbn 
mv /home/nobody/100g/msm8953/WW-MSM8953-1.2.0.79-fac-eng-20160605152837-test/modem/ZS550KL/image/cppf_join.mbn  /home/nobody/100g/msm8953/WW-MSM8953-1.2.0.79-fac-eng-20160605152837-test/modem/ZS550KL/image/cppf.mbn 
mv /home/nobody/100g/msm8953/WW-MSM8953-1.2.0.79-fac-eng-20160605152837-test/modem/ZS550KL/image/mdtp_join.mbn  /home/nobody/100g/msm8953/WW-MSM8953-1.2.0.79-fac-eng-20160605152837-test/modem/ZS550KL/image/mdtp.mbn 
mv /home/nobody/100g/msm8953/WW-MSM8953-1.2.0.79-fac-eng-20160605152837-test/modem/ZS550KL/image/securemm_join.mbn  /home/nobody/100g/msm8953/WW-MSM8953-1.2.0.79-fac-eng-20160605152837-test/modem/ZS550KL/image/securemm.mbn 
mv /home/nobody/100g/msm8953/WW-MSM8953-1.2.0.79-fac-eng-20160605152837-test/modem/ZS550KL/image/smplap64_join.mbn  /home/nobody/100g/msm8953/WW-MSM8953-1.2.0.79-fac-eng-20160605152837-test/modem/ZS550KL/image/smplap64.mbn 
mv /home/nobody/100g/msm8953/WW-MSM8953-1.2.0.79-fac-eng-20160605152837-test/modem/ZS550KL/image/widevine_join.mbn  /home/nobody/100g/msm8953/WW-MSM8953-1.2.0.79-fac-eng-20160605152837-test/modem/ZS550KL/image/widevine.mbn 


	;;
99) echo ""
mkdir /home/nobody/100g/msm8953/WW-MSM8953-1.2.0.79-fac-eng-20160605152837-test/modem/ZS550KL/image/splite/
cp /home/nobody/100g/msm8953/WW-MSM8953-1.2.0.79-fac-eng-20160605152837-test/modem/ZS550KL/image/signed/8953/*/*b0* /home/nobody/100g/msm8953/WW-MSM8953-1.2.0.79-fac-eng-20160605152837-test/modem/ZS550KL/image/splite/
cp /home/nobody/100g/msm8953/WW-MSM8953-1.2.0.79-fac-eng-20160605152837-test/modem/ZS550KL/image/signed/8953/*/*b1* /home/nobody/100g/msm8953/WW-MSM8953-1.2.0.79-fac-eng-20160605152837-test/modem/ZS550KL/image/splite/
cp /home/nobody/100g/msm8953/WW-MSM8953-1.2.0.79-fac-eng-20160605152837-test/modem/ZS550KL/image/signed/8953/*/*mdt /home/nobody/100g/msm8953/WW-MSM8953-1.2.0.79-fac-eng-20160605152837-test/modem/ZS550KL/image/splite/
	;;
100) echo ""
python /home/nobody/disk3_2/8917-evb-fc/vendor/qcom/proprietary/common/scripts/pil-splitter.py 32 /home/nobody/100g/msm8953/WW-MSM8953-1.2.0.79-fac-eng-20160605152837-test/8953-ststem-etc-firmware/firmware/a506_zap
mv /home/nobody/100g/msm8953/WW-MSM8953-1.2.0.79-fac-eng-20160605152837-test/8953-ststem-etc-firmware/firmware/a506_zap_join.mbn /home/nobody/100g/msm8953/WW-MSM8953-1.2.0.79-fac-eng-20160605152837-test/8953-ststem-etc-firmware/firmware/a506_zap.mbn

	;;
101) echo "run in qualcomm-sectools"
for sign_id in sbl1 mba sbl1 emmcbld firehose prog_emmc_firehose_dd prog_emmc_firehose_lite  validated_emmc_firehose_ddr   validated_emmc_firehose_lite  vip  adsp  devcfg  qsee  qhee  appsbl  uefi  rpm  mba  mba_wp  modem  wcnss  venus  vss  sampleapp  isdbtmm  widevine playready cmnlib cmnlib64 keymaster NON-HLOS winsecapp uefisecapp lksecapp mdtp cppf fingerprint qmpsecap dhsecapp dbgp_ap dbgp_msa dxhdcp2 sdksecapp efs_tar 
do
echo "sign_id:"$sign_id
dist/sectools secimage -p 8953 -i '/home/nobody/100g/msm8953/WW-MSM8953-1.2.0.79-fac-eng-20160605152837-test/8953-ststem-etc-firmware/firmware/a506_zap.mbn' -o '/home/nobody/100g/msm8953/WW-MSM8953-1.2.0.79-fac-eng-20160605152837-test/8953-ststem-etc-firmware/firmware/a506_zap' -g $sign_id -sa
done
	;;
102) echo "son"
	echo 'pid:'$$
	export num="102"
	echo "num-102;"$num
	python ~/100g/s_test/test.py 1
	echo "num-102;"$num
	;;
103) echo "father"
	export fruit="orange"
	echo 'pid:'$$
	export num="103"
	echo "num-103;"$num
	/bin/bash ~/100g/s_test/s_test 102
	echo "num-103;"$num
	;;
104) echo ""
	echo "fruit:"$fruit
	if [ "$fruit" = "orange" ] ;then
		echo "orange"
	fi
	echo "0:$1 1:$2 2:$2 3:$3"
	if [ "$3" == "remote" ] ; then
		echo "remote"
	fi
	echo "all:"$@
	echo "$@" |grep "fruit=orange"
	if [ $? -eq 0 ] ; then
		echo "0"
		export fruit="orange2"
	fi
	;;
105) echo ""
	echo "0:"$0
	echo "1:"$1
	echo "2:"$2
	echo "3:"$3
	echo "4:"$4
	echo "#:"$#
	echo "@:"$@
	;;
106) echo ""
	fruit="apple"
	if [ "$fruit" == "apple" ] ; then
		echo "=="
	fi
	if [ "$fruit" = "apple" ] ; then
		echo "="
	fi
	;;
107) echo ""
	fruit="orange"
	python ~/100g/s_test/test.py 2
	;;
108) echo ""	
	echo "animal="$animal
	echo "$animal" > /home/nobody/animal
	;;
109) echo "copy cn to ww"
	src_path=$2
#	adb push "$2"/lib/hw/sensors.msm8953.so /system/lib/hw/
#	adb push "$2"/lib/modules /system/lib/modules
#	adb push "$2"/lib/liboupengch.so /system/lib/
#	adb push "$2"/lib/liboupenglight.so /system/lib/
#	adb push "$2"/lib/liboupengtp.so /system/lib/

#	adb push "$2"/lib64/hw/sensors.msm8953.so /system/lib64/hw/
#	adb push "$2"/lib64/libnocompany_yellow_page.so /system/lib64/
#	adb push "$2"/lib64/libencrypt.so /system/lib64/
#	adb push "$2"/lib64/libgetValue-jni.so /system/lib64/
#	adb push "$2"/lib64/libttscompat.so /system/lib64/
#	adb push "$2"/lib64/libttspico.so /system/lib64/
#	adb push "$2"/lib64/libvlife_media.so /system/lib64/
#	adb push "$2"/lib64/libvlife_openglutil.so /system/lib64/
#	adb push "$2"/lib64/libvlife_render.so /system/lib64/

#	adb push "$2"/vendor/lib/libqmi.so /system/vendor/lib/
#	adb push "$2"/vendor/lib64/libsensor1.so /system/vendor/lib64/


#	adb shell rm /system/lib64/libbitmaps.so
#	adb shell rm /system/lib64/libcrashlytics-envelope.so
#	adb shell rm /system/lib64/libcrashlytics.so
#	adb shell rm /system/lib64/libfilterpack_facedetect.so
#	adb shell rm /system/lib64/libgif_encode.so
#	adb shell rm /system/lib64/libgifimage.so
#	adb shell rm /system/lib64/libimagepipeline.so
#	adb shell rm /system/lib64/libmemchunk.so
#	adb shell rm /system/lib64/libmvplayer-library.so
#	adb shell rm /system/lib64/libpapp.so
#	adb shell rm /system/lib64/libwebpimage.so
#	adb shell rm /system/lib64/libwebp.so

#	adb shell rm /system/vendor/media/LMspeed_508.emd
#	adb shell rm /system/vendor/media/PFFprec_600.emd

#	adb shell rm -rf /system/priv-app/AppUpdater/
#	adb shell rm -rf /data/data/com.nocompany.appinstallationservice

# fastboot format:ext4 userdata
	;;
110)

#	adb shell rm /system/vendor/lib/libp61-jcop-kit.so
	adb shell rm /system/vendor/lib/libQPayJNI.so
#	adb shell rm /system/vendor/lib64/libp61-jcop-kit.so
	adb shell rm /system/vendor/lib64/libQPayJNI.so

#/system/priv-app/nocompanyLauncher
	;;
111)
	adb push system/lib64/libbitmaps.so system/lib64/libbitmaps.so
	adb push system/lib64/libcrashlytics-envelope.so system/lib64/libcrashlytics-envelope.so
	adb push system/lib64/libcrashlytics.so system/lib64/libcrashlytics.so 
	adb push system/lib64/libfilterpack_facedetect.so system/lib64/libfilterpack_facedetect.so 
	adb push system/lib64/libgif_encode.so system/lib64/libgif_encode.so
	adb push system/lib64/libgifimage.so system/lib64/libgifimage.so
	adb push system/lib64/libimagepipeline.so system/lib64/libimagepipeline.so
	adb push system/lib64/libmemchunk.so system/lib64/libmemchunk.so
	adb push system/lib64/libmvplayer-library.so system/lib64/libmvplayer-library.so
	adb push system/lib64/libpapp.so system/lib64/libpapp.so
	adb push system/lib64/libwebpimage.so system/lib64/libwebpimage.so
	adb push system/lib64/libwebp.so system/lib64/libwebp.so

	adb push system/vendor/lib/libp61-jcop-kit.so system/vendor/lib/libp61-jcop-kit.so
	adb push system/vendor/lib/libQPayJNI.so system/vendor/lib/libQPayJNI.so
	adb push system/vendor/lib64/libp61-jcop-kit.so system/vendor/lib64/libp61-jcop-kit.so
	adb push system/vendor/lib64/libQPayJNI.so system/vendor/lib64/libQPayJNI.so

	adb push system/vendor/media/LMspeed_508.emd system/vendor/media/LMspeed_508.emd
	adb push system/vendor/media/PFFprec_600.emd system/vendor/media/PFFprec_600.emd

	;;
112) echo "cp drawable-xxx/*.png drawable/ if png doesnot exist"
    for d in `ls |grep drawable-`
    do
#        echo "dir:""$d"
        if [ -d $d ] ;then 
            echo "dir:""$d"           
            for png in `ls $d |grep png`  
            do
#                echo "png:$png"
                if [ ! -f "drawable/"$png ] ; then
                    echo cp $d"/"$png "drawable-land/"$png
                    cp $d"/"$png "drawable-land/"$png
                fi
            done
        fi
    done
    ;;
113) echo ""
    cp  core/res/res/drawable/power_off.png ~/tmp2/power_off.png
    cp  core/res/res/drawable/power_off_airplane.png ~/tmp2/power_off_airplane.png
cp core/res/res/drawable/power_off_airplane_sel.png ~/tmp2/power_off_airplane_sel.png
cp core/res/res/drawable/power_off_rebooting.png ~/tmp2/power_off_rebooting.png
cp core/res/res/drawable/power_off_silentmode_mute.png ~/tmp2/power_off_silentmode_mute.png
cp core/res/res/drawable/power_off_silentmode_normal.png ~/tmp2/power_off_silentmode_normal.png
cp core/res/res/drawable/power_off_silentmode_vibrate.png ~/tmp2/power_off_silentmode_vibrate.png
cp core/res/res/drawable/shutdown_background.png ~/tmp2/shutdown_background.png
    ;;
114) echo ""
    cp ~/tmp2/power_off.png  core/res/res/drawable/power_off.png
    cp ~/tmp2/power_off_airplane.png  core/res/res/drawable/power_off_airplane.png
cp ~/tmp2/power_off_airplane_sel.png core/res/res/drawable/power_off_airplane_sel.png
cp ~/tmp2/power_off_rebooting.png core/res/res/drawable/power_off_rebooting.png
cp ~/tmp2/power_off_silentmode_mute.png core/res/res/drawable/power_off_silentmode_mute.png
cp ~/tmp2/power_off_silentmode_normal.png core/res/res/drawable/power_off_silentmode_normal.png
cp ~/tmp2/power_off_silentmode_vibrate.png core/res/res/drawable/power_off_silentmode_vibrate.png
cp ~/tmp2/shutdown_background.png core/res/res/drawable/shutdown_background.png
    ;;
115)echo ""
    cp core/res/res/drawable/power_off_silentmode_normal.png  ~/tmp2/power_off_silentmode_normal.png
    cp core/res/res/drawable/power_off_silentmode_vibrate.png ~/power_off_silentmode_vibrate.png
    ;;
116)echo ""
    cp  ~/tmp2/power_off_silentmode_normal.png core/res/res/drawable/power_off_silentmode_normal.png
    cp ~/power_off_silentmode_vibrate.png core/res/res/drawable/power_off_silentmode_vibrate.png
    ;;
117)echo ""
input keyevent 3
am start --user 0 -n com.android.chrome/org.chromium.chrome.browser.ChromeTabbedActivity
input tap 260 1255
input text www.baidu.com
input tap 548 325
    ;;
118) echo ""
    count=0
    while [  "$count" -lt 102 ]; do
            echo "count:$count"
          adb shell service call window $count i32 0
            count=$(($count + 1))
        sleep 1
    done
    ;;
119) echo "diff"
for file in ` echo overlays/CN/frameworks/base/core/res/res/anim/shutdown_enter.xml overlays/CN/frameworks/base/core/res/res/anim/shutdown_exit.xml overlays/CN/frameworks/base/core/res/res/drawable-xxhdpi/power_off.png overlays/CN/frameworks/base/core/res/res/drawable-xxhdpi/power_off_airplane.png overlays/CN/frameworks/base/core/res/res/drawable-xxhdpi/power_off_airplane_off.png overlays/CN/frameworks/base/core/res/res/drawable-xxhdpi/power_off_airplane_off_sel.png overlays/CN/frameworks/base/core/res/res/drawable-xxhdpi/power_off_airplane_sel.png overlays/CN/frameworks/base/core/res/res/drawable-xxhdpi/power_off_rebooting.png overlays/CN/frameworks/base/core/res/res/drawable-xxhdpi/power_off_rebooting_sel.png overlays/CN/frameworks/base/core/res/res/drawable-xxhdpi/power_off_sel.png overlays/CN/frameworks/base/core/res/res/drawable-xxhdpi/power_off_silentmode_mute.png overlays/CN/frameworks/base/core/res/res/drawable-xxhdpi/power_off_silentmode_mute_sel.png overlays/CN/frameworks/base/core/res/res/drawable-xxhdpi/power_off_silentmode_normal.png overlays/CN/frameworks/base/core/res/res/drawable-xxhdpi/power_off_silentmode_normal_sel.png overlays/CN/frameworks/base/core/res/res/drawable-xxhdpi/power_off_silentmode_vibrate.png overlays/CN/frameworks/base/core/res/res/drawable-xxhdpi/power_off_silentmode_vibrate_sel.png overlays/CN/frameworks/base/core/res/res/drawable-xxhdpi/shutdown_background.png overlays/CN/frameworks/base/core/res/res/layout/global_actions.xml overlays/CN/frameworks/base/core/res/res/layout/global_actions_item2.xml overlays/CN/frameworks/base/core/res/res/values-zh-rCN/strings.xml overlays/CN/frameworks/base/core/res/res/values-zh-rTW/strings.xml overlays/CN/frameworks/base/core/res/res/values/add_resource_shutdown_dialog.xml overlays/CN/frameworks/base/core/res/res/values/strings.xml overlays/CN/frameworks/base/core/res/res/values/styles_shutdown_dialog.xml overlays/CN/frameworks/base/core/res/res/values/symbols.xml `
do 
    echo "file:$file"
    echo diff "/home/nobody/disk3_2/phonix/vendor/amax/""$file" "/home/nobody/disk2_2/amax_711/amax/""$file"
    diff "/home/nobody/disk3_2/phonix/vendor/amax/""$file" "/home/nobody/disk2_2/amax_711/amax/""$file"
done

    ;;
120)echo ""
#    cd ~/disk2_1/gradle/CNnocompanySystemUI-1.7-0.1
    grep -r "import android.util.Log;" src/|awk -F ":" '{print $1}' > ~/tt
    for file in `cat ~/tt`
    do
#        echo "file:$file"
        cat "$file" |grep "Log\." >> /dev/null
 #       echo "result:""$?"
        if [ $? -ne 0 ] ; then
            echo "file: ""$file"
        fi
    done
    ;;
121) echo "script arg1 <keys folder>"
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
122) echo "script arg1 <keys folder>"
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
123) #echo "cp signed mbn from $2/<platform>/<sign_id>/ to $3"
    #echo "cp signed b** from $2/<platform>/<sign_id>/ to $3/split"
    in_dir=$2
    out_dir=$3
    out_dir_split="$out_dir""/split"
    if [ ! -d $out_dir ] ; then
        mkdir -p $out_dir
    fi
    if [ ! -d $out_dir_split ] ; then
        mkdir -p $out_dir_split
    fi
    if [ -d "$in_dir""/8917/" ] ; then
        for dir in `dir "$in_dir""/8917/"`
        do
            mbn="$in_dir""/8917/""$dir""/*.mbn"
            mdt="$in_dir""/8917/""$dir""/*.mdt"
            b00="$in_dir""/8917/""$dir""/*.b**"
    #        ls -l $mbn
            cp $mbn $out_dir
            cp $mdt $out_dir_split
            cp $b00 $out_dir_split
        done
    fi
    ;;
124) echo "sign mbn on $2/, strore signed mbn in $3/<platform>/<sign_id>"
    in_dir=$2
    out_dir=$3
# count_mbn = count_ok + count_fail + count_missing
# count = count_mbn + count_contine
    count=0
    count_mbn=0
    count_ok=0
    count_fail=0
    count_missing=0
    count_continue=0
    msg_missing=""
    msg_fail=""
    msg_continue=""
    if [ ! -d $out_dir ] ; then
        mkdir -p $out_dir
    fi
    for file in `dir $in_dir`
    do
        missing="f"
        sign_id=""
        mbn="$in_dir""/""$file"
        echo "file:$mbn"
        if [ $file == "prog_emmc_firehose_8917.mbn" ]; then
            sign_id="prog_emmc_firehose_ddr"
            python ./sectools.py secimage -c config/8917/8917_secimage.xml -o $out_dir -i $mbn -g $sign_id -s
        elif [ $file == "validated_emmc_firehose_8917.mbn" ]; then
            sign_id="validated_emmc_firehose_ddr"
            python ./sectools.py secimage -c config/8917/8917_secimage.xml -o $out_dir -i $mbn -g $sign_id -s
        elif [ $file == "cmnlib.mbn" ]; then
            sign_id="cmnlib"
            python ./sectools.py secimage -c config/8917/8917_secimage.xml -o $out_dir -i $mbn -g $sign_id -s
        elif [ $file == "cmnlib64.mbn" ]; then
            sign_id="cmnlib64"
            python ./sectools.py secimage -c config/8917/8917_secimage.xml -o $out_dir -i $mbn -g $sign_id -s
        elif [ $file == "devcfg.mbn" ]; then
            sign_id="devcfg"
            python ./sectools.py secimage -c config/8917/8917_secimage.xml -o $out_dir -i $mbn -g $sign_id -s
        elif [ $file == "emmc_appsboot.mbn" ]; then
            sign_id="appsbl"
            python ./sectools.py secimage -c config/8917/8917_secimage.xml -o $out_dir -i $mbn -g $sign_id -s
        elif [ $file == "keymaster.mbn" ]; then
            sign_id="keymaster"
            python ./sectools.py secimage -c config/8917/8917_secimage.xml -o $out_dir -i $mbn -g $sign_id -s
        elif [ $file == "rpm.mbn" ]; then
            sign_id="rpm"
            python ./sectools.py secimage -c config/8917/8917_secimage.xml -o $out_dir -i $mbn -g $sign_id -s
        elif [ $file == "sbl1.mbn" ]; then
            sign_id="sbl1"
            python ./sectools.py secimage -c config/8917/8917_secimage.xml -o $out_dir -i $mbn -g $sign_id -s
        elif [ $file == "tz.mbn" ]; then
            sign_id="qsee"
            python ./sectools.py secimage -c config/8917/8917_secimage.xml -o $out_dir -i $mbn -g $sign_id -s
        elif [ $file == "adsp.mbn" ]; then
            sign_id="adsp"
            python ./sectools.py secimage -c config/8917/8917_secimage.xml -o $out_dir -i $mbn -g $sign_id -s
        elif [ $file == "cpe_9335.mbn" ]; then
            sign_id="cpe"
#            python ./sectools.py secimage -c config/8917/8917_secimage.xml -o $out_dir -i $mbn -g $sign_id -s
        elif [ $file == "cppf.mbn" ]; then
            sign_id="cppf"
            python ./sectools.py secimage -c config/8917/8917_secimage.xml -o $out_dir -i $mbn -g $sign_id -s
        elif [ $file == "dhsecapp.mbn" ]; then
            sign_id="dhsecapp"
            python ./sectools.py secimage -c config/8917/8917_secimage.xml -o $out_dir -i $mbn -g $sign_id -s
        elif [ $file == "fingerpr.mbn" ]; then
            sign_id="fingerpr"
            python ./sectools.py secimage -c config/8917/8917_secimage.xml -o $out_dir -i $mbn -g $sign_id -s
        elif [ $file == "fngap64.mbn" ]; then
            sign_id="fngap64"
            python ./sectools.py secimage -c config/8917/8917_secimage.xml -o $out_dir -i $mbn -g $sign_id -s
        elif [ $file == "gptest.mbn" ]; then
            sign_id="gptest"
            python ./sectools.py secimage -c config/8917/8917_secimage.xml -o $out_dir -i $mbn -g $sign_id -s
        elif [ $file == "isdbtmm.mbn" ]; then
            sign_id="isdbtmm"
            python ./sectools.py secimage -c config/8917/8917_secimage.xml -o $out_dir -i $mbn -g $sign_id -s
        elif [ $file == "mdtp.mbn" ]; then
            sign_id="mdtp"
            python ./sectools.py secimage -c config/8917/8917_secimage.xml -o $out_dir -i $mbn -g $sign_id -s
        elif [ $file == "modem.mbn" ]; then
            sign_id="modem"
            python ./sectools.py secimage -c config/8917/8917_secimage.xml -o $out_dir -i $mbn -g $sign_id -s
        elif [ $file == "qdsp6sw.mbn" ]; then
            sign_id="modem"
            python ./sectools.py secimage -c config/8917/8917_secimage.xml -o $out_dir -i $mbn -g $sign_id -s
        elif [ $file == "qmpsecap.mbn" ]; then
            sign_id="qmpsecap"
            python ./sectools.py secimage -c config/8917/8917_secimage.xml -o $out_dir -i $mbn -g $sign_id -s
        elif [ $file == "securemm.mbn" ]; then
            sign_id="securemm"
            python ./sectools.py secimage -c config/8917/8917_secimage.xml -o $out_dir -i $mbn -g $sign_id -s
        elif [ $file == "smplap32.mbn" ]; then
            sign_id="smplap32"
            python ./sectools.py secimage -c config/8917/8917_secimage.xml -o $out_dir -i $mbn -g $sign_id -s
        elif [ $file == "smplap64.mbn" ]; then
            sign_id="smplap64"
            python ./sectools.py secimage -c config/8917/8917_secimage.xml -o $out_dir -i $mbn -g $sign_id -s
        elif [ $file == "venus.mbn" ]; then
            sign_id="venus"
            python ./sectools.py secimage -c config/8917/8917_secimage.xml -o $out_dir -i $mbn -g $sign_id -s
        elif [ $file == "widevine.mbn" ]; then
            sign_id="widevine"
            python ./sectools.py secimage -c config/8917/8917_secimage.xml -o $out_dir -i $mbn -g $sign_id -s
        elif [ $file == "mba.mbn" ]; then
            sign_id="mba"
            python ./sectools.py secimage -c config/8917/8917_secimage.xml -o $out_dir -i $mbn -g $sign_id -s
        elif [ $file == "mcfg_hw.mbn" ]; then
            sign_id="mcfg_hw"
            python ./sectools.py secimage -c config/8917/8917_secimage.xml -o $out_dir -i $mbn -g $sign_id -s
        elif [ $file == "mcfg_sw.mbn" ]; then
            sign_id="mcfg_sw"
            python ./sectools.py secimage -c config/8917/8917_secimage.xml -o $out_dir -i $mbn -g $sign_id -s
        elif [ $file == "wcnss.mbn" ]; then
            sign_id="wcnss"
            python ./sectools.py secimage -c config/8917/8917_secimage.xml -o $out_dir -i $mbn -g $sign_id -s
        elif [ $file == "lksecapp.mbn" ]; then
            sign_id="lksecapp"
            python ./sectools.py secimage -c config/8917/8917_secimage.xml -o $out_dir -i $mbn -g $sign_id -s
        else 
            suffix=`echo $file|awk -F '.' '{print $NF}'`
            if [ $suffix == "mbn" ] ; then
                echo "ERROR: We dont know how to sign it?""$mbn"
                let count_missing=$count_missing+1
                msg_missing="            $file""\n""$msg_missing"
            else
                let count_continue=$count_continue+1
                msg_continue="        $file""\n""$msg_continue"
            fi
            missing="t"
        fi
        if [ $? -eq 0 ] ; then
            if [ $missing == "f" ] ; then
                out_mbn="$out_dir""/8917/""$sign_id""/""$file"
                if [ -f $out_mbn ] ; then
                    let count_ok=$count_ok+1
                else
                    let count_fail=$count_fail+1
                    msg_fail="            $file""\n""msg_fail"
                fi
            fi
        else 
            if [ $missing == "f" ] ; then
                let count_fail=$count_fail+1
                msg_fail="            $file""\n""$msg_fail"
            fi    
        fi
        let count=$count+1
    done
    let count_mbn=$count-$count_continue
    echo "$count"" : Total Files"
    echo "    $count_mbn"" : Total MBNs"
    echo "        $count_ok"" : MBNs Sign OK"
    echo "        $count_fail"" : MBNs Sign Fail"
    echo -e "$msg_fail"
    echo "        $count_missing"" : MBNs Miss Cmds"
    echo -e "$msg_missing"
    echo "    $count_continue"" : non-MBNs ignore"
    echo -e "$msg_continue"
    ;;
125) echo "ant-split *.n** & *.mdt"
    echo 'script $1 <..../> <wcnss>'
    echo "input : <path>"
    echo "output : <path>/joined"
    # cd /mnt/scripts
    # 
    path=$2
    fw_name=$3
    output_dir="$path""/joined"
    in_file_without="$path""/""$fw_name"
    in_file_mdt="$path""/""$fw_name"".mdt"
    out_file_mbn="$output_dir""/""$fw_name"".mbn"
    out_file_join_mbn="$path""/""$fw_name""_join.mbn"
    if [ ! -d $output_dir ] ; then
        mkdir -p $output_dir
    fi
    file $in_file_mdt
    type=`file $in_file_mdt |awk -F ' ' '{print $3}'`
    if [ $type == "32-bit" ] ; then
        type="32"
    elif [ $type == "64-bit" ] ; then
        type="64"
    fi
    echo "    python ./pil-splitter.py $type $in_file_without"
    python ./pil-splitter.py $type $in_file_without
    mv $out_file_join_mbn $out_file_mbn
    need_clean="true"
    if [ $need_clean == "true" ] ; then
        tmp_file="$path""/""$fw_name"".file"
        rm $tmp_file
    fi
    ;;
1255) #echo "ant-split A File,stored in $4"
    # cd /mnt/scripts
    path=$2
    fw_name=$3
    output_dir=$4
    in_file_without="$path""/""$fw_name"
    in_file_mdt="$path""/""$fw_name"".mdt"
    out_file_mbn="$output_dir""/""$fw_name"".mbn"
    out_file_join_mbn="$path""/""$fw_name""_join.mbn"
    if [ ! -d $output_dir ] ; then
        mkdir -p $output_dir
    fi
    file $in_file_mdt
    type=`file $in_file_mdt |awk -F ' ' '{print $3}'`
    if [ $type == "32-bit" ] ; then
        type="32"
    elif [ $type == "64-bit" ] ; then
        type="64"
    fi
    echo "    python ./pil-splitter.py $type $in_file_without"
    python ./pil-splitter.py $type $in_file_without
    mv $out_file_join_mbn $out_file_mbn
    need_clean="true"
    if [ $need_clean == "true" ] ; then
        tmp_file="$path""/""$fw_name"".file"
        rm $tmp_file
    fi
    ls -l $output_dir
    ;;
126) echo "ant-split A File & sign A Folder & store A Folder"
    path="$2"
    fw_name="$3"
    cd /mnt/scripts
    $script 125 "$path" "$fw_name"
    cd /mnt/sectools_8917/sectools
    $script 124 $path"/joined" $path"/signed"
    $script 123 $path"/signed" $path"/signed" 
    ;;
1266) echo "ant-split A File & sign a Folder arg4 & store a Folder arg5"
    path="$2"
    fw_name="$3"
    signed_path=$4
    joined_path=$5
    cd /mnt/scripts
    $script 1255 "$path" "$fw_name" $joined_path
    cd /mnt/sectools_8917/sectools
    $script 124 $joined_path $signed_path
    $script 123 $signed_path $signed_path 
    ;;
127) echo "sign A Folder $2 & store to Folder $3"
    path="$2"
    signed_path=$3
    cd /mnt/sectools_8917/sectools
    $script 124 $path $signed_path
    $script 123 $signed_path $signed_path
    ;;
128) echo "ant-split A folder,sign A folder,store A Folder"
    path="$2"
    fw_names=`ls $path|awk -F '.' '{print $1}'|sort|uniq`
    echo "fw_name(s):""$fw_names"
    # ant-split mdt & b0*
    for fw_name in $fw_names
    do
        echo "fw_name:$fw_name"
        mbn="$path""/""$fw_name"".mbn"
        mdt="$path""/""$fw_name"".mdt"
        if [ ! -f $mbn ] && [ -f $mdt ] ; then
        # if mbn exists, just sign it, wont ant-split mdt & b0*
            cd /mnt/scripts
            $script 125 "$path" "$fw_name"
        fi
    done
    cd /mnt/sectools_8917/sectools
    $script 124 $path $path"/signed"
    $script 124 $path"/joined" $path"/signed"
    $script 123 $path"/signed" $path"/signed" 
    ;;
1288) echo "ant-split A folder $2,sign folder $2,sign folder $4 ,store a folder $3"
    path="$2"
    signed_path=$3
    joined_path=$4
    rm -rf $signed_path"/"*
    rm -rf $joined_path"/"*
    fw_names=`ls $path|awk -F '.' '{print $1}'|sort|uniq`
    echo "fw_name(s):""$fw_names"
    # ant-split mdt & b0*
    for fw_name in $fw_names
    do
#        echo "fw_name:$fw_name"
        mbn="$path""/""$fw_name"".mbn"
        mdt="$path""/""$fw_name"".mdt"
        if [ ! -f $mbn ] && [ -f $mdt ] ; then
        # if mbn exists, just sign it, wont ant-split mdt & b0*
            cd /mnt/scripts
            echo $script 1255 "$path" "$fw_name" $joined_path
            $script 1255 "$path" "$fw_name" $joined_path
            ls -l $joined_path
        fi
    done
    cd /mnt/sectools_8917/sectools
    $script 124 $path $signed_path
    $script 124 $joined_path $signed_path
    $script 123 $signed_path $signed_path
    ;;
129) echo ""
    $script 130
    ;;
130) echo "awk,print $NF, print the last partment"
    ls /mnt/firehose_userdebug_0504/*.mbn|awk -F '/' '{print $NF}'
    ;;
131) echo "ant-split A folder,sign A folder,store A Folder,"
    echo "similar to 1288,besides, clean"
    ;;
132) #echo "ant-split A folder arg2 recursively,sign folder arg3,store a folder arg4,override"
    path="$2"
    signed_path=$3
    joined_path=$4
    $script 1333 $path $signed_path $joined_path
    sons=`ls $path`
    for son in $sons
    do
        son_path="$path""/""$son"        
#        echo "son:$son_path"
        if [ -d $son_path ] ; then
            echo "dir $son_path"
            $script 132 $son_path $signed_path $joined_path
        fi
    done
    ;;
1333) echo "ant-split A folder arg2,sign folder arg3,store a folder arg4,override"
    path="$2"
    signed_path=$3
    joined_path=$4
    split_path="$signed_path""/split"
    $script 1288 $path $signed_path $joined_path
    mbns_signed=`ls "$signed_path""/"*"."*`
    for mbn_signed in $mbns_signed
    do
        file_name=`basename $mbn_signed`
        mbn_origin="$path""/""$file_name"
        echo "mbn_origin:""$mbn_origin"
        if [ -f $mbn_origin ] ; then
            echo "to be overrider1:""$mbn_signed"" -> ""$mbn_origin"
            cp $mbn_signed $mbn_origin
        fi
    done
    mdts_signed=`ls "$split_path""/"*"."*`
    for mdt_signed in $mdts_signed
    do
        file_name=`basename $mdt_signed`
        mdt_origin="$path""/""$file_name"
        echo "mdt_origin:""$mdt_origin"
        if [ -f $mdt_origin ] ; then
            echo "to be overrider2:""$mdt_signed"" -> ""$mdt_origin"
            cp $mdt_signed $mdt_origin
        fi
    done
    ;;
1344) echo "ant-split A File arg2 & arg3,sign folder arg4,store a folder arg5,override"
    path="$2"
    fw_name="$3"
    signed_path=$4
    joined_path=$5
    split_path="$signed_path""/split"
    $script 1266 $path $fw_name $signed_path $joined_path
    mbns_signed=`ls "$signed_path""/""$fw_name""."*`
    for mbn_signed in $mbns_signed
    do
        file_name=`basename $mbn_signed`
        mbn_origin="$path""/""$file_name"
        echo "mbn_origin:""$mbn_origin"
        if [ -f $mbn_origin ] ; then
            echo "to be overrider:""$mbn_origin"
            cp $mbn_signed $mbn_origin
        fi
    done
    mdts_signed=`ls "$split_path""/""$fw_name""."*`
    for mdt_signed in $mdts_signed
    do
        file_name=`basename $mdt_signed`
        mdt_origin="$path""/""$file_name"
        echo "mdt_origin:""$mdt_origin"
        if [ -f $mdt_origin ] ; then
            echo "to be overrider:""$mdt_origin"
            cp $mdt_signed $mdt_origin
        fi
    done
    ;;
1355) echo "sign A Folder $2 & store to Folder $3,override"
    path="$2"
    signed_path=$3
    $script 127 $path $signed_path
    mbns_signed=`ls "$signed_path""/"*"."*`
    for mbn_signed in $mbns_signed
    do
        file_name=`basename $mbn_signed`
        mbn_origin="$path""/""$file_name"
        echo "mbn_origin:""$mbn_origin"
        if [ -f $mbn_origin ] ; then
            echo "to be overrider:""$mbn_signed"" -> ""$mbn_origin"
            cp $mbn_signed $mbn_origin
        fi
    done
    ;;
140) 
    index=0
    for file in `find ~/non-hlos/image/ -name fingerpr.mdt`
    do
        echo "file:$file"
        echo        cp $file "/home/server/fingerpr.mdt.""$index"
        cp $file "/home/server/fingerpr.mdt.""$index"
        if [ $index -eq 0 ] ; then
            rm $file
        fi
        echo        cp $file "/home/server/fingerpr.mdt.""$index"
        cp $file "/home/server/fingerpr.mdt.""$index"
        let "index+=1"
    done
    ;;
141) echo "generate keys to sign boot & system for company D"
    exit 0
#pem  key key.pub
    out/host/linux-x86/bin/generate_verity_key /mnt/keys_to_sign_boot3/key
#der  key.der
    openssl rsa -in /mnt/keys_to_sign_boot3/key -out /mnt/keys_to_sign_boot3/key.der -inform PEM -outform DER
#    openssl rsa -in key -out key.der -inform pem -outform der
#pem key.crt.pem
    openssl req -new -x509 -days 7300 -key /mnt/keys_to_sign_boot3/key -out /mnt/keys_to_sign_boot3/key.crt.pem
#der key.pub
    out/host/linux-x86/bin/generate_verity_key -convert /mnt/keys_to_sign_boot3/key.crt.pem /mnt/keys_to_sign_boot3/key
#pem key.pkcs8 der key.pkcs8.der
    openssl pkcs8 -topk8 -inform PEM -in /mnt/keys_to_sign_boot3/key -outform pem -nocrypt -out /mnt/keys_to_sign_boot3/key.pkcs8
    openssl pkcs8 -topk8 -inform PEM -in /mnt/keys_to_sign_boot3/key -outform der -nocrypt -out /mnt/keys_to_sign_boot3/key.pkcs8.der
#pem key.pkcs8.der.pub == key.pkcs8
    openssl pkcs8 -inform DER -nocrypt -in /mnt/keys_to_sign_boot3/key.pkcs8.der -out /mnt/keys_to_sign_boot3/key.pkcs8.der.pub
#der key.pkcs8.der.pub.pubout
    openssl rsa -in /mnt/keys_to_sign_boot3/key.pkcs8.der.pub -pubout -outform DER -out /mnt/keys_to_sign_boot3/key.pkcs8.der.pub.pubout
#keystore.img
    out/host/linux-x86/bin/keystore_signer /mnt/keys_to_sign_boot3/key.pkcs8.der /mnt/keys_to_sign_boot3/key.crt.pem /mnt/keys_to_sign_boot3/keystore.img /mnt/keys_to_sign_boot3/key.pkcs8.der.pub.pubout

    cp /mnt/keys_to_sign_boot3/key.pkcs8.der /mnt/keys_to_sign_boot3/verity.pk8
    cp /mnt/keys_to_sign_boot3/key.pub /mnt/keys_to_sign_boot3/verity_key
    cp /mnt/keys_to_sign_boot3/key.crt.pem /mnt/keys_to_sign_boot3/verity.x509.pem
    ;;
142) echo "adb pull file*"
    s=$2
    t=$3
    name=$4
    files=`adb shell ls $s"/""$name""*"`
    for file in $files
    do
        adb shell ls $file
        if [ $? -eq 0 ] ; then
            echo "file:$file"
            adb pull $file $t
        fi
    done
    ;;
143) echo "adb push <path>/<file_name> <path>"
    s=$2
    name=$3
    t=$4
    files=`ls "$s""/""$name"*`
    for file in $files
    do
        ls $file
        if [ $? -eq 0 ] ; then
            echo "file:$file"
            adb push $file $t
        fi
    done
    ;;
144) echo ""
    mkdir ~/d
    touch ~/d/f1
    touch ~/d/f2
    touch ~/d/f3
#
#/home/server/d/f1  /home/server/d/f2  /home/server/d/f3
#/home/server/d/f1  /home/server/d/f2  /home/server/d/f3
#ls: cannot access /home/server/d/f*: No such file or directory
#ls: cannot access /home/server/d/f*: No such file or directory
#
    ls /home/server/d/f*
    ls "/home/server/d/f"*
    ls /home/server/d/f"*"
    ls "/home/server/d/f""*"
    
    ;;
145) echo "get shell's path"
    dir=`dirname $0`
    echo "dir:"$dir
    path=`cd $dir;pwd`
    ;;
200)
    path="/home/server/d1"
    rm -rf $path"/"*
    ;;
146) echo "remount /firmware"
#    adb root;adb wait-for-device;
    adb shell mount |grep firmware
    adb shell umount /firmware;
    adb shell mount -t vfat -o rw /dev/block/mmcblk0p1 /firmware
    adb shell mount |grep firmware
    ;;
147) echo ""
    mdts=`find $2 -name "*.mdt"`
    for mdt in $mdts
    do
        hexdump -C $mdt|grep -ie shanghai
        if [ $? -ne 0 ] ; then
            echo "************* ERROR ************mdt=""$mdt"
        else
            echo 
        fi
        
    done
    mdts=`find $2 -name "*.mbn"`
    for mdt in $mdts
    do
        hexdump -C $mdt|grep -ie shanghai
        if [ $? -ne 0 ] ; then
            echo "************* ERROR ************mbn=""$mdt"
        else
            echo 
        fi
        
    done
    ;;
148) echo "temporary fix sign NON-HLOS.bin, sign modem.mdt handly"
    BIN=$2
    dat=`date +%Y%m%d_%H%M%S`
    workspace="/tmp/workspace_""$dat"
    path_joined="$workspace""/joined"
    path_signed="$workspace""/signed"
    path_mount_point="$workspace""/mount_point"
    mkdir -p $workspace
    mkdir -p $path_mount_point
    mkdir -p $path_joined
    mkdir -p $path_signed
    sudo mount $BIN $path_mount_point
    cp "$path_mount_point""/image/modem."* $workspace
    $script 1344 $workspace modem $path_signed $path_joined
    sudo cp $workspace"/modem."* $path_mount_point"/image/"
	sudo umount $path_mount_point
    ;;
149) echo "find mbn,override it !"
	name=$2
	path=$3
	file=$4
	mbns=`find $path -name $name`
	for mbn in $mbns
	do
		echo "mbn:$mbn  : to be overrided"
		echo cp $file $mbn
		cp $file $mbn
		if [ $? -ne 0 ] ; then
			echo "**************ERROR*********"
			exit -1
		fi
	done
	;;
150) echo "override mbn and sec.dat on modem/"
    echo 'cp $s_path/xxx.mbn $t_path/....../xxx.mbn'
	t_path=$2
	s_path=$3
	filenames="cmnlib64.mbn cmnlib.mbn devcfg.mbn keymaster.mbn lksecapp.mbn rpm.mbn sbl1.mbn tz.mbn sec.dat NON-HLOS.bin"
	for filename in $filenames
	do
		echo "************$filename********************$filename*******************$filename********************$filename*******************$filename******************"
		s_file="$s_path""/"$filename
		$script 149 $filename $t_path $s_file
		if [ $? -ne 0 ] ; then
			echo "**************ERROR*********"
			exit -1
		fi
		done
	filename="prog_emmc_firehose_8917_ddr.mbn"
	$script 149 $filename $t_path "$s_path""/""prog_emmc_firehose_8917.mbn"
			if [ $? -ne 0 ] ; then
			echo "**************ERROR*********"
			exit -1
		fi
	filename="validated_emmc_firehose_8917_ddr.mbn"
	$script 149 $filename $t_path $s_path"/""validated_emmc_firehose_8917.mbn"
			if [ $? -ne 0 ] ; then
			echo "**************ERROR*********"
			exit -1
		fi
	;;
151) echo "find mbn to be modified"
	filenames="cmnlib64.mbn cmnlib.mbn devcfg.mbn keymaster.mbn lksecapp.mbn rpm.mbn sbl1.mbn tz.mbn sec.dat NON-HLOS.bin"
	t_path="/home/release/temp/modem/"
	for filename in $filenames
	do
			mbns=`find $t_path -name $filename`
			for mbn in $mbns
			do
			echo "mbn: $mbn"
			echo $mbn" " >> ~/mbn.txt
			done
	done
	filename="prog_emmc_firehose_8917_ddr.mbn"
			mbns=`find $t_path -name $filename`
			for mbn in $mbns
			do
			echo "mbn: $mbn"
			echo $mbn" " >> ~/mbn.txt
			done
	filename="validated_emmc_firehose_8917_ddr.mbn"
			mbns=`find $t_path -name $filename`
			for mbn in $mbns
			do
			echo "mbn: $mbn"
			echo $mbn" " >> ~/mbn.txt
			done
	;;
152) echo "mv <file.name> to <file.name.back>"
	file_name=$2
	path=$3
	for f in `find $path -name $file_name`
	do
		new_file="$f"".back"
		echo "cmd: " mv $f $new_file
		mv $f $new_file
	done
	;;
153) echo "handle big txt,ignore line if line length > 1024"
	echo "bad!"
	exit 1;
	f=$2
	out=$f".2"
	for l in `cat $f`
	do
		size=`echo $l | wc -c`
		echo size: $size "($l)"
		if [ $size -lt 1024 ] ; then
			echo $1 >> $out
		fi
	done
	;;
154) echo "handle big txt,ignore line if line length > 1024"
    echo "bad!"
    exit 1;
	f=$2
	out="$2"".2"
	while read l
	do
		size=`echo $l | wc -c`
		echo size: $size
		if [ $size -lt 1024 ] ; then
			echo $1 >> $out
		fi
	done < $f
	;;
155) echo "spreadtrum,mv signed images to <path>/signed/override"
    echo "spreadtrum"
    signed="signed"
    override=$signed"/override"
    mkdir $signed
    mkdir $override
    images=$(get_images_to_sign_for_sprd_V4)
    for image in $images
    do
        postfix=`echo $image|awk -F '.' '{print $NF}'`
        signed_file_name=""
        echo "$postfix" |grep "("
        if [ $? -eq 0 ] ; then
            # special handle to xxx.xxx(1)
            postfix2=`echo $postfix|awk -F '(' '{print $1}'`
            file_name=`echo $image|awk -F "[.]$postfix2" '{print $1}'`
            signed_file_name="$file_name""-sign"".""$postfix"
            echo "postfix=$postfix"
            echo "postfix2=$postfix2"
            echo "echo $image|awk -F "[.]$postfix" '{print $1}'"
            echo "file_name=$file_name"
            echo "signed_file_name=$signed_file_name"
        else
            file_name=`echo $image|awk -F "[.]$postfix" '{print $1}'`
            signed_file_name="$file_name""-sign"".""$postfix"
        fi 
        mv $signed_file_name $signed"/"$signed_file_name
        cp $signed"/"$signed_file_name "$override""/""$image"
    done
    ;;
156) echo "cp out/target/product/generic/xxx <store_path>"
    echo "spreadtrum,sp9832a_3h10_volte"
    store_path=$2
    out_target_product_dir=$3
    images=$(get_images_to_override_for_sprd_V4)
    for image in $images
    do
        ls -l "$out_target_product_dir""/""$image"
        cp "$out_target_product_dir""/""$image" $store_path
    done
    ;;
157) echo "cp out/target/product/generic/xxx PCKs"
    echo "sign PCKs ,overide PCKS"
    echo "spreadtrum,sp9832a_3h10_volte"
    store_path="PCKs"
    out_target_product_dir="out/target/product/sp9832a_3h10_volte"
    if [ $# -eq 3 ] && [ $2 == "-i" ]; then
        out_target_product_dir=$3
    fi
    current_dir=`pwd`
    sprd_secure_boot_tool_path="vendor/sprd/open-source/tools/sprd_secure_boot_tool/"
    dat=`date +%Y%m%d_%H%M%S`
    store_path="$current_dir""/""$store_path""/""$dat""_signed"
    if [ ! -d $store_path ] ; then
        mkdir -p $store_path
    fi
    images=$(get_images_to_override_for_sprd_V4)
    for image in $images
    do
        #echo cp "$out_target_product_dir""/""$image" $store_path
        ls -l "$out_target_product_dir""/""$image"
        cp "$out_target_product_dir""/""$image" $store_path
    done
    cd "$current_dir""/""$sprd_secure_boot_tool_path"
    pwd
    /bin/bash ./sig_script.sh $store_path
    cd $store_path
    $script 155
    cd $current_dir
    cp $store_path"/signed/override/"* $store_path
    rm -rf $store_path"/signed/"
    ;;
158) 
    echo "sign unsigned/ ,overide unsigned/"
    echo "spreadtrum,sp9832a_3h10_volte"
    # absolute path
    store_path=$2
    diff_folder=$3
    current_dir=`pwd`

    sprd_secure_boot_tool_path="$current_dir""/sprd_secure_boot_tool/"

    cd "$sprd_secure_boot_tool_path"
    /bin/bash ./sig_script.sh $store_path
    #
    cd $store_path
    $script 165 $current_dir
    cd $current_dir
    # make diff
    $script 162 $store_path"/signed/override/" $store_path $diff_folder
    cp $store_path"/signed/override/"* $store_path
    rm -rf $store_path"/signed/"
    ;;
159) 
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
    image_signed="$2"
    image_unsigned="$3"
    image_signed_new=$4

    image_signed_p1_size=$5
    image_signed_1=$6
    image_signed_3=$7
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
    check=$8
    combine=$9
    
    dat=`date +%Y%m%d_%H%M%S_%N`
    image_unsigned_filename=`basename $image_unsigned`
    image_unsigned_1_and_2="/tmp/""$image_unsigned_filename""_part12_""$dat"
    image_unsigned_1_and_2_and_3="/tmp/""$image_unsigned_filename""_part123_""$dat"

    if [ "$check" != "true" ] ; then
        #function 1
        #create $image_signed_1
        dd if="$image_signed" of="$image_signed_1" bs=$image_signed_p1_size skip=0 seek=0 count=1
    fi
    if [ "$check" != "true" ] ; then
        #function 1
        cat $image_signed_1 $image_unsigned > $image_unsigned_1_and_2
    else
        echo /mnt/github/c_test/cp $image_signed_1 $image_unsigned_1_and_2
        /mnt/github/c_test/cp $image_signed_1 $image_unsigned_1_and_2
        if [ $? -ne 0 ] ; then
            rm -rf $image_unsigned_1_and_2 $image_unsigned_1_and_2_and_3
            exit 1;
        fi
        dd_if=$image_unsigned
        dd_of=$image_unsigned_1_and_2
        size_if=`wc -c < $dd_if`
        size_of=`wc -c < $dd_of`
        echo /mnt/github/c_test/dd $dd_if $dd_of 1 0 $size_of $size_if
        /mnt/github/c_test/dd $dd_if $dd_of 1 0 $size_of $size_if
        if [ $? -ne 0 ] ; then
            rm -rf $image_unsigned_1_and_2 $image_unsigned_1_and_2_and_3
            exit 1;
        fi
    fi

    size_image_unsigned_1_and_2=`wc -c < $image_unsigned_1_and_2`
    if [ "$check" != "true" ] ; then
        #function 1
        #create $image_signed_3
        dd if="$image_signed" of="$image_signed_3" bs=$size_image_unsigned_1_and_2 skip=1 seek=0
    fi
    if [ "$check" != "true" ] ; then
        #function 1
        cat $image_unsigned_1_and_2 $image_signed_3 > $image_unsigned_1_and_2_and_3
    else
        echo /mnt/github/c_test/cp $image_unsigned_1_and_2 $image_unsigned_1_and_2_and_3
        /mnt/github/c_test/cp $image_unsigned_1_and_2 $image_unsigned_1_and_2_and_3
        if [ $? -ne 0 ] ; then
            rm -rf $image_unsigned_1_and_2 $image_unsigned_1_and_2_and_3
            exit 1;
        fi
        dd_if=$image_signed_3
        dd_of=$image_unsigned_1_and_2_and_3
        size_if=`wc -c < $dd_if`
        size_of=`wc -c < $dd_of`
        echo /mnt/github/c_test/dd $dd_if $dd_of 1 0 $size_of $size_if
        /mnt/github/c_test/dd $dd_if $dd_of 1 0 $size_of $size_if
        if [ $? -ne 0 ] ; then
            rm -rf $image_unsigned_1_and_2 $image_unsigned_1_and_2_and_3
            exit 1;
        fi
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
            echo "     :create $image_signed_new from $image_signed & $image_signed_1 & $image_signed_1"        
    fi
    #clean
    rm -rf $image_unsigned_1_and_2 $image_unsigned_1_and_2_and_3
    ;;
160)
# function 1:
#   echo "given folder.signed & folder.unsigned"
#   echo "folder diff = folder.signed - folder.unsigned"
#   echo "let folder.singed.new = folder.unsigned + diff"
#   echo "check if folder.singed.new == folder_signed"
#   echo input : 
#       signed_dir : requested (not empty)
#       unsgined_dir : requested (not empty)
#       diff_folder : requested (empty)
#       signed_new_dir : requested (tmp)
#       check : not requested
#       combine : not requested
#   echo "output :folder diff"
# function 2:
#   if check flag "true" is given
#   check if folder signed == folder unsigned + folder diffed
#   echo input : 
#       signed_dir : requested (not empty)
#       unsgined_dir : requested (not empty)
#       diff_folder : requested (not empty)
#       signed_new_dir : requested (tmp)
#       check : requested ("true")
#       combine : not requested
#   echo output :
#       nothing
# function 3:
#   echo "given folder.diff & folder.unsigned"
#   echo "let folder.singed.new = folder.unsigned + diff"
#   echo "check if folder.singed.new == folder_signed"
#   echo "output : folder.signed.new"
#   echo input : 
#       signed_dir : requested (any string)
#       unsgined_dir : requested (not empty)
#       diff_folder : requested (not empty)
#       signed_new_dir : requested (empty)
#       check : requested ("true")
#       combine : requested ("true")
#   echo output :
#       signed_new_dir
#
#    echo "MTK, bv303b"
#
#   check   combine    function
#   true    true    3   create folder_signed_new 
#   true    false   2   create folder_signed_new & check & rm folder_signed_new
#   true    NULL    2   create folder_signed_new & check & rm folder_signed_new
#   false   true        not defined   
#   false   false   1   create diff & check & rm folder_signed_new
#   NULL    NULL    1   create diff & check & rm folder_signed_new
#   flag "check" define : create diff or not
#   flag "combine" define : (check & rm folder_signed_new) or not
    signed_dir=$2
    unsigned_dir=$3
    diff_folder=$4
    signed_new_dir=$5
    check=$6
    combine=$7
    files=""
    if [ "$combine" != "true" ] ; then
        # temporary folder
        mkdir -p "$signed_new_dir/"
    fi
    if [ "$check" != "true" ] ; then
        files=`dir "$signed_dir"`
        files=$(get_images_to_sign_for_MTK)
    else
        files=$(get_images_to_sign_for_MTK)
    fi
    echo "files:$files(end)"
    for file in $files
    do  
        image_signed="$signed_dir""/""$file"
        image_unsigned="$unsigned_dir""/""$file"
        image_signed_new="$signed_new_dir""/""$file"
        image_signed_part1="$diff_folder""/""$file"".part1"
        image_signed_part3="$diff_folder""/""$file"".part3"
        # 0x4040 = 16448
        size_image_signed_part1=16448
        $script 159 $image_signed $image_unsigned $image_signed_new $size_image_signed_part1 $image_signed_part1 $image_signed_part3 $check $combine
        if [ $? -ne 0 ] ; then
            # clean
            if [ "$combine" != "true" ] ; then
                rm -rf "$signed_new_dir"
            fi
            exit 1;
        fi
    done
    # clean
    if [ "$combine" != "true" ] ; then
        rm -rf "$signed_new_dir"
    fi
    ;;
161)
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
    image_signed="$2"
    image_unsigned="$3"
    image_signed_new=$4
    image_signed_p1_size=$5
    # output
    image_signed_1=$6
    image_signed_3=$7

    check=$8
    combine=$9

    dat=`date +%Y%m%d_%H%M%S_%N`
    image_unsigned_filename=`basename $image_unsigned`
    image_unsigned_1_and_2="/tmp/""$image_unsigned_filename""_part12_""$dat"
    image_unsigned_1_and_2_and_3="/tmp/""$image_unsigned_filename""_part123_""$dat"

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
        echo /mnt/github/c_test/cp $image_unsigned_1_and_2 $image_unsigned_1_and_2_and_3
        /mnt/github/c_test/cp $image_unsigned_1_and_2 $image_unsigned_1_and_2_and_3
        if [ $? -ne 0 ] ; then
            rm -rf $image_unsigned_1_and_2 $image_unsigned_1_and_2_and_3
            exit 1;
        fi
        dd_if=$image_signed_3
        dd_of=$image_unsigned_1_and_2_and_3
        size_if=`wc -c < $dd_if`
        size_of=`wc -c < $dd_of`
        echo /mnt/github/c_test/dd $dd_if $dd_of 1 0 $size_of $size_if
        /mnt/github/c_test/dd $dd_if $dd_of 1 0 $size_of $size_if
        if [ $? -ne 0 ] ; then
            rm -rf $image_unsigned_1_and_2 $image_unsigned_1_and_2_and_3
            exit 1;
        fi
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
            echo "     :create $image_signed_new from $image_signed & $image_signed_1 & $image_signed_1"        
    fi
    #clean
    rm -rf $image_unsigned_1_and_2 $image_unsigned_1_and_2_and_3
    ;;
162)
# function 1:
#   echo "given folder.signed & folder.unsigned"
#   echo "folder diff = folder.signed - folder.unsigned"
#   echo "let folder.singed.new = folder.unsigned + diff"
#   echo "check if folder.singed.new == folder_signed"
#   echo input : 
#       signed_dir : requested (not empty)
#       unsgined_dir : requested (not empty)
#       diff_folder : requested (empty)
#       signed_new_dir : requested (tmp)
#       check : not requested
#       combine : not requested
#   echo "output :folder diff"
# function 2:
#   if check flag "true" is given
#   check if folder signed == folder unsigned + folder diffed
#   echo input : 
#       signed_dir : requested (not empty)
#       unsgined_dir : requested (not empty)
#       diff_folder : requested (not empty)
#       signed_new_dir : requested (tmp)
#       check : requested ("true")
#       combine : not requested
#   echo "output : nothing"
# function 3:
#   echo "given folder.diff & folder.unsigned"
#   echo "let folder.singed.new = folder.unsigned + diff"
#   echo "check if folder.singed.new == folder_signed"
#   echo "output : folder.signed.new"
#   echo input : 
#       signed_dir : requested (any string)
#       unsgined_dir : requested (not empty)
#       diff_folder : requested (not empty)
#       signed_new_dir : requested (empty)
#       check : requested ("true")
#       combine : requested ("true")
#   echo "output : signed_new_dir"
#
#    echo "sprd, bv303c"
#   check   combine    function
#   true    true    3   create folder_signed_new 
#   true    false   2   create folder_signed_new & check & rm folder_signed_new
#   true    NULL    2   create folder_signed_new & check & rm folder_signed_new
#   false   true        not defined   
#   false   false   1   create diff & check & rm folder_signed_new
#   NULL    NULL    1   create diff & check & rm folder_signed_new
#   flag "check" define : create diff or not
#   flag "combine" define : (check & rm folder_signed_new) or not
#BSC_BIN
#VLR_BIN
#VLR_OTHER_BIN
    signed_dir=$2
    unsigned_dir=$3
    diff_folder=$4
    signed_new_dir=$5
    check=$6
    combine=$7

    if [ "$combine" != "true" ] ; then
        # temporary folder
        mkdir -p "$signed_new_dir"
    fi

    images_bsc_bin=$(get_images_to_sign_BSC_BIN_for_sprd_V4)
    # 0x304
    size_image_signed_part1="772"
    for file in $images_bsc_bin
    do  
        image_signed="$signed_dir""/""$file"
        image_unsigned="$unsigned_dir""/""$file"
        image_signed_new="$signed_new_dir""/""$file"
            image_signed_part1="$diff_folder""/""$file"".part1"
            image_signed_part3="$diff_folder""/""$file"".part3"
            $script 161 $image_signed $image_unsigned $image_signed_new  $size_image_signed_part1 $image_signed_part1 $image_signed_part3 $check $combine
            if [ $? -ne 0 ] ; then
                # clean
                if [ "$combine" != "true" ] ; then
                    rm -rf "$signed_new_dir"
                fi
                exit 1;
            fi
    done
    images_vlr_bin=$(get_images_to_sign_VLR_BIN_for_sprd_V4)
    # 0x600 
    size_image_signed_part1="1536"
    for file in $images_vlr_bin
    do  
        image_signed="$signed_dir""/""$file"
        image_unsigned="$unsigned_dir""/""$file"
        image_signed_new="$signed_new_dir""/""$file"
            image_signed_part1="$diff_folder""/""$file"".part1"
            image_signed_part3="$diff_folder""/""$file"".part3"
            $script 159 $image_signed $image_unsigned $image_signed_new  $size_image_signed_part1 $image_signed_part1 $image_signed_part3 $check $combine
            if [ $? -ne 0 ] ; then
                # clean
                if [ "$combine" != "true" ] ; then
                    rm -rf "$signed_new_dir"
                fi
                exit 1;
            fi
    done
    images_vlr_bin=$(get_images_to_sign_VLR_OTHER_BIN_for_sprd_V4)
    # 0x400 
    size_image_signed_part1="1024"
    for file in $images_vlr_bin
    do  
        image_signed="$signed_dir""/""$file"
        image_unsigned="$unsigned_dir""/""$file"
        image_signed_new="$signed_new_dir""/""$file"
            image_signed_part1="$diff_folder""/""$file"".part1"
            image_signed_part3="$diff_folder""/""$file"".part3"
            $script 159 $image_signed $image_unsigned $image_signed_new  $size_image_signed_part1 $image_signed_part1 $image_signed_part3 $check $combine
            if [ $? -ne 0 ] ; then
                # clean
                if [ "$combine" != "true" ] ; then
                    rm -rf "$signed_new_dir"
                fi
                exit 1;
            fi
    done

    # clean
    if [ "$combine" != "true" ] ; then
        rm -rf "$signed_new_dir"
    fi
    ;;
163)  echo "given unsigned.zip & project_name"
    echo "sign unsigned.zip"
    echo "MTK, bv303b"
    echo "/mnt/sign_server/sign_bv303b81t_gb.sh"
    echo "run on /mnt/sign_server"
    unsigned_zip=$2
    project=$3
    current_dir=`pwd`
    sign_workspace="/tmp/"
    sign_list="/mnt/svn/MTK/droi_custom_debug/images/signature_filelist.txt"

    zip_folder=`dirname $unsigned_zip`
    zip_name=`basename $unsigned_zip`
    postfix=`echo $zip_name|awk -F '.' '{print $NF}'`
    zip_filename=`echo $zip_name|awk -F "[.]$postfix" '{print $1}'`
    signed_zip="$sign_workspace""/""$zip_filename""_signed"".""$postfix"

    unsigned_unzip="$sign_workspace""/""$zip_name""_unzip/"
    if [ ! -d $unsigned_unzip ] ; then
        mkdir $unsigned_unzip
    fi
    unzip $unsigned_zip -d $unsigned_unzip
    cd /mnt/sign_server/MTK/bv303b81t_gb
    ./vendor/mediatek/proprietary/scripts/sign-image/sign_image.sh
    cd $current_dir
    # override unsigned images with signed ones
    for file in `dir $unsigned_unzip"/signed_bin"`
    do
        filename=`echo $file|awk -F "-sign" '{print $1$2}'`;
        file_unsigned="$unsigned_unzip""/""$filename"
        file_signed="$unsigned_unzip""/signed_bin/""$file"
        echo cp $file_signed $file_unsigned
        cp $file_signed $file_unsigned
    done
    # clean
    ls -l $unsigned_unzip"/sig/"
    rm -rf $unsigned_unzip"/sig/"
    ls -l $unsigned_unzip"/signed_bin/"
    rm -rf $unsigned_unzip"/signed_bin/"
    echo rm $unsigned_unzip"/"*"-verified"*
    ls -l $unsigned_unzip"/"*"-verified"*
    rm $unsigned_unzip"/"*"-verified"*

    cd $unsigned_unzip
    zip $signed_zip ./*
    cd $current_dir
    ;;
164) echo "given folder1 unsigned & project_name"
    echo "sign unsigned.zip"
    echo "get diff between unsigned.zip & signed.zip"
    echo "create filelist.txt"
    echo "SPRD, bv303c"
    echo "/mnt/sign_server/sign_sp9832a_3h10_volte.sh"
    echo "run on /mnt/sign_server"
    unsigned_zip=$2
    project=$3

    current_dir=`pwd`
    sign_workspace="/tmp/"

    zip_folder=`dirname $unsigned_zip`
    zip_name=`basename $unsigned_zip`
    postfix=`echo $zip_name|awk -F '.' '{print $NF}'`
    zip_filename=`echo $zip_name|awk -F "[.]$postfix" '{print $1}'`

#    signed_zip="$sign_workspace""/""$zip_filename""_signed"".""$postfix"
#    diff_zip="$sign_workspace""/""$zip_filename""_diff"".""$postfix"
#    signed_list_file="$sign_workspace""/""$zip_filename""_signed_list.txt"
    signed_zip="$4"
    diff_zip="$5"
    signed_list_file="$6"

    # clean & mkdir
    unsigned_unzip="$sign_workspace""/""$zip_name""_unzip/"
    diff_folder="$sign_workspace""/""$zip_name""_diff/"
    signed_new_folder="$sign_workspace""/""$zip_name""_singed_new/"
    rm -rf $signed_list_file
    rm -rf $unsigned_unzip
    rm -rf $diff_folder
    rm -rf $signed_new_folder
    mkdir -p $unsigned_unzip
    mkdir -p $diff_folder
    mkdir -p $signed_new_folder

    #unzip
    unzip $unsigned_zip -d $unsigned_unzip
    project_path=$current_dir"/sprd/sp9832a_3h10_volte"
#    $script 158 $unsigned_unzip $diff_folder
##############################################
#    echo "sign unsigned/ ,overide unsigned/"
#    echo "spreadtrum,sp9832a_3h10_volte"
    # absolute path
#    cd $project_path    
    store_path=$unsigned_unzip
#    diff_folder=$diff_folder
#    current_dir=`pwd`


    # sign
#    sprd_secure_boot_tool_path="$current_dir""/sprd_secure_boot_tool/"
    sprd_secure_boot_tool_path="$project_path""/sprd_secure_boot_tool/"

    cd "$sprd_secure_boot_tool_path"
    /bin/bash ./sig_script.sh $store_path
    #
    cd $store_path
    $script 165 $project_path
#    cd $project_path

    dir $store_path"/signed/override/" > $signed_list_file

    # make diff
    $script 162 $store_path"/signed/override/" $store_path $diff_folder $signed_new_folder
    if [ $? -ne 0 ] ; then
        #clean
        rm -rf $diff_folder
        rm -rf $signed_new_folder
        rm -rf $unsigned_unzip
        exit 1;
    fi

    cp $store_path"/signed/override/"* $store_path
    rm -rf $store_path"/signed/"
##############################################

    cd $diff_folder
    zip $diff_zip ./*
    cd $current_dir

    #clean
    rm -rf $diff_folder
    rm -rf $signed_new_folder

    cd $unsigned_unzip
    zip $signed_zip ./*
    cd $current_dir

    #clean
    rm -rf $unsigned_unzip
    ;;
165) echo "spreadtrum,mv signed images to <path>/signed/override"
    echo "similar with 155"
    echo "spreadtrum"
    signed="signed"
    override=$signed"/override"
    mkdir $signed
    mkdir $override
    rootdir=$2
    echo "rootdir:$rootdir"
    images=$(get_signature_filelist_sprd $rootdir)
    echo "images:$images(end)"
    for image in $images
    do
        postfix=`echo $image|awk -F '.' '{print $NF}'`
        file_name=`echo $image|awk -F "[.]$postfix" '{print $1}'`
        signed_file_name="$file_name""-sign"".""$postfix"
        mv $signed_file_name $signed"/"$signed_file_name
        cp $signed"/"$signed_file_name "$override""/""$image"
    done
    ;;
166) echo ""
    a="boot.img"
    b="\.img"
    c=".bin"
    echo "echo $a | sed s/$b/$c/"
    echo $a | sed s/$b/$c/
    echo $a
    ;;
167)   echo "given folder1 unsigned & project_name"
    echo "sign unsigned.zip"
    echo "get diff between unsigned.zip & signed.zip"
    echo "create filelist.txt"
    echo "MTK, bv303b"
    echo "/mnt/sign_server/sign_bv303b81t_gb.sh"
    echo "similar with 163"
    echo "run on /mnt/sign_server"
    unsigned_zip=$2
    project=$3
    current_dir=`pwd`
    sign_workspace="/tmp/"
    
    zip_folder=`dirname $unsigned_zip`
    zip_name=`basename $unsigned_zip`
    postfix=`echo $zip_name|awk -F '.' '{print $NF}'`
    zip_filename=`echo $zip_name|awk -F "[.]$postfix" '{print $1}'`
    #
#   signed_zip="$sign_workspace""/""$zip_filename""_signed"".""$postfix"
#   diff_zip="$sign_workspace""/""$zip_filename""_diff"".""$postfix"
    signed_zip="$4"
    diff_zip="$5"
    signed_list_file="$6"

    # clean & mkdir
    unsigned_unzip="$current_dir""/MTK/mtk_release/sign_image_split/out/target/product/""$project"
    diff_folder="$unsigned_unzip""/diff/"
    signed_new_folder="$unsigned_unzip""/signed_new/"
    rm -rf $signed_list_file
    rm -rf $unsigned_unzip
    rm -rf $diff_folder
    rm -rf $signed_new_folder
    mkdir $unsigned_unzip
    mkdir -p $diff_folder
    mkdir -p $signed_new_folder

    # unzip
    unzip $unsigned_zip -d $unsigned_unzip

    # sign
    cd $current_dir"/MTK/mtk_release/sign_image_split/sign-image"
    sed -i s/"^MTK_PROJECT_NAME := .*"/"MTK_PROJECT_NAME := $project"/g Android.mk
    sed -i s/"^MTK_PROJECT_NAME := .*"/"MTK_PROJECT_NAME := $project"/g Android.mk
    make -f Android.mk
    cd $current_dir

    # handle with signed images
    # mv xxx-sign.xxx xxx.xxx
    for file in `dir $unsigned_unzip"/signed_bin"`
    do
        filename=`echo $file|awk -F "-sign" '{print $1$2}'`;
        file_unsigned="$unsigned_unzip""/""$filename"
        file_signed="$unsigned_unzip""/signed_bin/""$file"
        echo $filename >> $signed_list_file
        mv $file_signed "$unsigned_unzip""/signed_bin/""$filename"
    done

    # make diff
    $script 160 "$unsigned_unzip""/signed_bin/" $unsigned_unzip $diff_folder $signed_new_folder
    if [ $? -ne 0 ] ; then
        rm -rf $unsigned_unzip
        rm -rf $diff_folder
        rm -rf $signed_new_folder
        exit 1;
    fi
    
    cd $diff_folder
    zip $diff_zip ./*
    cd $current_dir

    # override unsigned images with signed ones
    cp "$unsigned_unzip""/signed_bin/"* "$unsigned_unzip""/"

    # clean
    rm -rf $unsigned_unzip"/sig/"
    rm -rf $unsigned_unzip"/signed_bin/"
    rm $unsigned_unzip"/"*"-verified"*
    rm -rf $diff_folder
    rm -rf $signed_new_folder

    cd $unsigned_unzip
    zip $signed_zip ./*
    cd $current_dir

    # clean
    rm -rf $unsigned_unzip
    ;;
168)
    cat rawprogram_unsparse.xml|grep system_|awk -F "system_" '{print $2}'|awk -F ' ' '{print $3"\t" $5}'|awk -F '"' '{print $2"_"$4}' > ~/1
    ;;
169)
    r=1
    rm ~/2
    for l in `cat ~/1`
    do
        let r+=1
        echo "[$r]line:$l"
        num=`echo $l |awk -F '_' '{print $1}'`
        start=`echo $l |awk -F '_' '{print $2}'`
        let end=$num+$start
        echo $l"_"$end >> ~/2
    done
    ;;
170)
    pre_end=0
    rm ~/3
    r=1
    size=0
    block=0
    for l in `cat ~/2`
    do
        echo "[$r]line:$l"
        num=`echo $l |awk -F '_' '{print $1}'`
        start=`echo $l |awk -F '_' '{print $2}'`
        end=`echo $l |awk -F '_' '{print $3}'`
        let d=$start-$pre_end
        pre_end=$end
        echo $d >> ~/3
        if [ $r -gt 1 ] ; then
            size=`wc -c < system_unit`
            let block=$size/512
            echo "size $size"
        fi
        if [ $r -gt 1 ] ; then
            echo dd if="/dev/zero" of="system_unit" bs=512 count=$d  seek=$block
            dd if="/dev/zero" of="system_unit" bs=512 count=$d  seek=$block
        fi
        if [ $r -gt 1 ] ; then
            size=`wc -c < system_unit`
            let block=$size/512
            echo "size $size"
        fi
        echo dd if="system_""$r"".img" of="system_unit" bs=512 count=$num seek=$block
        dd if="system_""$r"".img" of="system_unit" bs=512 count=$num seek=$block
        let r+=1
    done
    ;;
171)
# combine 
#    echo "MTK, bv303b"
# call 160
    unsigned_dir=$2
    diff_folder=$3
    signed_dir=$4
    signed_images_dir=$signed_dir"_tmp"
    rm -rf $signed_dir
    rm -rf $signed_images_dir
    mkdir -p $signed_dir
    mkdir -p $signed_images_dir
    $script 160 "nothing_signed" $unsigned_dir $diff_folder $signed_images_dir true true
    cp $unsigned_dir"/"* $signed_dir
    cp $signed_images_dir"/"* $signed_dir
    #clean
    rm -rf $signed_images_dir
    ;;
172) 
# combine 
#    echo "SPRD, bv303c"
# call 162
    unsigned_dir=$2
    diff_folder=$3
    signed_dir=$4
    signed_images_dir=$signed_dir"_tmp"
    rm -rf $signed_dir
    rm -rf $signed_images_dir
    mkdir -p $signed_dir
    mkdir -p $signed_images_dir
    $script 162 "nothing_signed" $unsigned_dir $diff_folder $signed_images_dir true true
    cp $unsigned_dir"/"* $signed_dir
    cp $signed_images_dir"/"* $signed_dir
    #clean
    rm -rf $signed_images_dir
    ;;
*) echo "others"
    echo "1: $2"
    if [ "$2" == "aa" ] ; then
        echo "aa:$2"
    else
        echo "oo:$2"
    fi
    if [ $2 != "bb" ] ; then
        echo "not bb:$2"
    else
        echo "bb:$2"
    fi
	;;
esac
exit 0

##script $1 $2
