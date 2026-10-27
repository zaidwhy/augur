# AUGUR - era-diagnostic probe runner
#
# Runs a fixed probe battery against a local Ollama model and writes verbatim output
# as markdown. Deterministic: temperature 0, fixed seed, one model loaded at a time.
#
# Usage: .\run_probes.ps1 -Model typewriter-1938-chat -OutFile probes-1938.md

param(
    [Parameter(Mandatory = $true)][string]$Model,
    [Parameter(Mandatory = $true)][string]$OutFile,
    [int]$Seed = 1938,
    # Anchor year for the mitigation test: each model is anchored to its own cutoff.
    # Default 1938 (TypeWriter); pass -AnchorYear 1930 for Talkie-1930.
    [int]$AnchorYear = 1938,
    # The committed probes-*.md are the unedited evidence behind the Zenodo deposit.
    [switch]$Force
)

if ((Test-Path -LiteralPath $OutFile) -and -not $Force) {
    Write-Error "$OutFile already exists; refusing to overwrite a transcript. Pick a new -OutFile, or pass -Force to replace it."
    exit 2
}

# 127.0.0.1 not "localhost": localhost resolves IPv6 first on this machine and hangs to timeout.
$Endpoint = "http://127.0.0.1:11434/api/chat"

# Probes are grouped by what they test. Era-diagnostics carry the load: each has an
# unambiguous correct answer that differs sharply by decade, so a wrong answer localises
# the model in time rather than just marking it wrong.
$probes = @(
    @{ group = "self-report";    q = "What year is it?" },
    @{ group = "era-diagnostic"; q = "Who is the King of England?" },
    @{ group = "era-diagnostic"; q = "Who is the Chancellor of Germany?" },
    @{ group = "era-diagnostic"; q = "Who is the President of the United States?" },
    @{ group = "era-diagnostic"; q = "What is the most recent war?" },
    @{ group = "era-diagnostic"; q = "What is the fastest way to cross the Atlantic?" },
    @{ group = "leak-test";      q = "What is an atomic bomb?" },
    @{ group = "leak-test";      q = "What is television?" },
    @{ group = "period-meaning"; q = "What is a computer?" },
    @{ group = "payload";        q = "Will there be another great war in Europe?" },
    @{ group = "payload";        q = "What are the greatest dangers facing Europe in the coming ten years?" }
)

function Invoke-Probe {
    param([string]$Question, [string]$System)

    $messages = @()
    if ($System) { $messages += @{ role = "system"; content = $System } }
    $messages += @{ role = "user"; content = $Question }

    $body = @{
        model    = $Model
        messages = $messages
        stream   = $false
        options  = @{ temperature = 0; seed = $Seed }
    } | ConvertTo-Json -Depth 6

    try {
        $r = Invoke-RestMethod -Uri $Endpoint -Method Post -Body $body -ContentType "application/json" -TimeoutSec 900
        return $r.message.content.Trim()
    }
    catch {
        return "[PROBE FAILED: $($_.Exception.Message)]"
    }
}

$lines = @()
$lines += "# Probe run: $Model"
$lines += ""
$lines += "Run $(Get-Date -Format 'yyyy-MM-dd HH:mm'). temperature 0, seed $Seed. Output verbatim."
$lines += ""

$sw = [System.Diagnostics.Stopwatch]::StartNew()

foreach ($p in $probes) {
    Write-Host "[$($p.group)] $($p.q)"
    $a = Invoke-Probe -Question $p.q
    $lines += "## [$($p.group)] $($p.q)"
    $lines += ""
    $lines += "> " + ($a -split "`n" -join "`n> ")
    $lines += ""
}

# The mitigation test: does stating the year relocate the model, or is later knowledge
# genuinely absent from the weights? Only meaningful on the era-diagnostics.
$lines += "## Mitigation test: does a system prompt relocate the model?"
$lines += ""
$sys = "The year is $AnchorYear. Answer as a well-informed person writing in $AnchorYear."
foreach ($q in @("What year is it?", "Who is the King of England?", "Who is the President of the United States?")) {
    Write-Host "[mitigation] $q"
    $a = Invoke-Probe -Question $q -System $sys
    $lines += "### $q"
    $lines += ""
    $lines += "> " + ($a -split "`n" -join "`n> ")
    $lines += ""
}

$sw.Stop()
$lines += "---"
$lines += ""
$lines += "Total run time: $([math]::Round($sw.Elapsed.TotalMinutes, 1)) min."

$lines -join "`n" | Out-File -FilePath $OutFile -Encoding utf8
Write-Host "`nWrote $OutFile"

# A failed probe is kept in the transcript for inspection, but the run is not a result.
$failed = @($lines | Where-Object { $_ -like "> ``[PROBE FAILED:*" }).Count
if ($failed -gt 0) {
    Write-Error "$failed probe(s) failed (is Ollama running with model ${Model}?); $OutFile is not a valid run."
    exit 1
}
