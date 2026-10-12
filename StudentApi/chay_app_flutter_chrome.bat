@echo off
chcp 65001 > nul
echo ========================================================
echo   KHỞI ĐỘNG ỨNG DỤNG THI TOEIC READING TRÊN CHROME WEB
echo   Kết nối Backend: http://localhost:5247 (Database: de tanh)
echo ========================================================
cd /d "%~dp0dart"
flutter run -d chrome
pause
