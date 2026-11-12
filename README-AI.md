# INVminer public release repository

Release Note review is a mandatory publication gate for every release and text correction. Read [the review contract](docs/RELEASE-NOTE-GATE.md). The repository check requires a review bound to each current note; verify the fresh live body after publishing. The release agent performs the review without requesting routine owner approval.

Current owner policy: the only product difference between public and internal distribution is the supported coin set. Public builds contain NOID/QUAN or the separate Proxima product and must physically exclude Pearl GPU kernels. Both distributions accept compatible third-party pools and use the same NOID/QUAN implementations, fees and runtime behavior.

This policy replaces all historical public-only restrictions and version-specific exceptions. No pool-provider whitelist, forced TLS for bare addresses, single-CUDA HiveOS rule, or historical release-note template is a publication prerequisite.

Keep source, credentials, internal addresses and build paths out of this public repository and its assets. Binaries belong in GitHub Releases, not Git. Preserve normal identity, archive safety, signatures, hashes and correctness checks. Never relabel an internal three-coin binary as public.

Before publication run `bash scripts/check-public-release-repo.sh`, then verify every final archive with `bash scripts/verify-release-archive.sh ARCHIVE` on Linux. Publish both CUDA flavors from the same source, plus the unified HiveOS package. Check final public downloads and signatures. Record actual validation coverage; do not invent runtime or performance results.

## rigeos.ai reads this repository

rigeos.ai (the mining directory) takes INVminer's version, download URLs, SHA-256 values, supported coins and developer fee from `releases/<version>/RELEASE-MANIFEST.json`: the fields `version`, `assets` (file name → `url`, `sha256`, `size`), `coins` and `fee_ppm`. Keep these fields and their shapes. Every asset `url` must be this repository's release download of the same version; the site rejects a manifest that points anywhere else.

Keep the rigeos.ai links at the end of `README.md`, with `src=invminer-readme` unchanged (the site counts visits by it), and add one line per new coin.

For releases of the existing NOID/QUAN product, update the site in rigeos-ai-cc with `pnpm sync:release invminer --version <NOID/QUAN version>`, pass its gates, commit and deploy. The current site has only one INVminer product snapshot and its sync script sorts all releases by publication time. Do not overwrite that snapshot with a Proxima-only release: GitHub `latest=false` does not protect this script. Proxima catalog integration requires a separate product mapping before syncing or deploying; the GitHub release/download links remain the current Proxima distribution entry.

## Proxima public release product

v2.2.0.1 is a separate Proxima upgrade-6 binary product, not an update to NOID/QUAN flight sheets. Public source code stays private. Four-component numeric versions and Proxima-only zero-fee build metadata are supported by the public verifiers. Preserve the existing NOID/QUAN assets, signing key and default latest release; use explicit Proxima release/download URLs.

The owner expressly requested tested-GPU performance in this exact Release Note. Bind every measurement to its final public executable, model, device count, power cap and window. Do not copy previous internal artifact rates or infer untested models from compiled SM support. The adjacent review JSON binds the final note.
