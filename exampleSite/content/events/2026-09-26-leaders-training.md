+++
title       = "Leaders' Safeguarding Refresher"

# Event start time — the source-of-truth start, used by the listing
# filter, by Hugo's sort, and as DTSTART in the .ics.
date        = 2026-09-26T19:30:00+01:00

# When the event was added to the site. Set in the past so Hugo's
# `--buildFuture=false` build still includes this future event.
publishDate = 2026-08-01T10:00:00+01:00

# Optional explicit end. Omit to default to date + 1h30.
end         = 2026-09-26T21:00:00+01:00

location    = "Anytown Scout Hut"
audience    = "All Group volunteers"
dress       = "Mufti"

# No section badges — this is a leader-training event, not for any
# particular Scout section.
sections    = []

# ─── D8 status enum ────────────────────────────────────────────────
# Demonstrates the cancelled state. The card renders a red Cancelled
# pill; the event-page renders the same; the per-event /events/.../event.ics
# emits a well-formed but empty VCALENDAR (URL stays valid, calendar
# subscribers will see the meeting removed); and the event is omitted
# from /events/all.ics so subscribed parents' calendars update.
status      = "cancelled"

draft       = false

# Demo-roll metadata — used only by scripts/roll-example-dates.py.
[demo]
  target_offset_days = 140   # event happens ~5 months from build time
  publish_lead_days  = 95    # public listing ~3 months ago
+++

This event has been cancelled. The District training calendar is
being revised and we'll publish a new date once the new programme is
confirmed — keep an eye on the events page.

Volunteers who had this in their calendar via our subscription feed
will see the meeting disappear automatically.
