@echo off
set image_signed=%1
echo %image_signed%
set image_signed=%2
set image_unsigned=%3
set image_signed_new=%4
set image_signed_p1_size=%5
set image_signed_1=%6
set image_signed_3=%7
set check=%8
echo %date%
echo %time%
set dat=%date:~0,4%%date:~5,2%%date:~8,2%_%time:~0,2%%time:~3,2%%time:~6,2%_%time:~9,2%
echo %dat%
for /f %%a in ("%image_unsigned%") do (
	set image_unsigned_filename=%%~nxa
)

set image_unsigned_1_and_2=%temp%%image_unsigned_filename%_part12_%dat%
set image_unsigned_1_and_2_and_3=%temp%%image_unsigned_filename%_part123_%dat%

cp %image_signed_1% %image_unsigned_1_and_2%
if not "%errorlevel%" == "0" (
	del %image_unsigned_1_and_2% %image_unsigned_1_and_2_and_3%
	exit /b 1
)
set dd_if=%image_unsigned%
set dd_of=%image_unsigned_1_and_2%
for /f %%a in ("%dd_if%") do (
	set size_if=%%~za
)
for /f %%a in ("%dd_of%") do (
	set size_of=%%~za
)
dd %dd_if% %dd_of% 1 0 %size_of% %size_if%
if not "%errorlevel%" == "0" (
	del %image_unsigned_1_and_2% %image_unsigned_1_and_2_and_3%
	exit /b 1
)

for /f %%a in ("%image_unsigned_1_and_2%") do (
	set size_image_unsigned_1_and_2=%%~za
)

cp %image_unsigned_1_and_2% %image_unsigned_1_and_2_and_3%
if not "%errorlevel%" == "0" (
	del %image_unsigned_1_and_2% %image_unsigned_1_and_2_and_3%
	exit /b 1
)

set dd_if=%image_signed_3%
set dd_of=%image_unsigned_1_and_2_and_3%
for /f %%a in ("%dd_if%") do (
	set size_if=%%~za
)
for /f %%a in ("%dd_of%") do (
	set size_of=%%~za
)

dd %dd_if% %dd_of% 1 0 %size_of% %size_if%
if not "%errorlevel%" == "0" (
	echo "dd failed"
::	del %image_unsigned_1_and_2% %image_unsigned_1_and_2_and_3%
	exit /b 1
)


echo n | comp %image_signed% %image_unsigned_1_and_2_and_3%
if "%errorlevel%" == "0" (
        cp %image_unsigned_1_and_2_and_3% %image_signed_new%
        echo "SUCCESS******************"
        echo "     :create $image_signed_new from $image_signed & $image_unsigned"
) else (
        echo "ERROR********************"
        echo "     :create $image_signed_new from $image_signed & $image_unsigned failed!"
        ::clean
        del %image_unsigned_1_and_2% %image_unsigned_1_and_2_and_3%
        exit /b 1
)
    
::    #clean
del %image_unsigned_1_and_2% %image_unsigned_1_and_2_and_3%

exit /b 0