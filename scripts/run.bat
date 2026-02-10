@echo off
echo Starting OdinHFT Bot...
timeout /t 2 /nobreak >nul
bin\OdinHFT.exe --config=config\project.json
pause
