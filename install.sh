#!/usr/bin/env bash
set -euo pipefail

# ─────────────────────────────────────────────────────────────────────────────
# Growther.si C5 installer  ·  curl -fsSL https://growther.si/install.sh | bash
#
# Downloads the self-contained V8-bytecode binary for this OS/arch from GitHub
# Releases, verifies its SHA-256, installs it on PATH, and seeds ~/.growther with
# the signed build manifest. The app itself verifies that manifest's Ed25519
# signature at runtime (SOC 2 Change Management).
#
# Env overrides (all optional):
#   GROWTHER_VERSION        release tag to install (default: latest)
#   GROWTHER_INSTALL_DIR    where the binary goes    (default: ~/.local/bin)
#   GROWTHER_HOME           data dir                 (default: ~/.growther)
#   GROWTHER_RELEASE_BASE   release host base URL    (default: GrowtherSI/release raw mirror)
#   GROWTHER_ARCH           arm64|x64, overriding detection (Rosetta, cross-provisioning)
#   GROWTHER_INSTALL_SERVICE=1   install a launchd/systemd user service
#   GROWTHER_NO_MODIFY_PATH=1    don't touch shell rc files
#
# Enterprise install profile (Intune Win32 user context, Jamf, Ansible, a PKG
# postinstall). Every flag has a GROWTHER_* equivalent so a deployment tool that
# can only set environment variables reaches the same behaviour, and passing
# none of them leaves this script doing exactly what it always did:
#
#   --policy-expected     GROWTHER_POLICY_EXPECTED=1
#       Write ~/.growther/policy-expected. Its presence tells C5 that policy is
#       coming: the anonymous first-user bootstrap is disabled (nobody who opens
#       the tab first becomes the admin), missing policy is reported rather than
#       assumed, and doctor says "managed install". The first administrator then
#       comes from `growther user bootstrap-admin` or the identity provider.
#   --managed-install     GROWTHER_MANAGED_INSTALL=1
#       Write a `managed-install` marker beside the binary. C5 then treats the
#       binary the way it treats a Homebrew one: it never copies itself
#       elsewhere, and `growther update` reports the available version and
#       REFUSES the swap, naming whoever owns the install. Use it whenever an
#       MSI, PKG, MDM or configuration-management tool owns the file.
#   --managed-by <label>  GROWTHER_MANAGED_BY
#       Who that refusal names. Defaults to this script; the MSI and PKG pass
#       their own label so an operator is sent to the right place.
#   --no-activate         GROWTHER_NO_ACTIVATE=1
#       Set GROWTHER_NO_AUTO_ACTIVATE=1 in the config C5 loads at every launch
#       (service or terminal), so first run does not open a browser to activate.
#       For fleets that seed a licence by policy instead.
#   --install-service     GROWTHER_INSTALL_SERVICE=1
#   --home <dir>          (this run's home; see GROWTHER_HOME above)
#   --data-dir <dir>      GROWTHER_DATA_DIR
#       Where the home and the databases live. Because service units no longer
#       bake a home path, these are recorded in the device pointer
#       ~/.growther/home.json — the one file every launch reads to find them.
#       GROWTHER_HOME alone keeps its old meaning (the home THIS run seeds); the
#       pointer is written only when --home or --data-dir asks for it, so an
#       unattended re-run cannot silently repoint a machine that already has data.
#   --profile-only        GROWTHER_PROFILE_ONLY=1
#       The binary is ALREADY on disk — a signed PKG (packaging/pkg) placed it —
#       so skip the download, the checksum, the extract and the PATH edit and
#       apply only the enterprise profile above to GROWTHER_INSTALL_DIR. This is
#       the flag that keeps the packages free of configuration logic: they place
#       a signed payload and then run THIS script, so there is exactly one
#       implementation of what `--managed-install` or `--data-dir` mean. It is
#       not for interactive use; on its own it does nothing at all.
# ─────────────────────────────────────────────────────────────────────────────

# THIS FILE IS CANONICAL. growther.si serves it (marketing repo, public/install.sh)
# and GrowtherSI/release publishes it — both are mirrors checked against this
# copy by hash. There used to be three hand-maintained variants: the one people
# actually ran (growther.si) had the signed-release pin but not the icon stamp;
# this one had the icon stamp but not the pin. One file now carries both.

