# release.ps1 - 一键发布：同步生效副本 -> 包内 -> 打 zip -> 提交推送 -> 建 release
# ================================================================
# 用法：
#   powershell -NoProfile -ExecutionPolicy Bypass -File release.ps1 -Version v1.0
#
# 它做四件事：
#   1) 把生效副本目录下的 8 个模块同步回包内 skills\
#      —— 这是**唯一正确的同步方向**：生效副本是权威，仓库是它的镜像。
#   2) 打 zip（输出到仓库的**父目录**，不进 git）
#   3) git add / commit / push
#   4) gh release create
#
# 前置：本机已装 gh CLI 并登录（gh auth login）
# ================================================================
param(
    [Parameter(Mandatory = $true)]
    [ValidatePattern('^v\d')]
    [string]$Version
)
$ErrorActionPreference = "Stop"

$pkg     = $PSScriptRoot
$skillsDir = Join-Path $pkg "skills"
$liveDir   = Join-Path $HOME ".agents\skills"
$zipPath   = Join-Path (Split-Path -Parent $pkg) "opc-entrepreneurship-basics-zingy-$Version.zip"
$repo      = "yangzhe1952/opc-entrepreneurship-basics-zingy"

# ---------- 定位 gh（不再硬编码绝对路径） ----------
$gh = $null
$cmd = Get-Command gh -ErrorAction SilentlyContinue
if ($cmd) { $gh = $cmd.Source }
if (-not $gh) {
    foreach ($p in @(
        "$env:ProgramFiles\GitHub CLI\gh.exe",
        "${env:ProgramFiles(x86)}\GitHub CLI\gh.exe",
        "$env:LOCALAPPDATA\Programs\GitHub CLI\gh.exe"
    )) {
        if (Test-Path -LiteralPath $p) { $gh = $p; break }
    }
}
if (-not $gh) {
    throw "未找到 gh CLI。请先安装（winget install GitHub.cli）并执行 gh auth login。"
}
Write-Host "==> 使用 gh: $gh"

# ---------- 同步清单（必须与 install.ps1 的清单一致） ----------
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

if (-not (Test-Path -LiteralPath $liveDir)) {
    throw "未找到生效副本目录：$liveDir"
}

# ---------- 1) 同步生效副本 -> 包内 ----------
Write-Host "==> 同步 $liveDir -> $skillsDir"
foreach ($s in $skills) {
    $from = Join-Path $liveDir $s
    $to   = Join-Path $skillsDir $s
    if (-not (Test-Path -LiteralPath $from)) {
        Write-Warning "  生效副本缺少 $s，跳过"
        continue
    }
    if (Test-Path -LiteralPath $to) { Remove-Item -LiteralPath $to -Recurse -Force }
    Copy-Item -LiteralPath $from -Destination $to -Recurse -Force
    Write-Host "  synced -> $s"
}

# ---------- 2) 打 zip ----------
Write-Host "==> 打包 -> $zipPath"
if (Test-Path -LiteralPath $zipPath) { Remove-Item -LiteralPath $zipPath -Force }
Compress-Archive -Path $pkg -DestinationPath $zipPath -CompressionLevel Optimal
$sizeMB = [math]::Round((Get-Item -LiteralPath $zipPath).Length / 1MB, 2)
Write-Host "    包大小: $sizeMB MB"

# ---------- 3) git ----------
Write-Host "==> 提交并推送"
git -C $pkg add -A
git -C $pkg commit -m "release $Version" --allow-empty | Out-Null
git -C $pkg push

# ---------- 4) release ----------
Write-Host "==> 创建 GitHub Release $Version"
& $gh release create $Version $zipPath --repo $repo --title $Version --notes "OPC 创业基础课技能包 $Version"

Write-Host ""
Write-Host "完成：$Version"
Write-Host "注意：README 里的版本号请同步更新为 $Version。"
