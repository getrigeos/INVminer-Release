#!/usr/bin/env bash
set -euo pipefail

archive=${1:-}
[[ -f "$archive" ]] || {
  echo "usage: $0 <invminer-noid-vX.Y.Z-linux-x86_64-cudaXX.tar.gz>" >&2
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
done <"$members"
printf 'README.txt\ninvminer-noid\n' >"$work/expected-members"
diff -u "$work/expected-members" "$members"
tar -xzf "$archive" -C "$extract"

find "$extract" -type f -print | sed "s|^$extract/||" | sort >"$work/files"
printf 'README.txt\ninvminer-noid\n' >"$work/expected"
diff -u "$work/expected" "$work/files"
[[ -x "$extract/invminer-noid" ]] || { echo "invminer-noid is not executable" >&2; exit 1; }
file "$extract/invminer-noid" | rg -q 'ELF 64-bit.*x86-64'
strings "$extract/invminer-noid" >"$work/binary.strings"

if rg -n -i \
  'uminer-(noid|modules|watchdog)|\.local/state/uminer|/var/lib/uminer|/Users/|/root/|README-AI|id_ed25519' \
  "$work/binary.strings"; then
  echo "binary contains legacy branding/endpoint or a private build identifier" >&2
  exit 1
fi
if rg -n \
  'DEV_FEE_(POLICY|WINDOW_START|PREPARE_START).*address=|DEV_FEE_WINDOW_(START|END)|DEV_FEE_PREPARE_START|SHARE_(SUBMITTED|ACCEPTED|REJECTED) id=|GPU_WORK_SLICE mode=|GPU_HASHRATE device=|submitPlainProof accepted|已连接 gateway:' \
  "$work/binary.strings"; then
  echo "binary contains a forbidden fee-transition, fee-address or high-rate runtime log template" >&2
  exit 1
fi
rg -qi 'INVminer' "$work/binary.strings"
rg -q 'stratum\.innovlab\.cc' "$work/binary.strings"
rg -qi 'INVminer' "$extract/README.txt"
rg -q 'stratum\+ssl://stratum\.innovlab\.cc:19601' "$extract/README.txt"

echo "INVminer release archive: OK"
