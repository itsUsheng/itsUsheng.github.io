$ErrorActionPreference = 'SilentlyContinue'

$nodeDir = 'C:\Users\zhaihaoyu\.workbuddy\binaries\node\versions\22.22.2-6'
$gitDir  = 'C:\Users\zhaihaoyu\AppData\Local\Programs\WorkBuddy\resources\vendor\PortableGit'
$gitCmd  = Join-Path $gitDir 'cmd'
$gitBin  = Join-Path $gitDir 'mingw64\bin'

$userPath = [Environment]::GetEnvironmentVariable('Path', 'User')
$parts = @($userPath -split ';')
$need = @()
foreach ($p in @($nodeDir, $gitCmd, $gitBin)) {
    if ($parts -notcontains $p) { $need += $p }
}
if ($need.Count -gt 0) {
    $newPath = ($need -join ';') + ';' + $userPath
    [Environment]::SetEnvironmentVariable('Path', $newPath, 'User')
    Write-Host "  PATH updated: added $($need.Count) entries"
} else {
    Write-Host '  PATH already configured (skipped)'
}

& git config --global http.proxy http://127.0.0.1:7897
& git config --global https.proxy http://127.0.0.1:7897
& git config --global credential.helper manager
Write-Host '  Git proxy and credential helper: OK'

Set-ExecutionPolicy -Scope CurrentUser -ExecutionPolicy RemoteSigned -Force
Write-Host '  PowerShell execution policy: OK'
