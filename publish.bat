@echo off
chcp 65001 >nul
setlocal

set PG=C:\Users\zhaihaoyu\AppData\Local\Programs\WorkBuddy\resources\vendor\PortableGit
set PATH=%PG%\cmd;%PG%\mingw64\bin;%PATH%
set HTTP_PROXY=http://127.0.0.1:7897
set HTTPS_PROXY=http://127.0.0.1:7897
set http_proxy=http://127.0.0.1:7897
set https_proxy=http://127.0.0.1:7897

cd /d C:\Users\zhaihaoyu\WorkBuddy\2026-11-25-15-02-10\hexo-blog

echo [1/3] Adding changes...
git add -A
if errorlevel 1 goto fail

echo [2/3] Committing...
git commit -m "post: %date% %time%"
if errorlevel 1 (
  echo No changes to commit, skipping.
)

echo [3/3] Pushing to GitHub...
git -c http.proxy=http://127.0.0.1:7897 push origin main
if errorlevel 1 goto fail

echo.
echo Done! Your post will be live in 1-2 minutes at:
echo https://tekikoyo.github.io/itsusheng.github.io/
echo.
goto end

:fail
echo.
echo FAILED. Check your proxy (127.0.0.1:7897) and GitHub login.
echo.

:end
pause
