+++
# Trustee Board meeting summary archetype. SPEC-13.
#
# Create with:  hugo new about/minutes/2026-03-board.md
# Renders at:   /about/minutes/  via layouts/about/minutes/list.html
#               (cross-linked from the governance page)
#
# This file is the PUBLIC SUMMARY only - a short, redacted account of the
# decisions taken. The full minutes are written from the universal template
# at documentation/templates/trustee-minutes-template.md and kept PRIVATELY
# by the board (never committed to a public site repo).
#
# Gating: only renders when features.governance AND features.trustee_minutes
# are on AND this file has `approved = true`.
#
# FIRST TIME ONLY - create the section index content/about/minutes/_index.md:
#
#     +++
#     title = "Trustee Board meeting summaries"
#     intro = "A short summary of the decisions our Trustee Board takes."
#     draft = false
#     +++

title = "Trustee Board - March 2026"

# Meeting date - used for display and newest-first ordering.
meeting_date = "2026-03-12"

# Meeting type: "ordinary" | "extraordinary" | "agm"
meeting_type = "ordinary"

# Scouting level for this charity: "group" | "district" | "county".
# Optional - falls back to [params.minutes].level in hugo.toml.
# level = "group"

# Optional headline facts shown above the summary.
present_count = 0       # number of trustees present (0 = hide)
quorum_met    = true

# Optional: link to an APPROVED, redacted full-minutes PDF if the board
# chooses to publish one (drop the file in static/about/reports/ and it will
# also surface in /about/reports/ if listed in data/reports.toml).
# minutes_pdf = "/about/reports/2026-03-trustee-minutes.pdf"

# Publication gate. Only `true` files render. Defaults off so nothing is
# published by accident.
approved = false

draft = true

# Keep this content file out of disk output as a standalone page and out of
# site-wide collections - it is rendered inline on the archive page only.
# (TOML: this table must come after all top-level scalar keys above.)
[build]
  render = "never"
  list   = "local"
+++

At its meeting on [Month Year], the Trustee Board:

- agreed …
- approved …
- reviewed …

The full Trustees' Annual Report and accounts are published in our
[reports archive](/about/reports/).
