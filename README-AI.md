# README-AI — INVminer public release repository

This repository is public. It is a binary release channel, not the miner source
repository.

## Hard boundaries

- Product branding is `INVminer`; the only public executable is `invminer`.
  Coins are selected explicitly as `invminer --coin <coin>`; per-coin
  executables are forbidden.
- The public release repository is `getrigeos/INVminer-Release`.
- Official user-pool examples may use only the WebPKI TLS endpoints
  `stratum+ssl://eu.innovlab.cc:19601`,
  `stratum+ssl://hk.innovlab.cc:19601`, or
  `stratum+ssl://eu2.innovlab.cc:17601`. NOID examples default to Europe and
  replace only the hostname for Hong Kong. QUAN examples default to `eu2`. Do
  not restore `stratum.innovlab.cc` or publish an official plaintext example.
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
- Every Release Note, including historical notes kept in this repository and
  `release-notes/TEMPLATE.md`, must contain no `01pool` wording. The repository
  and per-note gates enforce this case-insensitively before publication.
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
  The approved v0.1.65 exception has the same four-model scope and covers only
  the exact final v0.1.65 rows recorded in its bilingual Release Note.
  The operator explicitly approved a v0.1.70 disclosure of all latest validated
  baseline and tuned sample-card rows. The v0.1.70 exact RTX 4070 row and the
  explicitly version-labelled preserved-module rows for CMP 50HX, A100, RTX
  3080, RTX 4090, and RTX 5090 are the complete exception; no percentage,
  efficiency, earnings, comparison, or unlabelled v0.1.70 performance claim is
  authorized.
  The operator explicitly approved the same complete disclosure scope for
  v0.1.71: the exact v0.1.71 RTX 4070 row plus the explicitly version-labelled
  unchanged-module rows for CMP 50HX, A100, RTX 3080, RTX 4090, and RTX 5090.
  Percentages, efficiency, earnings, comparisons, and unlabelled v0.1.71
  performance claims remain forbidden.
  The operator explicitly approved the same complete disclosure scope for
  v0.1.73: the exact v0.1.73 RTX 4070 row plus the explicitly version-labelled
  unchanged-module rows for CMP 50HX, A100, RTX 3080, RTX 4090, and RTX 5090.
  Percentages, efficiency, earnings, comparisons, and unlabelled v0.1.73
  performance claims remain forbidden.
- The operator separately authorized v0.1.74 notes to contain only measured
  v0.1.73-to-v0.1.74 hashrate, board-power and efficiency changes, with necessary
  GPU/settings/power-limit and warmed 60-second conditions. Pin the approved
  final-package table in the repository gate. Do not append upgrade commands,
  troubleshooting, development details, or unrelated claims to this one note.
  The older note contract remains in force for other versions. RTX 4070 OC is
  explicitly excluded; its row uses default controls only.
- For v0.1.78 only, the operator additionally authorized final desktop RTX
  4070/4090/5090 default-control rates, board power and efficiency, comparison
  with v0.1.77 and same-card Fl4shMiner 1.3.8 controls. Pin the entire approved
  bilingual note by SHA-256 in the repository gate. Identify the warmed
  60-second method and power caps; retain the RTX 4070 legacy-profile tradeoff
  and explicitly state that RTX 5090 has no new improvement over v0.1.77.
  This exception does not extend to README/package documents or later versions.
- Public assets must state that the executable never installs or enables an OS
  service, scheduled task, login/startup item, cron job or container restart
  policy. Any persistence template is opt-in and requires a separate explicit
  administrator action.
- The canonical CUDA 12/HiveOS binary must contain both the reviewed SM86
  performance profile and the embedded CUDA 12.2 native SM86 compatibility
  fallback. A driver image-compatibility failure must select that fallback
  automatically; never instruct HiveOS users to choose a second package or set
  a diagnostic module environment variable.
- The same canonical CUDA 12/HiveOS binary must retain the reviewed native SM89
  path and its CUDA 12.2 native SM89 fallback. Driver 535 / CUDA Driver API 12.2
  physical qualification must cover NOID and QUAN on every visible GPU.

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

The v0.1.84 and earlier ordinary Linux archives contain only `README.txt` and
`invminer`. Starting with v0.1.85, ordinary Linux archives use the fixed audited
package contract checked by `verify-release-archive.sh`: binary, documentation,
SBOM, build manifest, error catalogs, example config, HiveOS adapters, and
release-key metadata. Do not repack a qualified archive in this repository.

When recreating a legacy two-member archive on macOS, use both copyfile and
xattr controls:

```bash
COPYFILE_DISABLE=1 tar --no-xattrs -C dist/stage -czf dist/package.tar.gz \
  README.txt invminer
```

