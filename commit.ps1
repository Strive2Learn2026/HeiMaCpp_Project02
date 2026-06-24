# 用法: .\commit.ps1 "提交说明"
# 示例: .\commit.ps1 "更新 speechMatch 主程序"

param(
    [Parameter(Mandatory = $false, Position = 0)]
    [string]$Message = ""
)

$ErrorActionPreference = "Stop"

function Invoke-Git {
    param(
        [Parameter(Mandatory = $true)]
        [string[]]$GitArguments
    )

    & $script:GitExe @GitArguments
    if ($LASTEXITCODE -ne 0) {
        throw "git 命令失败 (exit $LASTEXITCODE): git $($GitArguments -join ' ')"
    }
}

function Invoke-GitSoft {
    param(
        [Parameter(Mandatory = $true)]
        [string[]]$GitArguments
    )

    & $script:GitExe @GitArguments
    return $LASTEXITCODE
}

function Write-Step {
    param([string]$Text)
    Write-Host ">> $Text" -ForegroundColor Cyan
}

function Write-Ok {
    param([string]$Text)
    Write-Host $Text -ForegroundColor Green
}

function Write-WarnBox {
    param([string[]]$Lines)
    Write-Host ""
    Write-Host "========================================" -ForegroundColor Red
    Write-Host "  警告: 未能推送到 GitHub" -ForegroundColor Red
    Write-Host "========================================" -ForegroundColor Red
    foreach ($line in $Lines) {
        Write-Host $line -ForegroundColor Yellow
    }
    Write-Host "========================================" -ForegroundColor Red
    Write-Host ""
}

function Test-BranchAhead {
    $status = (& $script:GitExe status -sb 2>$null) | Select-Object -First 1
    return ($status -match "ahead")
}

function Push-ToGitHub {
    param(
        [int]$MaxAttempts = 5,
        [int]$DelaySeconds = 5
    )

    $pushVariants = @(
        @("-c", "http.version=HTTP/1.1", "push"),
        @("push"),
        @("-c", "http.version=HTTP/1.1", "push", "origin", "master")
    )

    for ($attempt = 1; $attempt -le $MaxAttempts; $attempt++) {
        foreach ($variant in $pushVariants) {
            Write-Step "推送到 GitHub (第 $attempt/$MaxAttempts 次, git $($variant -join ' '))..."
            $code = Invoke-GitSoft -GitArguments $variant
            if ($code -eq 0 -and -not (Test-BranchAhead)) {
                return $true
            }
        }

        if ($attempt -lt $MaxAttempts) {
            Write-Host "推送失败，$DelaySeconds 秒后自动重试..." -ForegroundColor DarkYellow
            Start-Sleep -Seconds $DelaySeconds
        }
    }

    return $false
}

$env:Path = [Environment]::GetEnvironmentVariable("Path", "Machine") + ";" +
            [Environment]::GetEnvironmentVariable("Path", "User")

$gitCmd = Get-Command git -ErrorAction SilentlyContinue
if ($gitCmd) {
    $GitExe = $gitCmd.Source
} else {
    $GitExe = "C:\Program Files\Git\cmd\git.exe"
    if (-not (Test-Path $GitExe)) {
        Write-Error "未找到 git，请先安装 Git for Windows。"
    }
}

Set-Location $PSScriptRoot

Write-Step "当前目录: $PWD"
Invoke-Git @("status", "-sb")

$changes = Invoke-Git @("status", "--porcelain")
$ahead = Test-BranchAhead

if (-not $changes -and -not $ahead) {
    Write-Host "没有需要提交或推送的更改。" -ForegroundColor Yellow
    exit 0
}

if ($changes) {
    if ([string]::IsNullOrWhiteSpace($Message)) {
        Write-Error "有未提交的更改，请提供提交说明。示例: .\commit.ps1 `"更新主程序`""
    }

    Write-Step "暂存所有更改..."
    Invoke-Git @("add", "-A")

    Write-Step "提交到本地仓库: $Message"
    Invoke-Git @("commit", "-m", $Message)

    $commit = (Invoke-Git @("log", "-1", "--oneline")) | Select-Object -First 1
    Write-Ok "[本地提交成功] $commit"
} elseif ($ahead) {
    Write-Host "检测到本地有未推送的提交，将自动推送到 GitHub（无需再次 commit）。" -ForegroundColor DarkYellow
}

if (-not (Push-ToGitHub)) {
    Write-WarnBox @(
        "已自动重试多次，仍无法推送到 GitHub。",
        "常见原因: 网络不稳定、需要登录 GitHub、或防火墙拦截。",
        "",
        "请检查网络后再次运行:",
        "  .\commit.ps1",
        "",
        "当前状态:"
    )
    Invoke-Git @("status", "-sb")
    exit 1
}

Write-Ok "[全部完成] 代码已同步到 GitHub。"
Invoke-Git @("log", "-1", "--oneline")
Write-Host "可在 GitHub 仓库页面查看最新提交。" -ForegroundColor Green
exit 0