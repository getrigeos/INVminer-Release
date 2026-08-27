# README-AI — INVminer public release repository

This repository is public. It is a binary release channel, not the miner source
repository.

## Hard boundaries

- Product branding is `INVminer`; the only public executable is `invminer`.
  Coins are selected explicitly as `invminer --coin <coin>`; per-coin
  executables are forbidden.
- The public release repository is `getrigeos/INVminer`.
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
  `490476c5a6200395fe8a4ed81af3b8eca0c86f2b`; never copy that repository here.
- CUDA 12/13 are two host-compatibility flavors of the same multi-coin
  `invminer` program. They must not be renamed or split by coin or GPU model.
- Ordinary archive SHA-256 values are
  `c0b1367d2f8efd63aa8e72c80fc38924fbccefb04ad910c62f5eabb5c8065f39`
  (CUDA 12) and
  `c0af6addf7d1fa2dd8199208f6cbb653a20e2ef25f767d1c5e9069ac22b5d209`
  (CUDA 13). HiveOS archive SHA-256 values are
  `5209bb4153b41ac314c3592179ffbeb755e3f557c5ac0f4a5dcf31fa594552aa`
  and `fc484b5ee9a5262e2f006819c7c19acf55f4e8988c0605c88b1c4efc656313fb`.
- CUDA 12/13 binary SHA-256 values are
  `ce87b75081758cbf0fe18350b4acc732ff366952237e58462639721902a36784`
  and `8421d5fadf141cab981129afe7964739f7f296b0c27fb885113f639177f610ef`.
- Both exact candidates were physically gated on one RTX 4070 with Linux driver
  580.178.04, default board controls and no clock arguments. Do not convert the
  private engineering benchmark into a public performance claim.
- The canonical InnovLab endpoint was unavailable from the gate host. The
  already-authorized WebPKI compatibility gate was used and remained redacted;
  Release Notes disclose the substitution without naming its endpoint.
- Ordinary archives contain exactly `README.txt` and `invminer`. HiveOS archives
  use the fixed `invminer/` directory contract. Neither package creates or
  enables persistence.
