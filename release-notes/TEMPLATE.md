# INVminer NOID GPU Miner vX.Y.Z

> **Binary-only risk:** this release may not work with every GPU, driver, OS or
> pool state. Source is not provided, so users cannot independently rebuild,
> audit or patch it and must decide whether to trust the binary and checksums.
>
> A normally published release remains available by default. Withdrawal is only
> for a recorded version-specific security, integrity or correctness reason, or
> an explicit operator decision; it is not an automatic post-release step.

## Release assets

| Asset | Host/driver purpose | Embedded lanes | Archive SHA-256 | Binary SHA-256 |
|---|---|---|---|---|
| `invminer-noid-vX.Y.Z-linux-x86_64-cuda12.tar.gz` | Driver 535-era/broad compatibility | `sm_75`, `sm_86`, `sm_89`, `sm_120`, tower fallback | `TO_BE_FILLED` | `TO_BE_FILLED` |
| `invminer-noid-vX.Y.Z-linux-x86_64-cuda13.tar.gz` | Driver API 13.0 / driver 580+ | `sm_86`, `sm_89`, `sm_120` | `TO_BE_FILLED` | `TO_BE_FILLED` |

## Required command

```bash
./invminer-noid \
  --pool stratum+ssl://stratum.innovlab.cc:19601 \
  --worker YOUR_NOID_ADDRESS.RIG_NAME
```

The binary does not install or enable any boot service or scheduled startup.
Document any optional process-manager template as a separate explicit operator
action; installing or extracting the archive must leave the miner stopped.

## GPU compatibility qualification

| GPU | SM | Package | Driver | Physically tested | Complete command | Functional result |
|---|---|---|---|---:|---|---|
| RTX 3080 | `sm_86` | `TO_BE_FILLED` | `TO_BE_FILLED` | No | — | qualification pending |
| RTX 4070 SUPER | `sm_89` | `TO_BE_FILLED` | `TO_BE_FILLED` | No | — | qualification pending |
| RTX 4090 | `sm_89` | `TO_BE_FILLED` | `TO_BE_FILLED` | No | — | qualification pending |
| RTX 5090 | `sm_120` | `TO_BE_FILLED` | `TO_BE_FILLED` | No | — | qualification pending |

### Public performance boundary

Do not publish hashrate, throughput, optimization percentages, estimated
earnings or performance comparisons with another miner or an earlier INVminer
version. Keep numerical benchmarks in the private engineering repository.
Public notes may state only compatibility, pass/fail correctness, recovery
evidence and known boundaries.

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