# ── Enterprise profile flags ────────────────────────────────────────────────
# Parsed FIRST, before anything is resolved or downloaded: --home decides where
# the manifest is seeded, and an unknown flag must fail before the network is
# touched rather than after a binary has landed. `die()` is not defined yet
# (colours come later), so argument errors print plainly.
POLICY_EXPECTED="${GROWTHER_POLICY_EXPECTED:-0}"
MANAGED_INSTALL="${GROWTHER_MANAGED_INSTALL:-0}"
NO_ACTIVATE="${GROWTHER_NO_ACTIVATE:-0}"
INSTALL_SERVICE="${GROWTHER_INSTALL_SERVICE:-0}"
HOME_FLAG=""
DATA_DIR="${GROWTHER_DATA_DIR:-}"
MANAGED_BY="${GROWTHER_MANAGED_BY:-}"
PROFILE_ONLY="${GROWTHER_PROFILE_ONLY:-0}"
# Printed from a here-doc rather than read out of this file: under
# `curl … | bash` there is no script on disk to read $0 from.
usage() {
  cat <<'USAGE'
Growther.si C5 installer

  bash install.sh [options]        curl -fsSL https://growther.si/install.sh | bash -s -- [options]

Options (each has a GROWTHER_* environment equivalent):
  --policy-expected     mark this install as centrally managed (policy is coming)
  --managed-install     an MSI/PKG/MDM owns the binary: no self-install, check-only updates
  --managed-by <label>  who to name as that owner (default: this script)
  --no-activate         do not open a browser to activate on first run
  --install-service     register auto-start (launchd / systemd --user)
  --home <dir>          where C5's home lives (recorded in ~/.growther/home.json)
  --data-dir <dir>      where the databases live (recorded in the same pointer)
  --profile-only        the binary is already installed (a signed PKG placed it):
                        apply only the options above, download nothing
  -h, --help            this text

Environment: GROWTHER_VERSION, GROWTHER_ARCH, GROWTHER_INSTALL_DIR,
GROWTHER_HOME, GROWTHER_DATA_DIR, GROWTHER_RELEASE_BASE, GROWTHER_NO_MODIFY_PATH,
GROWTHER_POLICY_EXPECTED, GROWTHER_MANAGED_INSTALL, GROWTHER_MANAGED_BY,
GROWTHER_NO_ACTIVATE, GROWTHER_INSTALL_SERVICE, GROWTHER_PROFILE_ONLY.
See https://docs.growther.si/c5/getting-started/installation
USAGE
}
need_value() {
  if [ "$2" -lt 2 ]; then
    printf '%s needs a value\n' "$1" >&2
    exit 2
  fi
}
while [ $# -gt 0 ]; do
  case "$1" in
    --policy-expected) POLICY_EXPECTED=1 ;;
    --managed-install) MANAGED_INSTALL=1 ;;
    --managed-by) need_value "$1" $#; MANAGED_BY="$2"; shift ;;
    --managed-by=*) MANAGED_BY="${1#*=}" ;;
    --no-activate)     NO_ACTIVATE=1 ;;
    --install-service) INSTALL_SERVICE=1 ;;
    --profile-only)    PROFILE_ONLY=1 ;;
    --home)     need_value "$1" $#; HOME_FLAG="$2"; shift ;;
    --home=*)   HOME_FLAG="${1#*=}" ;;
    --data-dir) need_value "$1" $#; DATA_DIR="$2"; shift ;;
    --data-dir=*) DATA_DIR="${1#*=}" ;;
    -h|--help) usage; exit 0 ;;
    *) printf 'unknown option: %s (try --help)\n' "$1" >&2; exit 2 ;;
  esac
  shift
done

BIN_NAME="growther"
INSTALL_DIR="${GROWTHER_INSTALL_DIR:-$HOME/.local/bin}"
GROWTHER_HOME="${HOME_FLAG:-${GROWTHER_HOME:-$HOME/.growther}}"
# The pointer, the policy-expected marker and the key witnesses all live in the
# DEFAULT home even when the home moves: it is the one location every launch can
# find without being told where to look.
DEFAULT_HOME="$HOME/.growther"
# Public distribution is the raw GrowtherSI/release mirror (dist/c5/<tag>/<asset>),
# NOT the private source repo's GitHub Releases (which aren't anonymously downloadable).
DEFAULT_RELEASE_BASE="https://raw.githubusercontent.com/GrowtherSI/release/main/dist/c5"
RELEASE_BASE="$DEFAULT_RELEASE_BASE"
# A custom mirror redirects BOTH the binary and its checksum, so it is the whole
# trust root for this install. Require an explicit second opt-in rather than
# letting a single exported variable silently repoint a `curl | bash`.
if [ -n "${GROWTHER_RELEASE_BASE:-}" ] && [ "${GROWTHER_RELEASE_BASE}" != "$DEFAULT_RELEASE_BASE" ]; then
  if [ "${GROWTHER_ALLOW_CUSTOM_MIRROR:-}" = "1" ]; then
    RELEASE_BASE="$GROWTHER_RELEASE_BASE"
  else
    printf '%s\n' "refusing GROWTHER_RELEASE_BASE=${GROWTHER_RELEASE_BASE}" >&2
    printf '%s\n' "a custom mirror supplies both the binary and its checksum; re-run with GROWTHER_ALLOW_CUSTOM_MIRROR=1 if you trust it" >&2
    exit 1
  fi
fi
VERSION="${GROWTHER_VERSION:-latest}"

