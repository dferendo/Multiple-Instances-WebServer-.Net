@echo off

setlocal enabledelayedexpansion

SET defaultNumberOfInstances=5

SET startingPortNumber=57446
SET numberOfInstances=0

if %1.==. (
	SET numberOfInstances=%defaultNumberOfInstances%
) else (
	SET numberOfInstances=%1
)

SET currentPortNumber=%startingPortNumber%

REM Adjust depending on the file location of the bat script
cd ../.vs/config/

FOR /L %%A IN (1,1,%numberOfInstances%) DO (
	REM Start Webserver
	start cmd.exe /K iisexpress /config:applicationhost%%A.config
	
	REM Open browser
	start "" http:/localhost:!currentPortNumber!/
	
	SET /A currentPortNumber=currentPortNumber+1
)

exit /b