@echo off

setlocal enabledelayedexpansion

REM Update this port to the current port used by your application
SET defaultPortNumber=57446
SET defaultNumberOfInstances=5

SET numberOfInstances=0

if %1.==. (
	SET numberOfInstances=%defaultNumberOfInstances%
) else (
	SET numberOfInstances=%1
)

REM Adjust depending on the file location of the bat script
cd ../.vs/config/
SET stringToReplace=*:%defaultPortNumber%:localhost
SET currentPortNumber=57446

FOR /L %%A IN (1,1,%numberOfInstances%) DO (
	SET newString=*:!currentPortNumber!:localhost
	REM Copy files
	copy applicationhost.config applicationhost%%A.config
	REM Replace Port
	call :FindReplace %stringToReplace% !newString! applicationhost%%A.config
	
	SET /A currentPortNumber=currentPortNumber+1
)

pause

REM Delete files when done

FOR /L %%A IN (1,1,%numberOfInstances%) DO (
	del applicationhost%%A.config
)

exit /b

:FindReplace <findstr> <replstr> <file>
set tmp="%temp%\tmp.txt"
If not exist %temp%\_.vbs call :MakeReplace
for /f "tokens=*" %%a in ('dir "%3" /s /b /a-d /on') do (
  for /f "usebackq" %%b in (`Findstr /mic:"%~1" "%%a"`) do (
    echo(&Echo Replacing "%~1" with "%~2" in file %%~nxa
    <%%a cscript //nologo %temp%\_.vbs "%~1" "%~2">%tmp%
    if exist %tmp% move /Y %tmp% "%%~dpnxa">nul
  )
)
del %temp%\_.vbs
exit /b

:MakeReplace
>%temp%\_.vbs echo with Wscript
>>%temp%\_.vbs echo set args=.arguments
>>%temp%\_.vbs echo .StdOut.Write _
>>%temp%\_.vbs echo Replace(.StdIn.ReadAll,args(0),args(1),1,-1,1)
>>%temp%\_.vbs echo end with