# >>> GROWTHER_PINNED_RELEASE >>>
# Replaced at serve time by growther.si with hashes taken from an Ed25519-VERIFIED
# release manifest. Verification happens on the server because Ed25519 is not
# reliably available in a portable shell (macOS ships LibreSSL, whose pkeyutl has
# no -rawin). Left as-is, this file is UNPINNED and says so before installing.
GROWTHER_PINNED_VERSION=""
GROWTHER_PINNED_ASSETS=""
# <<< GROWTHER_PINNED_RELEASE <<<

c_reset=$'\033[0m'; c_b=$'\033[1m'; c_g=$'\033[32m'; c_y=$'\033[33m'; c_r=$'\033[31m'
say()  { printf '%s\n' "$*"; }
info() { printf '%s➜%s %s\n' "$c_b" "$c_reset" "$*"; }
ok()   { printf '%s✓%s %s\n' "$c_g" "$c_reset" "$*"; }
warn() { printf '%s!%s %s\n' "$c_y" "$c_reset" "$*" >&2; }
die()  { printf '%s✗ %s%s\n' "$c_r" "$*" "$c_reset" >&2; exit 1; }

trap 'die "install failed on line $LINENO"' ERR

# ── Acquire and place the binary (skipped by --profile-only) ────────────────
# --profile-only means a signed package has ALREADY placed the binary and its
# build manifest: there is nothing to resolve, download, verify, extract or put
# on PATH, and the package owns all of those. Everything BELOW this block still
# runs, so the enterprise profile a PKG applies is written by exactly the same
# code a `curl … | bash` runs — the package holds no second copy of it.
if [ "$PROFILE_ONLY" != "1" ]; then
  # ── Dependencies ─────────────────────────────────────────────────────────────
  have() { command -v "$1" >/dev/null 2>&1; }
  if have curl; then DL=(curl -fsSL -o); elif have wget; then DL=(wget -qO); else
    die "need curl or wget"; fi
  have tar || die "need tar"

  # ── OS / arch detection ──────────────────────────────────────────────────────
  case "$(uname -s)" in
    Darwin) OS=macos ;;
    Linux)  OS=linux ;;
    *) die "unsupported OS: $(uname -s) (this installer covers macOS/Linux; use install.ps1 on Windows)";;
  esac
  case "$(uname -m)" in
    arm64|aarch64) ARCH=arm64 ;;
    x86_64|amd64)  ARCH=x64 ;;
    *) die "unsupported architecture: $(uname -m)";;
  esac
  # `uname -m` reports the architecture of THIS PROCESS, not of the machine. A
  # bash translated by Rosetta answers x86_64 on an Apple Silicon Mac, so piping
  # this script into an Intel-built terminal, an x86_64 container, or an explicit
  # `arch -x86_64 bash` installs the Intel build on an ARM machine. It runs — every
  # instruction translated — while the native binary sits beside it in the very
  # same release, and nothing ever says so. install.ps1 has always handled the
  # mirror-image case explicitly (PROCESSOR_ARCHITEW6432 catches ARM64 under x64
  # emulation); this is the macOS half that was missing.
  #
  # hw.optional.arm64 describes the HARDWARE, so it stays true even when the
  # asking process is translated. sysctl.proc_translated is NOT a substitute: a
  # natively-x86_64 binary exec'd on Apple Silicon reports translated=0 and still
  # wants the arm64 build. On Linux the OS test short-circuits before sysctl runs.
  case "${GROWTHER_ARCH:-}" in
    arm64|x64) ARCH="${GROWTHER_ARCH}" ;;
    "")
      if [ "$OS" = macos ] && [ "$ARCH" = x64 ] &&
        [ "$(sysctl -n hw.optional.arm64 2>/dev/null || echo 0)" = 1 ]; then
        warn "x86_64 shell on an Apple Silicon Mac — installing the native arm64 build (GROWTHER_ARCH=x64 forces Intel)"
        ARCH=arm64
      fi
      ;;
    *) die "GROWTHER_ARCH must be arm64 or x64 (got: ${GROWTHER_ARCH})";;
  esac
  # growther-c5-<os>-<arch>-<runtime>: the executable's name, then the Node
  # runtime it embeds. A pinned installer takes the exact name from the SIGNED
  # manifest instead.
  PINNED_ASSET=""
  if [ -n "$GROWTHER_PINNED_ASSETS" ]; then
    PINNED_ASSET="$(printf '%s\n' "$GROWTHER_PINNED_ASSETS" \
      | awk -v k="${OS}-${ARCH}" '$1 == k { print $2; exit }')"
  fi
  if [ -n "$PINNED_ASSET" ]; then
    ASSET_CANDIDATES="$PINNED_ASSET"
  else
    ASSET_CANDIDATES="growther-c5-${OS}-${ARCH}-node24.tar.gz"
  fi
  ASSET="${ASSET_CANDIDATES%% *}"
  info "target: ${c_b}${OS}-${ARCH}${c_reset} · version: ${c_b}${VERSION}${c_reset}"

  # ── Resolve the release tag + URL (raw mirror layout: <base>/<tag>/<asset>) ───
  # 'latest' reads the published catalog's .stable.version; an explicit version is
  # normalized to a v-prefixed tag (accepts "2026.7.16-v42" or "v2026.7.16-v42").
  if [ "$VERSION" = "latest" ]; then
    cat_tmp="$(mktemp)"
    "${DL[@]}" "$cat_tmp" "${RELEASE_BASE}/releases.json" 2>/dev/null && [ -s "$cat_tmp" ] \
      || die "cannot fetch release catalog: ${RELEASE_BASE}/releases.json"
    if have jq; then ver="$(jq -r '.stable.version' "$cat_tmp")";
    elif have python3; then ver="$(python3 -c "import json,sys;print(json.load(open(sys.argv[1]))['stable']['version'])" "$cat_tmp")";
    else
      # Last-resort parse with no JSON tool present. Scope to the "stable" block
      # first (sed) so we never pick up a delta/beta channel's "version" — the
      # entry lists "version" before its "assets", so the first match after
      # "stable": is the stable version. `|| true` keeps `set -e` from aborting
      # before the friendly guard below fires on an empty result.
      ver="$(sed -n '/"stable"[[:space:]]*:/,/}/p' "$cat_tmp" \
        | grep -o '"version"[[:space:]]*:[[:space:]]*"[^"]*"' \
        | head -1 | sed -E 's/.*"([^"]*)"$/\1/' || true)"
    fi
    rm -f "$cat_tmp"
    [ -n "$ver" ] && [ "$ver" != "null" ] || die "could not read .stable.version from ${RELEASE_BASE}/releases.json — install jq or python3, or re-run with an explicit version (e.g. GROWTHER_VERSION=2026.7.17)"
    TAG="v${ver#v}"
  else
    TAG="v${VERSION#v}"
  fi
  info "resolved ${c_b}${TAG}${c_reset}"

  TMP="$(mktemp -d)"; trap 'rm -rf "$TMP"; ' EXIT
  got=""
  for ASSET in $ASSET_CANDIDATES; do
    URL="${RELEASE_BASE}/${TAG}/${ASSET}"
    info "downloading ${ASSET}"
    if "${DL[@]}" "$TMP/$ASSET" "$URL" 2>/dev/null && [ -s "$TMP/$ASSET" ]; then
      got=1
      break
    fi
    rm -f "$TMP/$ASSET"
  done
  [ -n "$got" ] || die "download failed: ${RELEASE_BASE}/${TAG}/ (tried: ${ASSET_CANDIDATES})"
  # The PINNED hash wins when present. It came from a signature-verified manifest,
  # whereas <asset>.sha256 is unsigned and served from the SAME origin as the
  # binary — so the sidecar proves transit integrity, not authenticity.
  pinned_sha=""
  if [ -n "$GROWTHER_PINNED_ASSETS" ]; then
    pinned_sha="$(printf '%s\n' "$GROWTHER_PINNED_ASSETS" \
      | awk -v k="${OS}-${ARCH}" '$1 == k { print $3; exit }')"
  fi

  file_sha() {
    if have sha256sum; then sha256sum "$1" | awk '{print $1}'
    else shasum -a 256 "$1" | awk '{print $1}'; fi
  }

  if [ -n "$pinned_sha" ]; then
    info "verifying SHA-256 (pinned to the signed release manifest for ${GROWTHER_PINNED_VERSION:-?})"
    actual="$(file_sha "$TMP/$ASSET")"
    [ "$pinned_sha" = "$actual" ] \
      || die "checksum mismatch against the SIGNED release manifest: expected $pinned_sha got $actual — do not run this file"
    ok "checksum verified against the signed release manifest"
    # A sidecar that disagrees with the signed manifest means the download path is
    # serving something other than what was signed. Report it; the pin already won.
    if "${DL[@]}" "$TMP/$ASSET.sha256" "${URL}.sha256" 2>/dev/null && [ -s "$TMP/$ASSET.sha256" ]; then
      side="$(awk '{print $1}' "$TMP/$ASSET.sha256")"
      [ "$side" = "$pinned_sha" ] || warn "the published .sha256 disagrees with the signed manifest — using the signed value"
    fi
  elif "${DL[@]}" "$TMP/$ASSET.sha256" "${URL}.sha256" 2>/dev/null && [ -s "$TMP/$ASSET.sha256" ]; then
    # Unpinned: this installer was not served by growther.si (saved copy, mirror,
    # or a preview without the verification key). The sidecar is same-origin and
    # unsigned, so say what it does and does not prove.
    warn "unpinned installer — the checksum below is unsigned and comes from the same host as the download"
    info "verifying SHA-256"
    expected="$(awk '{print $1}' "$TMP/$ASSET.sha256")"
    actual="$(file_sha "$TMP/$ASSET")"
    [ "$expected" = "$actual" ] || die "checksum mismatch: expected $expected got $actual"
    ok "checksum verified (unsigned sidecar)"
    say "  Run ${c_b}growther verify${c_reset} after installing for a signature-backed check."
  else
    # No per-asset checksum → refuse to run unverified bytes (the runtime attestation
    # does NOT hash the binary). Explicit opt-out for air-gapped/local installs.
    if [ "${GROWTHER_INSECURE_SKIP_CHECKSUM:-0}" = "1" ]; then
      warn "no checksum for $ASSET and GROWTHER_INSECURE_SKIP_CHECKSUM=1 — installing UNVERIFIED"
    else
      die "no published checksum for $ASSET — refusing to install unverified (set GROWTHER_INSECURE_SKIP_CHECKSUM=1 to override)"
    fi
  fi

  # ── Extract ──────────────────────────────────────────────────────────────────
  info "extracting"
  if tar -tzf "$TMP/$ASSET" | grep -Eq '(^/|(^|/)\.\./)'; then
    die "refusing archive: contains absolute or parent-relative paths"
  fi
  tar -xzf "$TMP/$ASSET" -C "$TMP" --no-same-owner
  # The downloaded archive sits in $TMP too, and its name STARTS with the
  # executable's — exclude archives and sidecars or the tarball itself matches.
  BIN_SRC="$(find "$TMP" -maxdepth 2 -type f -name "growther-c5-${OS}-${ARCH}*" ! -name '*.tar.gz' ! -name '*.zip' ! -name '*.sha256' ! -name '*.json' | head -1)"
  [ -n "$BIN_SRC" ] || BIN_SRC="$(find "$TMP" -maxdepth 2 -type f -name 'growther-c5-*' ! -name '*.json' ! -name '*.sha256' ! -name '*.tar.gz' | head -1)"
  [ -n "$BIN_SRC" ] && [ -f "$BIN_SRC" ] || die "binary not found in archive"

  # ── Install binary ───────────────────────────────────────────────────────────
  mkdir -p "$INSTALL_DIR"
  install -m 0755 "$BIN_SRC" "$INSTALL_DIR/$BIN_NAME"
  ok "installed ${c_b}${INSTALL_DIR}/${BIN_NAME}${c_reset}"

  # ── Icon on the UNIX EXECUTABLE ──────────────────────────────────────────────
  # This is the icon that matters most: `growther` in ~/.local/bin is what people
  # actually run, and the .app launches with no terminal attached, so it is a poor
  # home for a server that logs to stdout.
  #
  # A Mach-O has no icon slot — unlike a Windows .exe, where the icon is embedded
  # in the PE and travels with the file. On macOS the icon is a RESOURCE FORK, and
  # a fork survives no copy, archive, or artifact upload (`install -m 0755` above
  # copies bytes, so it cannot carry one). It has to be written here, on this
  # machine, against the file that was just installed.
  #
  # The .icns ships in the macOS tarball beside the binary, so this needs no
  # network and no assumptions about what else is on disk. (It used to be pulled
  # out of a Growther C5.app; that bundle is gone — it cost a second full copy of
  # the binary to deliver an icon on something LaunchServices starts with no
  # terminal attached. The icon belongs on the CLI, which is what people run.)
  # Best-effort throughout: `swift` only exists with the Xcode command line tools,
  # and C5 re-attempts this on boot (applyDarwinIcon in
  # server/src/cli/selfInstall.ts), so a miss here is a delay, never a failure.
  if [ "$OS" = "macos" ]; then
    ICNS_SRC="$(find "$TMP" -maxdepth 5 -type f -name 'logo-c5.icns' | head -1)"
    if [ -n "$ICNS_SRC" ]; then
      applied=0
      if have osascript; then
        if osascript -l JavaScript -e "
  ObjC.import('Cocoa');
  var img = $.NSImage.alloc.initWithContentsOfFile('$ICNS_SRC');
  if (!img.isNil()) {
    var ok = $.NSWorkspace.sharedWorkspace.setIconForFileOptions(img, '$INSTALL_DIR/$BIN_NAME', 0);
    if (!ok) $.exit(1);
  } else {
    $.exit(1);
  }" >/dev/null 2>&1; then
          applied=1
        fi
      fi
      if [ "$applied" -eq 0 ] && have swift; then
        if swift -e "
  import Cocoa
  if let img = NSImage(contentsOfFile: \"$ICNS_SRC\") {
    if !NSWorkspace.shared.setIcon(img, forFile: \"$INSTALL_DIR/$BIN_NAME\", options: []) { exit(1) }
  } else { exit(1) }" >/dev/null 2>&1; then
          applied=1
        fi
      fi
      if [ "$applied" -eq 1 ]; then
        ok "applied the C5 icon to ${c_b}${INSTALL_DIR}/${BIN_NAME}${c_reset}"
      else
        info "could not stamp the binary icon (C5 will retry on first run)"
      fi
    else
      info "skipping binary icon (logo-c5.icns not found in archive; C5 will retry on first run)"
    fi
  fi
fi

# Did anything ask for a file under a USER's own home? policy-expected,
# home.json, c5.yaml and the login agent all live there, and the answer decides
# both the root refusal below and whether a --profile-only run seeds a home at
# all. Read once, so the two cannot drift apart.
WANTS_PER_USER=0
if [ "$POLICY_EXPECTED" = "1" ] || [ "$NO_ACTIVATE" = "1" ] || [ "$INSTALL_SERVICE" = "1" ] ||
  [ -n "$HOME_FLAG" ] || [ -n "$DATA_DIR" ]; then
  WANTS_PER_USER=1
fi

# ── --profile-only preflight ─────────────────────────────────────────────────
# Nothing above ran, so the one assumption this mode makes has to be checked
# here rather than discovered later by a marker written beside a binary that is
# not there: GROWTHER_INSTALL_DIR must already hold the executable the package
# placed. A package whose payload failed must not go on to report success.
if [ "$PROFILE_ONLY" = "1" ]; then
  [ -f "$INSTALL_DIR/$BIN_NAME" ] \
    || die "--profile-only: no $BIN_NAME in $INSTALL_DIR — this mode configures a binary a package already placed; set GROWTHER_INSTALL_DIR to the directory holding it"
  # policy-expected, home.json, c5.yaml and the login agent all live under the
  # DEFAULT home, which is a PER-USER path ($HOME/.growther). A PKG postinstall
  # runs as ROOT, so unguarded they would land in /var/root/.growther, invisible
  # to every real account, while the install still reported success. The package
  # drops to the console user before calling this script; if something skipped
  # that, say so rather than writing markers nobody will ever read.
  if [ "$(id -u)" = "0" ] && [ "$WANTS_PER_USER" = "1" ]; then
    die "--profile-only: running as root (HOME=$HOME) but --policy-expected/--no-activate/--install-service/--home/--data-dir all write PER-USER files under the default home. They would land in root's profile where no user can see them. Run this as the user the package is being installed for, or set these through a configuration profile ('growther policy templates' writes ai.growther.c5.mobileconfig to ~/.growther/enterprise)."
  fi
  info "profile-only: configuring the existing ${c_b}${INSTALL_DIR}/${BIN_NAME}${c_reset}"
fi

# ── Seed ~/.growther + drop the signed build manifest (Installer method) ─────
# The home and the manifest are PER-USER state, so --profile-only seeds them
# only when the run is actually about a user. The machine-scoped shape — a PKG
# with no plist, whose one job is the marker beside the binary and which runs as
# ROOT — used to create and populate /var/root/.growther on every deploy: state
# in a profile nothing ever reads and no uninstall removes. An ordinary install
# always seeds, because it is installing FOR the user running it.
if [ "$PROFILE_ONLY" != "1" ] || [ "$WANTS_PER_USER" = "1" ]; then
  mkdir -p "$GROWTHER_HOME"
  chmod 0700 "$GROWTHER_HOME" 2>/dev/null || true
  # Normally the manifest comes out of the archive this script just extracted. In
  # --profile-only there is no archive: the package ships the manifest BESIDE the
  # binary, which is the same file from the same signed release.
  if [ "$PROFILE_ONLY" = "1" ]; then
    MANIFEST_SRC=""
    [ -f "$INSTALL_DIR/build_manifest.json" ] && MANIFEST_SRC="$INSTALL_DIR/build_manifest.json"
  else
    MANIFEST_SRC="$(find "$TMP" -maxdepth 2 -type f -name 'build_manifest.json' | head -1 || true)"
  fi
  if [ -n "$MANIFEST_SRC" ]; then
    cp "$MANIFEST_SRC" "$GROWTHER_HOME/build_manifest.json"
    ok "seeded ${GROWTHER_HOME}/build_manifest.json (signed attestation)"
  fi
fi

# ── Enterprise install profile ───────────────────────────────────────────────
# Everything below runs only when a flag (or its GROWTHER_* variable) asked for
# it, so an ordinary install writes not one extra byte.

# The marker that says a package or an MDM owns this binary. C5 reads it beside
# the executable (server/src/cli/selfInstall.ts): with it present the first boot
# does not copy itself to ~/.local/bin and `growther update` becomes check-only,
# which is what keeps a fleet's on-disk version equal to the version its
# management tool believes it shipped.
if [ "$MANAGED_INSTALL" = "1" ]; then
  printf '%s\n' "${MANAGED_BY:-install.sh --managed-install}" > "$INSTALL_DIR/managed-install"
  chmod 0644 "$INSTALL_DIR/managed-install" 2>/dev/null || true
  ok "marked as a managed install (${INSTALL_DIR}/managed-install) — updates are check-only"
fi

# The witness that policy is expected. An EMPTY file: nothing reads its contents,
# so a truncated write cannot become a wrong answer, only "present".
if [ "$POLICY_EXPECTED" = "1" ]; then
  mkdir -p "$DEFAULT_HOME"
  chmod 0700 "$DEFAULT_HOME" 2>/dev/null || true
  : > "$DEFAULT_HOME/policy-expected"
  chmod 0600 "$DEFAULT_HOME/policy-expected" 2>/dev/null || true
  ok "policy expected (${DEFAULT_HOME}/policy-expected) — anonymous first-user bootstrap is off"
fi

# The device pointer. Only written when a location was actually requested: it
# outranks nothing at boot except the platform default, but it is persistent, so
# writing one from an unattended re-run that merely inherited GROWTHER_HOME from
# a shell would repoint a machine whose data is somewhere else entirely.
if [ -n "$HOME_FLAG" ] || [ -n "$DATA_DIR" ]; then
  json_escape() { printf '%s' "$1" | sed -e 's/\\/\\\\/g' -e 's/"/\\"/g'; }
  mkdir -p "$DEFAULT_HOME"
  chmod 0700 "$DEFAULT_HOME" 2>/dev/null || true
  POINTER="$DEFAULT_HOME/home.json"
  # An existing pointer that named a different home has its HOME replaced —
  # but say so, because the data it pointed at stays where it is and only
  # `growther home migrate` moves it.
  if [ -f "$POINTER" ] && ! grep -qF "\"home\": \"$(json_escape "$GROWTHER_HOME")\"" "$POINTER" 2>/dev/null; then
    warn "replacing the home in the existing pointer $POINTER — any data under the old home stays there (see 'growther home migrate')"
  fi
  # EVERY OTHER KEY IS PRESERVED. The pointer is a map, not a value: it may
  # also name `secretsDir` (where the device master key lives — the default on
  # every new Windows install), `dataDir` and `cacheDir`. A writer that
  # rebuilds the file from {version, home, setBy, setAt} deletes the map to
  # the key set, and the next boot dies with "the device master key is
  # MISSING" while the key sits untouched in a directory nothing names any
  # more. The keys this run is setting are dropped from the carried-over set;
  # everything else — including keys a NEWER C5 wrote that this script has
  # never heard of — is copied through verbatim.
  PRESERVED=""
  if [ -f "$POINTER" ]; then
    PRESERVE_OK=1
    PRESERVED=$(awk -v drop_data="${DATA_DIR:+1}" '
      BEGIN { ok = 1 }
      {
        line = $0
        sub(/^[[:space:]]+/, "", line)
        sub(/[[:space:]]+$/, "", line)
        if (line == "" || line == "{" || line == "}") next
        sub(/,$/, "", line)
        # Only a COMPLETE "key": <scalar> pair on one line can be carried
        # through verbatim. Anything else (a nested object, a minified file)
        # would be re-emitted as broken JSON, so the whole rewrite is refused.
        if (line !~ /^"[A-Za-z0-9_]+"[[:space:]]*:[[:space:]]*("([^"\\]|\\.)*"|-?[0-9]+(\.[0-9]+)?|true|false|null)$/) {
          ok = 0
          exit 1
        }
        key = line
        sub(/^"/, "", key)
        sub(/".*$/, "", key)
        if (key == "version" || key == "home" || key == "setBy" || key == "setAt") next
        if (key == "dataDir" && drop_data == "1") next
        printf "  %s,\n", line
      }
      END { if (!ok) exit 1 }
    ' "$POINTER") || PRESERVE_OK=0
    # A pointer this reader cannot carry through in full AND which names a
    # location: orphaning a `secretsDir` is unrecoverable, refusing is not, so
    # the pointer is left exactly as it is.
    if [ "$PRESERVE_OK" = "0" ] && grep -qE '"(secretsDir|cacheDir|dataDir)"' "$POINTER" 2>/dev/null; then
      warn "$POINTER names a secretsDir/dataDir/cacheDir but is not in the one-key-per-line form this installer can rewrite safely."
      warn "Leaving it untouched rather than dropping those keys: relocate with 'growther home migrate', or fix the pointer by hand and re-run."
      POINTER=""
    elif [ "$PRESERVE_OK" = "0" ]; then
      PRESERVED=""
    fi
  fi
  if [ -n "$POINTER" ]; then
    {
      printf '{\n'
      printf '  "version": 1,\n'
      printf '  "home": "%s",\n' "$(json_escape "$GROWTHER_HOME")"
      if [ -n "$DATA_DIR" ]; then printf '  "dataDir": "%s",\n' "$(json_escape "$DATA_DIR")"; fi
      if [ -n "$PRESERVED" ]; then printf '%s\n' "$PRESERVED"; fi
      printf '  "setBy": "install.sh",\n'
      printf '  "setAt": "%s"\n' "$(date -u +%Y-%m-%dT%H:%M:%SZ)"
      printf '}\n'
    } > "$POINTER"
    chmod 0600 "$POINTER" 2>/dev/null || true
    if [ -n "$DATA_DIR" ]; then mkdir -p "$DATA_DIR"; fi
    ok "home pointer written ($POINTER → $GROWTHER_HOME${DATA_DIR:+, data $DATA_DIR})"
  fi
fi

# First-run activation off. This goes in config/c5.yaml rather than a service
# unit because units no longer carry environment for C5, and because the same
# answer has to hold whether the fleet starts C5 from the service or a terminal.
if [ "$NO_ACTIVATE" = "1" ]; then
  mkdir -p "$GROWTHER_HOME/config"
  chmod 0700 "$GROWTHER_HOME/config" 2>/dev/null || true
  CFG="$GROWTHER_HOME/config/c5.yaml"
  [ -f "$CFG" ] || : > "$CFG"
  if grep -q '^GROWTHER_NO_AUTO_ACTIVATE:' "$CFG" 2>/dev/null; then
    ok "first-run activation already disabled in $CFG"
  else
    printf 'GROWTHER_NO_AUTO_ACTIVATE: "1"\n' >> "$CFG"
    ok "first-run activation disabled (GROWTHER_NO_AUTO_ACTIVATE in $CFG)"
  fi
  chmod 0600 "$CFG" 2>/dev/null || true
fi

# ── PATH ─────────────────────────────────────────────────────────────────────
# Not in --profile-only: a package puts its own prefix on PATH the way its
# platform expects (/etc/paths.d for the PKG, the machine PATH for the MSI), and
# an installer that also edited the invoking user's shell rc would leave an entry
# behind that no uninstall knows about.
if [ "$PROFILE_ONLY" != "1" ]; then
  case ":$PATH:" in
    *":$INSTALL_DIR:"*) : ;;
    *)
      if [ "${GROWTHER_NO_MODIFY_PATH:-0}" != "1" ]; then
        rc=""
        case "${SHELL##*/}" in zsh) rc="$HOME/.zshrc";; bash) rc="$HOME/.bashrc";; fish) rc="$HOME/.config/fish/config.fish";; esac
        if [ -n "$rc" ]; then
          line="export PATH=\"$INSTALL_DIR:\$PATH\""
          [ "${SHELL##*/}" = "fish" ] && line="fish_add_path $INSTALL_DIR"
          mkdir -p "$(dirname "$rc")" 2>/dev/null || true   # fish: ~/.config/fish may not exist
          if ! grep -qF "$INSTALL_DIR" "$rc" 2>/dev/null; then
            if printf '\n# Growther.si C5\n%s\n' "$line" >> "$rc" 2>/dev/null; then
              ok "added $INSTALL_DIR to PATH in $rc (restart your shell)"
            else
              warn "could not update PATH in $rc — add $INSTALL_DIR to your PATH manually"
            fi
          fi
        fi
      else
        warn "$INSTALL_DIR is not on PATH — add it manually"
      fi
      ;;
  esac
