$ErrorActionPreference = 'Stop'

$blogDir  = 'C:\Users\zhaihaoyu\WorkBuddy\2026-11-25-15-02-10\hexo-blog'
$postsDir = Join-Path $blogDir 'source\_posts'

if ($args.Count -gt 0) {
    $title = ($args -join ' ')
} else {
    $title = Read-Host '请输入文章标题'
}

if ([string]::IsNullOrWhiteSpace($title)) {
    Write-Host '标题不能为空，已取消。'
    Read-Host '按回车键关闭'
    exit 1
}

# Choose category
Write-Host ''
Write-Host '请选择分类：'
Write-Host '  1. 作为评测者'
Write-Host '  2. 作为程序员'
Write-Host '  3. 工作日记'
$choice = Read-Host '输入 1/2/3（直接回车默认 3 工作日记）'
switch ($choice) {
    '1' { $category = '作为评测者' }
    '2' { $category = '作为程序员' }
    default { $category = '工作日记' }
}

$safeName = $title -replace '[\\/:*?"<>|]', '-'
$date = Get-Date -Format 'yyyy-MM-dd HH:mm:ss'
$fileName = "$safeName.md"
$path = Join-Path $postsDir $fileName

if (Test-Path $path) {
    $stamp = (Get-Date).ToString('yyyyMMdd-HHmmss')
    $fileName = "$safeName-$stamp.md"
    $path = Join-Path $postsDir $fileName
}

$body = @"
---
title: $title
date: $date
tags:
  - 学习笔记
categories:
  - $category
---

在这里写正文……


"@

$utf8NoBom = New-Object System.Text.UTF8Encoding($false)
[System.IO.File]::WriteAllText($path, $body, $utf8NoBom)

Write-Host ''
Write-Host '=================================================='
Write-Host "已创建新文章：$fileName"
Write-Host "位置：$path"
Write-Host '正在用记事本打开，写好正文后记得保存（Ctrl+S）。'
Write-Host '写完保存后，双击桌面的「一键发布博客」就能上线。'
Write-Host '=================================================='
Write-Host ''

Start-Process notepad.exe -ArgumentList "`"$path`""
