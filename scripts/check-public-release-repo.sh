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

release_note_files=()
while IFS= read -r -d '' path; do
  [[ -f "$path" ]] && release_note_files+=("$path")
done < <(git ls-files -z -- release-notes)
if (( ${#release_note_files[@]} > 0 )) && rg -n -i '01pool' "${release_note_files[@]}"; then
  echo 'Release Notes must not contain 01pool wording' >&2
  bad=1
fi

if (( ${#public_files[@]} > 0 )) && rg -n -i \
  '\buminer\b|invminer-noid|noid-miner|\bo[0-9a-z]{50,}\b|/Users/|(^|[^[:alnum:]_./-])/root/|id_ed25519|BEGIN (OPENSSH|RSA|EC|PRIVATE) KEY' \
  "${public_files[@]}"; then
  echo "public repository contains legacy branding/endpoint or a private marker" >&2
  bad=1
fi

documented_version=$(sed -nE \
  's#^\[v([0-9]+\.[0-9]+\.[0-9]+)\]\(https://github\.com/getrigeos/INVminer-Release/releases/tag/v[0-9]+\.[0-9]+\.[0-9]+\).*#\1#p' \
  README.md | head -n 1)

# Operator authorization is scoped to these final-package measurements only.
# Keep the complete note pinned even when a later release becomes current.
if [[ -f release-notes/v0.1.74.md ]]; then
  approved_v174_sha256=05d233038add50eea08445377edc9f92ee3a363ed79bc416a65fc26907a2f4ee
  actual_v174_sha256=$(shasum -a 256 release-notes/v0.1.74.md | awk '{print $1}')
  if [[ $actual_v174_sha256 != "$approved_v174_sha256" ]] \
    || ! bash scripts/check-release-note-upgrade.sh 0.1.74 release-notes/v0.1.74.md; then
    echo 'v0.1.74 performance note differs from the approved final-package evidence' >&2
    bad=1
  fi
fi
endpoint_files=(README.md README-AI.md release-notes/TEMPLATE.md)
if [[ -n $documented_version && -f release-notes/v${documented_version}.md ]]; then
  endpoint_files+=("release-notes/v${documented_version}.md")
fi
if rg -n -F 'stratum+ssl://stratum.innovlab.cc' "${endpoint_files[@]}"; then
  echo 'public user commands restored the retired NOID hostname' >&2
  bad=1
fi
for endpoint in \
  'stratum+ssl://eu.innovlab.cc:19601' \
  'stratum+ssl://hk.innovlab.cc:19601'; do
  rg -Fq "$endpoint" README.md README-AI.md release-notes/TEMPLATE.md || {
    echo "public release contract is missing official NOID endpoint: $endpoint" >&2
    bad=1
  }
done

if (( ${#public_files[@]} > 0 )); then
  performance_hits=$(rg -n -i \
    '[0-9]+([.][0-9]+)?[[:space:]]*(k|m|g|t|p|e)?h/s|[0-9]+([.][0-9]+)?[[:space:]]*hash(es)?/s' \
    "${public_files[@]}" || true)
  # The operator explicitly approved only the exact bilingual profile rows
  # below. Keep every exception release-specific; every other numeric mining
  # rate remains blocked.
  unexpected_performance_hits=$(printf '%s\n' "$performance_hits" | rg -v \
    -e '^release-notes/v0\.1\.63\.md:[0-9]+:\| RTX (3080 10GB \| (HiveOS/CUDA 12; INVminer controls|HiveOS／CUDA 12；INVminer 控制) \| 320 W \| 810 MHz \| \+260 MHz \| 64\.386 MH/s|4090 \| (HiveOS/CUDA 12; default clocks|HiveOS／CUDA 12；預設頻率) \| 450 W \| (Default|預設) \| 0 \| 148\.972 MH/s|4090 \| (CUDA 13; operating-system tuning|CUDA 13；作業系統調優) \| 450 W \| 810 MHz \| \+250 MHz \| 161\.447 MH/s|5090 \| (CUDA 13; default clocks|CUDA 13；預設頻率) \| 575 W \| (Default|預設) \| 0 \| 192\.195 MH/s|5090 \| (CUDA 13; operating-system tuning|CUDA 13；作業系統調優) \| 575 W \| 810 MHz \| \+250 MHz \| 204\.917 MH/s) \|$' \
    -e '^release-notes/v0\.1\.64\.md:[0-9]+:\| RTX (3080 10GB \| (Linux CUDA 12; default controls|Linux CUDA 12；預設控制) \| 320 W \| (Default|預設) \| 0 \| 57\.823 MH/s|4070 \| (HiveOS / CUDA 12; default controls|HiveOS／CUDA 12；預設控制) \| 200 W \| (Default|預設) \| 0 \| 56\.243 MH/s|4090 \| (Linux CUDA 13; INVminer tuning|Linux CUDA 13；INVminer 調優) \| 450 W \| 810 MHz \| \+250 MHz \| 161\.054 MH/s|5090 \| (Linux CUDA 13; INVminer tuning|Linux CUDA 13；INVminer 調優) \| 575 W \| 810 MHz \| \+400 MHz \| 231\.271 MH/s) \|$' \
    -e '^release-notes/v0\.1\.65\.md:[0-9]+:\| RTX (3080 10GB \| (Linux CUDA 12; default controls|Linux CUDA 12；預設控制) \| 320 W \| (Default|預設) \| 0 \| 57\.853 MH/s|4070 \| (HiveOS / CUDA 12; default controls|HiveOS／CUDA 12；預設控制) \| 200 W \| (Default|預設) \| 0 \| 57\.581 MH/s|4090 \| (Linux CUDA 13; INVminer tuning|Linux CUDA 13；INVminer 調優) \| 450 W \| 810 MHz \| \+250 MHz \| 165\.109 MH/s|5090 \| (Linux CUDA 13; INVminer tuning|Linux CUDA 13；INVminer 調優) \| 575 W \| 810 MHz \| \+400 MHz \| 231\.928 MH/s) \|$' \
    -e '^release-notes/v0\.1\.70\.md:[0-9]+:\| (NVIDIA CMP 50HX \| Baseline \(v0\.1\.69; unchanged module\) \| 160 W \| Default \| 0 \| 4\.186 MH/s|NVIDIA A100-SXM4-40GB \| Baseline \(v0\.1\.68; unchanged module\) \| 400 W \| Default \| 0 \| 77\.247 MH/s|RTX 3080 10GB \| Baseline \(v0\.1\.65; unchanged module\) \| 320 W \| Default \| 0 \| 57\.853 MH/s|RTX 3080 10GB \| Tuned \(v0\.1\.63; unchanged module\) \| 320 W \| 810 MHz \| \+260 MHz \| 64\.386 MH/s|RTX 4070 \| Baseline \(v0\.1\.70 exact\) \| 200 W \| Default \| 0 \| 57\.419 MH/s|RTX 4090 \| Baseline \(v0\.1\.63; unchanged module\) \| 450 W \| Default \| 0 \| 148\.972 MH/s|RTX 4090 \| Tuned \(v0\.1\.65; unchanged module\) \| 450 W \| 810 MHz \| \+250 MHz \| 165\.109 MH/s|RTX 5090 \| Baseline \(v0\.1\.63; unchanged module\) \| 575 W \| Default \| 0 \| 192\.195 MH/s|RTX 5090 \| Tuned \(v0\.1\.65; unchanged module\) \| 575 W \| 810 MHz \| \+400 MHz \| 231\.928 MH/s) \|$' \
    -e '^release-notes/v0\.1\.71\.md:[0-9]+:\| (NVIDIA CMP 50HX \| Baseline \(v0\.1\.69; unchanged module\) \| 160 W \| Default \| 0 \| 4\.186 MH/s|NVIDIA A100-SXM4-40GB \| Baseline \(v0\.1\.68; unchanged module\) \| 400 W \| Default \| 0 \| 77\.247 MH/s|RTX 3080 10GB \| Baseline \(v0\.1\.65; unchanged module\) \| 320 W \| Default \| 0 \| 57\.853 MH/s|RTX 3080 10GB \| Tuned \(v0\.1\.63; unchanged module\) \| 320 W \| 810 MHz \| \+260 MHz \| 64\.386 MH/s|RTX 4070 \| Baseline \(v0\.1\.71 exact\) \| 200 W \| Default \| 0 \| 57\.424 MH/s|RTX 4090 \| Baseline \(v0\.1\.63; unchanged module\) \| 450 W \| Default \| 0 \| 148\.972 MH/s|RTX 4090 \| Tuned \(v0\.1\.65; unchanged module\) \| 450 W \| 810 MHz \| \+250 MHz \| 165\.109 MH/s|RTX 5090 \| Baseline \(v0\.1\.63; unchanged module\) \| 575 W \| Default \| 0 \| 192\.195 MH/s|RTX 5090 \| Tuned \(v0\.1\.65; unchanged module\) \| 575 W \| 810 MHz \| \+400 MHz \| 231\.928 MH/s) \|$' \
    -e '^release-notes/v0\.1\.71\.md:[0-9]+:seconds, 57\.438 MH/s kernel rate, 186\.77 W average and 190\.93 W peak board power\.$' \
    -e '^release-notes/v0\.1\.73\.md:[0-9]+:\| (NVIDIA CMP 50HX \| Baseline \(v0\.1\.69; unchanged module\) \| 160 W \| Default \| 0 \| 4\.186 MH/s|NVIDIA A100-SXM4-40GB \| Baseline \(v0\.1\.68; unchanged module\) \| 400 W \| Default \| 0 \| 77\.247 MH/s|RTX 3080 10GB \| Baseline \(v0\.1\.65; unchanged module\) \| 320 W \| Default \| 0 \| 57\.853 MH/s|RTX 3080 10GB \| Tuned \(v0\.1\.63; unchanged module\) \| 320 W \| 810 MHz \| \+260 MHz \| 64\.386 MH/s|RTX 4070 \| Baseline \(v0\.1\.73 exact\) \| 200 W \| Default \| 0 \| 57\.366 MH/s|RTX 4090 \| Baseline \(v0\.1\.63; unchanged module\) \| 450 W \| Default \| 0 \| 148\.972 MH/s|RTX 4090 \| Tuned \(v0\.1\.65; unchanged module\) \| 450 W \| 810 MHz \| \+250 MHz \| 165\.109 MH/s|RTX 5090 \| Baseline \(v0\.1\.63; unchanged module\) \| 575 W \| Default \| 0 \| 192\.195 MH/s|RTX 5090 \| Tuned \(v0\.1\.65; unchanged module\) \| 575 W \| 810 MHz \| \+400 MHz \| 231\.928 MH/s) \|$' \
    -e '^release-notes/v0\.1\.73\.md:[0-9]+:seconds, 57\.381 MH/s kernel rate, 188\.45 W average and 190\.74 W peak board power\.$' \
    || true)
  if [[ -n $unexpected_performance_hits ]]; then
    printf '%s\n' "$unexpected_performance_hits"
    echo "public release material contains a prohibited mining-rate figure" >&2
    bad=1
  fi
fi

if (( ${#public_files[@]} > 0 )) && rg -n -i \
  '([0-9]+([.][0-9]+)?[[:space:]]*%[[:space:]]*(faster|slower|gain|gains|improvement|higher|lower))|((faster|slower|gain|gains|improvement|higher|lower)[^[:cntrl:]]{0,40}[0-9]+([.][0-9]+)?[[:space:]]*%)|[0-9]+([.][0-9]+)?[[:space:]]*(samples|solutions|candidates|targets?)/s' \
  "${public_files[@]}"; then
  echo "public release material contains a prohibited numerical performance claim" >&2
  bad=1
fi

for required in \
  'invminer-X.Y.Z.tar.gz' \
  '<miner-name>-<version>.tar.gz' \
  'Extra config arguments'; do
  rg -Fq "$required" README.md README-AI.md release-notes/TEMPLATE.md || {
    echo "public HiveOS contract is missing: $required" >&2
    bad=1
  }
done
if rg -n 'invminer-vX\.Y\.Z-hiveos|invminer-vX\.Y\.Z\.tar\.gz' \
  README.md README-AI.md release-notes/TEMPLATE.md; then
  echo "public documentation restored a superseded HiveOS archive name" >&2
  bad=1
fi

current_version=$documented_version
if [[ -z $current_version ]]; then
  echo 'README current release does not expose one parseable X.Y.Z version' >&2
  bad=1
else
  if ! rg -Fq "[v${current_version}](https://github.com/getrigeos/INVminer-Release/releases/tag/v${current_version})" README.md; then
    echo 'README current release label and tag URL versions differ' >&2
    bad=1
  fi
  current_note="release-notes/v${current_version}.md"
  if ! bash scripts/check-release-note-upgrade.sh "$current_version" "$current_note"; then
    echo "current public Release Note failed the mandatory older-HiveOS upgrade gate: $current_note" >&2
    bad=1
  fi
fi

(( bad == 0 )) || exit 1
echo "INVminer public release boundary: OK"
