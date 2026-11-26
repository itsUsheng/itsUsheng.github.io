@echo off
chcp 65001 >nul
title Blog One-Click Publisher
color 0A

echo.
echo  ==================================================
echo           Blog One-Click Publisher
echo  ==================================================
echo.

set "NODE_DIR=C:\Users\zhaihaoyu\.workbuddy\binaries\node\versions\22.22.2-6"
set "GIT_DIR=C:\Users\zhaihaoyu\AppData\Local\Programs\WorkBuddy\resources\vendor\PortableGit"
set "GIT_CMD=%GIT_DIR%\cmd"
set "GIT_BIN=%GIT_DIR%\mingw64\bin"
set "PROXY=http://127.0.0.1:7897"
set "PROXY_PORT=7897"
set "BLOG_DIR=C:\Users\zhaihaoyu\WorkBuddy\2026-11-25-15-02-10\hexo-blog"
set "SCRIPT_DIR=%~dp0"

echo [1/4] Setting up environment...
set "PATH=%NODE_DIR%;%GIT_CMD%;%GIT_BIN%;%PATH%"
powershell -NoProfile -ExecutionPolicy Bypass -File "%SCRIPT_DIR%setup_env.ps1"
echo.

echo [2/4] Checking proxy...
powershell -NoProfile -Command "try{$c=New-Object Net.Sockets.TcpClient;$c.Connect('127.0.0.1',7897);$c.Close();Write-Host '  Proxy 7897 is ON'}catch{Write-Host '  WARNING: proxy 7897 is OFF - start your VPN tool'}"
echo.

echo [3/4] Entering blog folder...
cd /d "%BLOG_DIR%"
if errorlevel 1 (
  echo  ERROR: cannot find blog folder
  goto fail
)
echo  Folder OK
echo.

echo [4/4] Committing and pushing...
git add -A
if errorlevel 1 goto fail
git commit -m "post: %date% %time%"
git push origin main
if errorlevel 1 goto fail

echo.
echo  ==================================================
echo    SUCCESS! Wait 1-2 minutes, then visit:
echo    https://tekikoyo.github.io/itsusheng.github.io/
echo  ==================================================
echo.
goto end

:fail
echo.
echo  ==================================================
echo    FAILED. Check in order:
echo    1. VPN/proxy is ON (port 7897)
echo    2. GitHub login window - click and authorize
echo    3. Network connection
echo    Fix it and double-click this script again
echo  ==================================================
echo.

:end
echo  Press any key to close...
pause >nul
