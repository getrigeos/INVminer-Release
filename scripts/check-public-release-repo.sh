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

public_files=()
while IFS= read -r -d '' path; do
  [[ -f "$path" ]] && public_files+=("$path")
done < <(git ls-files -z -- README.md README-AI.md docs release-notes)

if (( ${#public_files[@]} > 0 )) && rg -n -i \
  '\buminer\b|invminer-noid|noid-miner|\bo[0-9a-z]{50,}\b|/Users/|/root/|id_ed25519|BEGIN (OPENSSH|RSA|EC|PRIVATE) KEY' \
  "${public_files[@]}"; then
  echo "public repository contains legacy branding/endpoint or a private marker" >&2
  bad=1
fi

if (( ${#public_files[@]} > 0 )) && rg -n -i \
  '[0-9]+([.][0-9]+)?[[:space:]]*(k|m|g|t|p|e)?h/s|[0-9]+([.][0-9]+)?[[:space:]]*hash(es)?/s' \
  "${public_files[@]}"; then
  echo "public release material contains a prohibited mining-rate figure" >&2
  bad=1
fi

if (( ${#public_files[@]} > 0 )) && rg -n -i \
  '([0-9]+([.][0-9]+)?[[:space:]]*%[[:space:]]*(faster|slower|gain|gains|improvement|higher|lower))|((faster|slower|gain|gains|improvement|higher|lower)[^[:cntrl:]]{0,40}[0-9]+([.][0-9]+)?[[:space:]]*%)|[0-9]+([.][0-9]+)?[[:space:]]*(samples|solutions|candidates|targets?)/s' \
  "${public_files[@]}"; then
  echo "public release material contains a prohibited numerical performance claim" >&2
  bad=1
fi

(( bad == 0 )) || exit 1
echo "INVminer public release boundary: OK"
