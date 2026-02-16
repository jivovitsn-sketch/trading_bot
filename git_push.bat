@echo off
echo === PUSHING TO GITHUB ===

git add .
git commit -m "v2.0: Full production system with 12 exchanges"
git push origin main

echo === DONE ===
pause
