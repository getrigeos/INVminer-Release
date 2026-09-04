#!/usr/bin/env bash
set -euo pipefail

if [[ $# -ne 2 ]]; then
  echo 'usage: check-release-note-upgrade.sh <X.Y.Z> <release-note.md>' >&2
  exit 2
fi

version=${1#v}
note=$2
[[ $version =~ ^[0-9]+\.[0-9]+\.[0-9]+$ ]] || {
  echo "release-note version must be X.Y.Z: $version" >&2
  exit 2
}
[[ -f $note ]] || {
  echo "release note is missing: $note" >&2
  exit 1
}
if rg -n -i '01pool' "$note"; then
  echo 'release note contains forbidden 01pool wording' >&2
  exit 1
fi

english_scope='Only some older HiveOS installations need this manual replacement. Use it only when HiveOS does not update the installed custom miner after the Installation URL is changed to this release.'
traditional_scope='僅部分舊版 HiveOS 需要此手動覆蓋；只有在更新 Installation URL 後仍未替換已安裝的 Custom Miner 時才執行。'
upgrade_command="miner stop && cd /tmp && rm -rf invminer && rm -f invminer-${version}.tar.gz && wget -O invminer-${version}.tar.gz https://github.com/getrigeos/INVminer-Release/releases/download/v${version}/invminer-${version}.tar.gz && tar -xzf invminer-${version}.tar.gz && mkdir -p /hive/miners/custom/invminer && rm -f /hive/miners/custom/invminer/invminer && cp -af invminer/. /hive/miners/custom/invminer/ && chmod +x /hive/miners/custom/invminer/invminer /hive/miners/custom/invminer/h-*.sh && /hive/miners/custom/invminer/invminer --version && miner start"
short_version=${version#0.}
short_version=${short_version//./}
troubleshooting_command="(miner stop || true) && cd \"\$(mktemp -d /tmp/${short_version}invminer.XXXXXX)\" && wget -O invminer-${version}.tar.gz https://github.com/getrigeos/INVminer-Release/releases/download/v${version}/invminer-${version}.tar.gz && tar -xzf invminer-${version}.tar.gz && cd invminer && chmod +x invminer && ./invminer --coin noid --pool stratum+ssl://eu.innovlab.cc:19601 --user YOUR_NOID_ADDRESS --pass x"
troubleshooting_line="\`${troubleshooting_command}\`"

if ! grep -Fqx "# INVminer v${version}" "$note" &&
  ! grep -Fqx "# INVminer GPU v${version}" "$note" &&
  ! grep -Fqx "# INVminer v${version} Hotfix" "$note" &&
  ! grep -Fqx "# INVminer GPU v${version} Hotfix" "$note"; then
  echo "release-note title/version mismatch: expected INVminer v${version}" >&2
  exit 1
fi
grep -Fqx "$english_scope" "$note" || {
  echo 'release note must limit manual replacement to older HiveOS installations that did not update' >&2
  exit 1
}
grep -Fqx "$traditional_scope" "$note" || {
  echo 'release note must contain the equivalent Traditional Chinese manual-upgrade scope' >&2
  exit 1
}

command_count=$(grep -Fxc "$upgrade_command" "$note" || true)
[[ $command_count -eq 1 ]] || {
  echo "release note must contain exactly one unsplit version-derived HiveOS upgrade command; found $command_count" >&2
  exit 1
}

troubleshooting_count=$(grep -Fxc "$troubleshooting_line" "$note" || true)
[[ $troubleshooting_count -eq 1 ]] || {
  echo "release note must contain exactly one unsplit, current-version public troubleshooting command; found $troubleshooting_count" >&2
  exit 1
}
all_troubleshooting_count=$(grep -Fc '`(miner stop || true) && cd "$(mktemp -d /tmp/' "$note" || true)
[[ $all_troubleshooting_count -eq 1 ]] || {
  echo "release note contains a missing, duplicate, wrapped, or stale foreground troubleshooting command; found $all_troubleshooting_count" >&2
  exit 1
}

echo "INVminer release-note HiveOS upgrade/troubleshooting contract: OK version=$version"
