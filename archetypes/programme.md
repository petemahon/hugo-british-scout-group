+++
# Termly programme archetype. See SPEC-03 for the full feature spec.
#
# Filename convention:    <section>-<term>-<year>.md
# Example:                content/programme/cubs-summer-2026.md
# Run:                    hugo new programme/cubs-summer-2026.md
#
# Safeguarding & GDPR - read before publishing
# ---------------------------------------------
# OSM-level programme detail is NOT safe to publish on a public site.
# This page is the public-facing, sanitised summary.
#
#   - Don't name young people.
#   - Don't name external visiting adults unless they have consented;
#     when in doubt, omit names and use a role title in the notes.
#   - Don't publish specific addresses for activities held at private
#     venues. Use "off-site" or "at the District HQ" instead.
#   - Don't expose hazardous-activity risk-assessment detail; that
#     belongs in OSM, not on the public site.
#
# Density modes - choose with `density` below
# -------------------------------------------
#   themes_only   (default) - title + theme chips only. Safer.
#   full                    - adds the `notes` column. Use only when
#                             every notes value has been reviewed for
#                             the safeguarding points above.

title          = "{{ replace .Name "-" " " | title }}"

# REQUIRED. One of: squirrels, beavers, cubs, scouts, explorers, network.
section        = ""

# REQUIRED. Display label for the term, e.g. "Summer 2026".
term           = ""

# REQUIRED. First meeting date. Used by the home-page programme-current
# block ("is this programme current?") and by the archive cutoff.
term_start     = {{ .Date }}

# REQUIRED. Last meeting date. Programmes whose term_end is in the past
# are hidden unless params.programme.keep_archive = true.
term_end       = {{ .Date }}

# Optional free-text anchor for BSO Groups that align with a host-country
# school calendar - e.g. "British School in the Netherlands Spring Term".
# Empty by default.
term_anchor    = ""

# Density: "themes_only" (default) or "full". See safeguarding note above.
density        = "themes_only"

# Optional cross-reference to a SPEC-05 kit list that applies across the
# term. Empty by default.
# kit_list_ref = "/kit-lists/cubs-weekly/"

# Optional term-level notes - HTML allowed for occasional emphasis or a
# link. Renders below the table. "Week 5 is half-term", etc.
notes          = ""

# Optional. Set true once the District has signed off the programme per
# POR 9.1.2.1. Renders a small badge below the title.
district_approved = false

# Standard Hugo. Set to false to publish.
draft          = true

# Weekly meetings - at least one [[weeks]] block per published programme.
# `themes` keys come from data/programme_themes.toml.
# [[weeks]]
#   number            = 1
#   date              = 2026-04-15
#   title             = "Welcome back & investiture"
#   themes            = ["skills-for-life", "beliefs-and-attitudes"]
#   notes             = "Bring your necker. New Cubs welcome."   # full density only
#   cancelled         = false
#   cancellation_note = ""
+++

Optional opening paragraph rendered above the table - high-level intent
for the term ("This term we're working towards the Naturalist activity
badge, with a camp in week 8"). Keep it short.
