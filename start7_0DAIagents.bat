@ECHO OFF
REM This bat file is used to Start DAI Run Agents
REM Log folders must be created, and DAI 7 Agent ini files must be generated and uploaded into the DAI 7 agent before using this bat file
REM the env-id of each EE can be determined by opening the Execution Environment ini file in Notepad++ or similar text editor.
REM note that runscript is used to run the eggdrive process for the run agents as of DAI 7.  
REM This bat file ends all active runscript and eggplantDAIRunAgent processes before starting new agent and epf threads
REM All file paths and url references must be modified

cd "C:\Program Files (x86)\eggplantDAIRunAgent"

REM Check to see if agent(s) are already running, and abort if so
tasklist /fi "imagename eq eggplantDAIRunAgent.exe" |find "eggplantDAIRunAgent" > nul
if errorlevel 1 ( echo eggplantDAIRunAgent was not running, local time %time% %date% >> c:\DAI_Agent_Logs\EggLog1.txt) else (
taskkill /f /im "eggplantDAIRunAgent.exe">>c:\DAI_Agent_Logs\EggLog1.txt 2>&1
echo eggplantDAIRunAgent was running, local time %time% %date% >>c:\DAI_Agent_Logs\EggLog1.txt )

REM Check to see if previous runscript instances are active, and kill them
tasklist /fi "imagename eq runscript.exe" |find "runscript" > nul
if errorlevel 1 ( echo Runscript was not running, local time %time% %date% >> c:\DAI_Agent_Logs\EggLog2.txt) else (
taskkill /f /im "runscript.exe">>c:\DAI_Agent_Logs\EggLog2.txt 2>&1
echo Runscript was running, local time %time% %date% >>c:\DAI_Agent_Logs\EggLog2.txt )

REM Start BOND - edit the Run Agent name accordingly, as well as the suite root folder
ECHO Starting BOND Agent . . .
START /B eggplantDAIRunAgent.exe --ini-file "C:\DAI_Agent_INI\BOND.ini" --drive-port 5400 --gui False --host-url http://localhost:8000 --env-id 3 --log-level DEBUG --suite-root "C:\Users\davihest\Documents\BOND"

TIMEOUT 10

REM Start BOURNE - edit the Run Agent name accordingly, as well as the suite root folder
ECHO Starting BOURNE Agent . . .
START /B eggplantDAIRunAgent.exe --ini-file "C:\DAI_Agent_INI\BOURNE.ini" --drive-port 5401 --gui False --host-url http://localhost:8000 --env-id 4 --log-level DEBUG --suite-root "C:\Users\davidhest\Documents\BOURNE"

REM Insert START commands here for additional run agents

ECHO All agents should be running . . .
ECHO This window should remain open, or the Agents shut down!

cmd /k 