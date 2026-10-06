#!/usr/bin/env python3
"""Verify the current public package contract on Linux, including actual executable identity."""
import hashlib
import importlib.util
import json
from pathlib import Path, PurePosixPath
import re
import subprocess
import sys
import tarfile
import tempfile

spec = importlib.util.spec_from_file_location('coin_boundary', Path(__file__).with_name('check-public-coin-boundary.py'))
coin = importlib.util.module_from_spec(spec)
spec.loader.exec_module(coin)


def require(condition, message):
    if not condition:
        raise ValueError(message)


def sha(path):
    return hashlib.sha256(path.read_bytes()).hexdigest()


def verify(archive):
    native = re.fullmatch(r'invminer-v(\d+\.\d+\.\d+)-linux-x86_64-(cuda12|cuda13)\.tar\.gz', archive.name)
    hive = re.fullmatch(r'invminer-(\d+\.\d+\.\d+)\.tar\.gz', archive.name)
    require(native or hive, 'invalid archive filename')
    with tempfile.TemporaryDirectory() as temp:
        root = Path(temp)
        names = set()
        with tarfile.open(archive) as tar:
            for member in tar.getmembers():
                p = PurePosixPath(member.name)
                require(not p.is_absolute() and '..' not in p.parts, 'unsafe archive path')
                require(member.isfile() or member.isdir(), 'links/special archive members forbidden')
                require(not any(x.startswith('._') for x in p.parts), 'AppleDouble metadata forbidden')
                if member.isdir():
                    continue
                name = str(p)
                require(name not in names, 'duplicate archive member')
                names.add(name)
                require(member.size <= 1024**3, 'oversized member')
                out = root / name
                out.parent.mkdir(parents=True, exist_ok=True)
                with tar.extractfile(member) as source, out.open('wb') as dest:
                    import shutil
                    shutil.copyfileobj(source, dest)
                out.chmod(member.mode & 0o777)
        if hive:
            expected = {'invminer', 'cuda13/invminer', 'HIVEOS-BUNDLE.json', 'h-select.py',
                        'h-manifest.conf', 'h-config.sh', 'h-run.sh', 'h-stats.sh', 'h-readme.md'}
            require(names == {'invminer/' + n for n in expected}, 'unexpected HiveOS member set')
            package = root/'invminer'
            bundle = json.loads((package/'HIVEOS-BUNDLE.json').read_text())
            infos = []
            for flavor, relative in [('cuda12', 'invminer'), ('cuda13', 'cuda13/invminer')]:
                info = coin.check(package/relative)
                require(info['cuda_flavor'] == flavor and info['version'] == hive[1], 'HiveOS identity mismatch')
                require(bundle['binaries'][flavor] == dict(path=relative, sha256=sha(package/relative), build_info=info), 'bundle binary mismatch')
                infos.append(info)
            for key in ('source_commit', 'version', 'fee_assets', 'user_pool_endpoint_policies'):
                require(infos[0][key] == infos[1][key], 'mixed CUDA product: ' + key)
            require(bundle['source_commit'] == infos[0]['source_commit'], 'bundle source mismatch')
            for name, digest in bundle['files'].items():
                require(name in expected and sha(package/name) == digest, 'adapter checksum mismatch')
        else:
            expected = {'invminer', 'README.txt', 'EULA.txt', 'THIRD-PARTY-NOTICES.txt',
                        'SBOM.cargo-metadata.json', 'BUILD-MANIFEST.json', 'invminer-config.example.json',
                        'RELEASE-KEY-METADATA.json', 'RELEASE-REVOKED-KEYS.txt', 'ERROR-CATALOG.json',
                        'ERROR-CATALOG-SCHEMA.json', 'h-manifest.conf', 'h-run.sh', 'h-stats.sh',
                        'h-config.sh', 'h-readme.md'}
            require(names == expected, 'unexpected Linux member set')
            info = coin.check(root/'invminer')
            require(info == json.loads((root/'BUILD-MANIFEST.json').read_text()), 'binary/manifest mismatch')
            require(info['version'] == native[1] and info['cuda_flavor'] == native[2], 'archive identity mismatch')
            for filename, field in [('ERROR-CATALOG.json', 'sha256'), ('ERROR-CATALOG-SCHEMA.json', 'schema_sha256')]:
                require(sha(root/filename) == info['error_catalog'][field], 'error catalog mismatch')
        for name in names:
            p = root/name
            if p.name == 'invminer':
                continue
            data = p.read_bytes()
            require(not re.search(rb'BEGIN (?:OPENSSH |RSA |EC )?PRIVATE KEY|/Users/|/home/user/|/var/tmp/', data), 'private material in package')
    print('Public archive verified: ' + archive.name)


if __name__ == '__main__':
    try:
        require(len(sys.argv) == 2, 'usage: verify-release-archive.py ARCHIVE')
        verify(Path(sys.argv[1]))
    except (ValueError, OSError, KeyError, subprocess.SubprocessError, tarfile.TarError) as error:
        raise SystemExit('Public archive rejected: ' + str(error))
