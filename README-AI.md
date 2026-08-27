# README-AI — INVminer public release repository

This repository is public. It is a binary release channel, not the miner source
repository.

## Hard boundaries

- Product branding is `INVminer`; the Linux NOID executable is
  `invminer-noid`.
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
  README.txt invminer-noid
```

Do not omit either control. The verifier reads the raw tar member table through
Python and must see exactly `README.txt` and `invminer-noid`; this catches hidden
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
