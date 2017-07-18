@echo off
:: 161.bat
:: check or combine
set image_signed=%2
set image_unsigned=%3
set image_signed_new=%4
set image_signed_p1_size=%5
set image_signed_1=%6
set image_signed_3=%7
set check=%8
set combine=%9
echo %0 %1 %2 %3 %4 %5 %6 %7 %8 %9
echo check_err : %check_err%
echo combine_err : %combine_err%
echo %check%_%combine%
set dat=%date:~0,4%%date:~5,2%%date:~8,2%_%time:~0,2%%time:~3,2%%time:~6,2%_%time:~9,2%
echo %dat%
for /f %%a in ("%image_unsigned%") do (
	set image_unsigned_filename=%%~nxa
)

set image_unsigned_1_and_2=%temp%\%image_unsigned_filename%_part12_%dat%
set image_unsigned_1_and_2_and_3=%temp%\%image_unsigned_filename%_part123_%dat%


:: combine part1 & unsigned.img
copy /y %image_unsigned% %image_unsigned_1_and_2%
set dd_if=%image_signed_1%
set dd_of=%image_unsigned_1_and_2%
for /f %%a in ("%dd_if%") do (
	set size_if=%%~za
)
for /f %%a in ("%dd_of%") do (
	set size_of=%%~za
)
dd %dd_if% %dd_of% 1 0 0 %size_if%
if not "%errorlevel%" == "0" (
	del %image_unsigned_1_and_2% %image_unsigned_1_and_2_and_3%
	if "%check%" == "true" (
		if "%combine%" == "true" (
			set combine_err=1
		) else (
			set check_err=1
		)
	)
	exit /b 1
)

::combine (part1 + unsigned.img) & part3
type %image_unsigned_1_and_2% %image_signed_3% > %image_unsigned_1_and_2_and_3%

if not "%combine%" == "true" ( 
	echo n | comp %image_signed% %image_unsigned_1_and_2_and_3%
	if "%errorlevel%" == "0" (
        copy /y %image_unsigned_1_and_2_and_3% %image_signed_new%
        echo "SUCCESS******************"
        echo "     :create %image_signed_new% from %image_signed% & %image_unsigned%"
	) else (
        echo "ERROR********************"
        echo "     :create %image_signed_new% from %image_signed% & %image_unsigned% failed"
        ::clean
        del %image_unsigned_1_and_2% %image_unsigned_1_and_2_and_3%

		if "%check%" == "true" (
			if "%combine%" == "true" (
				set combine_err=1
			) else (
				set check_err=1
			)
		)
        exit /b 1
	)
) else (
        copy /y %image_unsigned_1_and_2_and_3% %image_signed_new%
        echo "COMBINE FINISH******************"
        echo "     :create %image_signed_new% from %image_unsigned% & %image_signed_1% & %image_signed_3%"
)    
::    #clean
del %image_unsigned_1_and_2% %image_unsigned_1_and_2_and_3%

exit /b 0