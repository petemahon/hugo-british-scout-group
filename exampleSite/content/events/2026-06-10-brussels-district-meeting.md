+++
title       = "Brussels District planning meeting"

# Event start time (LOCAL clock at the event's timezone). For this event
# the `timezone` field below is Europe/Brussels, so this 20:30 is local
# Brussels wall-clock time. Used by Hugo for sort and listing.
date        = 2026-06-17T20:30:00+02:00

# When the event was added to the site. Set in the past so Hugo's
# `--buildFuture=false` build still includes this future event.
publishDate = 2026-05-29T19:00:00+02:00

# Optional explicit end. Omit to default to date + 1h30.
end         = 2026-06-17T22:00:00+02:00

# Per-event timezone override (site default is Europe/London — see
# exampleSite/hugo.toml). Drives the TZID parameter on DTSTART/DTEND in
# the .ics. This is the SOURCE-OF-TRUTH timezone for the event.
timezone    = "Europe/Brussels"

location    = "Online (Microsoft Teams)"
audience    = "Section Leaders + Assistants"
dress       = "Mufti"

# BSO dual-time rendering. Both fields are pure free-text strings — the
# .ics still uses `date` for DTSTART, so calendar subscribers get the
# correct wall-clock time wherever they are. The dual rendering exists
# purely to help readers in different timezones see both times at a
# glance, lifted from the pattern at britishscoutingoverseas.org.uk.
times_local = "20:30 (Brussels)"
times_uk    = "19:30 (UK)"

# No section badges — this is a leader-coordination meeting, not a
# meeting for any particular Scout section.
sections    = []

draft       = false

# Demo-roll metadata — used only by scripts/roll-example-dates.py to
# keep the example site's events looking fresh against the build time.
# Group sites consuming the theme do NOT need a [demo] block — real
# Group events have real fixed dates.
[demo]
  target_offset_days = 14    # event happens ~2 weeks from build time
  publish_lead_days  = 5     # public listing about 5 days ago
+++

A short planning call for Section Leaders and Assistants across the
Brussels District ahead of the autumn term. We'll cover the term card,
the District camp shortlist, safeguarding refresher dates, and any
help needed on the volunteer rota.

Dial-in details will be sent by email the day before. If you can't
make it, drop the GSL a note and we'll fold your input into the notes.
