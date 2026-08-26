# INVminer

Official closed-source GPU miner for [InnovLab Pool](https://innovlab.cc).

This public repository is the release channel for signed/verified INVminer
binary packages. It does **not** contain the proprietary Rust/CUDA mining
source, vendored proof-system source, hardware-control implementation, wallet
material, credentials, private build paths, or infrastructure secrets.

## Current release

The first INVminer-branded candidate is v0.1.42. It was rebuilt from the private
INVminer source with the InnovLab product identity and is not a renamed binary
from an earlier product.

Download only from the [official release page](https://github.com/getrigeos/INVminer/releases/tag/v0.1.42)
and verify the published SHA-256 file before running it.

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

All visible GPUs must share one user-pool connection and receive disjoint
search ranges. Users do not supply mining geometry: physically qualified GPUs
select reviewed defaults, while other supported models use a bounded first-run
auto-tune and save the result under the miner state directory.

## CUDA and GPU packages

INVminer will publish two Linux x86_64 packages, selected by host-driver
compatibility rather than GPU model. Each package is one multi-architecture
binary, not a separate build per card.

| Package | Host boundary | Embedded GPU families | Physical qualification required before first release |
|---|---|---|---|
| CUDA 12 | Driver 535-era and broad compatibility hosts | RTX 30 (`sm_86`), RTX 40 (`sm_89`), RTX 50 (`sm_120`) | RTX 3080, RTX 4070 SUPER, RTX 4090, RTX 5090 as applicable |
| CUDA 13 | Driver API 13.0 / Linux driver 580 or newer | RTX 30 (`sm_86`), RTX 40 (`sm_89`), RTX 50 (`sm_120`) | RTX 4090 and RTX 5090; older-family module-load gates where available |

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
