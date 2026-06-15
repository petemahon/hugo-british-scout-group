+++
# Camp kit-list archetype. SPEC-05.
#
# Filename convention:  <slug>.md  (no date prefix - kit lists are reusable)
# Example:              content/kit-lists/cubs-weekend.md
# Run:                  hugo new kit-lists/cubs-weekend.md
#
# A kit list is structured data: one or more [[categories]], each with a
# list of [[categories.items]]. Both the on-screen view and the printable
# checkbox view (/kit-lists/<slug>/print.html) are generated from this
# same front-matter - never maintain two copies.

title         = "{{ replace .Name "-" " " | title }} Kit List"

# Which section this list is for - one of the keys in
# data/scout_sections.toml: squirrels | beavers | cubs | scouts |
# explorers | network. Drives the grouping on /kit-lists/.
section       = "cubs"

# Free text describing the trip. Convention: "weekend", "summer",
# "winter", "indoor", "expedition". Surfaced as a label only.
camp_type     = "weekend"

# "temperate" (default) | "desert" | "winter". Labels the list and lets
# Groups in hot climates ship a clearly-marked variant. Does not change
# rendering - it is editorial labelling for parents.
climate       = "temperate"

# Version + review provenance. last_reviewed is required so parents can
# see the list is current; a stale kit list is worse than none.
version       = "2026.1"
last_reviewed = {{ now.Format "2006-01-02" }}
reviewed_by   = ""                  # leader nickname, optional

# Optional HTML intro above the categories - hire-it offers, where to
# buy uniform, Scout-shop links all go here as Markdown/HTML.
intro         = ""

# Mobile-phone policy block. false by default - each Group affirmatively
# decides to publish one. When true, the block renders using
# [params.kit_lists].default_phone_policy_text (or the theme i18n
# default if that is blank). See SPEC-05 §Safeguarding.
phone_policy  = false

# BSO / cross-border travel notes. Free HTML. Leave "" for UK Groups.
# Recommended contents for a Group whose camps cross a border:
#   - Passport + a photocopy kept separately
#   - GHIC / EHIC card and travel insurance details
#   - A little local currency for tuck (e.g. €10 / AED 50)
#   - Travel adapters
#   - Local-pharmacy substitutes for any UK-only brand a parent assumes
#     will travel (sun cream, antihistamines, etc.)
cross_border_notes = ""

# "Please leave at home" list - free HTML. Phones, valuables, sweets, etc.
non_essential = ""

# Structured items. Repeat [[categories]] per logical grouping
# (Sleeping, Clothing, Personal, Wash kit, …). Within each, repeat
# [[categories.items]] per item.
#
#   quantity     defaults to 1; set 3 for "3 pairs of socks".
#   alternative  free text for a substitute - "or two warm blankets".
[[categories]]
  name  = "Sleeping"
  notes = ""                        # optional HTML, renders below the items

  [[categories.items]]
    name        = "Sleeping bag"
    quantity    = 1
    alternative = "Or two warm fleece blankets if no bag"

  [[categories.items]]
    name        = "Roll mat"
    quantity    = 1

[[categories]]
  name = "Clothing"

  [[categories.items]]
    name        = "Socks"
    quantity    = 3
    alternative = ""

  [[categories.items]]
    name     = "Waterproof coat"
    quantity = 1

# Standard Hugo. Set to false to publish.
draft = true
+++

Optional Markdown body - renders nowhere by default; keep notes for
leaders here, or move anything parent-facing into `intro` above.
