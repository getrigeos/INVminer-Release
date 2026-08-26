# INVminer NOID GPU Miner vX.Y.Z

> **Binary-only risk:** this release may not work with every GPU, driver, OS or
> pool state. Source is not provided, so users cannot independently rebuild,
> audit or patch it and must decide whether to trust the binary and checksums.

## Release assets

| Asset | Host/driver purpose | Embedded lanes | Archive SHA-256 | Binary SHA-256 |
|---|---|---|---|---|
| `invminer-noid-vX.Y.Z-linux-x86_64-cuda12.tar.gz` | Driver 535-era/broad compatibility | `sm_86`, `sm_89`, `sm_120` | `TO_BE_FILLED` | `TO_BE_FILLED` |
| `invminer-noid-vX.Y.Z-linux-x86_64-cuda13.tar.gz` | Driver API 13.0 / driver 580+ | `sm_86`, `sm_89`, `sm_120` | `TO_BE_FILLED` | `TO_BE_FILLED` |

## Required command

```bash
./invminer-noid \
  --pool stratum+ssl://stratum.innovlab.cc:19601 \
  --worker YOUR_NOID_ADDRESS.RIG_NAME
```

## GPU qualification

| GPU | SM | Package | Driver | Tested | Hashrate | Power limit | Average / peak power | Complete command | Difference |
|---|---|---|---|---:|---|---:|---|---|---|
| RTX 3080 | `sm_86` | `TO_BE_FILLED` | `TO_BE_FILLED` | No | — | — | — | — | qualification pending |
| RTX 4070 SUPER | `sm_89` | `TO_BE_FILLED` | `TO_BE_FILLED` | No | — | — | — | — | qualification pending |
| RTX 4090 | `sm_89` | `TO_BE_FILLED` | `TO_BE_FILLED` | No | — | — | — | — | qualification pending |
| RTX 5090 | `sm_120` | `TO_BE_FILLED` | `TO_BE_FILLED` | No | — | — | — | — | qualification pending |

### Measurement interpretation

For every performance row, state whether hardware controls were omitted or
explicitly applied, and report measured average/peak power. If a result differs
materially from an older release, run an old exact binary on the same host when
possible. Do not label a cross-host difference as a miner optimization, driver
gain, or universal GPU baseline unless a controlled same-card A/B isolates that
variable. Preserve a conservative cross-host baseline alongside exceptional
high-power host results.

## Developer fee

State the compiled rate, effective-GPU-time schedule, failover behavior and
exact pool-side accounting evidence for this candidate. Never print the fixed
payout address in public material. Do not use raw share-count ratios when the
user and fee sessions may have different variable difficulties.

## Reliability evidence

- accepted / stale / rejected totals and observation duration;
- disconnect and bounded-backoff recovery;
- GPU watchdog and CUDA-context recovery;
- multi-GPU connection count and search-domain uniqueness;
- optional hardware-control failure and rollback behavior;
- exact-candidate tests, formatting, lints, binary inspection and GLIBC ceiling.

## Unsupported or untested boundaries

List every architecture, driver, OS, pool profile and hardware-control profile
that is compatible by design but was not physically tested in this release.
