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

## v0.1.47 release handoff

- Public assets remain binary-only: one CUDA 12 and one CUDA 13 Linux x86_64
  archive, each containing exactly `README.txt` and `invminer-noid`.
- CUDA 12 archive/binary SHA-256:
  `3f51fd80752ddb0c0c5b247ac24adfaaddb62013f590582d393e57f0142841d5` /
  `54ca35679246abf69a3d84830664c0493d98260bf2019debf63949e7dd064874`.
- CUDA 13 archive/binary SHA-256:
  `4bd43266bf2b0e6fe63929c0d214ae523ea640842d5b724141fea43857c647eb` /
  `0e9b84d68be2d074f71f22e48028724bec58cdfa2fe92550b39a215c8eb89cc4`.
- Normal GPU and CPU-only commands omit `--state-dir`; automatic persistent
  state is the default. `INVMINER_STATE_DIR` and an explicit absolute override
  remain service/operator options.
- Exact v0.1.47 RTX 4090 default-clock measurements and exact CPU-only AVX-512 /
  AVX2 measurements are in `release-notes/v0.1.47.md`. RTX 3080, RTX 4070 SUPER
  and RTX 5090 rows are explicitly labeled historical physical lane evidence.
- The exact CUDA 12 executable was also re-gated on native `sm_75`: CMP 40HX
  `1.476 MH/s`, CMP 50HX `2.436 MH/s`, and RTX 2080 Ti `3.107 MH/s` fresh /
  `3.169 MH/s` cache-hit. All selected `384/2` at default clocks. CUDA 13 does
  not contain a default production `sm_75` lane.
- CMP 40HX and CMP 50HX also passed an exact-artifact live recovery gate. After
  forcibly closing each miner's only TLS socket, both stayed in-process,
  reconnected once, returned ONLINE and continued accepting shares. Final
  `/stats` A/S/R counters were `4/0/0` and `9/0/0`, respectively.
- The exact final CUDA 13 candidate connected through the authorized redacted
  WebPKI gate and finished with 99 accepted, 2 stale and 0 rejected shares.
  After the only socket was forcibly closed, reconnects increased to one, the
  process stayed alive and accepted continued increasing. These counters came
  from the nested `/stats` `shares` object because per-share INFO logs are
  intentionally absent.
