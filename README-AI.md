# README-AI — INVminer public release repository

This repository is public. It is a binary release channel, not the miner source
repository.

## Hard boundaries

- Product branding is `INVminer`; the only public executable is `invminer`.
  Coins are selected explicitly as `invminer --coin <coin>`; per-coin
  executables are forbidden.
- The public release repository is `getrigeos/INVminer-Release`.
- Official user-pool examples may use only
  `stratum+ssl://eu.innovlab.cc:19601` or
  `stratum+ssl://hk.innovlab.cc:19601`; examples default to Europe and replace
  only the hostname for Hong Kong. Do not restore `stratum.innovlab.cc` in
  user-facing commands.
- Public command examples omit `-p/--pass`: the option is not required and an
  omitted CLI password or empty HiveOS Pass uses the compatible default `x`.
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
  throughput benchmarks or comparative performance figures unless the operator
  explicitly approves a release-specific disclosure. Each exception must be
  exact, recorded in the repository gate, paired with GPU model, power cap and
  test duration, and must not authorize unrelated performance claims. The
  approved v0.1.64 exception covers only the exact final RTX 3080, RTX 4070,
  tuned RTX 4090, and tuned RTX 5090 60-second results.
- Public assets must state that the executable never installs or enables an OS
  service, scheduled task, login/startup item, cron job or container restart
  policy. Any persistence template is opt-in and requires a separate explicit
  administrator action.
- The canonical CUDA 12/HiveOS binary must contain both the reviewed SM86
  performance profile and the embedded CUDA 12.2 native SM86 compatibility
  fallback. A driver image-compatibility failure must select that fallback
  automatically; never instruct HiveOS users to choose a second package or set
  a diagnostic module environment variable.

Before every commit or release:

```bash
bash scripts/check-public-release-repo.sh
bash scripts/check-release-note-upgrade.sh X.Y.Z release-notes/vX.Y.Z.md
bash scripts/verify-release-archive.sh dist/<archive>.tar.gz
```

Only the archive-verification command requires a prepared release archive.
The Release Note upgrade gate is mandatory. Its version-derived command is
offered only to older HiveOS installations that fail to replace the installed
Custom Miner after their Installation URL changes. The command must remain one
physical line, start with `miner stop`, verify the installed binary, and end
with `miner start`; stale versions or Markdown line breaks block publication.

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
  performance comparisons without the exact operator-approved, release-specific
  exception described above.
- A newly published release remains available by default. Withdraw it only for
  a version-specific security leak, corrupt asset, correctness failure or an
  explicit operator decision; record that reason rather than treating withdrawal
  as an automatic post-release step.

## v0.1.52 release handoff

- Private binary source is fixed to reviewed commit
  `191a533b564b92a3a348f370f187ca0685ae40dc`; private follow-up documentation
  remains outside this public repository.
- NOID is WebPKI TLS-only. Plaintext Stratum/TCP, insecure TLS and operator
  certificate pins fail before device startup. Normal public-CA renewal and leaf
  key rotation for the canonical hostname must continue without reconfiguration.
- CUDA 12/13 binary SHA-256 values are
  `285edd3b3bae881d8f0e367e4ceab0a495d63debdce5faf05a2f7e183c839454`
  and `64b6e57d3503b6a51283f55fa9f494d875d28f8331a229edefef3d98e137d269`.
- Ordinary archive SHA-256 values are
  `052afccfc02a3cb9fada0cb1ff56dca6c82eae080f572b8804990d82e4783aa5`
  and `ae138c3b4597e1102bcb1beca464406b0c63de5a6d80c2ae665072fc6ee392ed`.
  The single canonical HiveOS archive is named
  `invminer-0.1.52.tar.gz` and its SHA-256 is
  `aa4b9ecab30e7f8b06998bb01cd6273aa66db3e7bd3087bc7b69afb5b515c035`.
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
