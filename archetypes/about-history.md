+++
# Group history page archetype. SPEC-07.
#
# Create with:  hugo new about/history.md
# Renders at:   /about/history/  via layouts/about/history.html
# `layout` pins the template so the page doesn't fall through to a
# default single template.
layout      = "history"

title       = "Our history"

# Year the Group was founded - rendered prominently. Optional.
# founded   = 1908

# Optional cover image, relative to assets/about/. cover_alt and
# photo_consent are REQUIRED if cover_image is set (SPEC-COMMON §10).
# cover_image   = "cover.jpg"
# cover_alt     = "The Group on parade outside the church, 1950s"
# photo_consent = true

# Sidebar timeline driven by data/history_timeline.toml.
show_timeline     = true
timeline_position = "sidebar"        # "sidebar" | "top" | "bottom"

# Optional outbound link to the Wikipedia "oldest Scout groups" entry.
# wikipedia_url = "https://en.wikipedia.org/wiki/List_of_the_oldest_Scout_Groups"

draft = true
+++

Write the Group's story here in Markdown - how it started, the people
who built it, the moves and milestones. The timeline in
`data/history_timeline.toml` runs alongside; keep the prose narrative
and let the timeline carry the dated beats.
