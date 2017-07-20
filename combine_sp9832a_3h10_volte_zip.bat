::# combine 
::#    echo "SPRD, bv303c"
::# call 172
::# combine_bv303b
::# absolute path is required
set    unsigned_zip=%1
set    diff_zip=%2
set    signed_zip=%3
set    current_dir=%cd%
for /f %%a in ("%unsigned_zip%") do (
	set unsigned_zip_unzip_folder=%temp%\%%~na
)
for /f %%a in ("%diff_zip%") do (
	set diff_zip_unzip_folder=%temp%\%%~na
)
for /f %%a in ("%signed_zip%") do (
	set signed_zip_unzip_folder=%temp%\%%~na
)
for /f %%a in ("%current_dir%") do (
	set current_disk=%%~da
	set current_folder=%%~fa
)
    echo unsigned_zip : %unsigned_zip%
    echo unsigned_zip_unzip_folder : %unsigned_zip_unzip_folder%
    echo diff_zip : %diff_zip%
    echo diff_zip_unzip_folder : %diff_zip_unzip_folder%
    echo signed_zip : %signed_zip%
    echo signed_zip_unzip_folder : %signed_zip_unzip_folder%
    md %unsigned_zip_unzip_folder%
    md %diff_zip_unzip_folder%
    md %signed_zip_unzip_folder%

	%current_folder%\winrar.exe x %unsigned_zip% %unsigned_zip_unzip_folder%
	%current_folder%\winrar.exe x %diff_zip% %diff_zip_unzip_folder%
	::winrar.exe x %signed_zip% %signed_zip_unzip_folder%

	call 172.bat 172 %unsigned_zip_unzip_folder% %diff_zip_unzip_folder% %signed_zip_unzip_folder%
	if not "%errorlevel%" == "0" (
		rd /s /q $unsigned_zip_unzip_folder
		rd /s /q $diff_zip_unzip_folder
		rd /s /q $signed_zip_unzip_folder
		echo ERROR********************
		echo      : combine from %unsigned_zip% & %diff_zip% failed
		exit /b 1
	)
	del %signed_zip%
echo     cd %signed_zip_unzip_folder%
for /f %%a in ("%signed_zip_unzip_folder%") do (
	set signed_zip_unzip_folder_disk=%%~da
)
%signed_zip_unzip_folder_disk%
    cd %signed_zip_unzip_folder%
	echo cd:%cd%
    %current_folder%\winrar.exe a %signed_zip% .\* 
%current_disk%	
    cd %current_dir%
    :: clean
echo    rd /s /q %unsigned_zip_unzip_folder%
echo    rd /s /q %diff_zip_unzip_folder%
echo    rd /s /q %signed_zip_unzip_folder%
rd /s /q %unsigned_zip_unzip_folder%
rd /s /q %diff_zip_unzip_folder%
rd /s /q %signed_zip_unzip_folder%
    echo COMBINE SIGNED_ZIP DIDD_ZIP OK*****************
    echo       : combine %unsigned_zip% and %diff_zip% OK