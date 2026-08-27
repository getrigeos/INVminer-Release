# INVminer

Official closed-source GPU miner for [InnovLab Pool](https://innovlab.cc).

This public repository is the release channel for signed/verified INVminer
binary packages. It does **not** contain the proprietary Rust/CUDA mining
source, vendored proof-system source, hardware-control implementation, wallet
material, credentials, private build paths, or infrastructure secrets.

## Public release status

No public binary release is currently offered. All previous GitHub Releases and
their downloadable assets were withdrawn on 2026-08-27. Existing Git tags are
historical markers only and are not binary download commitments.

Future public releases, if any, will document compatibility, integrity and
reliability but will not publish hashrate, throughput or comparative performance
figures.

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

If public distribution resumes, INVminer uses two Linux x86_64 packages selected
by host-driver compatibility rather than GPU model. Each package is one
multi-architecture binary, not a separate build per card.

| Package | Host boundary | Embedded GPU families | Qualification evidence |
|---|---|---|---|
| CUDA 12 | Driver 535-era and broad compatibility hosts | optimized Turing/CMP (`sm_75`), RTX 30 (`sm_86`), RTX 40 (`sm_89`), RTX 50 (`sm_120`), plus tower fallback | CMP 40HX, CMP 50HX, RTX 2080 Ti, RTX 3080, RTX 4070 SUPER and RTX 4090 physically tested; RTX 5090 module evidence requires a new driver |
| CUDA 13 | Driver API 13.0 / Linux driver 580 or newer | RTX 30 (`sm_86`), RTX 40 (`sm_89`), RTX 50 (`sm_120`) | RTX 4090 and RTX 5090 physically tested; older-family module-load gates where available |

Architecture support is not a performance claim for every model. Each release
page must distinguish tested cards from architecture-compatible but untested
cards and include the exact command, driver, CUDA flavor and functional gate
status. Public material must not publish hashrate or comparative performance.

CMP 40HX, CMP 50HX and RTX 2080 Ti are supported by the CUDA 12 package's
optimized native shared-GF8 `sm_75` lane. They are not supported by the CUDA 13
package; use the CUDA 12 asset on these cards.

## Optional hardware controls

Hardware-control arguments are optional. A release page may recommend a power
or clock profile only for the exact coin/GPU combination that was physically
qualified. An unsupported control operation must warn and continue at verified
default settings; an incomplete rollback must fail cleanly so a service manager
can restart without leaving a silent zero-hash process.

## Release integrity

Any future release must provide:

- `invminer-noid-vX.Y.Z-linux-x86_64-cuda12.tar.gz`;
- `invminer-noid-vX.Y.Z-linux-x86_64-cuda13.tar.gz`;
- `SHA256SUMS.txt`;
- release notes containing commands, compatibility and functional physical-test
  evidence without hashrate or comparative performance figures.

The public package contains only the stripped `invminer-noid` executable and
its operator `README.txt`. Run `scripts/verify-release-archive.sh` before an
upload. GitHub Actions, GitLab CI and other hosted build/release automation are
forbidden; builds and physical gates run outside GitHub and assets are uploaded
manually.

See [release policy](docs/RELEASE-POLICY.md) and the
[release-notes template](release-notes/TEMPLATE.md).
