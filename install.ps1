# ─────────────────────────────────────────────────────────────────────────────
# Growther.si C5 installer (Windows)  ·  irm https://growther.si/install.ps1 | iex
#
# Downloads the self-contained V8-bytecode binary for this arch from GitHub
# Releases, verifies SHA-256, installs it on PATH, and seeds %USERPROFILE%\.growther
# with the signed build manifest (verified at runtime).
#
# Env overrides: GROWTHER_VERSION, GROWTHER_INSTALL_DIR, GROWTHER_HOME,
#                GROWTHER_RELEASE_BASE, GROWTHER_NO_MODIFY_PATH=1
#
# Enterprise install profile (Intune Win32 in user context, SCCM, a signed MSI's
# custom action). Every flag has a GROWTHER_* equivalent so a deployment tool
# that can only set environment variables reaches the same behaviour, and an
# invocation that passes none of them behaves exactly as it always did. Both
# spellings are accepted (-ManagedInstall and --managed-install) so one Intune
# command line can be kept in step with install.sh:
#
#   -PolicyExpected   GROWTHER_POLICY_EXPECTED=1
#       Write %USERPROFILE%\.growther\policy-expected. Its presence tells C5
#       policy is coming: the anonymous first-user bootstrap is off (nobody who
#       opens the tab first becomes admin), missing policy is reported rather
#       than assumed, and doctor says "managed install".
#   -ManagedInstall   GROWTHER_MANAGED_INSTALL=1
#       Write a `managed-install` marker beside growther.exe. C5 then never
#       copies itself elsewhere and `growther update` reports the available
#       version but REFUSES the swap, naming whoever owns the install — which is
#       what keeps the on-disk version equal to the version Intune believes it
#       shipped.
#   -ManagedBy <label>  GROWTHER_MANAGED_BY
#       Who that refusal names. Defaults to this script; the MSI passes its own
#       label so an operator is sent to the right place.
#   -NoActivate       GROWTHER_NO_ACTIVATE=1
#       Set GROWTHER_NO_AUTO_ACTIVATE=1 in the config C5 loads at every launch,
#       so first run does not open a browser to activate.
#   -InstallService   GROWTHER_INSTALL_SERVICE=1
#   -Home <dir>       (this run's home; GROWTHER_HOME)
#   -DataDir <dir>    GROWTHER_DATA_DIR
#       Recorded in the device pointer %USERPROFILE%\.growther\home.json, the
#       one file every launch reads to find them (the scheduled task carries no
#       home path). GROWTHER_HOME alone keeps its old meaning; the pointer is
#       written only when -Home or -DataDir asks for it, so an unattended re-run
#       cannot silently repoint a machine whose data is elsewhere.
#   -ProfileOnly      GROWTHER_PROFILE_ONLY=1
#       The binary is ALREADY on disk — the signed MSI (packaging/msi) placed it
#       — so skip the download, the checksum, the extract and the PATH edit and
#       apply only the options above to GROWTHER_INSTALL_DIR. This is the flag
#       that keeps the MSI free of configuration logic: it lays down a signed
#       payload and then runs THIS script, so there is exactly one implementation
#       of what -ManagedInstall or -DataDir mean. Not for interactive use.
# ─────────────────────────────────────────────────────────────────────────────
#Requires -Version 5
$ErrorActionPreference = "Stop"

