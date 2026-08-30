#!/usr/bin/env bash
set -euo pipefail

archive=${1:-}
[[ -f "$archive" ]] || {
  echo "usage: $0 <invminer-vX.Y.Z-linux-x86_64-cudaXX.tar.gz|invminer-X.Y.Z.tar.gz>" >&2
  exit 2
}
for command in awk file python3 rg strings tar; do
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

parse_hiveos_name() {
  local name=$1 stem parsed_version parsed_miner
  [[ $name =~ ^invminer-[0-9]+\.[0-9]+\.[0-9]+\.tar\.gz$ ]] || return 1
  stem=${name%.tar.gz}
  parsed_version=${stem##*-}
  parsed_miner=${stem%-$parsed_version}
  [[ $parsed_miner == invminer && $parsed_version =~ ^[0-9]+\.[0-9]+\.[0-9]+$ ]]
}

archive_name=${archive##*/}
hiveos_archive=0
if parse_hiveos_name "$archive_name"; then
  hiveos_archive=1
  hiveos_stem=${archive_name%.tar.gz}
  hiveos_version=${hiveos_stem##*-}
  hiveos_miner=${hiveos_stem%-$hiveos_version}
  for invalid_name in \
    invminer-v0.1.51.tar.gz \
    invminer-v0.1.51-hiveos-linux-x86_64.tar.gz \
    invminer-v0.1.51-hiveos-linux-x86_64-cuda12.tar.gz \
    invminer-v0.1.51-hiveos-linux-x86_64-cuda13.tar.gz; do
    if parse_hiveos_name "$invalid_name"; then
      echo "invalid HiveOS name fixture was accepted: $invalid_name" >&2
      exit 1
    fi
  done
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
  if [[ ! $archive_name =~ ^invminer-v[0-9]+\.[0-9]+\.[0-9]+-linux-x86_64-cuda(12|13)\.tar\.gz$ ]]; then
    echo "archive name violates the INVminer release contract: $archive_name" >&2
    exit 1
  fi
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
if ((hiveos_archive == 1)); then
  manifest_name=$(awk -F= '/^CUSTOM_NAME=/ {print $2; exit}' "$extract/invminer/h-manifest.conf")
  manifest_version=$(awk -F= '/^CUSTOM_VERSION=/ {print $2; exit}' "$extract/invminer/h-manifest.conf")
  [[ $manifest_name == "$hiveos_miner" ]] || {
    echo "HiveOS manifest miner name does not match the archive parser" >&2
    exit 1
  }
  [[ $manifest_version == "$hiveos_version" ]] || {
    echo "HiveOS manifest version does not match the archive parser" >&2
    exit 1
  }
  rg -Fq 'invminer-X.Y.Z.tar.gz' "$extract/invminer/h-readme.md" || {
    echo "HiveOS readme lost the canonical name-version package rule" >&2
    exit 1
  }
fi
strings "$extract/$binary" >"$work/binary.strings"

if ((hiveos_archive == 1)) || [[ $archive_name == *-cuda12.tar.gz ]]; then
  for marker in \
    'cuda12abi7_sm86_clmad' \
    'cuda122_tower_sm86_compat_fallback' \
    'CUDA 12.2 native SM86 compatibility module selected'; do
    rg -Fq "$marker" "$work/binary.strings" || {
      echo "CUDA 12 archive is missing mandatory SM86 compatibility marker: $marker" >&2
      exit 1
    }
  done
fi

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
