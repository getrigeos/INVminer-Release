INVminer v0.1.50 - Linux x86_64

INVminer uses one executable. Select NOID explicitly:

This release supports only NOID and contains no CUDA modules for other coins.

  ./invminer --coin noid \
    -o stratum+ssl://stratum.innovlab.cc:19601 \
    -u YOUR_NOID_ADDRESS.RIG_NAME \
    -p x

CPU-only mode:

  ./invminer --coin noid --cpu-only \
    -o stratum+ssl://stratum.innovlab.cc:19601 \
    -u YOUR_NOID_ADDRESS.RIG_NAME \
    -p x

Choose the CUDA 12 or CUDA 13 archive according to host-driver compatibility.
The executable name remains invminer in both packages. Normal operation does
not require --state-dir or mining-geometry arguments.

NOID developer fee: 5% of effective mining time. Waiting and unavailable fee
work are not charged. The payout identity is not printed in normal logs.

This is closed-source, binary-only software and is provided without warranty.
It may be incompatible with a particular GPU, CPU, driver, OS, or future pool
state. Users cannot independently rebuild, audit, or patch the executable and
must decide whether to trust it and the published checksums.

Extracting or running this package does not install or enable a boot service,
scheduled task, cron job, login/startup item, or container restart policy.

Official downloads and SHA-256 checksums:
https://github.com/getrigeos/INVminer-Release/releases/tag/v0.1.50
