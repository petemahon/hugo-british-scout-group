+++
# Volunteer role archetype. SPEC-09.
#
# Create with:  hugo new support-us/volunteer-roles/treasurer.md
# Renders at:   /support-us/volunteer-roles/<slug>/
#
# A role appears on the listing, the homepage recruitment banner, and
# (from SPEC-11) the "We're recruiting" nav link ONLY while it is open:
#   role_open != false  AND  (no `closes` date OR closes is today/future).
# Set role_open = false to soft-disable without deleting; set a past
# `closes` date to retire it automatically. (We use `role_open`, not
# `published` - Hugo reserves `published` as a date field.)
#
# DBS / safeguarding (SPEC-COMMON §11):
#   dbs_required defaults true - DBS is uniform UK Scouts policy and
#   applies to BSO Groups too. We never collect DBS information on the
#   site; the role page only STATES that a check is required. Note the
#   UK-residency-since-age-10 nuance: applicants resident in the UK for
#   less than the relevant period may need additional overseas checks -
#   that is handled offline by the Group/BSO, not surfaced or collected
#   here.

title           = "{{ replace .Name "-" " " | title }}"

# Optional section this role serves - a data/scout_sections.toml key
# (squirrels|beavers|cubs|scouts|explorers|network). Leave "" for
# Group-wide roles (Treasurer, Trustee).
section         = ""

time_commitment = ""              # free text, e.g. "Two hours a week, term time"
dbs_required    = true            # see header note

# remote = true marks a role that can be done from anywhere - renders a
# "Remote OK" badge. BSO-relevant: BSO Area roles are explicitly open to
# any nationality, anywhere. Local meeting roles stay false.
remote          = false

# start_date = 2026-09-01         # optional
# closes     = 2026-12-31         # optional - role hidden after this date

apply_email     = "volunteers@example.org"   # required - generic Group inbox
# apply_url     = ""              # optional external application link

role_open       = true            # set false to soft-disable (NOT `published`)
draft           = true
+++

Describe what the role involves and who it would suit. Keep it about the
ROLE, not a named person who's standing down.
