# INVminer

Public NVIDIA miner for **NOID and QUAN**. Developer fees: **NOID 1%, QUAN 5%**. Compatible third-party pools are supported.

Current published release: [v0.2.22](https://github.com/getrigeos/INVminer-Release/releases/tag/v0.2.22). This release excludes Pearl GPU kernels.

Use `invminer --coin noid` or `invminer --coin quan`, with your pool URL and wallet. Explicit `stratum+tcp://` and `stratum+ssl://` select transport; bare `host:port` detects transport automatically.

New releases provide CUDA12/CUDA13 Linux packages and one HiveOS package that chooses the suitable bundled executable. Download assets and their SHA-256/signature files from Releases. [Signing key](trust/README.md).

HiveOS Installation URL: `https://github.com/getrigeos/INVminer-Release/releases/download/v0.2.22/invminer-0.2.22.tar.gz`
