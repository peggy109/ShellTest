::@echo off
::sprd, bv303c
set signed_dir=%2
set    unsigned_dir=%3
set    diff_folder=%4
set signed_new_dir=%5
set check=%6
set combine=%7
:: unsigned_dir & diff_folder & signed_new_dir should exist
set combine_err=0
set check_err=0

set    images_bsc_bin=fdl1.bin u-boot-spl-16k.bin  
::    # 0x304
set    size_image_signed_part1=772
for %%a in (%images_bsc_bin%) do (
    call 161.bat 161 %signed_dir%\%%a %unsigned_dir%\%%a %signed_new_dir%\%%a  %size_image_signed_part1% %diff_folder%\%%a.part1 %diff_folder%\%%a.part3 %check% %combine%
)	
if "%check%" == "true" (
	if "%combine%" == "true" (
		if not "%combine_err%" == "0" (
			echo "sign "%images_bsc_bin% failed
			exit /b 1
		)
	) else (
		if not "%check_err%" == "0" (
			exit /b 1
		)
	)
)


set    images_vlr_bin=fdl2.bin   u-boot.bin   
::    # 0x600 
set    size_image_signed_part1=1536
for %%a in (%images_vlr_bin%) do (
    call 159.bat 159 %signed_dir%\%%a %unsigned_dir%\%%a %signed_new_dir%\%%a  %size_image_signed_part1% %diff_folder%\%%a.part1 %diff_folder%\%%a.part3 %check% %combine%
)

if "%check%" == "true" (
	if "%combine%" == "true" (
		if not "%combine_err%" == "0" (
			echo "sign "%images_vlr_bin% failed
			exit /b 1
		)
	) else (
		if not "%check_err%" == "0" (
			exit /b 1
		)
	)
)

	
set    images_vlr_bin=ltemodem.bin    ltedsp.bin   ltegdsp.bin ltewarm.bin  pmsys.bin   boot.img    recovery.img       
::    # 0x400 
set size_image_signed_part1=1024
for %%a in (%images_vlr_bin%) do (
    call 159.bat 159 %signed_dir%\%%a %unsigned_dir%\%%a %signed_new_dir%\%%a  %size_image_signed_part1% %diff_folder%\%%a.part1 %diff_folder%\%%a.part3 %check% %combine%
)	
if "%check%" == "true" (
	if "%combine%" == "true" (
		if not "%combine_err%" == "0" (
			echo "sign "%images_vlr_bin% failed
			exit /b 1
		)
	) else (
		if not "%check_err%" == "0" (
			exit /b 1
		)
	)
)

