# Proxima release signing keys

These RSA-3072 keys sign the separate Proxima release product. They do not replace the
NOID/QUAN signing key. Check the fingerprint of the key you use before verifying.

| Key | Signs | Public-key SPKI DER SHA-256 |
|---|---|---|
| [proxima-release-2026b.pem](proxima-release-2026b.pem) | v2.2.0.9 | `612c43a49ff25ba9ca3dc4e477e32bd76737c84a3e52b971f8677269d3b6c829` |
| [proxima-release-2026.pem](proxima-release-2026.pem) | v2.2.0.1 - v2.2.0.5; v2.2.0.10 - v2.2.0.11 | `ddfef178854a1445fa6d79eabb7872d23d247391fc44e6f765c34b7092ab7235` |

Earlier releases keep their original signatures and stay verifiable with the key that signed them.

v2.2.0.10 and v2.2.0.11 use the existing original Proxima key shown above. Use the key identified
by each release's manifest; do not assume the immediately preceding release used
the same key. This does not change signatures on already published releases.

Fingerprint: `openssl pkey -pubin -in KEY.pem -outform DER | sha256sum`

Verify: `openssl dgst -sha256 -verify KEY.pem -signature ARCHIVE.sig ARCHIVE`.
