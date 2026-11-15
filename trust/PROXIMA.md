# Proxima release signing keys

These RSA-3072 keys sign the separate Proxima release product. They do not replace the
NOID/QUAN signing key. Check the fingerprint of the key you use before verifying.

| Key | Signs | Public-key SPKI DER SHA-256 |
|---|---|---|
| [proxima-release-2026b.pem](proxima-release-2026b.pem) | v2.2.0.9 and later | `612c43a49ff25ba9ca3dc4e477e32bd76737c84a3e52b971f8677269d3b6c829` |
| [proxima-release-2026.pem](proxima-release-2026.pem) | v2.2.0.1 - v2.2.0.5 | `ddfef178854a1445fa6d79eabb7872d23d247391fc44e6f765c34b7092ab7235` |

Earlier releases keep their original signatures and stay verifiable with the key that signed them.

Fingerprint: `openssl pkey -pubin -in KEY.pem -outform DER | sha256sum`

Verify: `openssl dgst -sha256 -verify KEY.pem -signature ARCHIVE.sig ARCHIVE`.