# ── Exit codes ──────────────────────────────────────────────────────────────
# 0  applied
# 1  FAILED — something this script tried to do did not work
# 2  bad usage (an unknown option, a flag with no value)
# 3  REFUSED — the request is well formed but this CONTEXT cannot carry it out
#    (running as a machine account, a payload that is not there, a value that
#    reached us mangled). The distinction matters to the MSI: a refusal is a
#    deployment mistake an operator has to correct, a failure is ours. It is
#    reported through Return="check" either way, so the deployment tool sees a
#    non-zero exit and the product stays installed — packaging/msi/README.md
#    says what to do next.
function Deny([string]$message) {
  [Console]::Error.WriteLine("growther install: REFUSED — $message")
  exit 3
}
# ⚠️ NOT Write-Error. $ErrorActionPreference is "Stop", which makes Write-Error
# a TERMINATING error: the `exit 2` written after one never runs, and the
# script leaves with 1 — a bad option reported as a failure of ours, which is
# the one distinction the exit codes above exist to make.
function Stop-GrowtherUsage([string]$message) {
  [Console]::Error.WriteLine("growther install: $message")
  exit 2
}
# A directory value may arrive with a trailing separator: [INSTALLFOLDER] from
# Windows Installer ALWAYS has one, and a path pasted out of Explorer usually
# does. Normalising here — once, in the script every package calls — is what
# keeps "$dir\growther.exe" from becoming "...\C5\\growther.exe" and what keeps
# a trailing slash out of the persistent device pointer. A drive root keeps its
# separator, because "D:" without one means "the current directory on D:".
function Format-GrowtherDir([string]$value) {
  if (-not $value) { return $value }
  if ($value -match '^[A-Za-z]:[\\/]$') { return $value }
  $trimmed = $value.TrimEnd('\', '/')
  if (-not $trimmed) { return $value }
  return $trimmed
}
# A quote cannot appear in a Windows path and has no business in a label. When
# one shows up in a value it did not come from the administrator: it is what a
# command line looks like after a backslash immediately before a closing quote
# ate the quote (`-Home "D:\Data\"`), which swallows every following flag into
# this one value. Refusing by NAME beats the "Illegal characters in path" this
# would otherwise become three hundred lines later.
function Assert-GrowtherValue([string]$flag, [string]$value) {
  if ($value -and $value.Contains('"')) {
    Deny "the value passed to $flag contains a quote character, so it reached this script mangled: $value`nA value ending in a backslash escapes the closing quote of a Windows command line. Drop the trailing separator, or pass the value through the GROWTHER_* environment variable instead."
  }
}

# ── Enterprise profile flags ────────────────────────────────────────────────
# Parsed FIRST, from $args rather than a param() block: this script is normally
# run as `irm … | iex`, where a param() block can never be bound, and an unknown
# flag must fail before the network is touched rather than after a binary lands.
$PolicyExpected = ($env:GROWTHER_POLICY_EXPECTED -eq "1")
$ManagedInstall = ($env:GROWTHER_MANAGED_INSTALL -eq "1")
$NoActivate     = ($env:GROWTHER_NO_ACTIVATE -eq "1")
$InstallService = ($env:GROWTHER_INSTALL_SERVICE -eq "1")
$HomeFlag       = ""
$DataDir        = if ($env:GROWTHER_DATA_DIR) { $env:GROWTHER_DATA_DIR } else { "" }
$ManagedBy      = if ($env:GROWTHER_MANAGED_BY) { $env:GROWTHER_MANAGED_BY } else { "" }
$ProfileOnly    = ($env:GROWTHER_PROFILE_ONLY -eq "1")
function Show-GrowtherUsage {
  Write-Host @'
Growther.si C5 installer (Windows)

  .\install.ps1 [options]

Options (each has a GROWTHER_* environment equivalent):
  -PolicyExpected    mark this install as centrally managed (policy is coming)
  -ManagedInstall    an MSI/MDM owns the binary: no self-install, check-only updates
  -ManagedBy <label> who to name as that owner (default: this script)
  -NoActivate        do not open a browser to activate on first run
  -InstallService    register auto-start (Task Scheduler, per user)
  -Home <dir>        where C5's home lives (recorded in %USERPROFILE%\.growther\home.json)
  -DataDir <dir>     where the databases live (recorded in the same pointer)
  -ProfileOnly       the binary is already installed (the signed MSI placed it):
                     apply only the options above, download nothing
  -Help              this text

Exit codes: 0 applied · 1 failed · 2 bad usage · 3 REFUSED (the request is fine
but this context cannot carry it out - wrong account, no payload, a value that
arrived mangled). A deployment tool should treat 3 as "correct the deployment".

Environment: GROWTHER_VERSION, GROWTHER_INSTALL_DIR, GROWTHER_HOME,
GROWTHER_DATA_DIR, GROWTHER_RELEASE_BASE, GROWTHER_NO_MODIFY_PATH,
GROWTHER_POLICY_EXPECTED, GROWTHER_MANAGED_INSTALL, GROWTHER_MANAGED_BY,
GROWTHER_NO_ACTIVATE, GROWTHER_INSTALL_SERVICE, GROWTHER_PROFILE_ONLY.
See https://docs.growther.si/c5/getting-started/installation
'@
}
for ($i = 0; $i -lt $args.Count; $i++) {
  $a = [string]$args[$i]
  $value = $null
  if ($a -match '^(--?[A-Za-z-]+)=(.*)$') { $value = $Matches[2]; $a = $Matches[1] }
  switch -Regex ($a) {
    '^(--policy-expected|-PolicyExpected)$' { $PolicyExpected = $true }
    '^(--managed-install|-ManagedInstall)$' { $ManagedInstall = $true }
    '^(--managed-by|-ManagedBy)$' {
      if ($null -eq $value) { $i++; if ($i -ge $args.Count) { Stop-GrowtherUsage "-ManagedBy needs a value" }; $value = [string]$args[$i] }
      $ManagedBy = $value
    }
    '^(--no-activate|-NoActivate)$'         { $NoActivate = $true }
    '^(--install-service|-InstallService)$' { $InstallService = $true }
    '^(--profile-only|-ProfileOnly)$'       { $ProfileOnly = $true }
    '^(--home|-Home)$' {
      if ($null -eq $value) { $i++; if ($i -ge $args.Count) { Stop-GrowtherUsage "-Home needs a value" }; $value = [string]$args[$i] }
      $HomeFlag = $value
    }
    '^(--data-dir|-DataDir)$' {
      if ($null -eq $value) { $i++; if ($i -ge $args.Count) { Stop-GrowtherUsage "-DataDir needs a value" }; $value = [string]$args[$i] }
      $DataDir = $value
    }
    '^(--help|-Help|-h|/\?)$' { Show-GrowtherUsage; exit 0 }
    default { Stop-GrowtherUsage "unknown option: $a (try -Help)" }
  }
}

Assert-GrowtherValue "-Home" $HomeFlag
Assert-GrowtherValue "-DataDir" $DataDir
Assert-GrowtherValue "-ManagedBy" $ManagedBy

$Version      = if ($env:GROWTHER_VERSION)      { $env:GROWTHER_VERSION }      else { "latest" }
$InstallDirRaw = if ($env:GROWTHER_INSTALL_DIR) { $env:GROWTHER_INSTALL_DIR } else { "$env:LOCALAPPDATA\Growther\bin" }
$InstallDir   = Format-GrowtherDir $InstallDirRaw
$HomeFlag     = Format-GrowtherDir $HomeFlag
$DataDir      = Format-GrowtherDir $DataDir
# %USERPROFILE% is the anchor for every per-user path below. Empty, the two
# expressions that follow collapse to "\.growther" — the ROOT OF THE CURRENT
# DRIVE, which for a custom action running out of Program Files is C:\.growther
# — and the install would go on to create it and report success. Nothing can be
# right after that, so say so here.
if (-not $env:USERPROFILE -and -not $HomeFlag -and -not $env:GROWTHER_HOME) {
  Deny "USERPROFILE is not set, so there is no per-user home to install into (the default would collapse to the root of the current drive). Run this as a real user, or pass -Home."
}
$GrowtherHome = if ($HomeFlag) { $HomeFlag } elseif ($env:GROWTHER_HOME) { Format-GrowtherDir $env:GROWTHER_HOME } else { "$env:USERPROFILE\.growther" }
# The pointer and the policy-expected marker live in the DEFAULT home even when
# the home moves: it is the one location every launch finds without being told.
$DefaultHome  = "$env:USERPROFILE\.growther"
# THIS FILE IS CANONICAL. growther.si serves it and GrowtherSI/release publishes
# it — both are mirrors checked against this copy by hash. It used to exist as
# three divergent variants (this repo, the release repo, growther.si's fork);
# only the fork had the signed-release pin. One file now carries everything.
#
# Public distribution is the raw GrowtherSI/release mirror (dist/c5/<tag>/<asset>),
# NOT the private source repo's GitHub Releases (not anonymously downloadable).
$DefaultReleaseBase = "https://raw.githubusercontent.com/GrowtherSI/release/main/dist/c5"
$ReleaseBase  = $DefaultReleaseBase
# A custom mirror supplies BOTH the binary and its checksum, so it is the whole
# trust root. Require an explicit second opt-in rather than letting one env var
# silently repoint an `irm | iex`.
if ($env:GROWTHER_RELEASE_BASE -and $env:GROWTHER_RELEASE_BASE -ne $DefaultReleaseBase) {
  if ($env:GROWTHER_ALLOW_CUSTOM_MIRROR -eq "1") {
    $ReleaseBase = $env:GROWTHER_RELEASE_BASE
  } else {
    [Console]::Error.WriteLine("growther install: refusing GROWTHER_RELEASE_BASE=$($env:GROWTHER_RELEASE_BASE) — a custom mirror supplies both the binary and its checksum; re-run with GROWTHER_ALLOW_CUSTOM_MIRROR=1 if you trust it")
    exit 1
  }
}

# >>> GROWTHER_PINNED_RELEASE >>>
# Replaced at serve time by growther.si with hashes from an Ed25519-VERIFIED
# release manifest. Left as-is, this file is UNPINNED and says so before installing.
$GrowtherPinnedVersion = ""
$GrowtherPinnedAssets = ""
# <<< GROWTHER_PINNED_RELEASE <<<

# ── Resolve what to download (skipped by -ProfileOnly) ─────────────────────
# -ProfileOnly means the signed MSI has ALREADY placed growther.exe: there is
# no arch to detect, no catalog to fetch and no URL to build. Everything below
# the download block still runs, so the enterprise profile the MSI applies is
# written by exactly the same code an `irm | iex` runs.
if (-not $ProfileOnly) {
  # Arch detection (handles ARM64 under x64 emulation).
  $arch = if ($env:PROCESSOR_ARCHITECTURE -eq "ARM64" -or $env:PROCESSOR_ARCHITEW6432 -eq "ARM64") { "arm64" } else { "x64" }
  # growther-c5-win-<arch>-<runtime>: the executable's name, then the Node
  # runtime it embeds. A pinned installer takes the exact name from the SIGNED
  # manifest instead.
  $assetCandidates = @("growther-c5-win-$arch-node24.zip")
  if ($GrowtherPinnedAssets) {
    foreach ($line in ($GrowtherPinnedAssets -split "`n")) {
      $parts = $line.Trim() -split '\s+'
      if ($parts.Length -ge 3 -and $parts[0] -eq "win-$arch") { $assetCandidates = @($parts[1]); break }
    }
  }
  $asset = $assetCandidates[0]
  # Resolve the release tag (raw layout: <base>/<tag>/<asset>). 'latest' reads the
  # catalog's .stable.version; an explicit version is normalized to a v-prefixed tag.
  if ($Version -eq "latest") {
    # raw.githubusercontent.com serves releases.json as text/plain, which
    # Invoke-RestMethod does NOT auto-deserialize — parse the string ourselves.
    $cat = Invoke-RestMethod -Uri "$ReleaseBase/releases.json" -UseBasicParsing
    if ($cat -is [string]) { $cat = $cat | ConvertFrom-Json }
    $ver = $cat.stable.version
    if (-not $ver) { throw "could not read .stable.version from $ReleaseBase/releases.json" }
    $tag = "v" + ($ver -replace '^v','')
  } else {
    $tag = "v" + ($Version -replace '^v','')
  }
  Write-Host "➜ target: win-$arch · version: $Version"
}

# No scratch directory in -ProfileOnly: nothing is downloaded, so creating one
# would leave an empty folder in %TEMP% for every managed re-deploy.
$tmp = if ($ProfileOnly) { $null } else { New-Item -ItemType Directory -Path (Join-Path $env:TEMP ("growther-" + [guid]::NewGuid())) }
try {
  # ── Download, verify and place the binary (skipped by -ProfileOnly) ───────
  if (-not $ProfileOnly) {
    $got = $false
    foreach ($candidate in $assetCandidates) {
      $asset = $candidate
      $url = "$ReleaseBase/$tag/$asset"
      Write-Host "➜ downloading $asset"
      try {
        Invoke-WebRequest -Uri $url -OutFile "$tmp\$asset" -UseBasicParsing
        if ((Test-Path "$tmp\$asset") -and (Get-Item "$tmp\$asset").Length -gt 0) { $got = $true; break }
      } catch {
        Remove-Item "$tmp\$asset" -Force -ErrorAction SilentlyContinue
      }
    }
    if (-not $got) { throw "download failed: $ReleaseBase/$tag/ (tried: $($assetCandidates -join ', '))" }

    # Fetch the checksum separately so a genuine MISMATCH hard-fails (only a missing
    # sidecar is tolerated, and only with the explicit opt-out).
    $haveChecksum = $false
    try {
      Invoke-WebRequest -Uri "$url.sha256" -OutFile "$tmp\$asset.sha256" -UseBasicParsing
      $haveChecksum = Test-Path "$tmp\$asset.sha256"
    } catch { $haveChecksum = $false }

    # The PINNED hash wins when present: it came from a signature-verified manifest,
    # whereas the .sha256 sidecar is unsigned and served from the SAME origin as the
    # binary, so it proves transit integrity and not authenticity.
    $pinnedSha = ""
    if ($GrowtherPinnedAssets) {
      foreach ($line in ($GrowtherPinnedAssets -split "`n")) {
        $parts = $line.Trim() -split '\s+'
        if ($parts.Length -ge 3 -and $parts[0] -eq "win-$arch") { $pinnedSha = $parts[2].ToLower(); break }
      }
    }

    $actual = (Get-FileHash "$tmp\$asset" -Algorithm SHA256).Hash.ToLower()

    if ($pinnedSha) {
      Write-Host "➜ verifying SHA-256 (pinned to the signed release manifest for $GrowtherPinnedVersion)"
      if ($pinnedSha -ne $actual) {
        throw "checksum mismatch against the SIGNED release manifest: expected $pinnedSha got $actual — do not run this file"
      }
      Write-Host "✓ checksum verified against the signed release manifest"
      if ($haveChecksum) {
        $side = ((Get-Content "$tmp\$asset.sha256") -split '\s+')[0].ToLower()
        if ($side -ne $pinnedSha) {
          Write-Warning "the published .sha256 disagrees with the signed manifest — using the signed value"
        }
      }
    } elseif ($haveChecksum) {
      # Unpinned: not served by growther.si (saved copy, mirror, or a preview
      # without the verification key). Say what the sidecar does and does not prove.
      Write-Warning "unpinned installer — the checksum below is unsigned and comes from the same host as the download"
      $expected = ((Get-Content "$tmp\$asset.sha256") -split '\s+')[0].ToLower()
      if ($expected -ne $actual) { throw "checksum mismatch: expected $expected got $actual" }
      Write-Host "✓ checksum verified (unsigned sidecar)"
      Write-Host "  Run 'growther verify' after installing for a signature-backed check."
    } elseif ($env:GROWTHER_INSECURE_SKIP_CHECKSUM -eq "1") {
      Write-Warning "no checksum for $asset and GROWTHER_INSECURE_SKIP_CHECKSUM=1 — installing UNVERIFIED"
    } else {
      throw "no published checksum for $asset — refusing to install unverified (set GROWTHER_INSECURE_SKIP_CHECKSUM=1 to override)"
    }

    Expand-Archive -Path "$tmp\$asset" -DestinationPath "$tmp\x" -Force
    $bin = Get-ChildItem -Path "$tmp\x" -Recurse -Filter "growther-c5-win-$arch*.exe" | Select-Object -First 1
    if (-not $bin) { $bin = Get-ChildItem -Path "$tmp\x" -Recurse -Filter "growther-c5-*.exe" | Select-Object -First 1 }
    if (-not $bin) { throw "binary not found in archive" }

    New-Item -ItemType Directory -Force -Path $InstallDir | Out-Null
    Copy-Item $bin.FullName "$InstallDir\growther.exe" -Force
    Write-Host "✓ installed $InstallDir\growther.exe"

    Set-Content -Path "$InstallDir\growther.cmd" -Value "@echo off`r`n`"%~dp0growther.exe`" %*`r`n" -Encoding ASCII
    Set-Content -Path "$InstallDir\growther" -Value "#!/bin/sh`nexec `"`$(dirname `"`$0`")/growther.exe`" `"`$@`"`n" -Encoding ASCII
  }

  # ── -ProfileOnly preflight ────────────────────────────────────────────────
  # Nothing above ran, so this mode's one assumption is checked here rather than
  # discovered later by a marker written beside an executable that is not there:
  # GROWTHER_INSTALL_DIR must already hold the growther.exe the MSI placed.
  #
  # The second check is the one that has to be loud. policy-expected, home.json
  # and c5.yaml all live under the DEFAULT home, which is %USERPROFILE%\.growther
  # — a PER-USER path. Run from an MSI custom action executing as a MACHINE
  # ACCOUNT they would land in C:\Windows\system32\config\systemprofile (or a
  # ServiceProfiles directory) and no real user would ever see them, while the
  # install still reported success. Deploy the package in user context (Intune
  # Win32 user context is the documented shape), or set those keys through
  # Group Policy / the ADMX instead.
  $wantsPerUser = [bool]($PolicyExpected -or $NoActivate -or $InstallService -or $HomeFlag -or $DataDir)
  if ($ProfileOnly) {
    if (-not (Test-Path "$InstallDir\growther.exe")) {
      Deny "-ProfileOnly: no growther.exe in $InstallDir — this mode configures a binary a package already placed; set GROWTHER_INSTALL_DIR to the directory holding it"
    }
    # IDENTITY, not a path suffix. The previous shape matched USERPROFILE
    # ending in "\systemprofile", which catches SYSTEM and nothing else:
    # LocalService, NetworkService, a gMSA and an SCCM task-sequence account
    # all have ordinary-looking profiles and sailed straight through, writing
    # policy-expected and home.json into a profile no interactive user ever
    # reads while the install reported success — the one state this programme
    # cannot see. The SID check is the answer for the well-known machine
    # accounts; the path checks stay as a belt-and-braces for the profiles
    # those accounts use, since a token check can be unavailable in a
    # constrained host.
    $machineAccount = ""
    if ($env:USERPROFILE -match '(?i)\\systemprofile$') { $machineAccount = "SYSTEM" }
    elseif ($env:USERPROFILE -match '(?i)\\ServiceProfiles\\') { $machineAccount = "a service account" }
    else {
      try {
        $sid = ([Security.Principal.WindowsIdentity]::GetCurrent()).User
        foreach ($well in @("LocalSystemSid", "LocalServiceSid", "NetworkServiceSid")) {
          if ($sid.IsWellKnown([Security.Principal.WellKnownSidType]$well)) {
            $machineAccount = $well -replace 'Sid$', ''
            break
          }
        }
      } catch {
        # No token to inspect (a constrained or non-Windows host). The path
        # checks above already ran; do not fail an install over the probe.
      }
    }
    if ($wantsPerUser -and $machineAccount) {
      Deny "-ProfileOnly: running as $machineAccount (USERPROFILE=$env:USERPROFILE) but -PolicyExpected/-NoActivate/-InstallService/-Home/-DataDir all write PER-USER files under the default home. They would land in a machine account's profile where no user can see them. Deploy this package in USER context, or set these through Group Policy (packaging/enterprise/Growther-C5.admx)."
    }
    Write-Host "➜ profile-only: configuring the existing $InstallDir\growther.exe"
  }

  # The home and the build manifest are PER-USER state, so -ProfileOnly seeds
  # them only when the run is actually about a user. A machine-scoped run — the
  # documented SYSTEM deployment that sets only MANAGEDINSTALL, whose one job is
  # the marker beside the binary — used to create and populate
  # C:\Windows\system32\config\systemprofile\.growther on every re-deploy, state
  # in a profile nothing ever reads and no uninstall removes. An ordinary
  # (non-profile-only) install always seeds: it is installing FOR the user
  # running it.
  if (-not $ProfileOnly -or $wantsPerUser) {
    New-Item -ItemType Directory -Force -Path $GrowtherHome | Out-Null
    # Normally the manifest comes out of the archive just extracted. In
    # -ProfileOnly there is no archive: the package ships the manifest BESIDE
    # growther.exe, which is the same file from the same signed release.
    $manifest = if ($ProfileOnly) {
      Get-Item -Path "$InstallDir\build_manifest.json" -ErrorAction SilentlyContinue
    } else {
      Get-ChildItem -Path "$tmp\x" -Recurse -Filter "build_manifest.json" | Select-Object -First 1
    }
    if ($manifest) { Copy-Item $manifest.FullName "$GrowtherHome\build_manifest.json" -Force; Write-Host "✓ seeded $GrowtherHome\build_manifest.json" }
  }

  # ── Enterprise install profile ────────────────────────────────────────────
  # Each block runs only when a flag (or its GROWTHER_* variable) asked for it,
  # so an ordinary install writes not one extra byte.

  # The marker that says a package or an MDM owns this binary. C5 reads it beside
  # growther.exe (server/src/cli/selfInstall.ts): with it present the first boot
  # does not copy itself into %LOCALAPPDATA% and `growther update` is check-only.
  if ($ManagedInstall) {
    $owner = if ($ManagedBy) { $ManagedBy } else { "install.ps1 --managed-install" }
    try {
      Set-Content -Path "$InstallDir\managed-install" -Value $owner -Encoding ASCII
    } catch {
      # The marker lives BESIDE the binary, which for the MSI is under Program
      # Files. The package's profile action runs in the client context — the
      # account that launched msiexec — so a standard user who elevated through
      # a UAC prompt cannot write here even though the payload landed. Name
      # that, rather than letting a raw UnauthorizedAccessException surface
      # from a run that has already committed the install.
      Deny "cannot write the managed-install marker to $InstallDir ($($_.Exception.Message)). This directory is machine-scoped: run the installer from an already-elevated context (an administrator command prompt, or Intune's SYSTEM context), or set MANAGEDINSTALL=0 if this fleet manages updates another way."
    }
    Write-Host "✓ marked as a managed install ($InstallDir\managed-install) — updates are check-only"
  }

  # The witness that policy is expected. An EMPTY file: nothing reads its
  # contents, so a truncated write cannot become a wrong answer, only "present".
  if ($PolicyExpected) {
    New-Item -ItemType Directory -Force -Path $DefaultHome | Out-Null
    Set-Content -Path "$DefaultHome\policy-expected" -Value "" -NoNewline -Encoding ASCII
    Write-Host "✓ policy expected ($DefaultHome\policy-expected) — anonymous first-user bootstrap is off"
  }

  # The device pointer. Written only when a location was actually requested: it
  # is persistent, so writing one from an unattended re-run that merely inherited
  # GROWTHER_HOME would repoint a machine whose data is somewhere else.
  if ($HomeFlag -or $DataDir) {
    New-Item -ItemType Directory -Force -Path $DefaultHome | Out-Null
    $pointerPath = "$DefaultHome\home.json"
    # MERGE, never rebuild. The pointer is a map, not a value: C5 writes
    # `secretsDir` into it for EVERY new Windows install (the device master key
    # goes under %LOCALAPPDATA%, outside the roaming profile), and may write
    # `dataDir` and `cacheDir` too. Rebuilding the file from {version, home,
    # dataDir, setBy, setAt} — which an Intune re-deploy did on every cycle,
    # because it sets GROWTHER_DATA_DIR — deletes the map to the key set: the
    # next boot resolves secrets to <home>\config, finds no key there, and
    # exits with "the device master key is MISSING" while the key sits
    # untouched in a directory nothing names any more. Only the keys this run
    # is actually setting are replaced; everything else, including keys a newer
    # C5 wrote that this script has never heard of, is carried through.
    $pointer = [ordered]@{}
    $unreadable = $false
    if (Test-Path $pointerPath) {
      try {
        $existingObj = Get-Content $pointerPath -Raw | ConvertFrom-Json
        foreach ($prop in $existingObj.PSObject.Properties) {
          $pointer[$prop.Name] = $prop.Value
        }
      } catch {
        $unreadable = $true
      }
      if ($unreadable) {
        Write-Warning "$pointerPath is not readable JSON; it may name a secretsDir or dataDir this installer cannot carry through."
        Write-Warning "Leaving it exactly as it is rather than dropping those keys — fix it by hand, or relocate with 'growther home migrate', and re-run."
      } elseif ($pointer["home"] -and $pointer["home"] -ne $GrowtherHome) {
        # The HOME is replaced — but say so: the old home's data stays where it
        # is, and only `growther home migrate` moves it.
        Write-Warning "replacing the home in the existing pointer $pointerPath (was $($pointer['home'])) — data under the old home stays there; see 'growther home migrate'"
      }
    }
    if (-not $unreadable) {
      $pointer["version"] = 1
      $pointer["home"] = $GrowtherHome
      if ($DataDir) { $pointer["dataDir"] = $DataDir }
      $pointer["setBy"] = "install.ps1"
      $pointer["setAt"] = (Get-Date).ToUniversalTime().ToString("yyyy-MM-ddTHH:mm:ssZ")
      Set-Content -Path $pointerPath -Value ($pointer | ConvertTo-Json -Depth 10) -Encoding ASCII
      if ($DataDir) { New-Item -ItemType Directory -Force -Path $DataDir | Out-Null }
      Write-Host "✓ home pointer written ($pointerPath -> $GrowtherHome)"
    }
  }

  # First-run activation off. This goes in config\c5.yaml rather than the
  # scheduled task because the task carries no environment for C5, and the same
  # answer has to hold whether the fleet starts C5 from the task or a terminal.
  if ($NoActivate) {
    New-Item -ItemType Directory -Force -Path "$GrowtherHome\config" | Out-Null
    $cfg = "$GrowtherHome\config\c5.yaml"
    if (-not (Test-Path $cfg)) { Set-Content -Path $cfg -Value "" -NoNewline -Encoding ASCII }
    if ((Get-Content $cfg -Raw -ErrorAction SilentlyContinue) -match '(?m)^GROWTHER_NO_AUTO_ACTIVATE:') {
      Write-Host "✓ first-run activation already disabled in $cfg"
    } else {
      Add-Content -Path $cfg -Value 'GROWTHER_NO_AUTO_ACTIVATE: "1"' -Encoding ASCII
      Write-Host "✓ first-run activation disabled (GROWTHER_NO_AUTO_ACTIVATE in $cfg)"
    }
  }

  # Not in -ProfileOnly: the MSI puts its own machine-wide prefix on the MACHINE
  # PATH through Windows Installer's own Environment table, which its uninstall
  # then removes. Editing the invoking user's PATH here as well would leave an
  # entry behind that nothing owns.
  if (-not $ProfileOnly -and $env:GROWTHER_NO_MODIFY_PATH -ne "1") {
    $userPath = [Environment]::GetEnvironmentVariable("Path", "User")
    if (-not $userPath) { $userPath = "" }
    $entries = $userPath -split ';' | Where-Object { $_.Trim() -ne '' }
    $normTarget = $InstallDir.TrimEnd('\', '/')
    $alreadyOnPath = $false
    foreach ($e in $entries) {
      if ($e.Trim().Trim('"').TrimEnd('\', '/') -eq $normTarget) {
        $alreadyOnPath = $true
        break
      }
    }
    if (-not $alreadyOnPath) {
      $newPath = if ($userPath.Trim()) { "$InstallDir;$userPath" } else { $InstallDir }
      [Environment]::SetEnvironmentVariable("Path", $newPath, "User")
      Write-Host "✓ added $InstallDir to PATH (restart your terminal)"
    }
  }

  # ── Optional managed startup (auto-start at sign-in + keep-alive) ───────────
  # Registered through the binary itself (Windows Startup / per-user Run key +
  # keep-alive supervisor). No admin required; a clean quit stays down, only a
  # crash restarts. Activates at next sign-in.
  if ($InstallService) {
    & "$InstallDir\growther.exe" service install | Out-Null
    if ($LASTEXITCODE -eq 0) {
      Write-Host "✓ managed startup enabled (auto-start + keep-alive) — manage in Settings > System"
    } else {
      Write-Host "⚠ could not enable managed startup (run 'growther service install' to retry)" -ForegroundColor Yellow
    }
  }

  Write-Host ""
  Write-Host "✓ Growther.si C5 installed." -ForegroundColor Green
  Write-Host ""
  Write-Host "Next steps:"
  if ($NoActivate) {
    # No browser will open, so say what replaces it.
    Write-Host "  1. Start it:  growther   (first-run activation is off - provide the licence by policy, or run 'growther activate')"
  } else {
    Write-Host "  1. Start it:  growther   (opens your browser to activate - sign in, then start a trial or pick a plan)"
    Write-Host "     Or activate explicitly:  growther activate"
  }
  if ($ManagedInstall) {
    Write-Host "  2. Updates:  managed install - 'growther update' reports new versions but installs nothing; roll them out with your MDM or package"
  } else {
    Write-Host "  2. Update later:  growther update"
  }
  Write-Host ""
  Write-Host "  Air-gapped / manual seed:  Add-Content `"$GrowtherHome\.env`" 'GROWTHER_C5_LICENSE_SEED=<your-seed>'"
} finally {
  if ($tmp) { Remove-Item -Recurse -Force $tmp }
}

# EXPLICIT, not implicit. `growther.exe service install` above leaves its own
# code in $LASTEXITCODE and a warning is not a failure, so a caller that reads
# $LASTEXITCODE after `& install.ps1` — which is how the MSI's custom action
# invokes it — would otherwise report a successful install as failed.
exit 0
