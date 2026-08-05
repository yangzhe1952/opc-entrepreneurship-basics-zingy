# release.ps1 - one-command OPC skill pack release
# Usage: powershell -NoProfile -ExecutionPolicy Bypass -File release.ps1 -Version v0.6 [-Notes "..."]
param(
    [Parameter(Mandatory=$true)][string]$Version,
    [string]$Notes = ""
)
$ErrorActionPreference = "Stop"
$gh = "C:\Program Files\GitHub CLI\gh.exe"
$pkg = $PSScriptRoot
$zip = Join-Path (Split-Path $pkg -Parent) "opc-entrepreneurship-basics-zingy.zip"
$repo = "yangzhe1952/opc-entrepreneurship-basics-zingy"
$skills = @(
    "opc-m1-track-analysis", "opc-m2-track-profile", "opc-m3-solution-design",
    "opc-m4-requirements", "opc-m5-ai-testing", "opc-m6-iteration",
    "opc-m7-pitch", "opc-m8-assets"
)
if ($Version -notmatch '^v\d') { throw "Version must start with 'v', e.g. v0.6" }
if (-not (Test-Path -LiteralPath $gh)) { throw "gh not found at $gh" }

# 1) sync local installed skills (where you edit/test) into package source
$srcRoot = Join-Path $HOME ".agents\skills"
if (Test-Path -LiteralPath $srcRoot) {
    Write-Host "[1/4] syncing from $srcRoot ..."
    foreach ($s in $skills) {
        $from = Join-Path $srcRoot $s
        $to = Join-Path $pkg "skills\$s"
        if (Test-Path -LiteralPath $from) {
            if (Test-Path -LiteralPath $to) { Remove-Item -LiteralPath $to -Recurse -Force }
            Copy-Item -LiteralPath $from -Destination $to -Recurse -Force
            Write-Host "  synced $s"
        }
    }
} else {
    Write-Host "[1/4] skip sync (no ~/.agents/skills), using package files as-is"
}

# 2) rebuild zip
Write-Host "[2/4] building zip ..."
if (Test-Path -LiteralPath $zip) { Remove-Item -LiteralPath $zip -Force }
Compress-Archive -Path $pkg -DestinationPath $zip -Force
Write-Host "  zip: $zip ($([int]((Get-Item $zip).Length/1KB)) KB)"

# 3) git commit + push
Write-Host "[3/4] git commit + push ..."
Push-Location $pkg
git add -A
git commit -m "release $Version" --allow-empty
git push
Pop-Location

# 4) create release with zip asset
Write-Host "[4/4] creating GitHub release $Version ..."
$notes = if ($Notes) { $Notes } else { "OPC 创业基础课 8 个 Skill 安装包 $Version" }
& $gh release create $Version -R $repo --title $Version --notes $notes $zip
Write-Host ""
Write-Host "DONE: https://github.com/$repo/releases/tag/$Version"
