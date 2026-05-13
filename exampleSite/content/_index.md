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

  [[sections.cards]]
    icon  = "waitlist"
    title = "Add a young person"
    text  = "For each child you'd like to register, fill out an entry form."
    [sections.cards.button] 
      label = "Add to waiting list"
      url   = "/joining/"
      style = "primary"
      arrow = true

  [[sections.cards]]
    icon    = "volunteer"
    variant = "accent"
    title   = "Volunteer with us"
    text    = "Anyone over 18 is welcome."
    [sections.cards.button]
      label = "Register as volunteer"
      url   = "/volunteer/"
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
  align    = "centre"         # default centred; "left" → left-aligned head  
  title    = "Our Sections"
  subtitle = "There is a place in Scouts for almost all ages, either as a member of one of the sections below, or as a volunteer. Clicking the Learn More buttons below will take you to the UK Scouts website for further information.<br><br>Sections meet on weekday evenings, during school term-time. To see timings for each group, check the map further down the page."
  button_label = "Learn more"

# -----------------------------------------------------------------------------
# 4. Who can join — BSO membership eligibility (POR 3.2.1.1)
# -----------------------------------------------------------------------------
[[sections]]
  type = "bso-membership"
  id   = "membership"
  bg   = "muted"

# -----------------------------------------------------------------------------
# 5. Network 18-25 — stacked-features
# -----------------------------------------------------------------------------
[[sections]]
  type  = "stacked-features"
  id    = "network"
  bg    = "accent"
  title = "Maybe you're over 18. But not over Scouts."
  intro = "Network members start small but think big, always challenging themselves to do more and be more."

  [[sections.items]]
    title = "Aged 18-25?"
    body  = "Try more. See more. Do more. At Scout Network, you'll stand on your own two feet, and make memories to last a lifetime."
  [[sections.items]]
    title = "Being part of Network"
    body  = "When you join Network, you'll be introduced to lots of new activities, people and things. Find out more about what we get up to and how you can get involved."
    [sections.items.link]
      label = "Discover how you can be a part of Network"
      url   = "https://www.scouts.org.uk/network/being-part-of-network/"
  [[sections.items]]
    title = "Awards"
    body  = "The Scout Network programme is based around projects and events. Network members start small but think big, always challenging themselves to do more and be more. It all starts with an award."
    [sections.items.link]
      label = "Learn about awards"
      url   = "https://www.scouts.org.uk/network/awards/"

  [sections.image]
    src = "images/sections/network.webp"
    alt = "Network Scouts Logo"

# -----------------------------------------------------------------------------
# 6. Volunteer — two-col-image-cta
# -----------------------------------------------------------------------------
[[sections]]
  type        = "two-col-image-cta"
  id          = "volunteer"
  title       = "Register to Volunteer"
  title_color = "secondary"
  text        = "Our amazing teams of helpers, Team Leads and Boards of Trustees are all volunteers.<br><br>We are always looking for more people to join us, and there are lots of options. Whether you have an hour every two months, or can give your time weekly, we <strong>need</strong> you.<br><br>It's time to embrace your next big adventure. Volunteer with 1st Anytown Scouts and be the best role model.<br><br>Aged 18-25? You can volunteer too, as a member of the Scout Network.<br><br>Get in touch below to find out more."
  [sections.image]
    src = "images/volunteer/role-model.webp"
    alt = "Volunteer with Scouts"
  [[sections.buttons]]
    label    = "I want to volunteer"
    url      = "https://forms.example.com/volunteer"
    style    = "secondary"
    external = true

# -----------------------------------------------------------------------------
# 7. Whats coming up — events-upcoming (opt-in via params.features.events)
# -----------------------------------------------------------------------------
[[sections]]
  type        = "events-upcoming"
  id          = "whats-on"
  title       = "What's coming up"
  title_color = "primary"
  subtitle    = "Camps, parades and the rest of the diary. Subscribe to <a href=\"/events/all.ics\">all upcoming events</a> to keep your calendar in sync."
  count       = 3
  show_more   = true

# -----------------------------------------------------------------------------
# 8. Latest news — news-grid (opt-in via params.features.news in hugo.toml)
# -----------------------------------------------------------------------------
[[sections]]
  type        = "news-grid"
  id          = "news"
  bg          = "muted"
  title       = "Latest news"
  title_color = "primary"   # match the brand-purple weight of other section headings
  subtitle    = "Camp write-ups, badge presentations, and what's been happening across the Group."
  count       = 3
  show_more   = true


# -----------------------------------------------------------------------------
# 9. Where we meet — section-header (acts as title for the map below)
# -----------------------------------------------------------------------------
[[sections]]
  type        = "section-header"
  id          = "where-we-meet"
  title       = "Where we meet"
  title_color = "primary"
  subtitle = "There are several groups of Scouts operating across Anytown, with more in the works. To find out more details for each group, click the place marker on the map below.<br><br>Scout Network meets at various locations across the city."

# -----------------------------------------------------------------------------
# 10. The map — embed
# -----------------------------------------------------------------------------
[[sections]]
  type   = "embed"
  url    = "https://snazzymaps.com/embed/123456"   # CHANGE ME — your map ID
  title  = "Map of where we meet"
  height = "600px"
  width  = "90%"
+++
