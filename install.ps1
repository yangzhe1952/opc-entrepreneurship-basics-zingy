# install.ps1 - OPC Entrepreneurship Basics skill pack installer
# ================================================================
# 支持两种安装源：
#   方式一（在线，推荐）：从 GitHub 直接拉取整个 skill 包
#      powershell -NoProfile -ExecutionPolicy Bypass -Command "& { iwr https://raw.githubusercontent.com/yangzhe1952/opc-entrepreneurship-basics-zingy/master/install.ps1 -UseBasicParsing | iex } -Source github"
#      （若用 irm | iex 方式，脚本会自动检测并切到 github 源）
#   方式二（离线/zip）：本机已解压的 skills\ 目录
#      powershell -NoProfile -ExecutionPolicy Bypass -File install.ps1
#
# 参数：
#   -Source   github | local | auto   （默认 auto：能定位到本地包就用 local，否则用 github）
#   -Repo     仓库地址（默认 yangzhe1952/opc-entrepreneurship-basics-zingy）
#   -Branch   分支（默认 master）
#   -Target   auto | agents | claude | workbuddy | custom:<path>
#   -Force    覆盖已存在的同名技能目录（默认**不覆盖**，改为备份后询问式提示）
#   -NoBackup 关闭自动备份（不推荐）
# ================================================================
param(
    [ValidateSet("github", "local", "auto")]
    [string]$Source = "auto",
    [string]$Repo = "yangzhe1952/opc-entrepreneurship-basics-zingy",
    [string]$Branch = "master",
    [string]$Target = "auto",
    [switch]$Force,
    [switch]$NoBackup
)
$ErrorActionPreference = "Stop"

# 8 个技能模块（每个都自包含：references\ + scripts\ + data\ 由 sync-references.ps1 分发）
$skills = @(
    "opc-m1-track-analysis",
    "opc-m2-problem-definition",
    "opc-m3-solution-design",
    "opc-m4-requirements-analysis",
    "opc-m5-product-testing",
    "opc-m6-product-iteration",
    "opc-m7-product-pitch",
    "opc-m8-archive-generation"
)

# ---------- -Only：只安装指定模块 ----------
if ($Only) {
    $map = @{
        "m1" = "opc-m1-track-analysis";      "m2" = "opc-m2-problem-definition"
        "m3" = "opc-m3-solution-design";     "m4" = "opc-m4-requirements-analysis"
        "m5" = "opc-m5-product-testing";     "m6" = "opc-m6-product-iteration"
        "m7" = "opc-m7-product-pitch";       "m8" = "opc-m8-archive-generation"
    }
    $wanted = @()
    foreach ($x in ($Only -split '\s*,\s*')) {
        $k = $x.Trim().ToLower()
        if ($map.ContainsKey($k)) { $wanted += $map[$k] }
        elseif ($skills -contains $k) { $wanted += $k }
        else { throw "未知的模块：$x（可用 m1–m8 或完整目录名，多个用英文逗号分隔）" }
    }
    $skills = @($skills | Where-Object { $wanted -contains $_ })
    Write-Host "==> 仅安装指定模块：$($skills -join ', ')"
}

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

# ---------- 解析安装源 ----------
$tmpRoot = Join-Path $env:TEMP ("opc-skill-install-" + [System.Guid]::NewGuid().ToString("N").Substring(0, 8))
New-Item -ItemType Directory -Path $tmpRoot -Force | Out-Null

# 关键修复：irm | iex 方式下 $PSScriptRoot 为空，local 源必然失败。
# 这里做一次自动判断，避免 README 里的在线安装命令直接报错。
$localSrc = $null
if ($PSScriptRoot) {
    $candidate = Join-Path $PSScriptRoot "skills"
    if (Test-Path -LiteralPath $candidate) { $localSrc = $candidate }
}
if ($Source -eq "auto") {
    if ($localSrc) { $Source = "local" } else { $Source = "github" }
}
if ($Source -eq "local" -and -not $localSrc) {
    Write-Host "==> 未找到本地 skills\ 目录，自动改用 github 源" -ForegroundColor Yellow
    $Source = "github"
}

if ($Source -eq "github") {
    Write-Host "==> 从 GitHub 拉取 $Repo@$Branch ..."
    $dl = Join-Path $tmpRoot "opc-skills.zip"
    $url = "https://github.com/$Repo/archive/refs/heads/$Branch.zip"
    Invoke-WebRequest -Uri $url -OutFile $dl -UseBasicParsing
    Expand-Archive -LiteralPath $dl -DestinationPath (Join-Path $tmpRoot "unz") -Force
    $src = Get-ChildItem (Join-Path $tmpRoot "unz") -Directory | Select-Object -First 1
    $src = Join-Path $src.FullName "skills"
    Write-Host "    解压完成: $src"
} else {
    $src = $localSrc
    Write-Host "==> 从本地包安装: $src"
}

# ---------- 安装（先备份，再覆盖；不静默删除） ----------
$stamp = Get-Date -Format "yyyyMMdd-HHmmss"
$installed = 0
$skipped = 0
$backedUp = @()

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
            if (-not $Force) {
                # 默认不覆盖：备份后跳过，避免把用户手改过的版本静默冲掉
                if (-not $NoBackup) {
                    $bak = "$to.backup-$stamp"
                    Copy-Item -LiteralPath $to -Destination $bak -Recurse -Force
                    $backedUp += $bak
                }
                Write-Host "  已存在，已备份并跳过 -> $to" -ForegroundColor Yellow
                Write-Host "     （如需覆盖请加 -Force）" -ForegroundColor DarkGray
                $skipped++
                continue
            }
            if (-not $NoBackup) {
                $bak = "$to.backup-$stamp"
                Copy-Item -LiteralPath $to -Destination $bak -Recurse -Force
                $backedUp += $bak
            }
            Remove-Item -LiteralPath $to -Recurse -Force
        }

        Copy-Item -LiteralPath $from -Destination $to -Recurse -Force
        Write-Host "  installed -> $to"
        $installed++
    }
}

Write-Host ""
Write-Host "OPC skills installed: $installed folders, skipped: $skipped, across $($targets.Count) location(s)."
if ($backedUp.Count -gt 0) {
    Write-Host "备份位置："
    $backedUp | ForEach-Object { Write-Host "  $_" }
}
Write-Host "Restart opencode / Claude Code / WorkBuddy / PI-Desktop to load them."
Write-Host ""

# ---------- 依赖说明（可选组件不随包分发） ----------
Write-Host ""
Write-Host "==> 可选依赖（不随本包分发，按需单独下载）"
Write-Host "    M7 路演 PPT 若选 dashi-ppt 方案："
Write-Host "      npx --registry=https://registry.npmmirror.com dashi-ppt-skill@latest"
Write-Host "      或 GitHub: https://github.com/chuspeeism/dashi-ppt-skill"
Write-Host "      需要 Node 20+ 与 Chrome/Edge（导出 PPTX/PDF 时）。"
Write-Host "      选 guizang-ppt 方案：https://github.com/op7418/guizang-ppt-skill"
Write-Host "    两个方案都下载失败时，M7 会自动回退到方案 A（内置 16:9 翻页模板，无需联网）。"
Write-Host ""

# ---------- 清理 ----------
Remove-Item -LiteralPath $tmpRoot -Recurse -Force -ErrorAction SilentlyContinue
Write-Host ""
Write-Host "完成！"
Write-Host ""
Write-Host "提示：每个技能模块都是自包含的（自带 references\ 与 scripts\），可单独安装使用。"
Write-Host "      若脚本或参考文件缺失，说明该模块被部分复制了，请重跑本脚本。"
