# GTA 6 Clipper for Windows (GitHub Copilot Edition): one-command install.
# Paste into PowerShell (Start menu -> type "PowerShell" -> open it):
#   powershell -NoProfile -ExecutionPolicy Bypass -File .\install.ps1
# Copies both skills into your GitHub Copilot skills folder (%USERPROFILE%\.copilot\skills)
# as well as %USERPROFILE%\.claude\skills for compatibility, and runs setup.ps1. No admin needed.
$ErrorActionPreference = "Stop"
$ProgressPreference = "SilentlyContinue"
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

Write-Host "Installing GTA 6 Clipper for Windows (GitHub Copilot Edition)..."
$CopilotSkills = Join-Path $env:USERPROFILE ".copilot\skills"
$ClaudeSkills  = Join-Path $env:USERPROFILE ".claude\skills"
$LocalRepo     = if ($PSScriptRoot -and (Test-Path (Join-Path $PSScriptRoot "skills\gta6-clipper"))) { $PSScriptRoot } else { $null }
$Src           = if ($env:GTA6_INSTALL_SRC) { $env:GTA6_INSTALL_SRC } elseif ($LocalRepo) { $LocalRepo } else { $null }

if (-not $Src) {
  $Zip = Join-Path $env:TEMP "gta6-clipper-windows.zip"
  $Tmp = Join-Path $env:TEMP "gta6-clipper-windows"
  Invoke-WebRequest -UseBasicParsing -Uri "https://github.com/vossashtonai/gta6-clipper-windows/archive/refs/heads/main.zip" -OutFile $Zip
  Remove-Item -Recurse -Force $Tmp -ErrorAction SilentlyContinue
  Expand-Archive -Path $Zip -DestinationPath $Tmp -Force
  $Src = (Get-ChildItem $Tmp -Directory | Select-Object -First 1).FullName
  Remove-Item -Force $Zip -ErrorAction SilentlyContinue
}

foreach ($TargetRoot in @($CopilotSkills, $ClaudeSkills)) {
  New-Item -ItemType Directory -Force -Path $TargetRoot | Out-Null
  foreach ($name in @("gta6-clipper", "gta6-live-clipper")) {
    $dst = Join-Path $TargetRoot $name
    New-Item -ItemType Directory -Force -Path $dst | Out-Null
    Copy-Item -Recurse -Force (Join-Path $Src "skills\$name\*") $dst
    Write-Host "  [ok]      skill $name -> $dst"
  }
}

$SetupScript = if ($LocalRepo) {
  Join-Path $LocalRepo "skills\gta6-clipper\scripts\setup.ps1"
} else {
  Join-Path $CopilotSkills "gta6-clipper\scripts\setup.ps1"
}

$ErrorActionPreference = "Continue"
& powershell.exe -NoProfile -ExecutionPolicy Bypass -File $SetupScript
if ($LASTEXITCODE -eq 0) {
  # If we ran setup in the repo, also copy config.json and .ready to the global skill folders
  if ($LocalRepo) {
    foreach ($TargetRoot in @($CopilotSkills, $ClaudeSkills)) {
      foreach ($f in @("config.json", ".ready")) {
        $sf = Join-Path $LocalRepo "skills\gta6-clipper\$f"
        if (Test-Path $sf) { Copy-Item -Force $sf (Join-Path $TargetRoot "gta6-clipper\$f") }
      }
    }
  }
  Write-Host ""
  Write-Host "Done! Open VS Code (GitHub Copilot Chat) or GitHub Copilot CLI and say:"
  Write-Host "  clip this stream <link>"
  Write-Host "  find me today's biggest GTA 6 streams and clip them"
  Write-Host "  live clip <link>"
} else {
  Write-Host ""
  Write-Host "Setup didn't finish. Copy the output above and paste it into GitHub Copilot Chat so it can fix it for you."
}
