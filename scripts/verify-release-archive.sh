#!/usr/bin/env bash
set -euo pipefail

archive=${1:-}
[[ -f "$archive" ]] || {
  echo "usage: $0 <invminer-noid-vX.Y.Z-linux-x86_64-cudaXX.tar.gz>" >&2
  exit 2
}
for command in file rg strings tar; do
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
tar -tzf "$archive" >"$members"
while IFS= read -r member; do
  case "$member" in
    /*|*../*) echo "unsafe archive member: $member" >&2; exit 1 ;;
  esac
done <"$members"
tar -xzf "$archive" -C "$extract"

find "$extract" -type f -print | sed "s|^$extract/||" | sort >"$work/files"
printf 'README.txt\ninvminer-noid\n' >"$work/expected"
diff -u "$work/expected" "$work/files"
[[ -x "$extract/invminer-noid" ]] || { echo "invminer-noid is not executable" >&2; exit 1; }
file "$extract/invminer-noid" | rg -q 'ELF 64-bit.*x86-64'

if strings "$extract/invminer-noid" | rg -n -i \
  'uminer-(noid|modules|watchdog)|\.local/state/uminer|/var/lib/uminer|/Users/|/root/|README-AI|id_ed25519'; then
  echo "binary contains legacy branding/endpoint or a private build identifier" >&2
  exit 1
fi
strings "$extract/invminer-noid" | rg -qi 'INVminer'
strings "$extract/invminer-noid" | rg -q 'stratum\.innovlab\.cc'
rg -qi 'INVminer' "$extract/README.txt"
rg -q 'stratum\+ssl://stratum\.innovlab\.cc:19601' "$extract/README.txt"

echo "INVminer release archive: OK"
