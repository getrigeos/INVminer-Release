import copy
import importlib.util
from pathlib import Path
import unittest

spec = importlib.util.spec_from_file_location('boundary', Path(__file__).with_name('check-public-coin-boundary.py'))
boundary = importlib.util.module_from_spec(spec)
spec.loader.exec_module(boundary)


class ProximaBoundaryTests(unittest.TestCase):
    def setUp(self):
        self.info = {'release_channel': 'public', 'restrict_pool_endpoints': False,
                     'coins': [{'id': 'proxima', 'fee_ppm': 0,
                                'protocol_profiles': ['proxima-pool-v6']}],
                     'fee_assets': {'configured_coin_ppm': {'proxima': 0},
                                    'catalog_coin_ppm': {}, 'release_mode': 'zero'},
                     'mining_tls_default': 'compatible'}

    def test_public_proxima(self):
        boundary.validate_info(self.info)

    def test_internal_or_mixed_product_rejected(self):
        for field, value in [('release_channel', 'internal'), ('restrict_pool_endpoints', True),
                             ('coins', self.info['coins'] + [{'id': 'noid'}]),
                             ('mining_tls_default', 'strict')]:
            with self.subTest(field=field):
                mutated = copy.deepcopy(self.info)
                mutated[field] = value
                with self.assertRaises(ValueError):
                    boundary.validate_info(mutated)

    def test_nonzero_or_hidden_fee_rejected(self):
        for field, value in [('configured_coin_ppm', {'proxima': 10000}),
                             ('catalog_coin_ppm', {'noid': 10000}),
                             ('release_mode', 'active')]:
            with self.subTest(field=field):
                mutated = copy.deepcopy(self.info)
                mutated['fee_assets'][field] = value
                with self.assertRaises(ValueError):
                    boundary.validate_info(mutated)

    def test_excluded_kernels_rejected(self):
        for symbol in [b'pearl_gemm', b'btx_matmul', b'csd_sha256d']:
            with self.assertRaises(ValueError):
                boundary.validate_blob(b'ELF fixture ' + symbol)


if __name__ == '__main__':
    unittest.main()
