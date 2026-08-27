# INVminer

Official closed-source multi-coin miner for [InnovLab Pool](https://innovlab.cc).

This public repository contains release binaries, checksums, operator
documentation, and release notes only. Proprietary Rust/CUDA source,
hardware-control implementation, credentials, wallet material, and private
infrastructure are not published here.

## Current release

The current release is
[v0.1.50](https://github.com/getrigeos/INVminer/releases/tag/v0.1.50). Download
only from that page and verify `SHA256SUMS.txt` before use.

## Required command shape

INVminer has one executable, `invminer`. The algorithm is always selected
explicitly with `--coin`; there are no per-coin executables.

All visible GPUs:

```bash
./invminer --coin noid \
  -o stratum+ssl://stratum.innovlab.cc:19601 \
  -u YOUR_NOID_ADDRESS.RIG_NAME \
  -p x
```

One selected GPU:

```bash
./invminer --coin noid \
  -o stratum+ssl://stratum.innovlab.cc:19601 \
  -u YOUR_NOID_ADDRESS.RIG_NAME \
  -p x \
  --device 0
```

CPU-only mode:

```bash
./invminer --coin noid --cpu-only \
  -o stratum+ssl://stratum.innovlab.cc:19601 \
  -u YOUR_NOID_ADDRESS.RIG_NAME \
  -p x
```

With no device list, supported GPUs share one user-pool connection and use
non-overlapping search ranges. Do not supply GPU geometry, CPU thread count,
batch size, or ISA flags; the miner selects reviewed defaults or a bounded
first-run auto-tune. `--state-dir` is optional and is not part of the normal
command.

## Downloads

Each version provides two ordinary Linux archives and two HiveOS archives:

- `invminer-vX.Y.Z-linux-x86_64-cuda12.tar.gz`
- `invminer-vX.Y.Z-linux-x86_64-cuda13.tar.gz`
- `invminer-vX.Y.Z-hiveos-linux-x86_64-cuda12.tar.gz`
- `invminer-vX.Y.Z-hiveos-linux-x86_64-cuda13.tar.gz`

Choose the CUDA flavor by host-driver compatibility, not by renaming the
binary or downloading a GPU-specific build.

| Flavor | Host boundary | Embedded NVIDIA lanes |
|---|---|---|
| CUDA 12 | Broad compatibility, including 535-era hosts | `sm_75`, `sm_86`, `sm_89`, `sm_120`, plus fallback |
| CUDA 13 | CUDA Driver API 13.0 / Linux driver 580 or newer | `sm_86`, `sm_89`, `sm_120` |

Turing/CMP cards such as CMP 40HX, CMP 50HX, and RTX 2080 Ti must use the CUDA
12 package. RTX 30, RTX 40, and RTX 50 families select their embedded lane at
runtime. Architecture support is not a model-specific performance claim.

## HiveOS

Use the HiveOS archive matching the host driver. In a Custom Miner flight
sheet set:

- Hash algorithm: `noid`
- Pool URL: `stratum+ssl://stratum.innovlab.cc:19601`
- Template: `%WAL%.%WORKER_NAME%`
- Pass: `x`

The wrapper builds `invminer --coin noid ...` as an argv array and reports
aggregate and per-GPU statistics through HiveOS. Installing the archive does
not itself start the miner; HiveOS starts it only after the operator applies a
flight sheet.

## Developer fee

NOID uses a 5% developer fee measured from effective mining time. Waiting,
connection preparation failures, and unavailable fee work are not charged.
The payout identity is private and is not printed in normal logs or public
documentation.

## Binary-only risk and process behavior

The software may be incompatible with a particular GPU, CPU, driver, OS, or
future pool state. Source is not provided, so users cannot independently
rebuild, audit, or patch it and must decide whether to trust the binary and
published checksums. The software is provided without warranty.

Extracting or running INVminer does not install or enable a systemd service,
cron job, scheduled task, login/startup item, registry Run key, or container
restart policy. Hardware-control options are disabled unless explicitly
provided; unsupported optional controls warn and continue at verified
defaults.

Public releases document compatibility and functional qualification but do
not publish numerical hashrate, throughput, optimization percentages,
estimated earnings, or comparative performance.

See [release policy](docs/RELEASE-POLICY.md) and the
[release-notes template](release-notes/TEMPLATE.md).
