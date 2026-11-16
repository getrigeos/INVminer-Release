# INVminer

Public NVIDIA miner with separate **NOID/QUAN** and **Proxima upgrade-6** packages. Developer fees: **NOID 1%, QUAN 5%, Proxima 0%**. Compatible pools are supported.

Current NOID/QUAN release: [v0.2.22](https://github.com/getrigeos/INVminer-Release/releases/tag/v0.2.22). This release excludes Pearl GPU kernels.

Use `invminer --coin noid` or `invminer --coin quan`, with your pool URL and wallet. Explicit `stratum+tcp://` and `stratum+ssl://` select transport; bare `host:port` detects transport automatically.

New releases provide CUDA12/CUDA13 Linux packages and one HiveOS package that chooses the suitable bundled executable. Download assets and their SHA-256/signature files from Releases. [Signing key](trust/README.md).

HiveOS Installation URL: `https://github.com/getrigeos/INVminer-Release/releases/download/v0.2.22/invminer-0.2.22.tar.gz`

## Proxima upgrade-6

Proxima release: [v2.2.0.11](https://github.com/getrigeos/INVminer-Release/releases/tag/v2.2.0.11). This package supports Proxima only; keep the NOID/QUAN package for those flight sheets. Version 2.2.0.8 remains withdrawn.

HiveOS Installation URL:
https://github.com/getrigeos/INVminer-Release/releases/download/v2.2.0.11/invminer-2.2.0.11.tar.gz

Use `--coin proxima` with your registered 64-hex holder/account ID. Recommended ordered pools:

| Region | Primary | Backup 1 | Backup 2 |
|---|---|---|---|
| Asia | `stratum+ssl://fast-hk1.innovlab.cc:19701` | `stratum+ssl://fast-hk2.innovlab.cc:19701` | `stratum+ssl://hk.innovlab.cc:19701` |
| Europe | `stratum+ssl://fast1-ru.innovlab.cc:19701` | `stratum+ssl://fast2-ru.innovlab.cc:19701` | `stratum+ssl://eu3.innovlab.cc:19701` |

HiveOS wallet template: `%WAL%.%WORKER_NAME%`; extra arguments: `--coin proxima`. Enter the ordered pool URLs on separate lines. Password: `x`. The default `primary` mode returns after successful primary probes; `--pool-failover-mode rotate` stays on a healthy backup. The release note includes explicit default thresholds and Linux/Windows examples.

Default mode prioritizes mining throughput while reducing CPU overhead. Optional `--proxima-cpu-mode low` trades longer batches for fewer CPU wakeups and may slightly reduce hashrate; omit it to keep the default.

[Proxima signing key](trust/PROXIMA.md). Tested GPU models, CPU use, measured rates and conditions are recorded in the Release Note.

Flight sheets and pool comparison on [rigeos.ai](https://rigeos.ai/?src=invminer-readme), the mining directory:

- NOID: [flight sheet generator](https://rigeos.ai/setup?coin=noid&miner=invminer&src=invminer-readme) (RigeOS / HiveOS / Linux) · [pools, fees and calculator](https://rigeos.ai/coins/noid?src=invminer-readme)
- QUAN: [flight sheet generator](https://rigeos.ai/setup?coin=quan&miner=invminer&src=invminer-readme) (RigeOS / HiveOS / Linux) · [pools, fees and calculator](https://rigeos.ai/coins/quan?src=invminer-readme)

- Proxima: [flight sheet generator](https://rigeos.ai/setup?coin=prox&miner=invminer-proxima&src=invminer-readme) (RigeOS / HiveOS / Linux) · [project risks, pools and software](https://rigeos.ai/coins/prox?src=invminer-readme). The directory uses the separate Proxima package.

For connection or share problems, open the [configuration diagnostics](https://rigeos.ai/diagnose?src=invminer-readme). Before moving a farm, use the [RigeOS migration checklist](https://rigeos.ai/guides/migrate?src=invminer-readme).

## Proxima for Windows

Windows x64: [v2.2.0.11](https://github.com/getrigeos/INVminer-Release/releases/tag/v2.2.0.11).

https://github.com/getrigeos/INVminer-Release/releases/download/v2.2.0.11/invminer-v2.2.0.11-windows-x86_64.zip

Extract the ZIP and run `start-proxima.bat`; enter a registered 64-hex holder/account ID. Asia is the default; add `-Region europe` for Europe. Optional `-CpuMode low` selects lower CPU usage; the default remains performance-first. Proxima only, 0% developer fee. Physical GPU, OS, driver and power conditions are listed in the release note; Linux gains are not Windows guarantees.
