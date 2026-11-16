[CmdletBinding()]
param(
    [switch]$Status,
    [switch]$ToOrca,
    [switch]$FromOrca,
    [string]$OriginalDir = "C:\Users\USER\Desktop\Work\01_アプリ\ai-otazune",
    [string]$OrcaDir = "C:\Users\USER\orca\workspaces\ai-otazune\featherstar"
)

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

if (-not (Test-Path -LiteralPath $OriginalDir)) {
    Write-Error "Original directory not found: $OriginalDir"
}
if (-not (Test-Path -LiteralPath $OrcaDir)) {
    Write-Error "Orca worktree not found: $OrcaDir"
}

Write-Host "=== Agent Worktree Sync Tool ===" -ForegroundColor Cyan
Write-Host "Original: $OriginalDir"
Write-Host "Orca:     $OrcaDir"
Write-Host ""

$sharedFiles = @(
    "AGENTS.md",
    "CLAUDE.md",
    "CODEX.md",
    "GEMINI.md",
    "docs\handoff.md",
    "docs\antigravity-cli-setup.md",
    "docs\agent-workflow.md"
)

$sharedDirs = @(
    "docs\reviews",
    "docs\research",
    "media-prompts"
)

$codeFiles = @(
    "index.html",
    "firestore.rules",
    "manual.html"
)

function Show-Status {
    Write-Host "[1] Shared Docs & Rules Status" -ForegroundColor Yellow
    foreach ($f in $sharedFiles) {
        $origPath = Join-Path $OriginalDir $f
        $orcaPath = Join-Path $OrcaDir $f
        $origStat = if (Test-Path -LiteralPath $origPath) { "OK" } else { "--" }
        $orcaStat = if (Test-Path -LiteralPath $orcaPath) { "OK" } else { "--" }
        Write-Host " - $f : [Original: $origStat] [Orca: $orcaStat]"
    }

    Write-Host ""
    Write-Host "[2] Implementation Code Timestamp" -ForegroundColor Yellow
    foreach ($cf in $codeFiles) {
        $origPath = Join-Path $OriginalDir $cf
        $orcaPath = Join-Path $OrcaDir $cf
        if ((Test-Path -LiteralPath $origPath) -and (Test-Path -LiteralPath $orcaPath)) {
            $origTime = (Get-Item -LiteralPath $origPath).LastWriteTime
            $orcaTime = (Get-Item -LiteralPath $orcaPath).LastWriteTime
            $comp = if ($origTime -gt $orcaTime) { "Original is newer" } elseif ($origTime -lt $orcaTime) { "Orca is newer" } else { "Identical" }
            Write-Host " - $cf : Original=$origTime / Orca=$orcaTime ($comp)"
        }
    }
}

function Copy-ToOrca {
    Write-Host "[Sync] Original -> Orca (Docs, Rules, Reviews, Handoff)" -ForegroundColor Green
    foreach ($f in $sharedFiles) {
        $src = Join-Path $OriginalDir $f
        $dst = Join-Path $OrcaDir $f
        if (Test-Path -LiteralPath $src) {
            $parent = Split-Path -Parent $dst
            if (-not (Test-Path -LiteralPath $parent)) { New-Item -ItemType Directory -Path $parent -Force | Out-Null }
            Copy-Item -LiteralPath $src -Destination $dst -Force
            Write-Host " Copied: $f" -ForegroundColor Gray
        }
    }
    foreach ($d in $sharedDirs) {
        $srcDir = Join-Path $OriginalDir $d
        $dstDir = Join-Path $OrcaDir $d
        if (Test-Path -LiteralPath $srcDir) {
            if (-not (Test-Path -LiteralPath $dstDir)) { New-Item -ItemType Directory -Path $dstDir -Force | Out-Null }
            Copy-Item -LiteralPath "$srcDir\*" -Destination $dstDir -Recurse -Force
            Write-Host " Copied Dir: $d" -ForegroundColor Gray
        }
    }
    Write-Host "Done! Claude Code & Codex in Orca can now see the latest rules and reviews." -ForegroundColor Green
}

function Copy-FromOrca {
    Write-Host "[Sync] Orca -> Original (Code, Handoff)" -ForegroundColor Green
    foreach ($cf in $codeFiles) {
        $src = Join-Path $OrcaDir $cf
        $dst = Join-Path $OriginalDir $cf
        if (Test-Path -LiteralPath $src) {
            Copy-Item -LiteralPath $src -Destination $dst -Force
            Write-Host " Reflected: $cf" -ForegroundColor Gray
        }
    }
    $srcHandoff = Join-Path $OrcaDir "docs\handoff.md"
    $dstHandoff = Join-Path $OriginalDir "docs\handoff.md"
    if (Test-Path -LiteralPath $srcHandoff) {
        Copy-Item -LiteralPath $srcHandoff -Destination $dstHandoff -Force
        Write-Host " Reflected: docs\handoff.md" -ForegroundColor Gray
    }
    Write-Host "Done! Changes from Orca are now reflected in the original repository." -ForegroundColor Green
}

if ($ToOrca) {
    Copy-ToOrca
} elseif ($FromOrca) {
    Copy-FromOrca
} else {
    Show-Status
    Write-Host ""
    Write-Host "Usage: .\sync-worktree.ps1 -ToOrca   (Original -> Orca)" -ForegroundColor Cyan
    Write-Host "       .\sync-worktree.ps1 -FromOrca (Orca -> Original)" -ForegroundColor Cyan
}