# INVminer

Public NVIDIA miner with separate **NOID/QUAN** and **Proxima upgrade-6** packages. Developer fees: **NOID 1%, QUAN 5%, Proxima 0%**. Compatible pools are supported.

Current NOID/QUAN release: [v0.2.22](https://github.com/getrigeos/INVminer-Release/releases/tag/v0.2.22). This release excludes Pearl GPU kernels.

Use `invminer --coin noid` or `invminer --coin quan`, with your pool URL and wallet. Explicit `stratum+tcp://` and `stratum+ssl://` select transport; bare `host:port` detects transport automatically.

New releases provide CUDA12/CUDA13 Linux packages and one HiveOS package that chooses the suitable bundled executable. Download assets and their SHA-256/signature files from Releases. [Signing key](trust/README.md).

HiveOS Installation URL: `https://github.com/getrigeos/INVminer-Release/releases/download/v0.2.22/invminer-0.2.22.tar.gz`

## Proxima upgrade-6

Proxima release: [v2.2.0.3](https://github.com/getrigeos/INVminer-Release/releases/tag/v2.2.0.3). This separate package supports Proxima only; keep the NOID/QUAN package for those flight sheets.

HiveOS Installation URL:
https://github.com/getrigeos/INVminer-Release/releases/download/v2.2.0.3/invminer-2.2.0.3.tar.gz

Use `--coin proxima` with your registered 64-hex holder/account ID. Ordered pool URLs:

- `stratum+ssl://global.innovlab.cc:19701`
- `stratum+ssl://eu3.innovlab.cc:19701`

HiveOS wallet template: `%WAL%.%WORKER_NAME%`; extra arguments: `--coin proxima`. Password is optional (default `x`). Default `primary` failover returns to the first recovered endpoint; `--pool-failover-mode rotate` stays on a healthy backup.

[Proxima signing key](trust/PROXIMA.md). Tested GPU models, measured rates and conditions are recorded in the Release Note.

Flight sheets and pool comparison on [rigeos.ai](https://rigeos.ai/?src=invminer-readme), the mining directory:

- NOID: [flight sheet generator](https://rigeos.ai/setup?coin=noid&miner=invminer&src=invminer-readme) (RigeOS / HiveOS / Linux) · [pools, fees and calculator](https://rigeos.ai/coins/noid?src=invminer-readme)
- QUAN: [flight sheet generator](https://rigeos.ai/setup?coin=quan&miner=invminer&src=invminer-readme) (RigeOS / HiveOS / Linux) · [pools, fees and calculator](https://rigeos.ai/coins/quan?src=invminer-readme)

- Proxima: [flight sheet generator](https://rigeos.ai/setup?coin=prox&miner=invminer-proxima&src=invminer-readme) (RigeOS / HiveOS / Linux) · [project risks, pools and software](https://rigeos.ai/coins/prox?src=invminer-readme). The directory uses the separate Proxima package.

For connection or share problems, open the [configuration diagnostics](https://rigeos.ai/diagnose?src=invminer-readme). Before moving a farm, use the [RigeOS migration checklist](https://rigeos.ai/guides/migrate?src=invminer-readme).
