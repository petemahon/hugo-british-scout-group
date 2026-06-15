#!/usr/bin/env python3
"""
roll-example-dates.py - keep the exampleSite events looking fresh.

Reads each Markdown file under exampleSite/content/events/, looks for a
`[demo]` table in the front-matter, and rewrites `date`, `publishDate`
and `end` so the demo always shows future-dated events relative to the
build time.

The committed dates in git are the canonical "last known good" example
dates; this script overwrites them in-flight before every `hugo serve`
and every CI build of the theme's Pages preview. Group sites consuming
the theme do NOT need `[demo]` blocks - real Group events have real
fixed dates, and this script never touches them.

Front-matter contract (TOML):

    [demo]
      target_offset_days = 65    # event happens this many days from now
      publish_lead_days  = 23    # publishDate = now - this many days

Idempotent: re-running picks the same offsets each time, applied
relative to the new `now`. The result is a working tree with modified
event files that should NOT be committed.

Stdlib only - Python 3.9+.
"""

from __future__ import annotations

import re
import sys
from datetime import datetime, timedelta, timezone
from pathlib import Path

REPO_ROOT  = Path(__file__).resolve().parent.parent
EVENTS_DIR = REPO_ROOT / "exampleSite" / "content" / "events"

# Front-matter delimited by +++ on its own line (TOML). Captures:
#   1: opening delimiter (+++ + newline)
#   2: front-matter body
#   3: closing delimiter (newline + +++ + newline)
#   4: rest of file (Markdown body)
FRONT_MATTER_RE = re.compile(
    r"^(\+\+\+\r?\n)(.*?)(\r?\n\+\+\+\s*\r?\n)(.*)$",
    re.DOTALL,
)

# Match a [demo] table header on its own line.
DEMO_TABLE_RE = re.compile(r"(?m)^\s*\[demo\]\s*$")


def split_frontmatter(text: str):
    """Return (open_delim, front, close_delim, body) or None if no fence."""
    m = FRONT_MATTER_RE.match(text)
    if not m:
        return None
    return m.group(1), m.group(2), m.group(3), m.group(4)


def extract_value(front: str, key: str) -> str | None:
    """Extract the bare token value of `key = ...` (stops at whitespace or #)."""
    pattern = rf"(?m)^\s*{re.escape(key)}\s*=\s*([^\s#]+)"
    m = re.search(pattern, front)
    return m.group(1) if m else None


def replace_value(front: str, key: str, new_value: str) -> str:
    """Replace the value of `key = ...`, preserving any trailing comment."""
    pattern = rf"(?m)^(\s*{re.escape(key)}\s*=\s*)([^\s#]+)(\s*(?:#[^\n]*)?\s*)$"
    return re.sub(
        pattern,
        lambda m: f"{m.group(1)}{new_value}{m.group(3)}",
        front,
        count=1,
    )


def has_demo_block(front: str) -> bool:
    return bool(DEMO_TABLE_RE.search(front))


def parse_int_value(s: str) -> int:
    return int(s.split("#", 1)[0].strip())


def parse_iso(s: str) -> datetime:
    return datetime.fromisoformat(s.strip())


def fmt_iso(d: datetime) -> str:
    # Python's isoformat() yields RFC-3339-compatible output that TOML
    # accepts as an Offset Date-Time when a tz offset is present.
    return d.isoformat()


def roll_event(path: Path, now: datetime) -> bool:
    """Roll one event file. Returns True if changed, False otherwise."""
    text  = path.read_text(encoding="utf-8")
    parts = split_frontmatter(text)
    if not parts:
        print(f"  {path.name}: no TOML front-matter, skipping", file=sys.stderr)
        return False

    open_d, front, close_d, body = parts

    if not has_demo_block(front):
        return False

    target_str = extract_value(front, "target_offset_days")
    if target_str is None:
        print(f"  {path.name}: [demo] but no target_offset_days, skipping",
              file=sys.stderr)
        return False
    target_offset_days = parse_int_value(target_str)

    publish_str = extract_value(front, "publish_lead_days")
    publish_lead_days = parse_int_value(publish_str) if publish_str else None

    date_str = extract_value(front, "date")
    if date_str is None:
        print(f"  {path.name}: no `date` field, skipping", file=sys.stderr)
        return False
    original_date = parse_iso(date_str)

    # New date = (now + offset_days), preserving original time-of-day and tz.
    new_target_date = (now + timedelta(days=target_offset_days)).date()
    new_date = datetime.combine(
        new_target_date,
        original_date.time(),
        tzinfo=original_date.tzinfo,
    )
    delta = new_date - original_date

    new_front = replace_value(front, "date", fmt_iso(new_date))

    end_value = extract_value(front, "end")
    if end_value:
        original_end = parse_iso(end_value)
        new_end = original_end + delta
        new_front = replace_value(new_front, "end", fmt_iso(new_end))

    if publish_lead_days is not None:
        publish_value = extract_value(front, "publishDate")
        if publish_value:
            original_publish = parse_iso(publish_value)
            new_publish_date = (now - timedelta(days=publish_lead_days)).date()
            new_publish = datetime.combine(
                new_publish_date,
                original_publish.time(),
                tzinfo=original_publish.tzinfo,
            )
            new_front = replace_value(
                new_front, "publishDate", fmt_iso(new_publish)
            )

    path.write_text(open_d + new_front + close_d + body, encoding="utf-8")
    print(f"  {path.name}: date → {new_date.date()}")
    return True


def main() -> int:
    if not EVENTS_DIR.is_dir():
        print(f"Events dir not found: {EVENTS_DIR}", file=sys.stderr)
        return 1

    now = datetime.now(timezone.utc)
    print(f"Rolling example event dates (now = {now.isoformat()})")

    rolled = 0
    for path in sorted(EVENTS_DIR.glob("*.md")):
        if path.name.startswith("_"):
            continue
        if roll_event(path, now):
            rolled += 1

    print(f"Rolled {rolled} event file(s).")
    return 0


if __name__ == "__main__":
    sys.exit(main())
