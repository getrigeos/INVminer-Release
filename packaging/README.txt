INVminer v0.1.73 - Linux x86_64

INVminer uses one executable and this release supports only NOID:

  ./invminer --coin noid \
    -o stratum+ssl://eu.innovlab.cc:19601 \
    -u YOUR_NOID_ADDRESS.RIG_NAME

CPU-only mode:

  ./invminer --coin noid --cpu-only \
    -o stratum+ssl://eu.innovlab.cc:19601 \
    -u YOUR_NOID_ADDRESS.RIG_NAME

The password option is optional. When -p/--pass is omitted or HiveOS Pass is
left empty, INVminer uses the compatible default value x. A worker suffix is
also optional when the pool accepts the wallet address by itself.

Ordered backup pools can be comma-separated or supplied by repeating -o:

  ./invminer --coin noid \
    -o stratum+ssl://eu.innovlab.cc:19601 \
    -o stratum+ssl://hk2.innovlab.cc:19601 \
    -o stratum+ssl://us.innovlab.cc:19601 \
    -o stratum+ssl://ru.innovlab.cc:19601 \
    -u YOUR_NOID_ADDRESS.RIG_NAME

The default primary mode keeps one active mining connection. While mining on a
backup, it uses only a short, bounded primary probe and returns after consecutive
successful probes. Rotate mode advances on failure without proactive return.
INVminer does not keep persistent sessions open to every configured pool.

Public binaries accept only the approved innovlab.cc and 01pool.com TLS domain
boundary. NOID accepts only WebPKI-verified TLS in this public artifact.
Plaintext Stratum/TCP, insecure TLS, and operator certificate pins are rejected
before device startup.

Temporary DNS, certificate, or pool-service failures do not require a process
restart. INVminer retries with bounded backoff, re-resolves through the system
configuration, and resumes after the service and its valid certificate are
restored. TLS certificate-chain and exact-hostname verification remain enabled
on every reconnect; TLS is never downgraded to plaintext.

Choose the CUDA 12 or CUDA 13 archive according to host-driver compatibility.
The executable name remains invminer in both packages. The CUDA 12 package is
the broad compatibility choice, including the embedded Ampere fallback.

NOID developer fee: 1% of effective mining time. Waiting and unavailable fee
work are not charged. The payout identity is not printed in normal logs.

This is closed-source, binary-only software and is provided without warranty.
It may be incompatible with a particular GPU, CPU, driver, OS, or future pool
state. Users cannot independently rebuild, audit, or patch the executable and
must decide whether to trust it and the published checksums.

Extracting or running this package does not install or enable a boot service,
scheduled task, cron job, login/startup item, or container restart policy.

Official downloads and SHA-256 checksums:
https://github.com/getrigeos/INVminer-Release/releases/tag/v0.1.73
