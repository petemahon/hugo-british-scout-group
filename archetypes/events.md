+++
# Filename convention: YYYY-MM-DD-kebab-case-title.md
# Hugo will render this at /events/<filename-without-extension>/.
# See SPEC-02 in the project knowledge for the full schema.

title = "{{ replace .Name "-" " " | title }}"

# When -----------------------------------------------------------------------
# `date` IS the event start time. Required. Used for sort, by the listing
# template's `Date >= now` filter, and as DTSTART in the .ics. Edit the
# auto-filled value below to the actual event start.
date = {{ .Date }}

# `publishDate` is when this event was added to the site. The archetype
# sets it to the moment of `hugo new` and you should normally leave it
# alone — it's guaranteed in the past at any later build, so Hugo's
# `--buildFuture=false` deploy policy still includes future events.
# (Without publishDate set, Hugo's future check uses `date` itself,
# which would suppress every upcoming event.)
publishDate = {{ .Date }}

# Optional explicit end. Defaults to:
#   - date + 1h30 for timed events
#   - same date for all-day events (single-day; .ics still emits the
#     RFC-5545-correct exclusive end of the next day)
# end   = ""

# all_day  = false           # If true, the .ics uses VALUE=DATE (no times).
# timezone = ""              # IANA TZ. Defaults to params.events.timezone.

# Where ----------------------------------------------------------------------
# Required. Venue name only — the headline location string.
location = ""

# address  = ""              # Optional full street address.
# map_url  = ""              # Optional. OpenStreetMap or Google Maps —
#                            # whichever you prefer; theme is map-agnostic.

# Who ------------------------------------------------------------------------
# `sections` is the shared taxonomy. Values are keys from
# data/scout_sections.toml: squirrels, beavers, cubs, scouts, explorers,
# network. Renders as colour-coded badges; links to the per-section filter.
sections = []

# audience = ""              # "Cubs only", "Whole Group", "Parents welcome".
# dress    = ""              # "Full uniform", "Activity uniform", "Mufti".

# Cost & RSVP ----------------------------------------------------------------
# cost          = ""         # Free text — "£25", "Free", "€10 per Cub".
# cost_includes = ""         # "Activities, food, accommodation".
# cost_pay_url  = ""         # External payment link only — never a form.

# rsvp_to       = ""         # Generic Group email — gsl@1stanytown.org.uk.
#                            # NEVER a personal address.
# rsvp_deadline = ""         # Optional ISO-8601.

# Kit (cross-references SPEC-05 once that ships) -----------------------------
# kit_list_ref   = ""        # Slug of a local kit list.
# kit_list_url   = ""        # External kit list link if not local.
# additional_kit = ""        # Per-event additions on top of the referenced
#                            # list. HTML allowed.

# Cancellation ---------------------------------------------------------------
# cancelled         = false  # Renders Cancelled badge + STATUS:CANCELLED.
# cancellation_note = ""     # Optional explanation alongside the badge.

# Image (optional) -----------------------------------------------------------
# Drop the image at assets/events/<slug>/cover.jpg in your site repo.
# cover_image   = "cover.jpg"
# cover_alt     = ""         # Required when cover_image is set.
# photo_consent = true       # Required when ANY image is referenced.
#                            # See SPEC-COMMON §10 for the rule.

# BSO dual times (optional) --------------------------------------------------
# When an event is held overseas, render both local and UK times. Both must
# be set for dual rendering; otherwise only the single time line shows.
# Pattern lifted verbatim from britishscoutingoverseas.org.uk.
# times_local = "20:30 (Brussels)"
# times_uk    = "19:30 (UK)"

# External event (optional) --------------------------------------------------
# Use when the event is hosted by another body (District camp, World
# Jamboree). The Group's events page will still list it, with the link
# label going out to the host's page.
# external_url       = ""
# external_url_label = "More information"

draft = true
+++

Brief description of the event. The first paragraph or so will be used
as the .ics DESCRIPTION when no `summary` field is set.
