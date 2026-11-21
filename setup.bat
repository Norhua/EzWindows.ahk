@echo off
chcp 65001 >nul
setlocal

cd /d "%~dp0"

echo 正在创建目录...
if not exist ".\resources" (
    mkdir ".\resources"
)
if not exist ".\resources\lib" (
    mkdir ".\resources\lib"
)

set "VD_URL=https://raw.githubusercontent.com/FuPeiJiang/VD.ahk/v2_port/VD.ah2"
set "VD_OUT=.\resources\lib\VD.ah2"

echo 正在下载 VD.ah2 到 %VD_OUT% ...
where curl >nul 2>nul
if %errorlevel% equ 0 (
    curl -L -f -o "%VD_OUT%" "%VD_URL%"
) else (
    powershell -NoProfile -ExecutionPolicy Bypass -Command "[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; Invoke-WebRequest -Uri '%VD_URL%' -OutFile '%VD_OUT%'"
)

if %errorlevel% neq 0 (
    echo [错误] 下载 VD.ah2 失败，请检查网络连接后重试。
    exit /b 1
)

echo [完成] 已成功获取 VD.ah2 到 ./resources/lib/VD.ah2
endlocal
