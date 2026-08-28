# README-AI — INVminer public release repository

This repository is public. It is a binary release channel, not the miner source
repository.

## Hard boundaries

- Product branding is `INVminer`; the only public executable is `invminer`.
  Coins are selected explicitly as `invminer --coin <coin>`; per-coin
  executables are forbidden.
- The public release repository is `getrigeos/INVminer-Release`.
- The canonical pool endpoint is
  `stratum+ssl://stratum.innovlab.cc:19601`.
- Never copy proprietary Rust/CUDA source, Cargo workspaces, vendored source,
  hardware-control source, source archives, build caches or internal recovery
  material into this repository.
- Never store SSH/WireGuard/TLS private keys, passwords, tokens, wallet files,
  seed phrases, internal host addresses or private build paths here.
- Never print the embedded developer-fee payout address in README files,
  Release Notes, package documentation, public log examples or support text.
  Public material may disclose the fee rate and schedule only.
- Never reintroduce exact `DEV_FEE_WINDOW_START`, `DEV_FEE_WINDOW_END` or
  `DEV_FEE_PREPARE_START` templates. They reveal actionable fee timing even
  without a payout address; only aggregate policy/health state is public.
- Do not add GitHub Actions, GitLab CI, reusable workflows or other hosted
  build/release automation. Build, scan and physical GPU qualification happen
  outside this repository; upload release assets manually.
- Do not rename a pre-INVminer binary or archive. The binary itself must report
  INVminer identity, contain the InnovLab endpoint policy and contain no legacy
  product/endpoint strings.
- The GitHub Releases that existed on 2026-08-27 were removed as a one-time
  historical cleanup. This is not a standing ban: future versions may follow
  the normal release workflow and are not automatically withdrawn afterward.
- Future public pages, notes and package READMEs must not state hashrate,
  throughput benchmarks or comparative performance figures. Those records are
  private engineering evidence only.
- Public assets must state that the executable never installs or enables an OS
  service, scheduled task, login/startup item, cron job or container restart
  policy. Any persistence template is opt-in and requires a separate explicit
  administrator action.

Before every commit or release:

```bash
bash scripts/check-public-release-repo.sh
bash scripts/verify-release-archive.sh dist/<archive>.tar.gz
```

Only the second command requires a prepared release archive.

On macOS, create archives with both copyfile metadata and xattrs disabled:

```bash
COPYFILE_DISABLE=1 tar --no-xattrs -C dist/stage -czf dist/package.tar.gz \
  README.txt invminer
```

Do not omit either control. The verifier reads the raw tar member table through
Python and must see exactly `README.txt` and `invminer`; this catches hidden
AppleDouble `._*` members that BSD tar may suppress while listing or extracting.

## Release lifecycle and public performance boundary

- Immediately after the Release title, show a standalone GPU command and a
  standalone CPU-only command. The CPU example must contain `--cpu-only`.
  Do not place version background, risk notices, asset tables or other long
  explanations before these two commands.
- The Releases API is empty immediately after the historical cleanup, but it is
  expected to contain future normally approved releases. Do not encode “API must
  remain empty” as a repository gate.
- Historical release-note files were removed from the current branch. Git
  history and tags remain sufficient for private recovery correlation.
- A future release may state tested GPU/driver compatibility, commands, package
  hashes, accepted/rejected recovery evidence and known limitations. It must not
  publish hashrate, throughput, optimization percentages, estimated earnings or
  performance comparisons.
- A newly published release remains available by default. Withdraw it only for
  a version-specific security leak, corrupt asset, correctness failure or an
  explicit operator decision; record that reason rather than treating withdrawal
  as an automatic post-release step.

## v0.1.52 release handoff

- Private binary source is fixed to reviewed commit
  `1d12e951435734afe503e43392b9590e3bef0aee`; private follow-up documentation
  remains outside this public repository.
- NOID is WebPKI TLS-only. Plaintext Stratum/TCP, insecure TLS and operator
  certificate pins fail before device startup. Normal public-CA renewal and leaf
  key rotation for the canonical hostname must continue without reconfiguration.
- CUDA 12/13 binary SHA-256 values are
  `900664a10a1954a863dada053e40584e8aa4827136d5edc3c2c1a6a38b223112`
  and `40b0d106a7d581ccc971909321f75be15e2c9b111b694d78847d479fcddcdd9d`.
- Ordinary archive SHA-256 values are
  `f129ca305fbc15fe090e06c865beb787426d5ce47d7622996c2ba948853e6d69`
  and `00409a18013b3eef790f210046d0bd67e428012406542c30254af75344463fce`.
  The single canonical HiveOS archive is named
  `invminer-0.1.52.tar.gz` and its SHA-256 is
  `c13a9800b28647bbf6092f1fedcab0fc2ad1eebe5ce09e86aebc4cb727d16ab7`.
- Both exact candidates were physically gated on RTX 4070 / Driver 580.178.04
  with default controls. Both passed exact CPU/GPU self-tests and submitted
  accepted shares with zero resolved rejects; CUDA 12 also recovered in-process
  from an injected loss of its only pool socket.
- Ordinary archives contain exactly `README.txt` and `invminer`; the canonical
  HiveOS archive retains the fixed `invminer/` contract. HiveOS asset names must
  be only `<miner-name>-<version>.tar.gz`; do not add tag `v`, platform, architecture,
  HiveOS, or CUDA labels. Use the broad CUDA 12 binary for that one package.
  Neither package creates persistence.
- HiveOS instructions must provide the canonical Installation URL as its own
  field. Extra config arguments are empty by default and must never contain an
  alternate CUDA package URL.
- Every future HiveOS archive must pass the public archive verifier, whose
  permanent negative fixtures reject tag `v`, platform/architecture, HiveOS and
  CUDA filename labels. Before publishing, the exact archive digest must also be
  launched on an idle HiveOS qualification host, reach `ONLINE`, produce at
  least one accepted share with zero rejected shares, and pass `h-stats`.
