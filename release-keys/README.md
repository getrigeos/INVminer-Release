# INVminer release trust anchor

The active release-key public identity is `invminer-release-2026-ed25519`.
It is valid from `2026-09-14T12:15:00Z`.

The independently published SHA-256 digest of the SubjectPublicKeyInfo DER is:

```text
5dfba8946575cd2dcc95aea2a384427cd9cf42ef8ac670fc85e775db9128fb20
```

Verify the checked-out public key with:

```bash
openssl pkey -pubin -in release-keys/invminer-release-2026-ed25519.pub.pem -outform DER \
  | sha256sum
```

The private key is never stored in this repository or in release archives.
