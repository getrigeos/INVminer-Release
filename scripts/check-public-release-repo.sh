#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")/.."
python3 - <<'CHECK'
from pathlib import Path
import subprocess,re
names=subprocess.check_output(['git','ls-files','-z'],text=True).split('\0')
for name in filter(None,names):
 p=Path(name)
 if not p.exists(): continue
 if p.suffix.lower() in ('.rs','.cu','.cuh','.cubin','.fatbin','.ptx','.gz','.zip') or p.name in ('Cargo.toml','Cargo.lock'):
  raise SystemExit('source/build artifact forbidden in public Git: '+name)
 if p.is_symlink(): raise SystemExit('unexpected symlink: '+name)
 data=p.read_bytes()
 if p.suffix not in ('.py','.sh') and re.search(rb'BEGIN (?:OPENSSH |RSA |EC )?PRIVATE KEY|/Users/|/home/user/|/var/tmp/|(?<![0-9])192\.168\.[0-9]+\.[0-9]+',data):
  raise SystemExit('private material in '+name)
assert Path('docs/RELEASE-POLICY.md').is_file()
print('Public metadata boundary: passed')
CHECK

# Every current note must have a review bound to the exact final text.
notes=(release-notes/v*.md)
[[ -f ${notes[0]} ]] || { echo 'No public release note found' >&2; exit 1; }
for note in "${notes[@]}"; do
  version=${note##*/v}
  version=${version%.md}
  python3 scripts/release_note_review.py --channel public --version "$version" \
    --note "$note" --review "${note%.md}.review.json"
done
