# INVminer vX.Y.Z

> **Binary-only risk:** this release may not work with every GPU, CPU, driver,
> OS, or future pool state. Source is not provided, so users cannot independently
> rebuild, audit, or patch it and must decide whether to trust the executable and
> published checksums. The software is provided without warranty.

## Release assets

| Asset | Purpose | Embedded lanes | Archive SHA-256 | Binary SHA-256 |
|---|---|---|---|---|
| `invminer-vX.Y.Z-linux-x86_64-cuda12.tar.gz` | Broad/535-era host compatibility | `sm_75`, `sm_86`, `sm_89`, `sm_120`, fallback | `TO_BE_FILLED` | `TO_BE_FILLED` |
| `invminer-vX.Y.Z-linux-x86_64-cuda13.tar.gz` | Driver API 13.0 / Linux driver 580+ | `sm_86`, `sm_89`, `sm_120` | `TO_BE_FILLED` | `TO_BE_FILLED` |
| `invminer-vX.Y.Z-hiveos-linux-x86_64-cuda12.tar.gz` | HiveOS, CUDA 12 flavor | same CUDA 12 lanes | `TO_BE_FILLED` | `TO_BE_FILLED` |
| `invminer-vX.Y.Z-hiveos-linux-x86_64-cuda13.tar.gz` | HiveOS, CUDA 13 flavor | same CUDA 13 lanes | `TO_BE_FILLED` | `TO_BE_FILLED` |

## Required command

```bash
./invminer --coin noid \
  -o stratum+ssl://stratum.innovlab.cc:19601 \
  -u YOUR_NOID_ADDRESS.RIG_NAME \
  -p x
```

The same `invminer` binary selects every supported coin with `--coin`; a
per-coin executable is never published. The archive does not install or enable
any boot service or scheduled startup.

## HiveOS

Use the matching HiveOS archive and set Hash algorithm to `noid`, Pool URL to
the TLS endpoint above, Template to `%WAL%.%WORKER_NAME%`, and Pass to `x`.
Record the installed-archive functional gate for dashboard statistics, username
mapping, extra arguments, and logs.

## Compatibility qualification

| GPU family | SM | CUDA 12 | CUDA 13 | Tested in this release | Functional result |
|---|---:|---|---|---|---|
| Turing / CMP | `sm_75` | Supported | Unsupported | `TO_BE_FILLED` | `TO_BE_FILLED` |
| RTX 30 | `sm_86` | Supported | Supported | `TO_BE_FILLED` | `TO_BE_FILLED` |
| RTX 40 | `sm_89` | Supported | Supported | `TO_BE_FILLED` | `TO_BE_FILLED` |
| RTX 50 | `sm_120` | Supported | Supported | `TO_BE_FILLED` | `TO_BE_FILLED` |

Do not publish hashrate, throughput, optimization percentages, estimated
earnings, or performance comparisons. Public notes may state only compatibility,
pass/fail correctness, recovery evidence, and known boundaries.

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
- exact candidate hashes, archive boundary, GLIBC ceiling, and privacy scans.

## Known boundaries

List every architecture, driver, OS, pool profile, and optional hardware-control
profile that was not physically tested in this release.
