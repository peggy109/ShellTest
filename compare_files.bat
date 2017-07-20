@echo off
set config_md5_file=%1
set folder_to_be_check=%2
set c_dir=%cd%
for /f %%i in ("%c_dir%") do (
	set c_d=%%~di
	set c_folder=%%~fi
)
for /f %%i in ("%folder_to_be_check%") do (
	set t_d=%%~di
)
echo t_d : %t_d%
echo 
%t_d%
cd %folder_to_be_check%
echo cd : %cd%
set compare_err=0
FOR /F "tokens=1,2" %%i IN (%config_md5_file%) DO (
	echo line: %%i_%%j_END
	call %c_folder%\compare_file.bat %%i %%j
)

echo after compare_file for every file
echo compare_err = %compare_err%

%c_d%
cd %c_dir%
if "%compare_err%" == "1" (
	echo ******************************************
	echo COMPARE ERROR*****************************
	echo     compare %folder_to_be_check% and %config_md5_file% failed
	echo ******************************************
	exit /b 1
) else (
	echo ******************************************
	echo ***********COMPARE OK*********************
	echo     compare %folder_to_be_check% and %config_md5_file% ok
	echo ******************************************
	exit /b 0
)
@echo on