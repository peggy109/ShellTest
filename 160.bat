::@echo off
::MTK, bv303b
set signed_dir=%2
set    unsigned_dir=%3
set    diff_folder=%4
set signed_new_dir=%5
set check=%6
set combine=%7
:: unsigned_dir & diff_folder & signed_new_dir should exist

::	set fo=%%a
::	echo "fo        : "%fo%
set files=boot.img	logo.bin	   system.img cache.img	recovery.img  trustzone.bin lk.bin	secro.img	   userdata.img
echo files:%files%-end

set combine_err=0
set check_err=0
for  %%a in (%files%) do (
	echo "file      : "%%a
	echo "file      : "%%a_edit
    call 159.bat 159 %signed_dir%\%%a %unsigned_dir%\%%a %signed_new_dir%\%%a 16448 %diff_folder%\%%a.part1 %diff_folder%\%%a.part3 %check% %combine%
)
if "%check%" == "true" (
	if "%combine%" == "true" (
		if not "%combine_err%" == "0" (
			exit /b 1
		)
	) else (
		if not "%check_err%" == "0" (
			exit /b 1
		)
	)
)
