# Public release policy

Mandatory [Release Note review](RELEASE-NOTE-GATE.md): follow the previous approved format, list only actual user-visible changes, verify claims and practical instructions, and bind the checked final text before publication and after live readback. Internal qualification details belong in evidence records. Missing or stale reviews block publication, including note-only corrections.

Public: NOID/QUAN. Internal: NOID/QUAN plus Pearl. Pearl kernels must never be compiled into or included with public binaries or archives. This is the only channel-specific product gate.

Both channels accept compatible third-party user pools. Explicit TCP/TLS schemes select transport; bare host:port uses automatic transport detection. TLS validation failures never downgrade. NOID fee is 1%; QUAN fee is 5% in both channels.

Publish CUDA12 and CUDA13 Linux packages and one HiveOS archive containing both. General correctness, integrity, source/secret boundaries and signature verification apply to every release. The current branch contains only current policy; historical product gates and their release-specific exceptions have been removed. Existing published tags/assets are immutable.
