@echo off
chcp 65001 > nul
echo ========================================================
echo   BACKEND ASP.NET CORE API - HỆ THỐNG THI TOEIC READING
echo   Database: [de tanh] & [sinhv] trên LAPTOP-MAALSNS1
echo   Cổng kết nối: http://localhost:5247
echo ========================================================
cd /d "%~dp0StudentApi"
dotnet run --urls=http://localhost:5247
pause
