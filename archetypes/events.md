+++
# Title shown on the listing, the single page, and the calendar SUMMARY.
title       = "{{ replace .Name "-" " " | title }}"

# Event start time — the source-of-truth start, used by the listing
# filter, by Hugo's sort, and as DTSTART in the .ics.
# ISO-8601 with a timezone offset. The offset should match the
# `timezone` field below (or the site default).
date        = {{ .Date }}

# When the event was added to the site. Set in the past so Hugo's
# `--buildFuture=false` build still includes this future event.
# Auto-filled to NOW at `hugo new` time, which is exactly what we want.
publishDate = {{ .Date }}

# Optional explicit end. Omit to default to date + 1h30.
# end       = "2026-07-12T17:00:00+01:00"

# Per-event timezone override (site default is set in hugo.toml under
# [params.events]). Drives the TZID parameter on DTSTART/DTEND in the
# .ics. This is the SOURCE-OF-TRUTH timezone for the event.
# timezone  = "Europe/London"

# Single-time-zone groups can skip times_local and times_uk; date
# already drives the time. For BSO events with parents in two zones,
# set BOTH and the single-event page will render both. The card view
# (home block + listing) shows times_local only.
# times_local = "20:30 (Brussels)"
# times_uk    = "19:30 (UK)"

location    = ""
# address     = "12 Hut Lane, Anytown, AT1 2BC"     # optional, single page only
audience    = ""
dress       = ""
cost        = ""

# ─── Kit (SPEC-05) ─────────────────────────────────────────────────
# Link this event to a reusable kit list at /kit-lists/<slug>/. When set
# (and params.features.kit_lists is on), the event page shows a
# "Kit list for this camp → <title>" link. Build warns if the slug has
# no matching kit list.
# kit_list_ref   = "cubs-weekend"
#
# Free text appended to the kit list for THIS event only — anything
# beyond the standard list. Shown under the kit link on the event page,
# and appended when the list is transcluded inline in the body below
# with the kit-list shortcode (see the README for the exact syntax).
# additional_kit = "Swimming kit, and £5 for the activity centre."

# Sections taxonomy. Renders coloured pill badges on the card and on
# the single page. Allowed keys: squirrels, beavers, cubs, scouts,
# explorers, network. Leave empty for events that aren't section-
# specific (e.g. leader training).
sections    = []

# ─── Status (D8) ───────────────────────────────────────────────────
# Allowed values:
#   "active"      (default) — event is happening as advertised.
#   "cancelled"   event is off. The card and single page show a red
#                 Cancelled pill; the per-event .ics still renders
#                 (with an empty VCALENDAR body); the event is omitted
#                 from /events/all.ics so subscribers' calendar items
#                 disappear on next refresh.
#   "postponed"   event has been rescheduled. Update `date` and `end`
#                 to the NEW time and BUMP `revision` by 1 (see below).
#                 The card and single page show an amber Postponed pill;
#                 the .ics emits the new date with DESCRIPTION prefixed
#                 "Note: new date/time. " and SEQUENCE bumped, so
#                 subscriber calendars update the meeting in place.
status      = "active"

# Bump this integer each time you change the date of an existing
# event. Required for status="postponed" to propagate cleanly to
# subscribed calendars (the .ics will emit SEQUENCE:1 even if you
# leave revision at 0, but bumping it here keeps the metadata honest
# for any future re-postponement). Defaults to 0; ignored unless the
# event has been rescheduled.
# revision    = 1

draft       = true
+++

A short paragraph or two describing the event. This becomes the
DESCRIPTION field in the .ics if `summary` isn't set in the
front-matter, truncated to 500 characters.
