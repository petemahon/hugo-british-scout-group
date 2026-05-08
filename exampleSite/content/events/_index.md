+++
title       = "Events"
description = "Camps, parades, badge presentations, and the rest of what's coming up at 1st Anytown Scouts."

# This section page (rendered at /events/) emits HTML plus an aggregate
# calendar feed at /events/all.ics — a single subscribable URL through
# which parents see every upcoming event flow into their calendar app.
# See SPEC-02.
outputs = ["html", "EventsAggregateCalendar"]

# Cascade: every event page (descendant of /events/) emits HTML plus
# its own event.ics next to its index.html. Group authors do not need
# to set `outputs` in individual event front-matter.
[cascade]
  outputs = ["html", "EventCalendar"]
+++

The full list of upcoming events. Add `all.ics` to your calendar app
to subscribe and see everything flow in.
