#!/usr/bin/env bash
set -euo pipefail

archive=${1:-}
[[ -f "$archive" ]] || {
  echo "usage: $0 <invminer-vX.Y.Z-linux-x86_64-cudaXX.tar.gz|invminer-X.Y.Z.tar.gz>" >&2
  exit 2
}
for command in awk bash file jq python3 rg sha256sum strings tar; do
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
normalized_members="$work/members.normalized"
sed -E 's#^\./##' "$members" | sed -e '/^$/d' -e '/^\.$/d' >"$normalized_members"
if [[ $(sort "$normalized_members" | uniq -d | wc -l | awk '{print $1}') != 0 ]]; then
  echo "archive contains duplicate normalized member names" >&2
  exit 1
fi

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
full_package=0
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
  ordinary_version=${archive_name#invminer-v}
  ordinary_version=${ordinary_version%%-linux-*}
  if rg -Fxq 'BUILD-MANIFEST.json' "$normalized_members"; then
    full_package=1
    printf '%s\n' \
      BUILD-MANIFEST.json \
      ERROR-CATALOG-SCHEMA.json \
      ERROR-CATALOG.json \
      EULA.txt \
      README.txt \
      RELEASE-KEY-METADATA.json \
      RELEASE-REVOKED-KEYS.txt \
      SBOM.cargo-metadata.json \
      THIRD-PARTY-NOTICES.txt \
      h-config.sh \
      h-manifest.conf \
      h-readme.md \
      h-run.sh \
      h-stats.sh \
      invminer \
      invminer-config.example.json >"$work/expected-members"
  else
    printf '%s\n' README.txt invminer >"$work/expected-members"
  fi
  binary=invminer
  readme=README.txt
fi
sort -u "$normalized_members" >"$work/members.sorted"
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
if ((full_package == 1)); then
  for executable in h-config.sh h-run.sh h-stats.sh; do
    [[ -x "$extract/$executable" ]] || {
      echo "full release package contains a non-executable adapter: $executable" >&2
      exit 1
    }
  done
  bash -n "$extract/h-config.sh" "$extract/h-run.sh" "$extract/h-stats.sh"
  jq -e --arg version "$ordinary_version" --arg archive "$archive_name" '
    .product == "invminer"
    and .version == $version
    and .release_channel == "public"
    and .user_pool_endpoint_policy == "coin-specific-v1"
    and .user_pool_endpoint_policies.noid == "public-approved-tls-domains-v1"
    and .user_pool_endpoint_policies.quan == "quan-compatible-tcp-tls-quic-endpoints-v2"
    and (.source_commit | test("^[0-9a-f]{40}$"))
    and (.cuda_flavor == (if ($archive | contains("-cuda12.")) then "cuda12" else "cuda13" end))
    and .fee_assets.release_mode == "active"
    and .fee_assets.configured_coin_ppm == {"noid":10000,"quan":20000}
    and .fee_assets.catalog_coin_ppm == .fee_assets.configured_coin_ppm
  ' "$extract/BUILD-MANIFEST.json" >/dev/null || {
    echo "full release package build manifest violates the public contract" >&2
    exit 1
  }
  jq -e '
    .schema_version == 1
    and .key_id == "invminer-release-2026-ed25519"
    and .fingerprint_algorithm == "sha256-spki-der"
    and .public_key_sha256 == "5dfba8946575cd2dcc95aea2a384427cd9cf42ef8ac670fc85e775db9128fb20"
    and .status == "active"
    and (.trust_anchor_url | startswith("https://raw.githubusercontent.com/getrigeos/INVminer-Release/"))
  ' "$extract/RELEASE-KEY-METADATA.json" >/dev/null || {
    echo "full release package key metadata violates the public trust-anchor contract" >&2
    exit 1
  }
  [[ $(sha256sum "$extract/ERROR-CATALOG.json" | awk '{print $1}') == \
    $(jq -r .error_catalog.sha256 "$extract/BUILD-MANIFEST.json") ]] || {
    echo "full release package error catalog digest mismatch" >&2
    exit 1
  }
  [[ $(sha256sum "$extract/ERROR-CATALOG-SCHEMA.json" | awk '{print $1}') == \
    $(jq -r .error_catalog.schema_sha256 "$extract/BUILD-MANIFEST.json") ]] || {
    echo "full release package error schema digest mismatch" >&2
    exit 1
  }
  [[ $(awk -F= '/^CUSTOM_VERSION=/ {print $2; exit}' "$extract/h-manifest.conf") == "$ordinary_version" ]] || {
    echo "full release package HiveOS manifest version mismatch" >&2
    exit 1
  }
fi
strings "$extract/$binary" >"$work/binary.strings"
# Rust panic locations can retain the builder's standard crates.io registry
# prefix. It identifies public dependencies rather than the private source
# checkout. Normalize only that fixed prefix before the private-path scan so
# /root/projects, user directories and every other /root path remain blocked.
sed -E \
  's#/root/\.cargo/registry/src/index\.crates\.io-[0-9a-f]+/#/cargo/registry/#g' \
  "$work/binary.strings" >"$work/binary.strings.public-scan"

if ((hiveos_archive == 1)) || [[ $archive_name == *-cuda12.tar.gz ]]; then
  for marker in \
    'cuda133abi8_sm80_clmad_r4_allbyte64_mixed9_persistent_v1' \
    'cuda122_sm80_gf8_shared_compat_v1' \
    'cuda12abi7_sm86_clmad' \
    'cuda122_tower_sm86_compat_fallback' \
    'cuda122_tower_sm89_compat_fallback' \
    'reviewed CUDA compatibility module selected'; do
    rg -Fq "$marker" "$work/binary.strings" || {
      echo "CUDA 12 archive is missing mandatory SM86 compatibility marker: $marker" >&2
      exit 1
    }
  done
fi

if rg -n -i \
  '/Users/|(^|[^[:alnum:]_./-])/root/|README-AI|id_ed25519|BEGIN (OPENSSH|RSA|EC|PRIVATE) KEY' \
  "$work/binary.strings.public-scan" "$extract/$readme"; then
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
