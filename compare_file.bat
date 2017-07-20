@echo off
set md5_old=%1
set image_to_be_hashed=%2
certutil -hashfile %image_to_be_hashed% MD5
certutil -hashfile %image_to_be_hashed% MD5 |findstr /v  MD5 |findstr /v "CertUtil: -hashfile"
certutil -hashfile %image_to_be_hashed% MD5 |findstr /v  MD5 |findstr /v "CertUtil: -hashfile" > %temp%\%image_to_be_hashed%_hash

set /p "hash_tmp=" < %temp%\%image_to_be_hashed%_hash
echo %hash_tmp%
set hash_tmp=%hash_tmp: =%
echo %hash_tmp%
if "%hash_tmp%" == "%md5_old%" (
	echo Compare %image_to_be_hashed% and %md5_old% OK
) else (
	echo Compare %image_to_be_hashed% and %md5_old% FAIL
	set compare_err=1
	del /s /q %temp%\%image_to_be_hashed%_hash
	exit /b 1
)
del /s /q %temp%\%image_to_be_hashed%_hash
exit /b 0
@echo on