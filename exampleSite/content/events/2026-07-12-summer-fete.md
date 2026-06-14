+++
title       = "Summer Fete"
# Event start time — the source-of-truth start, used by the listing
# filter, by Hugo's sort, and as DTSTART in the .ics.
date        = 2026-08-17T13:00:00+01:00

# When the event was added to the site. Set in the past so Hugo's
# `--buildFuture=false` build still includes this future event.
# (See SPEC-02 for the full rationale.)
publishDate = 2026-05-21T10:00:00+01:00

# Optional explicit end. Omit to default to date + 1h30.
end         = 2026-08-17T17:00:00+01:00

location    = "Anytown Scout Hut"
address     = "12 Hut Lane, Anytown, AT1 2BC"
audience    = "Whole Group + parents"
dress       = "Activity uniform"
cost        = "Free"
sections    = ["beavers", "cubs", "scouts"]
draft       = false

# Demo-roll metadata — used only by scripts/roll-example-dates.py to
# keep the example site's events looking fresh against the build time.
# Group sites consuming the theme do NOT need a [demo] block — real
# Group events have real fixed dates.
[demo]
  target_offset_days = 65    # event happens ~9 weeks from build time
  publish_lead_days  = 23    # public listing about 3 weeks ago
+++

Our annual Summer Fete on the Hut grounds — bouncy castle, BBQ, raffle,
plus a chance for parents to meet the leadership team and learn about
the year ahead.

Volunteers welcome — get in touch if you can help with the BBQ or the
gates rota.
