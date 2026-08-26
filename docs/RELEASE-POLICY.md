# INVminer release policy

## Private build baseline

The initial migration baseline is private miner tag `v0.1.41`, commit
`9d77ab5fe77e0c0f350191f98653e358080cc3fd`. The source worktree was clean when
recorded on 2026-08-26. This commit identifies engineering ancestry only; its
existing public binaries are not INVminer artifacts and must not be republished
under a new filename.

An INVminer candidate must be built from an isolated private copy so the source
repository remains untouched. The candidate needs a new version because these
release-visible and protocol-bound values change:

- product, executable, banner, user-agent and build-manifest identity;
- canonical InnovLab Stratum TLS endpoint;
- developer-fee commitment domain and endpoint binding;
- release archive names, operator README and checksums;
- error/help text and any persisted state namespace that embeds product name.

## Public payload boundary

Git commits may contain documentation and verifier scripts only. Large binary
archives belong to GitHub Releases, not Git history. A release archive may
contain only:

1. stripped executable `invminer-noid`;
2. public operator documentation `README.txt`.

The following are prohibited in Git and release assets:

- `.rs`, `.cu`, `.cuh`, Cargo manifests/locks, vendored crates or source tarballs;
- hardware-control implementation source;
- signing keys, SSH/WireGuard/TLS keys, passwords, tokens or wallet material;
- internal hostnames, IP addresses, home directories or builder paths;
- hosted-CI workflow files.

## Candidate gates

Before publishing a new tag:

1. Build CUDA 12 and CUDA 13 flavors in their approved isolated builders.
2. Verify the embedded product identity and InnovLab endpoint before CUDA starts.
3. Run CPU/GPU gold-vector self-tests on each claimed native architecture.
4. Obtain accepted shares with zero or very low resolved rejection rate through
   the production InnovLab TLS endpoint. If that endpoint is unavailable for a
   confirmed pool-infrastructure reason, an explicitly authorized,
   WebPKI-verified `release-gate-compat` path may be used, provided its actual
   hostname is absent from public files and logs and the Release Notes disclose
   which gate was used.
5. Verify multi-GPU uses one user connection and disjoint search domains.
6. Exercise disconnect, authentication failure, job pause, stale response,
   CUDA error and service restart recovery.
7. Record exact binary/archive SHA-256, driver, CUDA flavor, GPU, command,
   hashrate unit, power limit and measured average/peak power.
8. Run both repository and archive verification scripts locally.
9. Upload assets manually and confirm `releases/latest/download/...` resolves to
   the exact new files.

No historical rate or power result may be represented as a measurement of a
new INVminer binary until that exact candidate is physically run.
