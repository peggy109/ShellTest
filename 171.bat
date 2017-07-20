:: combine 
::   echo "MTK, bv303b"
:: call 160
set unsigned_dir=%2
set diff_folder=%3
set signed_folder=%4
:: signed_folder ends with \ is not recommanded
set signed_images_dir=%signed_folder%_tmp
rd /s /q   %signed_folder%
rd /s /q %signed_images_dir%
md %signed_folder%
md %signed_images_dir%
call 160.bat 160 "nothing_signed" %unsigned_dir%  %diff_folder% %signed_images_dir% true true
if not "%errorlevel%" == "0" (
	rd /s /q %signed_images_dir%
	echo ERROR********************
	echo      : combine from %unsigned_dir% & %diff_folder% failed
	exit /b 1
)

copy /y %unsigned_dir%\* %signed_folder%\
copy /y %signed_images_dir%\* %signed_folder%\
::#clean
rd /s /q %signed_images_dir%

