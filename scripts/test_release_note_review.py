import hashlib
import json
from pathlib import Path
import tempfile
import unittest
from release_note_review import CHECKS, check_note


class NoteReviewTests(unittest.TestCase):
    def setUp(self):
        self.tmp = tempfile.TemporaryDirectory()
        self.addCleanup(self.tmp.cleanup)
        self.note = Path(self.tmp.name) / "note.md"
        self.review = Path(self.tmp.name) / "review.json"
        self.text = "# INVminer v1.2.3\n\n## Changes\n\n- Improve NOID on RTX 4090.\n\n## Downloads\n\nhttps://example.com/package\n"
        self.note.write_text(self.text)
        self.record = {"schema": 1, "version": "1.2.3", "channel": "public",
                       "note_sha256": hashlib.sha256(self.text.encode()).hexdigest(),
                       "reviewed_by": "release agent",
                       "reference_release": "https://example.com/releases/v1.2.2",
                       "checks": dict.fromkeys(CHECKS, True),
                       "changes": [{"text": "Improve NOID on RTX 4090.",
                                    "evidence": ["qualification.json"]}]}
        self.save()

    def save(self):
        self.review.write_text(json.dumps(self.record))

    def check(self, live=None):
        return check_note(self.note, self.review, "1.2.3", "public", live)

    def test_exact_review_and_live_pass(self):
        self.assertTrue(self.check(self.text)["live_release_checked"])

    def test_missing_review_blocks(self):
        self.review.unlink()
        with self.assertRaises(OSError):
            self.check()

    def test_edit_after_review_blocks(self):
        self.note.write_text(self.text + "Unreviewed text.\n")
        with self.assertRaisesRegex(ValueError, "changed after review"):
            self.check()

    def test_each_unchecked_item_blocks(self):
        for key in CHECKS:
            with self.subTest(key=key):
                self.record["checks"] = dict.fromkeys(CHECKS, True)
                self.record["checks"][key] = False
                self.save()
                with self.assertRaisesRegex(ValueError, "checklist incomplete"):
                    self.check()

    def test_wrong_version_or_channel_blocks(self):
        for key, value in [("version", "1.2.4"), ("channel", "internal")]:
            original = self.record[key]
            self.record[key] = value
            self.save()
            with self.assertRaisesRegex(ValueError, "version/channel"):
                self.check()
            self.record[key] = original

    def test_change_without_evidence_blocks(self):
        self.record["changes"][0]["evidence"] = []
        self.save()
        with self.assertRaisesRegex(ValueError, "evidence"):
            self.check()

    def test_unreviewed_changes_block_even_with_current_digest(self):
        self.record["changes"][0]["text"] = "Another change."
        self.save()
        with self.assertRaisesRegex(ValueError, "reviewed scope"):
            self.check()

    def test_live_difference_blocks(self):
        with self.assertRaisesRegex(ValueError, "live Release Note"):
            self.check(self.text.rstrip())

    def test_missing_reference_blocks(self):
        del self.record["reference_release"]
        self.save()
        with self.assertRaisesRegex(ValueError, "reference"):
            self.check()

    def test_duplicate_changes_heading_blocks(self):
        self.note.write_text(self.text + "\n## Changes\n\n- Duplicate.\n")
        self.record["note_sha256"] = hashlib.sha256(self.note.read_bytes()).hexdigest()
        self.save()
        with self.assertRaisesRegex(ValueError, "one Changes"):
            self.check()


if __name__ == "__main__":
    unittest.main()
