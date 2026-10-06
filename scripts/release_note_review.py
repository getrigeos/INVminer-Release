#!/usr/bin/env python3
"""Bind an editorial review to exact release-note bytes; optionally check live text.

The release agent must actually review the facts and evidence. This checker
validates the review record, not the truth of a performance claim.
"""
import argparse
import hashlib
import json
from pathlib import Path
import re

CHECKS = (
    "current_user_visible_changes_only",
    "previous_release_format_reviewed",
    "commands_downloads_fees_and_compatibility_checked",
    "performance_claims_supported",
    "internal_process_details_kept_in_validation_records",
)


def require(condition, message):
    if not condition:
        raise ValueError(message)


def check_note(note_path, review_path, version, channel, live_note=None):
    require(re.fullmatch(r"\d+\.\d+\.\d+", version), "invalid version")
    require(channel in ("public", "internal"), "invalid channel")
    raw = Path(note_path).read_bytes()
    note = raw.decode("utf-8")
    review = json.loads(Path(review_path).read_text())
    require(review.get("schema") == 1, "unsupported review schema")
    require(review.get("version") == version and review.get("channel") == channel,
            "review version/channel mismatch")
    digest = hashlib.sha256(raw).hexdigest()
    require(review.get("note_sha256") == digest, "note changed after review")
    require(re.match(r"# INVminer (?:GPU )?v?" + re.escape(version) + r"(?:\s|$)", note),
            "note title/version mismatch")
    require(isinstance(review.get("reviewed_by"), str) and review["reviewed_by"].strip(),
            "missing editorial reviewer")
    require(isinstance(review.get("reference_release"), str)
            and review["reference_release"].startswith("https://"),
            "missing previous release format reference")
    checks = review.get("checks", {})
    require(isinstance(checks, dict) and all(checks.get(k) is True for k in CHECKS),
            "editorial checklist incomplete")
    sections = re.findall(
        r"^## (?:Changes|更新内容|更新內容)\s*\n(.*?)(?=^## |\Z)", note,
        re.MULTILINE | re.DOTALL,
    )
    require(len(sections) == 1, "expected one Changes section")
    listed = [line[2:].strip() for line in sections[0].splitlines() if line.startswith("- ")]
    require(listed and all(not line.strip() or line.startswith("- ")
                          for line in sections[0].splitlines()),
            "Changes must contain concise bullet items only")
    changes = review.get("changes")
    require(isinstance(changes, list) and all(isinstance(c, dict) for c in changes),
            "missing reviewed change list")
    require([c.get("text") for c in changes] == listed, "Changes differ from reviewed scope")
    for change in changes:
        evidence = change.get("evidence")
        require(isinstance(evidence, list) and evidence
                and all(isinstance(x, str) and x.strip() for x in evidence),
                "missing change evidence reference")
    if live_note is not None:
        require(isinstance(live_note, str) and live_note.encode("utf-8") == raw,
                "live Release Note differs from reviewed bytes")
    return {"pass": True, "version": version, "channel": channel,
            "note_sha256": digest, "review_sha256": hashlib.sha256(
                Path(review_path).read_bytes()).hexdigest(),
            "live_release_checked": live_note is not None}


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--note", type=Path, required=True)
    parser.add_argument("--review", type=Path, required=True)
    parser.add_argument("--version", required=True)
    parser.add_argument("--channel", choices=("public", "internal"), required=True)
    parser.add_argument("--live-release-json", type=Path)
    parser.add_argument("--output", type=Path)
    args = parser.parse_args()
    try:
        live = None
        if args.live_release_json:
            response = json.loads(args.live_release_json.read_text())
            expected_tag = ("v" if args.channel == "public" else "01pool-miner-v") + args.version
            require(response.get("tag_name") == expected_tag, "live release tag mismatch")
            key = "body" if args.channel == "public" else "description"
            require(isinstance(response.get(key), str), "missing live Release Note")
            live = response[key]
        result = check_note(args.note, args.review, args.version, args.channel, live)
    except (ValueError, OSError, TypeError, KeyError) as error:
        parser.exit(1, "RELEASE_NOTE_REVIEW_FAILED: " + str(error) + "\n")
    output = json.dumps(result, indent=2) + "\n"
    if args.output:
        args.output.write_text(output)
    print(output, end="")


if __name__ == "__main__":
    main()
