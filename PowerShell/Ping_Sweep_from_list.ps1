# Ping sweep
@echo off
setlocal enabledelayedexpansion

#Define the input and output files
set "input=ip_list.txt" # replace with your list
set "output=Ping_Sweep_Results.txt"

# Clear the output file
echo > %output%

# Read each line from the input file
for /f "tokens=*" %%i in (%input%) do (
    ping -n 1 -w 200 %%i | find "TTL" > nul
    if !errorlevel! == 0 (
        echo %%i is up >> %output%
    ) else (
        echo %%i is down >> %output%
    )
)
