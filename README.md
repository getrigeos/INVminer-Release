# INVminer

Official closed-source NOID and QUAN miner for [InnovLab Pool](https://innovlab.cc).
This repository contains release binaries, checksums, operator documentation,
and release notes. It does not contain miner source or private credentials.

## Current release

The current release is
[v0.1.82](https://github.com/getrigeos/INVminer-Release/releases/tag/v0.1.82).
Download only from that page and verify `SHA256SUMS.txt` before use.

## Commands

NOID on all visible GPUs:

```bash
./invminer --coin noid \
  -o stratum+ssl://eu.innovlab.cc:19601 \
  -u YOUR_NOID_ADDRESS[.WORKER]
```

QUAN on all visible GPUs:

```bash
./invminer --coin quan \
  -o stratum+ssl://eu2.innovlab.cc:17601 \
  -u YOUR_QUANTUS_ADDRESS[.WORKER]
```

NOID CPU-only mode:

```bash
./invminer --coin noid --cpu-only \
  -o stratum+ssl://eu.innovlab.cc:19601 \
  -u YOUR_NOID_ADDRESS[.WORKER]
```

`--coin noid` or `--coin quan` is required. A missing or unsupported coin exits
before network or GPU startup. The worker suffix and `--pass` are optional; an
omitted password uses the compatible value `x`.

When neither `--device` nor `--devices` is supplied, INVminer starts every
visible supported GPU in one process. The GPUs share one user-pool connection
and receive disjoint search domains. Use `--device 0` for one GPU or
`--devices 0,2` for an explicit subset.

NOID endpoints are `eu.innovlab.cc:19601` (Europe) and
`hk.innovlab.cc:19601` (Hong Kong). QUAN defaults to
`eu2.innovlab.cc:17601` (Europe) and also accepts compatible QUAN QUIC, TCP,
and TLS pools selected by the user.

## Downloads

Each version provides two Linux archives and one canonical HiveOS archive:

- `invminer-vX.Y.Z-linux-x86_64-cuda12.tar.gz`
- `invminer-vX.Y.Z-linux-x86_64-cuda13.tar.gz`
- `invminer-X.Y.Z.tar.gz`

Choose the CUDA flavor for host-driver compatibility. The CUDA 12 archive is
the broad compatibility build and is also used by HiveOS. The CUDA 13 archive
requires the CUDA Driver API 13.0 generation. Linux x86_64 requires glibc 2.30
or newer.

Supported embedded NVIDIA architectures include `sm_75`, `sm_80`, `sm_86`,
`sm_89`, and `sm_120`, subject to the package and driver limits in each Release
Note. v0.1.82 integrates the qualified RTX 5090 sparse path and CMP 50HX c2
pipeline while preserving the RTX 4090, A40, RTX 3080, A100 and generic lanes.

## HiveOS

HiveOS requires the package format `<miner-name>-<version>.tar.gz`. For v0.1.82:

- Miner name: `invminer`
- Installation URL: `https://github.com/getrigeos/INVminer-Release/releases/download/v0.1.82/invminer-0.1.82.tar.gz`
- Coin: Custom
- Hash algorithm: leave blank
- Pool URL: use the NOID or QUAN TLS endpoint shown above
- Wallet and worker template: `%WAL%.%WORKER_NAME%`
- Pass: `x`
- Extra config arguments: `--coin noid` or `--coin quan`

No `--devices` argument is needed to use all visible GPUs. The wrapper reports
aggregate and per-GPU statistics through HiveOS.

## Developer fee

NOID uses a 1% developer fee and QUAN uses a 3% developer fee, measured from
effective mining time. Waiting, connection preparation failures, and unavailable
fee work are not charged.

## Binary-only risk and process behavior

The software may be incompatible with a particular GPU, CPU, driver, OS, or
future pool state. Source is not provided, so users cannot independently rebuild,
audit, or patch it. The software is provided without warranty.

Extracting or running INVminer does not install or enable a systemd service,
cron job, scheduled task, login/startup item, registry Run key, or container
restart policy. Hardware controls remain disabled unless explicitly requested.

See the [release policy](docs/RELEASE-POLICY.md) and
[release-note template](release-notes/TEMPLATE.md).
