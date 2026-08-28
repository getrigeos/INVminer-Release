#!/usr/bin/env bash
set -euo pipefail

archive=${1:-}
[[ -f "$archive" ]] || {
  echo "usage: $0 <invminer-vX.Y.Z[-hiveos]-linux-x86_64-cudaXX.tar.gz>" >&2
  exit 2
}
for command in file python3 rg strings tar; do
  command -v "$command" >/dev/null || {
    echo "missing verification command: $command" >&2
    exit 1
  }
done

work=$(mktemp -d "${TMPDIR:-/tmp}/invminer-release.XXXXXX")
trap 'rm -rf "$work"' EXIT
members="$work/members"
extract="$work/extract"
mkdir "$extract"
python3 - "$archive" >"$members" <<'PY'
import sys
import tarfile

with tarfile.open(sys.argv[1], "r:gz") as archive:
    for member in archive.getmembers():
        print(member.name)
PY
while IFS= read -r member; do
  case "$member" in
    /*|*../*) echo "unsafe archive member: $member" >&2; exit 1 ;;
  esac
  case "$member" in
    *.rs|*.cu|*.cuh|*/Cargo.toml|*/Cargo.lock|Cargo.toml|Cargo.lock)
      echo "source material is forbidden in release archive: $member" >&2
      exit 1
      ;;
  esac
done <"$members"

if [[ ${archive##*/} == *-hiveos-* ]]; then
  if [[ ! ${archive##*/} =~ ^invminer-v[0-9]+\.[0-9]+\.[0-9]+-hiveos-linux-x86_64\.tar\.gz$ ]]; then
    echo "HiveOS archive name violates the canonical Custom Miner package contract: ${archive##*/}" >&2
    exit 1
  fi
  printf '%s\n' \
    invminer \
    invminer/h-config.sh \
    invminer/h-manifest.conf \
    invminer/h-readme.md \
    invminer/h-run.sh \
    invminer/h-stats.sh \
    invminer/invminer >"$work/expected-members"
  binary=invminer/invminer
  readme=invminer/h-readme.md
else
  printf '%s\n' README.txt invminer >"$work/expected-members"
  binary=invminer
  readme=README.txt
fi
sort -u "$members" >"$work/members.sorted"
sort -u "$work/expected-members" >"$work/expected.sorted"
diff -u "$work/expected.sorted" "$work/members.sorted"

tar -xzf "$archive" -C "$extract"
[[ -x "$extract/$binary" ]] || { echo "invminer is not executable" >&2; exit 1; }
file "$extract/$binary" | rg -q 'ELF 64-bit.*x86-64'
strings "$extract/$binary" >"$work/binary.strings"

if rg -n -i \
  '/Users/|/root/|README-AI|id_ed25519|BEGIN (OPENSSH|RSA|EC|PRIVATE) KEY|01pool' \
  "$work/binary.strings" "$extract/$readme"; then
  echo "archive contains a private build marker, endpoint, or credential" >&2
  exit 1
fi
if rg -n \
  'DEV_FEE_(POLICY|WINDOW_START|PREPARE_START).*address=|DEV_FEE_WINDOW_(START|END)|DEV_FEE_PREPARE_START|SHARE_(SUBMITTED|ACCEPTED|REJECTED) id=|GPU_WORK_SLICE mode=|GPU_HASHRATE device=|submitPlainProof accepted|已连接 gateway:' \
  "$work/binary.strings"; then
  echo "binary contains a forbidden fee-transition, fee-address or high-rate runtime log template" >&2
  exit 1
fi
rg -qi 'INVminer' "$work/binary.strings"
rg -q -- '--coin' "$work/binary.strings"
rg -q 'stratum\.innovlab\.cc' "$work/binary.strings"
rg -qi 'INVminer' "$extract/$readme"

if rg -n -i 'invminer-noid|noid-miner' "$members" "$extract/$readme"; then
  echo "archive contains a forbidden per-coin executable name" >&2
  exit 1
fi

echo "INVminer release archive: OK"
