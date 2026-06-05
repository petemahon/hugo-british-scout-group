+++
title       = "District Rally"

# IMPORTANT — this event has been POSTPONED. The date here is the
# NEW date. The original was scheduled for 2026-10-04; postponed to
# 2026-11-22. Revision is bumped to 1 so subscriber calendars update
# the meeting in place rather than treating it as a new entry.
date        = 2026-12-21T10:00:00+00:00

# Set in the past so Hugo's --buildFuture=false build still emits.
publishDate = 2026-04-05T09:00:00+01:00

end         = 2026-12-21T16:00:00+00:00

location    = "Anytown District Camp Site"
address     = "Camp Lane, Anytown, AT2 3CD"
audience    = "Whole Group"
dress       = "Activity uniform"
cost        = "£5"
sections    = ["beavers", "cubs", "scouts", "explorers"]

# ─── D8 status enum ────────────────────────────────────────────────
# Demonstrates the postponed state. The card renders an amber Postponed
# pill; the .ics emits the new DTSTART/DTEND with DESCRIPTION prefixed
# "Note: new date/time. " and SEQUENCE:1, so subscriber calendars
# update the existing meeting rather than duplicating it.
status      = "postponed"
revision    = 1

draft       = false

# Demo-roll metadata.
[demo]
  target_offset_days = 200   # event happens ~6.5 months from build
  publish_lead_days  = 60    # public listing about 2 months ago
+++

The District Rally has been **rescheduled** from October to late
November to align with the District's outdoor programme. Same venue,
new date — full Group day with backwoods cooking, pioneering, a wide
game in the afternoon, and the District flag ceremony to finish.

If you subscribed to our events calendar you don't need to do
anything; the meeting will update automatically.

Bring a packed lunch and a warm layer.
