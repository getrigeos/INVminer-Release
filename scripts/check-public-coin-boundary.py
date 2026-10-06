#!/usr/bin/env python3
"""Fail closed on public coin/kernel leakage; shared runtime qualification is separate."""
import argparse
import json
from pathlib import Path
import re
import subprocess

# These names are present in both native ELF symbol tables and PTX exports.
FORBIDDEN = re.compile(rb"pearl_(?:gemm|sm[0-9]+|search|pack_|expand_|noise|tensor)|btx_matmul|csd_sha256d", re.I)


def validate_info(info):
    if info.get('release_channel') != 'public':
        raise ValueError('expected public channel')
    if [c['id'] for c in info['coins']] != ['noid', 'quan']:
        raise ValueError('public product must contain exactly NOID/QUAN')
    if info.get('restrict_pool_endpoints') is not False:
        raise ValueError('retired pool restriction must remain disabled')
    expected = {'noid': 10000, 'quan': 50000}
    if any(info['fee_assets'].get(k) != expected for k in ('configured_coin_ppm', 'catalog_coin_ppm')):
        raise ValueError('public Fee catalog must contain only NOID/QUAN')


def validate_blob(data):
    if FORBIDDEN.search(data):
        raise ValueError('excluded coin GPU kernel found in public executable')


def check(binary, module_root=None):
    info = json.loads(subprocess.check_output([str(Path(binary).resolve()), '--build-info'], text=True))
    validate_info(info)
    validate_blob(Path(binary).read_bytes())
    if module_root:
        for p in Path(module_root).rglob('*'):
            if p.is_file() and p.suffix in ('.ptx', '.cubin', '.fatbin'):
                if 'pearl' in str(p).lower():
                    raise ValueError('Pearl GPU module produced in public build: ' + str(p))
                validate_blob(p.read_bytes())
    return info


if __name__ == '__main__':
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('binary')
    parser.add_argument('--module-root')
    args = parser.parse_args()
    try:
        check(args.binary, args.module_root)
    except (ValueError, OSError, KeyError, subprocess.SubprocessError) as error:
        raise SystemExit('Public coin boundary rejected: ' + str(error))
    print('Public coin boundary: NOID/QUAN only; excluded GPU modules absent; compatible pools enabled')