Do not omit either control. The verifier reads the raw tar member table through
Python and checks the exact version-specific member contract; this catches
hidden AppleDouble `._*` members that BSD tar may suppress while listing or
extracting.

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


## v0.1.83 release handoff

- The reviewed source is fixed at commit
  `091b923d9e704c2b3f220e388f06201ebc9715f9`; follow-up evidence stays in the
  private source repository.
- The official QUAN endpoint is `stratum+ssl://eu2.innovlab.cc:17601`. It uses
  the LuckyPool-compatible Full256 protocol and selects that dialect
  automatically. HiveOS host-and-port-only input defaults to authenticated TLS.
- The CUDA 12/13 public binary SHA-256 values are
  `74e9cb15b155b9c82fd74a6d81736cb89d5af300210bcbce66c2b59e9ef99455` and
  `4a11ea986a0abe3a30310b92ede48dbcf9c1ce9092e4eaa45b173e8010df657b`.
- The CUDA 12/13 Linux archive SHA-256 values are
  `7ed6c068af6d47847b854072fe32f99ed9249e9dee5a1847a0d8b4b433256f51` and
  `5a3fc40a4451ec9788342c1e93f05e39c7652990c4481ea1e41ffba3a59d8f5b`.
  The canonical HiveOS archive SHA-256 is
  `3133231f9d3589dc4733e7d82ff37b187bf35c14544462d81ab550c9dcbaec71`.
- Both public flavors were reproduced byte for byte from the frozen source. The
  exact HiveOS archive passed CMP 40HX native GPU/CPU self-test, live WebPKI TLS
  mining with accepted shares and zero rejected/stale shares, and `h-stats`.
- Public v0.1.83 material contains no numerical performance claim.

## v0.1.84 release handoff

- The reviewed source is fixed at commit
  `945303cb75f5d02b48e0e6903b23d0cea0dca3a9`; private performance evidence remains in the source repository.
- QUAN uses a disclosed 2% developer fee through the official Quanpool hostname. User-selected
  compatible QUAN pools remain independent and hostnames are resolved at connection time.
- The CUDA 12/13 public binary SHA-256 values are
  `034055a62c732c9d8cdd7c25d491856153ebf9e6893055a6fbe639c4c1e688c2` and
  `c404289d9dc5c44ddbbebcb34beeb6f88822460747c305ccbf0876b9f2e8168b`.
- The CUDA 12/13 Linux archive SHA-256 values are
  `a2550253042cb254ed615209f86f0009a40df490fe96290e808e8a8981524d09` and
  `d4b5a5da71da80eb89c90d179633e71784c1f366f58a182161ce616dfa8eb5a7`.
  The canonical HiveOS archive SHA-256 is
  `71ad0d147c54f25f930df9901ce707bd51b2a0bb83c4ecf8fe93cd8fb24f6da5`.
- Both public flavors were reproduced byte for byte from the frozen source. The exact canonical
  archive passed native QUAN self-tests on CMP 50HX and RTX 4090. Its host-and-port-only HiveOS
  configuration defaults to authenticated TLS; the packaged adapter reached Full256 mining,
  accepted a share with zero rejected or stale shares, and returned valid `h-stats` on CMP 50HX.
- Public v0.1.84 material contains no numerical performance claim.

## v0.1.85 release handoff

- The reviewed source and final source tag resolve to commit
  `7a04f752e8f6dd66d73e0220a37c25a77c3f329a`.
- The CUDA 12/13 public binary SHA-256 values are
  `790929a6951e58f003b73340fa5c113e50ccd70ad3b6d4a8296c111c97c5a1ea` and
  `dbfe39276d5160acc1bbb5a41d1a9601c1972f76c871c7c9d3c2950d68779745`.
- The CUDA 12/13 Linux archive SHA-256 values are
  `3b9cc4fffbbe1fb1563e72fdbf12d3ec60836459a6e1a4aa5760cd0e15a7b95b` and
  `36648d3f3726d1def43a349d94333820ac83f0b4cdcfa7fa283febd305233444`.
  The canonical HiveOS archive SHA-256 is
  `78a6855999fdaf304b4c2e23032ff3db644d76356415cc1fd9ac11df405aa2bf`.
- All four public/companion CUDA combinations were built twice and were
  byte-identical. The public CUDA 12 archive passed Driver 535 six-GPU NOID
  compatibility, QUAN native self-tests, live TLS shares, and HiveOS adapters.
  The CUDA 13 archive passed native self-test and live TLS shares on RTX 5090.
- Public v0.1.85 material contains no numerical performance claim.
