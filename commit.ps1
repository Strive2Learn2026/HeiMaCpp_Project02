# 用法: .\commit.ps1 "提交说明"
# 示例: .\commit.ps1 "更新 speechMatch 主程序"
# 也可双击或在终端运行: commit.bat "提交说明"

param(
    [Parameter(Mandatory = $true, Position = 0)]
    [string]$Message
)

$ErrorActionPreference = "Stop"

$env:Path = [Environment]::GetEnvironmentVariable("Path", "Machine") + ";" +
            [Environment]::GetEnvironmentVariable("Path", "User")

$git = Get-Command git -ErrorAction SilentlyContinue
if (-not $git) {
    $gitPath = "C:\Program Files\Git\cmd\git.exe"
    if (-not (Test-Path $gitPath)) {
        Write-Error "未找到 git，请先安装 Git for Windows。"
    }
    $git = $gitPath
} else {
    $git = $git.Source
}

Set-Location $PSScriptRoot

Write-Host ">> 当前目录: $PWD" -ForegroundColor Cyan
& $git status -sb

$changes = & $git status --porcelain
if (-not $changes) {
    Write-Host "没有需要提交的更改。" -ForegroundColor Yellow
    exit 0
}

Write-Host ">> 暂存所有更改..." -ForegroundColor Cyan
& $git add -A

Write-Host ">> 提交: $Message" -ForegroundColor Cyan
& $git commit --trailer "Co-authored-by: Cursor <cursoragent@cursor.com>" -m $Message

Write-Host ">> 推送到远程..." -ForegroundColor Cyan
& $git -c http.version=HTTP/1.1 push

Write-Host "完成。" -ForegroundColor Green
& $git log -1 --oneline