#!/usr/bin/env bash
set -euo pipefail

root=$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)
cd "$root"

bad=0
while IFS= read -r path; do
  case "$path" in
    .github/workflows/*|.gitlab-ci.yml)
      echo "hosted CI is forbidden: $path" >&2
      bad=1
      ;;
    *.rs|*.cu|*.cuh|Cargo.toml|Cargo.lock|vendor/*|target/*|*.tar|*.tar.gz.enc)
      echo "private/source material is forbidden in Git: $path" >&2
      bad=1
      ;;
  esac
done < <(git ls-files)

if git ls-files -z -- README.md README-AI.md docs release-notes \
  | xargs -0 rg -n -i \
    '\buminer\b|\bo[0-9a-z]{50,}\b|/Users/|/root/|id_ed25519|BEGIN (OPENSSH|RSA|EC|PRIVATE) KEY'; then
  echo "public repository contains legacy branding/endpoint or a private marker" >&2
  bad=1
fi

(( bad == 0 )) || exit 1
echo "INVminer public release boundary: OK"
