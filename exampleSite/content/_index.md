+++
title = "1st Anytown Scouts" # optional; only used if you want different from site.Title
description = "Skills for Life — example Scout Group home page using the British Scout Group theme."

# Each [[sections]] entry is rendered by the partial in
# layouts/partials/sections/<type>.html. Reorder, remove or duplicate entries
# to suit your Group. See the theme README for the full list of section types.

# -----------------------------------------------------------------------------
# 1. Hero
# -----------------------------------------------------------------------------
[[sections]]
  type    = "hero"
  id      = "hero"                       # optional, defaults to "hero"
  eyebrow = "Skills for life · Anytown"  # optional; default builds from
                                          # i18n "heroEyebrow" + place
  lede    = "Fun and friendship …"       # optional supporting paragraph
  photo   = "images/hero/photo.webp"     # optional (default theme photo)
                                          # set photo = false to suppress
  photo_alt = "Cubs round a fire at night, lighting it together"

  [sections.stat]                         # optional; only renders if
    number = "300+"                       # photo is set (overlays it)
    label  = "Young people across<br>5 sections, 4 nights a week."

  [[sections.buttons]]                    # optional; 0–N buttons
    label = "Join the Group"
    url   = "/#join"
    style = "primary"                     # primary | ghost |
                                          # primary-outline | secondary
                                          # | tertiary
    arrow = true                          # appends the animated arrow
  
  [[sections.buttons]]
    label = "Volunteer with us"
    url   = "/#volunteer"
    style = "ghost"

# -----------------------------------------------------------------------------
# 2. Join us — two-column CTA
# -----------------------------------------------------------------------------
[[sections]]
  type     = "join"
  id       = "join"
  bg       = "muted"
  eyebrow  = "Join Us"
  title    = "Joining couldn't be easier."
  subtitle = "Register your interest below - for your child, yourself, or both. We give priority to families who are happy to volunteer their time alongside us."

  # Head CTA — sends visitors to the full /join/ page (section-by-section
  # openings, meeting nights, fees, FAQ and the Welcome Pack) before they
  # commit to a waiting-list or volunteer card below.
  [sections.button]
    label = "See how to join"
    url   = "/join/"
    style = "primary-outline"
    arrow = true

  [[sections.cards]]
    icon  = "waitlist"
    title = "Add a young person"
    text  = "For each child you'd like to register, fill out an entry form."
    [sections.cards.button] 
      label = "Add to waiting list"
      url   = "/join/"
      style = "primary"
      arrow = true

  [[sections.cards]]
    icon    = "volunteer"
    variant = "accent"
    title   = "Volunteer with us"
    text    = "Anyone over 18 is welcome."
    [sections.cards.button]
      label = "Register as volunteer"
      url   = "/support-us/volunteer-roles/"
      style = "ghost"

# -----------------------------------------------------------------------------
# 3. Our Sections — section-grid
# -----------------------------------------------------------------------------
# -----------------------------------------------------------------------------
# 3. Our Sections — auto-renders enabled UK Scout sections.
# Toggle each section on/off and set logo paths in [params.scoutSections]
# in hugo.toml. Section metadata (ages, URLs) comes from the theme.
# -----------------------------------------------------------------------------
[[sections]]
  type     = "scout-sections"
  id       = "sections"
  bg       = "tertiary"
  eyebrow  = "Age groups"   # small uppercase lead-in above the h2
  #align    = "left"         # default centred; "left" → left-aligned head  
  title    = "Our Sections"
  subtitle = "There is a place in Scouts for almost all ages, either as a member of one of the sections below, or as a volunteer. Clicking the Learn More buttons below will take you to the UK Scouts website for further information.<br><br>Sections meet on weekday evenings, during school term-time. To see timings for each group, check the map further down the page."
  button_label = "Learn more"

# -----------------------------------------------------------------------------
# 4. Network 18-25 — network-feature (opt-in via params.features.network_feature)
#
# Note: the home page used to carry a `bso-membership` section here
# rendering the POR 3.2.1.1 notice. We removed it deliberately — the
# canonical place for "who can join" prose is now the /join/ page,
# which embeds the same partial in context with the joining cards.
# The bso-membership section type still exists in the theme; Groups
# that prefer the home-page placement can add it back here.
# -----------------------------------------------------------------------------
[[sections]]
  type    = "network-feature"
  id      = "network"
  # eyebrow, title, intro, cta_label, cta_href all use theme defaults via i18n.
  # [[sections.points]] is omitted — the theme renders the three default points.