fi

# ── Optional user service ────────────────────────────────────────────────────
# Register managed startup (auto-start at sign-in + keep-alive) through the
# binary itself so there is ONE definition — see
# server/src/services/serviceManager.ts — with the correct exit-code contract:
# a clean `growther stop` / the in-app Quit exits 0 and STAYS down; only a crash
# (non-zero exit) is restarted. Covers macOS (launchd), Linux (systemd --user,
# with an autostart fallback), and Windows (Task Scheduler). No admin required.
# Activates at the next sign-in; run `growther` now to start it immediately.
if [ "$INSTALL_SERVICE" = "1" ]; then
  if "$INSTALL_DIR/$BIN_NAME" service install >/dev/null 2>&1; then
    ok "managed startup enabled (auto-start + keep-alive) — manage in Settings › System › Startup & Reliability"
  else
    warn "could not enable managed startup (run '$BIN_NAME service install' to retry)"
  fi
fi

# ── Done ─────────────────────────────────────────────────────────────────────
say ""
ok "${c_b}Growther.si C5 installed.${c_reset}"
say ""
say "Next steps:"
if [ "$NO_ACTIVATE" = "1" ]; then
  # No browser will open, so the operator has to be told what replaces it.
  say "  1. Start it:  ${c_b}${BIN_NAME}${c_reset}  — first-run activation is off; provide the licence by policy or ${c_b}${BIN_NAME} activate${c_reset}."
else
  say "  1. Start it:  ${c_b}${BIN_NAME}${c_reset}  — opens your browser to activate (sign in, then start a trial or pick a plan)."
  say "       Or activate explicitly:  ${c_b}${BIN_NAME} activate${c_reset}    (set GROWTHER_INSTALL_SERVICE=1 to run as a service)"
fi
if [ "$MANAGED_INSTALL" = "1" ]; then
  say "  2. Updates:  managed install — ${c_b}${BIN_NAME} update${c_reset} reports new versions but installs nothing; roll them out with your package manager or MDM."
else
  say "  2. Update later:  ${c_b}${BIN_NAME} update${c_reset}"
fi
say ""
say "  Installing offline or air-gapped? See ${c_b}https://docs.growther.si/c5/getting-started/installation${c_reset}"
say ""
