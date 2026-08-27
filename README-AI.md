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

## v0.1.50 release handoff

- Private release source is fixed to the reviewed INVminer source commit
  `3640e855e435badc62836232cd95cb7c27a24584`; never copy that repository here.
- CUDA 12/13 are two host-compatibility flavors of the same `invminer` program.
  v0.1.50 supports only `--coin noid`; both public binaries must contain only
  NOID CUDA modules and must not be renamed or split by GPU model.
- Ordinary archive SHA-256 values are
  `4e1115b2f8093ec01686449787925424cab42d3dcd8ac454a0fa494e693412f6`
  (CUDA 12) and
  `f2df9c02b90cc4f617d2c51c1427c8601606885cf8df9c673930cc4366545a25`
  (CUDA 13). HiveOS archive SHA-256 values are
  `928d1ef6fa838227a3d232992328d329688308224ab9d58acac3b9c4aca8e9d6`
  and `0148e309be2fccfe8c6eed46c437baf2677033aa2a818eeba65121f0000c79d4`.
- CUDA 12/13 binary SHA-256 values are
  `73de5728d3304da7bf4726d40a7443aaa2fdb8200f006f24cc5161f2a34212eb`
  and `1d37573b70c9ad8bbde0a9a21f277048a66cd53956c2867d04dffe4eaa8e99e2`.
- Both exact candidates were physically gated on one RTX 4070 with Linux driver
  580.178.04, default board controls and no clock arguments. Do not convert the
  private engineering benchmark into a public performance claim.
- The canonical InnovLab endpoint was unavailable from the gate host. The
  already-authorized WebPKI compatibility gate was used and remained redacted;
  Release Notes disclose the substitution without naming its endpoint.
- Ordinary archives contain exactly `README.txt` and `invminer`. HiveOS archives
  use the fixed `invminer/` directory contract. Neither package creates or
  enables persistence.
