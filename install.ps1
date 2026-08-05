# install.ps1 - OPC Entrepreneurship Basics skill pack installer
# Usage: powershell -NoProfile -ExecutionPolicy Bypass -File install.ps1 [-Target auto|agents|claude]
param(
    [ValidateSet("auto", "agents", "claude")]
    [string]$Target = "auto"
)
$ErrorActionPreference = "Stop"
$src = Join-Path $PSScriptRoot "skills"
$skills = @(
    "opc-m1-track-analysis",
    "opc-m2-track-profile",
    "opc-m3-solution-design",
    "opc-m4-requirements",
    "opc-m5-ai-testing",
    "opc-m6-iteration",
    "opc-m7-pitch",
    "opc-m8-assets"
)

$targets = @()
if ($Target -eq "auto") {
    $targets = @((Join-Path $HOME ".agents\skills"), (Join-Path $HOME ".claude\skills"))
} elseif ($Target -eq "agents") {
    $targets = @((Join-Path $HOME ".agents\skills"))
} else {
    $targets = @((Join-Path $HOME ".claude\skills"))
}

$installed = 0
foreach ($t in $targets) {
    if (-not (Test-Path -LiteralPath $t)) {
        New-Item -ItemType Directory -Path $t -Force | Out-Null
    }
    foreach ($s in $skills) {
        $from = Join-Path $src $s
        $to = Join-Path $t $s
        if (-not (Test-Path -LiteralPath $from)) {
            Write-Warning "missing: $from"
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
Write-Host "Restart opencode / Claude Code to load them."