# -----------------------------------------------------------------------------
# 5a. Recruitment banner — volunteer-recruitment-banner (SPEC-09).
# Conditional: renders ONLY when at least one volunteer role is currently
# open (data/content under content/support-us/volunteer-roles/). When no
# roles are open, the home page flows straight past it. Gated by
# params.features.fundraising.
# -----------------------------------------------------------------------------
[[sections]]
  type     = "volunteer-recruitment-banner"
  id       = "volunteer-banner"
  # title, message, cta_text all use theme defaults via i18n.
  bg       = "primary"

# -----------------------------------------------------------------------------
# 5. Volunteer — volunteer-feature brand-anchor band (D11)
# Opt-in via params.features.volunteer_feature in hugo.toml. Always renders
# on Scouts Purple regardless of palette. The text column ships the canonical
# i18n-default copy; the poster ships in the default `role-model` variant.
# Switch the example to the `stat-yellow` variant by uncommenting `variant`.
# The CTA points at the real volunteer-roles page (SPEC-09).
# -----------------------------------------------------------------------------
[[sections]]
  type     = "volunteer-feature"
  id       = "volunteer"
  cta_href = "/support-us/volunteer-roles/"
  # variant = "stat-yellow"   # default "role-model"; uncomment to switch
  # eyebrow, title, body1, body2, network_note, cta_label,
  # poster_tag, poster_headline, poster_hash, stat_line_a, stat_line_b
  # all use theme defaults via i18n.

# -----------------------------------------------------------------------------
# 6. This term's programme — programme-current (opt-in via
#    params.features.programme). SPEC-03 Q3.1 was revised on 2026-05-21
#    to wire this block into the example site so the demo exercises
#    every section type; consuming Group sites still opt in by adding
#    this block to their own content/_index.md.
#
#    Auto-detects "current" by term_start <= today <= term_end. Renders
#    one collapsible <details> per matching programme. `density` here
#    overrides each programme's own density so the home block stays
#    consistently terse regardless of what each programme page chose.
# -----------------------------------------------------------------------------
[[sections]]
  type     = "programme-current"
  id       = "this-term"
  bg       = "muted"
  align    = "left"
  eyebrow  = "This term"
  title    = "What we're doing right now."
  subtitle = "Click a section to see this term's weekly meeting plan and the Skills for Life themes we're covering."
  density  = "themes_only"
  # sections = ["beavers", "cubs"]   # optional filter; empty = all sections

# -----------------------------------------------------------------------------
# 7. Whats coming up — events-upcoming (opt-in via params.features.events)
# -----------------------------------------------------------------------------
[[sections]]
  type    = "events-upcoming"
  id      = "whats-on"
  align   = "left"
  eyebrow = "What's coming up"
  title   = "Camps, parades and meetings."
  count   = 3
  
# -----------------------------------------------------------------------------
# 8. Latest news — news-grid (opt-in via params.features.news in hugo.toml)
# -----------------------------------------------------------------------------
[[sections]]
  type        = "news-grid"
  id          = "news"
  bg          = "muted"
  align       = "left"
  eyebrow     = "Latest news"
  title       = "Camp write-ups & badges."
  subtitle    = "Camp write-ups, badge presentations…"
  count       = 3
  show_more   = true


# -----------------------------------------------------------------------------
# 9. Latest gallery — gallery-strip (opt-in via params.features.galleries)
# Renders the most recent gallery's cover plus a short row of thumbs and
# a "View all galleries" CTA. Renders nothing if no galleries are
# published yet (or if params.features.galleries is false).
# -----------------------------------------------------------------------------
[[sections]]
  type      = "gallery-strip"
  id        = "galleries"
  align     = "left"
  eyebrow   = "Lately"
  title     = "From our latest camp."
  count     = 5
  show_more = true

# -----------------------------------------------------------------------------
# 10. Where we meet — section-header (acts as title for the map below)
# -----------------------------------------------------------------------------
[[sections]]
  type     = "section-header"
  id       = "where-we-meet"
  align    = "left"
  eyebrow  = "Where we meet"
  title    = "Anytown Scout Group huts."
  subtitle = "There are several groups of Scouts operating across Anytown, with more in the works. To find out more details for each group, click the place marker on the map below.<br><br>Scout Network meets at various locations across the city."

# -----------------------------------------------------------------------------
# 11. The map — embed
# -----------------------------------------------------------------------------
[[sections]]
  type   = "embed"
  url    = "https://snazzymaps.com/embed/123456"   # CHANGE ME — your map ID
  title  = "Map of where we meet"
  # height / width omitted — the embed uses the D13 aspect-ratio default
  # (4:3 mobile, 16:9 desktop). Set explicit values here only if you
  # need a fixed-pixel iframe.
+++
