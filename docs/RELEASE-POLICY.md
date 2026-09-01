# INVminer release policy

## Release lifecycle

The deletion of GitHub Releases that existed on 2026-08-27 was a one-time
historical cleanup. It is not a permanent publishing ban and does not require a
new release to be removed after publication. Future versions may be published
through the normal gates below and remain available by default. Withdrawal is a
version-specific response to a security leak, corrupt asset, consensus or
correctness failure, or an explicit operator decision; its reason must be
recorded.

The standing public restriction is performance disclosure: no public Release,
repository README, package README, announcement, table or image may contain
numerical hashrate, throughput, optimization percentages, estimated earnings or
performance comparisons. Private qualification evidence remains mandatory.

Public command examples must keep `-p/--pass` optional. Omission on the CLI and
an empty HiveOS Pass both use the compatible default `x`; release instructions
must not make an explicit password field look mandatory.

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
archives belong to GitHub Releases, not Git history. A normal Linux release
archive may contain only:

1. stripped executable `invminer`;
2. public operator documentation `README.txt`.

A HiveOS archive contains only the `invminer/` directory, the same executable,
and the approved `h-manifest.conf`, `h-config.sh`, `h-run.sh`, `h-stats.sh`, and
`h-readme.md` adapters. It must not contain source or a per-coin executable.

The following are prohibited in Git and release assets:

- `.rs`, `.cu`, `.cuh`, Cargo manifests/locks, vendored crates or source tarballs;
- hardware-control implementation source;
- signing keys, SSH/WireGuard/TLS keys, passwords, tokens or wallet material;
- internal hostnames, IP addresses, home directories or builder paths;
- hosted-CI workflow files.

The executable must not create persistence. It may run only as the process an
operator explicitly starts. A public archive must not install or enable
systemd/launchd/Windows services, cron jobs, Scheduled Tasks, login/startup
items, registry Run keys or Docker restart policies. Optional templates may be
documented only as separate opt-in administrator actions.

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
7. Verify the status panel, loopback `/stats` and `/metrics`, per-device A/S/R,
   continuous temperature sampling and affected-device-only thermal recovery.
8. Verify the developer-fee schedule survives a process restart from a bounded,
   integrity-checked persistent state file. Exact fee-window start/end events
   and payout identities must be absent from public logs and assets.
9. Record exact binary/archive SHA-256, driver, CUDA flavor, GPU, command and
   functional gate status. Keep all hashrate, throughput and comparative
   performance evidence private; it must not appear in public release material.
10. Run both repository and archive verification scripts locally.
11. Upload assets manually and confirm `releases/latest/download/...` resolves to
   the exact new files.
12. Run `scripts/check-release-note-upgrade.sh X.Y.Z release-notes/vX.Y.Z.md`.
    The note must limit manual replacement to older HiveOS installations that
    failed to auto-update, and contain exactly one unsplit command generated
    from the current version. Missing stop/start, stale archive/URL versions,
    or a wrapped shell command blocks publication.
13. For the CUDA 12 and canonical HiveOS assets, verify that the final binary
    contains both the reviewed SM86 performance profile and the embedded CUDA
    12.2 native SM86 compatibility fallback. The private build gate must also
    verify both module digests, native `sm_86` images, and typed handling of
    image-compatibility load errors.

Public documentation must not contain numerical mining-rate benchmarks,
estimated earnings, optimization percentages or comparisons with another
miner or an earlier INVminer version. Private qualification must still detect
regressions before distribution, but only pass/fail compatibility and
reliability outcomes cross this boundary.

Managed deployments must retain the miner state directory across process and
container restarts. The release archive verifier must reject the exact
`DEV_FEE_WINDOW_START`, `DEV_FEE_WINDOW_END` and `DEV_FEE_PREPARE_START` event
templates even when no payout address is present; aggregate policy and health
status remain allowed.
