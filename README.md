# INVminer

Official closed-source NOID miner for [InnovLab Pool](https://innovlab.cc).

This public repository contains release binaries, checksums, operator
documentation, and release notes only. Proprietary Rust/CUDA source,
hardware-control implementation, credentials, wallet material, and private
infrastructure are not published here.

## Current release

The current release is
[v0.1.55](https://github.com/getrigeos/INVminer-Release/releases/tag/v0.1.55). Download
only from that page and verify `SHA256SUMS.txt` before use.

## Required command shape

INVminer has one executable, `invminer`. The algorithm is always selected
explicitly with `--coin`; there are no per-coin executables. The current public
release supports only `--coin noid` and does not include other coin CUDA modules.

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

NOID accepts only WebPKI-verified TLS in v0.1.55. Plaintext Stratum/TCP,
insecure TLS, and operator certificate pins are rejected before device startup.
A valid public-CA certificate renewal for the same hostname, including a new
leaf key, requires no miner configuration change.

## Optional NVIDIA controls

v0.1.55 can apply the reviewed NVIDIA settings from the `invminer` command
itself. The supported controls are `--power-limit`, `--lock-core` (core upper
bound), `--locked-core-clock` (fixed core), `--lock-mem` (fixed memory clock),
and `--core-clock-offset`. Core-offset users may also select
`--nvidia-display` and `--nvidia-xauthority` for `nvidia-settings`.

For example, the miner can own a reviewed RTX 4090 power and memory profile:

```bash
./invminer --coin noid --devices 0 --power-limit 450 --lock-mem 810 \
  -o stratum+ssl://stratum.innovlab.cc:19601 \
  -u YOUR_NOID_ADDRESS.RIG_NAME \
  -p x
```

`--lock-core` and `--locked-core-clock` are mutually exclusive. An unsupported
clock, missing driver permission, or unavailable display produces a warning and
mining continues at the verified original/default state. If a partially applied
profile cannot be rolled back safely, the miner stops instead of running under
unknown settings.

## Downloads

Each version provides two ordinary Linux archives and one canonical HiveOS archive:

- `invminer-vX.Y.Z-linux-x86_64-cuda12.tar.gz`
- `invminer-vX.Y.Z-linux-x86_64-cuda13.tar.gz`
- `invminer-X.Y.Z.tar.gz`

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

The canonical HiveOS archive uses the broad CUDA 12 host-compatibility flavor;
its filename intentionally has no CUDA suffix because HiveOS validates the
Custom Miner package name. For v0.1.55, set:

- Miner name: `invminer`
- Installation URL: `https://github.com/getrigeos/INVminer-Release/releases/download/v0.1.55/invminer-0.1.55.tar.gz`
- Hash algorithm: `noid`
- Pool URL: `stratum+ssl://stratum.innovlab.cc:19601`
- Wallet and worker template: `%WAL%.%WORKER_NAME%`
- Pass: `x`
- Extra config arguments: leave empty unless ordinary runtime options are
  required; never put an alternate package URL here

HiveOS requires the package format `<miner-name>-<version>.tar.gz`; the tag's
leading `v` and platform/CUDA labels are not part of this filename. There is no
separate CUDA 12 or CUDA 13 HiveOS URL. The single package already contains the
broad CUDA 12 host build.

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
