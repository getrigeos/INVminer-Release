#!/usr/bin/env python3
"""The v0.1.74 user-authorized, performance-only public note contract.

This checks structure and arithmetic, not measurement provenance. The public
repository also pins each approved row to the private final-package evidence.
"""

import math
from pathlib import Path
import re
import sys


TITLE = "# INVminer v0.1.74"
CONDITIONS = (
    "v0.1.73 → v0.1.74 · Same GPU/settings, warmed 60-second runs; average board power. "
    "同卡同設定，預熱後測試 60 秒；功耗為平均板卡功耗。"
)
HEADER = (
    "| GPU | Settings / 設定 | Power limit / 功率上限 | MH/s (0.1.73 → 0.1.74) "
    "| Hashrate / 算力變化 | W (0.1.73 → 0.1.74) | Power / 功耗變化 | MH/s/W / 能效變化 |"
)
SEPARATOR = "|---|---|---|---|---|---|---|---|"


def validate(version, body):
    if version != "0.1.74":
        raise ValueError("compact performance note is authorized only for 0.1.74")
    lines = [line for line in body.splitlines() if line]
    if lines[:4] != [TITLE, CONDITIONS, HEADER, SEPARATOR]:
        raise ValueError("unexpected title, conditions, or performance table")
    if not 1 <= len(lines[4:]) <= 7:
        raise ValueError("expected one to seven measured GPU/settings rows")
    seen = set()
    for line in lines[4:]:
        if not line.startswith("| ") or not line.endswith(" |"):
            raise ValueError("only performance table rows may follow the header")
        columns = [part.strip() for part in line.split("|")[1:-1]]
        if len(columns) != 8:
            raise ValueError("unexpected performance columns")
        gpu, setting, cap, rate, rate_change, power, power_change, efficiency = columns
        if gpu not in {"RTX 3080", "RTX 4070", "RTX 4090", "RTX 5090"}:
            raise ValueError("unqualified GPU")
        if setting not in {"Default / 預設", "LMC 810 MHz, core +250 MHz", "LMC 810 MHz, core +400 MHz"}:
            raise ValueError("unqualified settings")
        if gpu == "RTX 4070" and setting != "Default / 預設":
            raise ValueError("4070 OC was canceled by the user")
        if (gpu, setting) in seen:
            raise ValueError("duplicate GPU/settings row")
        seen.add((gpu, setting))
        if not re.fullmatch(r"[1-9][0-9]{2} W", cap):
            raise ValueError("invalid power cap")

        def pair(value):
            if not re.fullmatch(r"[0-9]+\.[0-9]+ → [0-9]+\.[0-9]+", value):
                raise ValueError("expected old → new decimal measurements")
            values = tuple(map(float, value.split(" → ")))
            if not all(math.isfinite(x) and x > 0 for x in values):
                raise ValueError("invalid measurement")
            return values

        old_rate, new_rate = pair(rate)
        old_power, new_power = pair(power)
        expected = (
            (new_rate / old_rate - 1) * 100,
            (new_power / old_power - 1) * 100,
            ((new_rate / new_power) / (old_rate / old_power) - 1) * 100,
        )
        for value, computed in zip((rate_change, power_change, efficiency), expected):
            if not re.fullmatch(r"[+-][0-9]+\.[0-9]{2}%", value):
                raise ValueError("expected signed two-decimal percentage")
            if abs(float(value[:-1]) - computed) > 0.03:
                raise ValueError("percentage does not match the measurements")


if __name__ == "__main__":
    try:
        if len(sys.argv) != 3:
            raise ValueError("usage: check-release-note-performance.py X.Y.Z release-note.md")
        validate(sys.argv[1], Path(sys.argv[2]).read_text(encoding="utf-8"))
    except (ValueError, OSError) as error:
        sys.exit(str(error))
    print("INVminer v0.1.74 compact performance note: OK")
