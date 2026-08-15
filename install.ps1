# install.ps1 - OPC Entrepreneurship Basics skill pack installer
# ================================================================
# 支持两种安装源：
#   方式一（在线，推荐）：从 GitHub 直接拉取整个 skill 包
#      powershell -NoProfile -ExecutionPolicy Bypass -File install.ps1 -Source github
#   方式二（离线/zip）：本机已解压的 skills\ 目录
#      powershell -NoProfile -ExecutionPolicy Bypass -File install.ps1
#
# 参数：
#   -Source   github | local   （默认 local）
#   -Repo     仓库地址（默认 yangzhe1952/opc-entrepreneurship-basics-zingy）
#   -Branch   分支（默认 main）
#   -Target   auto | agents | claude | workbuddy | custom:<path>
#   -WithDashi  是否安装/初始化 dashi-ppt（M7 路演 PPT 依赖），默认 true
# ================================================================
param(
    [ValidateSet("github", "local")]
    [string]$Source = "local",
    [string]$Repo = "yangzhe1952/opc-entrepreneurship-basics-zingy",
    [string]$Branch = "main",
    [string]$Target = "auto",
    [switch]$WithDashi = $true
)
$ErrorActionPreference = "Stop"

$skills = @(
    "opc-m1-track-analysis",
    "opc-m2-track-profile",
    "opc-m3-solution-design",
    "opc-m4-requirements",
    "opc-m5-ai-testing",
    "opc-m6-iteration",
    "opc-m7-pitch",
    "opc-m8-assets",
    "dashi-ppt"
)

# ---------- 解析安装目标目录 ----------
$targets = @()
if ($Target -eq "auto") {
    $targets = @((Join-Path $HOME ".agents\skills"), (Join-Path $HOME ".claude\skills"))
} elseif ($Target -eq "agents") {
    $targets = @((Join-Path $HOME ".agents\skills"))
} elseif ($Target -eq "claude") {
    $targets = @((Join-Path $HOME ".claude\skills"))
} elseif ($Target -eq "workbuddy") {
    # WorkBuddy 常见 skills 目录（按需自行调整，或用 -Target custom:<绝对路径>）
    $targets = @((Join-Path $HOME ".workbuddy\skills"), (Join-Path $HOME ".agents\skills"))
} elseif ($Target -like "custom:*") {
    $targets = @($Target.Substring(7))
} else {
    throw "Unknown -Target: $Target"
}

# ---------- 获取源 ----------
$tmpRoot = Join-Path $env:TEMP "opc-skill-install"
if (Test-Path -LiteralPath $tmpRoot) { Remove-Item -LiteralPath $tmpRoot -Recurse -Force }
New-Item -ItemType Directory -Path $tmpRoot -Force | Out-Null

if ($Source -eq "github") {
    Write-Host "==> 从 GitHub 拉取 $Repo@$Branch ..."
    $dl = "$tmpRoot\opc-skills.zip"
    $url = "https://github.com/$Repo/archive/refs/heads/$Branch.zip"
    Invoke-WebRequest -Uri $url -OutFile $dl -UseBasicParsing
    Expand-Archive -LiteralPath $dl -DestinationPath "$tmpRoot\unz" -Force
    $src = Get-ChildItem "$tmpRoot\unz" -Directory | Select-Object -First 1
    $src = Join-Path $src.FullName "skills"
    Write-Host "    解压完成: $src"
} else {
    $src = Join-Path $PSScriptRoot "skills"
    if (-not (Test-Path -LiteralPath $src)) {
        throw "local 模式未找到 skills\ 目录。请确认脚本位于解压后的包内。"
    }
    Write-Host "==> 从本地包安装: $src"
}

# ---------- 安装 ----------
$installed = 0
foreach ($t in $targets) {
    if (-not (Test-Path -LiteralPath $t)) {
        New-Item -ItemType Directory -Path $t -Force | Out-Null
    }
    foreach ($s in $skills) {
        $from = Join-Path $src $s
        $to = Join-Path $t $s
        if (-not (Test-Path -LiteralPath $from)) {
            Write-Warning "  missing: $from"
            continue
        }
        if (Test-Path -LiteralPath $to) {
            Remove-Item -LiteralPath $to -Recurse -Force
        }
        Copy-Item -LiteralPath $from -Destination $to -Recurse -Force
        Write-Host "  installed -> $to"
        $installed++
    }
}
Write-Host ""
Write-Host "OPC skills installed: $installed folders across $($targets.Count) location(s)."
Write-Host "Restart opencode / Claude Code / WorkBuddy to load them."
Write-Host ""

# ---------- dashi-ppt 初始化（npm install） ----------
if ($WithDashi) {
    $project = Join-Path $HOME ".agents\skills\dashi-ppt\project"
    if (-not (Test-Path -LiteralPath (Join-Path $project "package.json"))) {
        $project = Join-Path $HOME ".claude\skills\dashi-ppt\project"
    }
    if (Test-Path -LiteralPath (Join-Path $project "package.json")) {
        if (-not (Test-Path -LiteralPath (Join-Path $project "node_modules"))) {
            Write-Host "==> 初始化 dashi-ppt 依赖（首次较慢）..."
            Write-Host "    项目: $project"
            if (Test-Path -LiteralPath (Join-Path $project "npmrc.template")) {
                if (-not (Test-Path -LiteralPath (Join-Path $project ".npmrc"))) {
                    Copy-Item -LiteralPath (Join-Path $project "npmrc.template") -Destination (Join-Path $project ".npmrc") -Force
                }
            }
            Push-Location $project
            npm install 2>&1 | ForEach-Object { Write-Host "    $_" }
            Pop-Location
            Write-Host "==> dashi-ppt 依赖安装完成。"
        } else {
            Write-Host "==> dashi-ppt 依赖已存在，跳过。"
        }
    } else {
        Write-Host "警告: 未找到 dashi-ppt 项目，跳过依赖初始化。"
    }
}

# ---------- 清理 ----------
Remove-Item -LiteralPath $tmpRoot -Recurse -Force -ErrorAction SilentlyContinue
Write-Host ""
Write-Host "完成！"
