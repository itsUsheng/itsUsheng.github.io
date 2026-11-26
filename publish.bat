@echo off
chcp 65001 >nul
title Blog One-Click Publisher
color 0A

echo.
echo  ==================================================
echo           Blog One-Click Publisher
echo  ==================================================
echo.

rem === Defensive: clear Git reserved env vars (they can break git commands) ===
rem === Lesson: never name our own variable GIT_DIR / GIT_WORK_TREE / GIT_INDEX_FILE ===
set "GIT_DIR="
set "GIT_WORK_TREE="
set "GIT_INDEX_FILE="
set "GIT_CONFIG="

set "NODE_DIR=C:\Users\zhaihaoyu\.workbuddy\binaries\node\versions\22.22.2-6"
set "PGROOT=C:\Users\zhaihaoyu\AppData\Local\Programs\WorkBuddy\resources\vendor\PortableGit"
set "GIT_CMD=%PGROOT%\cmd"
set "GIT_BIN=%PGROOT%\mingw64\bin"
set "GIT_EXE=%GIT_CMD%\git.exe"
set "PROXY=http://127.0.0.1:7897"
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
echo  (If a GitHub login window pops up, click it to authorize)
echo.
"%GIT_EXE%" add -A
"%GIT_EXE%" commit -m "post: %date% %time%"
echo.
echo  ===== upload details (real errors appear here) =====
"%GIT_EXE%" -c http.proxy=%PROXY% push origin main
set "PUSH_CODE=%ERRORLEVEL%"
echo  ===== upload finished =====
echo.

if not "%PUSH_CODE%"=="0" goto fail

echo  ==================================================
echo    SUCCESS! Wait 1-2 minutes, then visit:
echo    https://tekikoyo.github.io/itsusheng.github.io/
echo  ==================================================
echo.
goto end

:fail
echo.
echo  ==================================================
echo    FAILED - the real error is shown ABOVE.
echo    Common causes:
echo    1. Proxy OFF - start your VPN tool (port 7897)
echo    2. GitHub login window - click it to authorize
echo    3. No internet connection
echo    Fix it, then double-click this script again.
echo  ==================================================
echo.

:end
echo  Press any key to close...
pause >nul
