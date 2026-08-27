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

## v0.1.48 release handoff

- Public assets remain binary-only: one CUDA 12 and one CUDA 13 Linux x86_64
  archive, each containing exactly `README.txt` and `invminer-noid`.
- CUDA 12 archive/binary SHA-256:
  `82c9bc1802dcf7d9c1d00dfaf1d0a1d316fca27334135c92dd7dda4b3dd59fff` /
  `a40e3ea26b3daefb8183b2c82a11ab6c84f904081ff2898b9ed833bd75f20ac0`.
- CUDA 13 archive/binary SHA-256:
  `4647465383b96191304943ac8e20d1c83719949995748d5941efacff1971bc81` /
  `75c5781b1956205e1aa8c009f6343475341d164e7ad752de3f6a2987f76decd1`.
- Normal GPU and CPU-only commands omit `--state-dir`; automatic persistent
  state is the default. `INVMINER_STATE_DIR` and an explicit absolute override
  remain service/operator options.
- CUDA 12 adds the reviewed shared-GF8 SM75 lane. Matched stock-clock A/B gains
  are 20.9% on CMP 40HX, 19.6% on CMP 50HX and 18.3% on RTX 2080 Ti. Integrated
  rates are `1.776`, `2.911`, and `3.722/3.697 MH/s`; the exact final Focal
  CUDA 12 executable reran at `2.914 MH/s` on CMP 50HX. All select `384/2`
  automatically. CUDA 13 has no production SM75 lane.
- The exact final CUDA 12 executable survived a forced socket loss on CMP 50HX
  through the authorized redacted compatibility gate: accepted advanced from
  one to three in the same PID after one reconnect, with zero stale and zero
  rejected. Never publish the endpoint or test identity.
- RTX 4090, CPU-only, RTX 3080, RTX 4070 SUPER and RTX 5090 rows are explicitly
  labeled retained v0.1.47 or historical physical evidence because their
  kernels did not change and were not rerun for v0.1.48.
