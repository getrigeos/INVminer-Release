# Proxima release signing key

This RSA-3072 key signs the separate Proxima release product, starting with
v2.2.0.1. It does not replace the NOID/QUAN signing key.

Public-key SPKI DER SHA-256:
`ddfef178854a1445fa6d79eabb7872d23d247391fc44e6f765c34b7092ab7235`

Key: [proxima-release-2026.pem](proxima-release-2026.pem).

Verify: `openssl dgst -sha256 -verify proxima-release-2026.pem -signature ARCHIVE.sig ARCHIVE`.
