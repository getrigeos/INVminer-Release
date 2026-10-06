# INVminer public release repository

Release Note review is a mandatory publication gate for every release and text correction. Read [the review contract](docs/RELEASE-NOTE-GATE.md). The repository check requires a review bound to each current note; verify the fresh live body after publishing. The release agent performs the review without requesting routine owner approval.

Current owner policy: the only product difference between public and internal distribution is the supported coin set. Public builds contain NOID/QUAN only and must physically exclude Pearl GPU kernels. Both distributions accept compatible third-party pools and use the same NOID/QUAN implementations, fees and runtime behavior.

This policy replaces all historical public-only restrictions and version-specific exceptions. No pool-provider whitelist, forced TLS for bare addresses, single-CUDA HiveOS rule, or historical release-note template is a publication prerequisite.

Keep source, credentials, internal addresses and build paths out of this public repository and its assets. Binaries belong in GitHub Releases, not Git. Preserve normal identity, archive safety, signatures, hashes and correctness checks. Never relabel an internal three-coin binary as public.

Before publication run `bash scripts/check-public-release-repo.sh`, then verify every final archive with `bash scripts/verify-release-archive.sh ARCHIVE` on Linux. Publish both CUDA flavors from the same source, plus the unified HiveOS package. Check final public downloads and signatures. Record actual validation coverage; do not invent runtime or performance results.
