@echo off
chcp 65001 >nul
title 博客一键发布工具
color 0A

echo.
echo  ==================================================
echo              博客一键发布工具
echo  ==================================================
echo.

rem ========== 配置区（一般不用改，换电脑才需要改）==========
set "NODE_DIR=C:\Users\zhaihaoyu\.workbuddy\binaries\node\versions\22.22.2-6"
set "GIT_DIR=C:\Users\zhaihaoyu\AppData\Local\Programs\WorkBuddy\resources\vendor\PortableGit"
set "GIT_CMD=%GIT_DIR%\cmd"
set "GIT_BIN=%GIT_DIR%\mingw64\bin"
set "PROXY=http://127.0.0.1:7897"
set "PROXY_PORT=7897"
set "BLOG_DIR=C:\Users\zhaihaoyu\WorkBuddy\2026-11-25-15-02-10\hexo-blog"
rem =========================================================

echo [1/4] 正在检查并配置运行环境...
echo.

rem 临时 PATH（保证本次运行一定能找到命令）
set "PATH=%NODE_DIR%;%GIT_CMD%;%GIT_BIN%;%PATH%"

rem 永久 PATH（写入用户环境变量，已经配过就自动跳过）
powershell -NoProfile -Command "$n='%NODE_DIR%';$g='%GIT_CMD%';$b='%GIT_BIN%';$p=[Environment]::GetEnvironmentVariable('Path','User');$need=@();foreach($x in @($n,$g,$b)){if(($p -split ';') -notcontains $x){$need+=$x}};if($need.Count -gt 0){$new=$p;foreach($x in $need){$new=$x+';'+$new};[Environment]::SetEnvironmentVariable('Path',$new,'User');Write-Host ('  PATH updated: added '+$need.Count+' entries')}else{Write-Host '  PATH already configured (skipped)'}"

rem Git 全局代理 + 凭据管理器（重复执行不会出问题）
git config --global http.proxy %PROXY%
git config --global https.proxy %PROXY%
git config --global credential.helper manager
echo  Git proxy and credential helper: OK

rem PowerShell 执行策略（让 npm/hexo 在 PowerShell 里也能跑）
powershell -NoProfile -Command "Set-ExecutionPolicy -Scope CurrentUser -ExecutionPolicy RemoteSigned -Force" >nul 2>&1
echo  PowerShell execution policy: OK
echo.

echo [2/4] 正在检查代理（科学上网工具）...
powershell -NoProfile -Command "try{$c=New-Object Net.Sockets.TcpClient;$c.Connect('127.0.0.1',%PROXY_PORT%);$c.Close();Write-Host '  Proxy %PROXY_PORT% is ON'}catch{Write-Host '  WARNING: proxy %PROXY_PORT% is OFF - please start your VPN tool'}"
echo.

echo [3/4] 进入博客目录...
cd /d "%BLOG_DIR%"
if errorlevel 1 (
  echo  ERROR: cannot find blog folder: %BLOG_DIR%
  goto fail
)
echo  Folder OK
echo.

echo [4/4] 提交并推送文章...
git add -A
if errorlevel 1 goto fail
git commit -m "post: %date% %time%"
git push origin main
if errorlevel 1 goto fail

echo.
echo  ==================================================
echo    发布成功！等 1-2 分钟后访问：
echo    https://tekikoyo.github.io/itsusheng.github.io/
echo  ==================================================
echo.
goto end

:fail
echo.
echo  ==================================================
echo    发布失败，请按顺序检查：
echo    1. 科学上网工具是否开启（代理端口 %PROXY_PORT%）
echo    2. 屏幕上是否弹出 GitHub 登录窗口，点开并授权
echo    3. 网络是否正常
echo    解决后再双击一次本脚本即可
echo  ==================================================
echo.

:end
echo  按任意键关闭窗口...
pause >nul
