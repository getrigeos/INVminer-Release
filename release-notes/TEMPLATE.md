# INVminer vX.Y.Z

## GPU command

```bash
./invminer --coin noid \
  -o stratum+ssl://eu.innovlab.cc:19601 \
  -u YOUR_NOID_ADDRESS.RIG_NAME
```

Use only an official NOID TLS endpoint: `eu.innovlab.cc:19601` (Europe) or
`hk.innovlab.cc:19601` (Hong Kong). Release examples default to Europe; replace
only the hostname to use Hong Kong.

## CPU-only command

```bash
./invminer --coin noid --cpu-only \
  -o stratum+ssl://eu.innovlab.cc:19601 \
  -u YOUR_NOID_ADDRESS.RIG_NAME
```

> **Binary-only risk:** this release may not work with every GPU, CPU, driver,
> OS, or future pool state. Source is not provided, so users cannot independently
> rebuild, audit, or patch it and must decide whether to trust the executable and
> published checksums. The software is provided without warranty.

## Release assets

| Asset | Purpose | Embedded lanes | Archive SHA-256 | Binary SHA-256 |
|---|---|---|---|---|
| `invminer-vX.Y.Z-linux-x86_64-cuda12.tar.gz` | Broad/535-era host compatibility | `sm_75`, `sm_86`, `sm_89`, `sm_120`, fallback | `TO_BE_FILLED` | `TO_BE_FILLED` |
| `invminer-vX.Y.Z-linux-x86_64-cuda13.tar.gz` | Driver API 13.0 / Linux driver 580+ | `sm_86`, `sm_89`, `sm_120` | `TO_BE_FILLED` | `TO_BE_FILLED` |
| `invminer-X.Y.Z.tar.gz` | Canonical HiveOS `<name>-<version>` package; broad CUDA 12 host flavor | same CUDA 12 lanes | `TO_BE_FILLED` | `TO_BE_FILLED` |

The same `invminer` binary selects every supported coin with `--coin`; a
per-coin executable is never published. The archive does not install or enable
any boot service or scheduled startup.

## HiveOS

Use the exact canonical HiveOS archive name above; do not add tag `v`, platform,
architecture, HiveOS, or CUDA suffixes.
Set Miner name to `invminer`, Installation URL to the canonical HiveOS asset,
Hash algorithm to `noid`, Pool URL to the TLS endpoint above, Template to
`%WAL%.%WORKER_NAME%`, and Pass empty (or `x`; both use the compatible default).
Leave Extra config arguments empty
unless ordinary runtime flags are required; never put another package URL there.
Record the installed-archive functional gate for dashboard statistics, username
mapping, extra arguments, and logs.

### Manual upgrade for older HiveOS installations

Only some older HiveOS installations need this manual replacement. Use it only when HiveOS does not update the installed custom miner after the Installation URL is changed to this release.

```bash
miner stop && cd /tmp && rm -rf invminer && rm -f invminer-X.Y.Z.tar.gz && wget -O invminer-X.Y.Z.tar.gz https://github.com/getrigeos/INVminer-Release/releases/download/vX.Y.Z/invminer-X.Y.Z.tar.gz && tar -xzf invminer-X.Y.Z.tar.gz && mkdir -p /hive/miners/custom/invminer && rm -f /hive/miners/custom/invminer/invminer && cp -af invminer/. /hive/miners/custom/invminer/ && chmod +x /hive/miners/custom/invminer/invminer /hive/miners/custom/invminer/h-*.sh && /hive/miners/custom/invminer/invminer --version && miner start
```

### 舊版 HiveOS 手動升級

僅部分舊版 HiveOS 需要此手動覆蓋；只有在更新 Installation URL 後仍未替換已安裝的 Custom Miner 時才執行。

## Compatibility qualification

| GPU family | SM | CUDA 12 | CUDA 13 | Tested in this release | Functional result |
|---|---:|---|---|---|---|
| Turing / CMP | `sm_75` | Supported | Unsupported | `TO_BE_FILLED` | `TO_BE_FILLED` |
| RTX 30 | `sm_86` | Supported | Supported | `TO_BE_FILLED` | `TO_BE_FILLED` |
| RTX 40 | `sm_89` | Supported | Supported | `TO_BE_FILLED` | `TO_BE_FILLED` |
| RTX 50 | `sm_120` | Supported | Supported | `TO_BE_FILLED` | `TO_BE_FILLED` |

For CUDA 12/HiveOS on `sm_86`, state whether the exact affected model was
physically tested. The package must automatically select its embedded CUDA 12.2
native compatibility profile when the driver rejects the primary image; users
must not be told to switch HiveOS packages or select a module manually.

Do not publish hashrate, throughput, optimization percentages, estimated
earnings, or performance comparisons unless the operator explicitly approves
an exact release-specific disclosure. Such an exception must include GPU model,
power cap and test duration and must have an exact repository-gate allowlist;
it does not authorize unrelated figures. Otherwise public notes state only
compatibility, pass/fail correctness, recovery evidence, and known boundaries.

## Developer fee

State the compiled per-coin rate and effective-work schedule. Never print the
fixed payout address. Do not infer the schedule from raw share-count ratios when
sessions may have different assigned difficulty.

## Reliability evidence

- CPU/GPU exact self-test and native module selection;
- accepted/stale/rejected functional result;
- disconnect and bounded recovery result;
- one shared user connection and disjoint multi-GPU search domains;
- HiveOS argv/statistics validation;
- exact HiveOS `<name>-<version>` parser result and a live packaged-archive gate
  with `ONLINE`, at least one accepted share, zero rejected shares, and passing
  `h-stats`;
- exact candidate hashes, archive boundary, GLIBC ceiling, and privacy scans.

## Known boundaries

List every architecture, driver, OS, pool profile, and optional hardware-control
profile that was not physically tested in this release.
