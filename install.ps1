# Before the AI Project: installer / updater (Windows PowerShell 5.1+ and PowerShell 7+)
# Usage:
#   irm https://raw.githubusercontent.com/TapasDas1982/before_the_Ai_Project/main/install.ps1 | iex
#   .\install.ps1 [-Target C:\path\to\project] [-Branch main]
# Env (useful with irm | iex, which cannot pass arguments):
#   BTAP_TARGET  target directory (default: current directory)
#   BTAP_BRANCH  branch or tag to install (default: main)
#   BTAP_SOURCE  use a local copy of this repo instead of downloading

function Install-BeforeAiProject {
    [CmdletBinding()]
    param(
        [string]$Target = $(if ($env:BTAP_TARGET) { $env:BTAP_TARGET } else { (Get-Location).Path }),
        [string]$Branch = $(if ($env:BTAP_BRANCH) { $env:BTAP_BRANCH } else { 'main' }),
        [string]$Source = $env:BTAP_SOURCE,
        [string]$ScriptRoot
    )

    $ErrorActionPreference = 'Stop'
    $RepoSlug  = 'TapasDas1982/before_the_Ai_Project'
    $StartMark = '<!-- BEFORE-AI:START (managed by the Before the AI Project installer; edits inside this block are overwritten on update) -->'
    $EndMark   = '<!-- BEFORE-AI:END -->'
    $Utf8      = New-Object System.Text.UTF8Encoding $false

    function Say([string]$msg) { Write-Host "  $msg" }
    function Rel([string]$p) { $p.Substring($Target.Length).TrimStart('\', '/') -replace '\\', '/' }
    function Read-Text([string]$p) { [System.IO.File]::ReadAllText($p) -replace "`r`n", "`n" }
    function Write-Text([string]$p, [string]$text) {
        $dir = Split-Path -Parent $p
        if (-not (Test-Path $dir)) { New-Item -ItemType Directory -Force -Path $dir | Out-Null }
        [System.IO.File]::WriteAllText($p, $text, $Utf8)
    }

    if (-not (Test-Path -PathType Container $Target)) { throw "Target directory '$Target' does not exist." }
    $Target = (Resolve-Path $Target).Path.TrimEnd('\', '/')

    # ---- locate source -------------------------------------------------------
    $tmp = $null
    try {
        if (-not $Source -and $ScriptRoot -and (Test-Path (Join-Path $ScriptRoot 'rules/00-core.md'))) {
            $Source = $ScriptRoot
        }
        if (-not $Source) {
            Write-Host "Downloading rule pack ($RepoSlug@$Branch)..."
            [Net.ServicePointManager]::SecurityProtocol = [Net.ServicePointManager]::SecurityProtocol -bor [Net.SecurityProtocolType]::Tls12
            $tmp = Join-Path ([System.IO.Path]::GetTempPath()) ("btap-" + [guid]::NewGuid().ToString('N'))
            New-Item -ItemType Directory -Path $tmp | Out-Null
            $zip = Join-Path $tmp 'src.zip'
            Invoke-WebRequest -UseBasicParsing -Uri "https://codeload.github.com/$RepoSlug/zip/$Branch" -OutFile $zip
            Expand-Archive -Path $zip -DestinationPath $tmp -Force
            $Source = (Get-ChildItem -Path $tmp -Directory | Select-Object -First 1).FullName
        }
        if (-not (Test-Path (Join-Path $Source 'rules/00-core.md'))) { throw "'$Source' does not look like the rule pack." }
        $Source = (Resolve-Path $Source).Path.TrimEnd('\', '/')
        if ($Source -eq $Target) { throw "Target is the rule pack repo itself; run this inside your project." }

        $versionFile = Join-Path $Source 'VERSION'
        $Version = if (Test-Path $versionFile) { (Read-Text $versionFile).Trim() } else { 'unknown' }
        Write-Host "Installing Before the AI Project v$Version into $Target"

        $tpl = Join-Path $Source 'templates'

        function Set-ManagedBlock([string]$file, [string]$blockFile, [string]$header) {
            $block = "$StartMark`n" + (Read-Text $blockFile).TrimEnd("`n") + "`n$EndMark`n"
            if (-not (Test-Path $file)) {
                $text = if ($header) { "$header`n`n$block" } else { $block }
                Write-Text $file $text
                Say "created  $(Rel $file)"
            } else {
                $existing = Read-Text $file
                $pattern = '(?s)<!-- BEFORE-AI:START.*?<!-- BEFORE-AI:END -->\n?'
                if ([regex]::IsMatch($existing, $pattern)) {
                    $evaluator = [System.Text.RegularExpressions.MatchEvaluator] { param($m) $block }
                    Write-Text $file ([regex]::Replace($existing, $pattern, $evaluator, 'None'))
                    Say "updated  $(Rel $file) (managed block)"
                } else {
                    Write-Text $file ($existing.TrimEnd("`n") + "`n`n" + $block)
                    Say "appended $(Rel $file) (your content kept, block added at end)"
                }
            }
        }

        # ---- upstream-owned files (replaced on every run) ---------------------
        $aiDir = Join-Path $Target '.ai-rules'
        $rulesDst = Join-Path $aiDir 'rules'
        New-Item -ItemType Directory -Force -Path $aiDir | Out-Null
        if (Test-Path $rulesDst) { Remove-Item -Recurse -Force $rulesDst }
        Copy-Item -Recurse (Join-Path $Source 'rules') $rulesDst
        Write-Text (Join-Path $aiDir 'VERSION') "$Version`n"
        Say "synced   .ai-rules/rules/ ($((Get-ChildItem $rulesDst -File).Count) files)"

        $cursorDst = Join-Path $Target '.cursor/rules/before-ai.mdc'
        Write-Text $cursorDst (Read-Text (Join-Path $tpl 'cursor-rule.mdc'))
        Say "synced   .cursor/rules/before-ai.mdc"

        # ---- user-owned files (created once, never overwritten) ---------------
        Get-ChildItem (Join-Path $tpl 'project') -Filter *.md | ForEach-Object {
            $dst = Join-Path $aiDir ("project/" + $_.Name)
            if (Test-Path $dst) { Say "kept     $(Rel $dst) (yours)" }
            else { Write-Text $dst (Read-Text $_.FullName); Say "created  $(Rel $dst)" }
        }

        # ---- agent entry points (managed block only) ---------------------------
        Set-ManagedBlock (Join-Path $Target 'AGENTS.md') (Join-Path $tpl 'agents-block.md') '# AGENTS.md'
        Set-ManagedBlock (Join-Path $Target 'CLAUDE.md') (Join-Path $tpl 'claude-block.md') '# CLAUDE.md'
        Set-ManagedBlock (Join-Path $Target '.github/copilot-instructions.md') (Join-Path $tpl 'copilot-block.md') ''

        Write-Host ""
        Write-Host "Done. Next steps:"
        Write-Host "  1. Fill in .ai-rules/project/PROJECT_MAP.md"
        Write-Host "  2. Record your models/SDKs in .ai-rules/project/FRESHNESS.md (with verified dates)"
        Write-Host "  3. Write 10-20 golden cases in .ai-rules/project/EVALS.md"
        Write-Host "  Update anytime by re-running the installer."
    }
    finally {
        if ($tmp -and (Test-Path $tmp)) { Remove-Item -Recurse -Force $tmp }
    }
}

Install-BeforeAiProject @args -ScriptRoot $PSScriptRoot
