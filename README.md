# INVminer

Official closed-source GPU miner for [InnovLab Pool](https://innovlab.cc).

This public repository is the release channel for signed/verified INVminer
binary packages. It does **not** contain the proprietary Rust/CUDA mining
source, vendored proof-system source, hardware-control implementation, wallet
material, credentials, private build paths, or infrastructure secrets.

## Current release

The current release is v0.1.47. It was rebuilt reproducibly from the private
INVminer source with the InnovLab product identity.

Download only from the [official release page](https://github.com/getrigeos/INVminer/releases/tag/v0.1.47)
and verify the published SHA-256 file before running it.

v0.1.47 adds an explicit CPU-only NOID mode with runtime-selected AVX-512 or
AVX2 packed execution. Normal GPU mode remains CUDA-only and never creates a
CPU nonce-search pool. It also retains the status, monitoring, recovery,
thermal protection and persistent developer-fee controls introduced in
v0.1.45. See the release page for exact GPU/CPU measurements and live-pool
acceptance/recovery evidence.

## Binary-only risk notice

This repository provides closed-source binaries only. A package may be
incompatible with a particular GPU, driver, OS or pool state and may stop
working after external protocol changes. Because source is not provided, users
cannot independently rebuild, audit or patch the miner and must decide whether
to trust the published binary and checksums.

## Required connection

The production command shape is:

```bash
./invminer-noid \
  --pool stratum+ssl://stratum.innovlab.cc:19601 \
  --worker YOUR_NOID_ADDRESS.RIG_NAME
```

Single GPU:

```bash
./invminer-noid \
  --pool stratum+ssl://stratum.innovlab.cc:19601 \
  --worker YOUR_NOID_ADDRESS.RIG_NAME \
  --device 0
```

CPU-only mode:

```bash
./invminer-noid \
  --cpu-only \
  --pool stratum+ssl://stratum.innovlab.cc:19601 \
  --worker YOUR_NOID_ADDRESS.RIG_NAME
```

All visible GPUs must share one user-pool connection and receive disjoint
search ranges. Users do not supply mining geometry: physically qualified GPUs
select reviewed defaults, while other supported models use a bounded first-run
auto-tune and save the result under the miner state directory.

Do not provide CPU threads, CPU batch size or ISA flags. CPU-only mode selects
the best supported backend and all logical CPUs visible to the process. The
normal commands intentionally omit `--state-dir`; INVminer chooses a persistent
per-user location automatically. Managed services may set
`INVMINER_STATE_DIR`, and an explicit absolute `--state-dir` is optional.

## CUDA and GPU packages

INVminer publishes two Linux x86_64 packages, selected by host-driver
compatibility rather than GPU model. Each package is one multi-architecture
binary, not a separate build per card.

| Package | Host boundary | Embedded GPU families | Qualification evidence |
|---|---|---|---|
| CUDA 12 | Driver 535-era and broad compatibility hosts | RTX 30 (`sm_86`), RTX 40 (`sm_89`), RTX 50 (`sm_120`), plus tower fallback | RTX 3080, RTX 4070 SUPER and RTX 4090 physically tested; RTX 5090 module evidence requires a new driver |
| CUDA 13 | Driver API 13.0 / Linux driver 580 or newer | RTX 30 (`sm_86`), RTX 40 (`sm_89`), RTX 50 (`sm_120`) | RTX 4090 and RTX 5090 physically tested; older-family module-load gates where available |

Architecture support is not a performance claim for every model. Each release
page must distinguish tested cards from architecture-compatible but untested
cards and include the exact command, driver, CUDA flavor, hashrate unit, power
limit and measured average/peak power.

## Optional hardware controls

Hardware-control arguments are optional. A release page may recommend a power
or clock profile only for the exact coin/GPU combination that was physically
qualified. An unsupported control operation must warn and continue at verified
default settings; an incomplete rollback must fail cleanly so a service manager
can restart without leaving a silent zero-hash process.

## Release integrity

Every release must provide:

- `invminer-noid-vX.Y.Z-linux-x86_64-cuda12.tar.gz`;
- `invminer-noid-vX.Y.Z-linux-x86_64-cuda13.tar.gz`;
- `SHA256SUMS.txt`;
- release notes containing commands, compatibility and physical test evidence.

The public package contains only the stripped `invminer-noid` executable and
its operator `README.txt`. Run `scripts/verify-release-archive.sh` before an
upload. GitHub Actions, GitLab CI and other hosted build/release automation are
forbidden; builds and physical gates run outside GitHub and assets are uploaded
manually.

See [release policy](docs/RELEASE-POLICY.md) and the
[release-notes template](release-notes/TEMPLATE.md).
