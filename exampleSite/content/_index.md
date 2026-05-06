+++
title = "1st Anytown Scouts"
description = "Skills for Life — example Scout Group home page using the British Scout Group theme."

# Each [[sections]] entry is rendered by the partial in
# layouts/partials/sections/<type>.html. Reorder, remove or duplicate entries
# to suit your Group. See the theme README for the full list of section types.

# -----------------------------------------------------------------------------
# 1. Hero
# -----------------------------------------------------------------------------
[[sections]]
  type  = "hero"
  id    = "hero"
  title = "Welcome to 1st Anytown Scouts"
  text  = "1st Anytown Scouts provides fun and friendship, challenge and everyday adventure to over 300 young people in Anytown, for both boys and girls aged 6 to 18."

# -----------------------------------------------------------------------------
# 2. Join us — two-column CTA
# -----------------------------------------------------------------------------
[[sections]]
  type = "two-col-cta"
  id   = "join"
  bg   = "muted"
  [sections.left]
    title = "Joining us couldn't be easier"
    text  = "Register your interest to join 1st Anytown Scouts. We welcome everyone to join us, and will give priority to young people who have a parent willing to volunteer some of their time to help out. No previous experience necessary!<br><br>If you would like to both volunteer and register a Young Person, please ensure you complete <strong>both</strong> entry forms on this page."
  [sections.right]
    title = "Join 1st Anytown Scouts"
    text  = "For each young person you would like to register, fill out an entry form below. Adults above the age of 18 are welcome to volunteer and do not need to have a child in Scouting."
    [[sections.right.buttons]]
      label    = "Add a Young Person to the Waiting List"
      url      = "https://forms.example.com/join"
      style    = "primary"
      external = true
    [[sections.right.buttons]]
      label    = "Register interest as a Volunteer"
      url      = "https://forms.example.com/volunteer"
      style    = "primary-outline"
      external = true

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
  title    = "Our Sections"
  subtitle = "There is a place in Scouts for almost all ages, either as a member of one of the sections below, or as a volunteer. Clicking the Learn More buttons below will take you to the UK Scouts website for further information.<br><br>Sections meet on weekday evenings, during school term-time. To see timings for each group, check the map further down the page."
  button_label = "Learn more"
  button_style = "primary"

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
# 5. Volunteer — two-col-image-cta
# -----------------------------------------------------------------------------
[[sections]]
  type        = "two-col-image-cta"
  id          = "volunteer"
  title       = "Register to Volunteer"
  title_color = "secondary"
  text        = "Our amazing teams of helpers, Team Leads and Boards of Trustees are all volunteers.<br><br>We are always looking for more people to join us, and there are lots of options. Whether you have an hour every two months, or can give your time weekly, we <strong>need</strong> you.<br><br>It's time to embrace your next big adventure. Volunteer with 1st Anytown Scouts and be the best role model.<br><br>Aged 18-25? You can volunteer too, as a member of the Scout Network.<br><br>Get in touch below to find out more."
  [sections.image]
    src = "images/placeholder-volunteer.svg"
    alt = "Volunteer with Scouts"
  [[sections.buttons]]
    label    = "I want to volunteer"
    url      = "https://forms.example.com/volunteer"
    style    = "secondary"
    external = true

# -----------------------------------------------------------------------------
# 6. Where we meet — section-header (acts as title for the map below)
# -----------------------------------------------------------------------------
[[sections]]
  type        = "section-header"
  id          = "where-we-meet"
  title       = "Where we meet"
  title_color = "primary"
  subtitle = "There are several groups of Scouts operating across Anytown, with more in the works. To find out more details for each group, click the place marker on the map below.<br><br>Scout Network meets at various locations across the city."

# -----------------------------------------------------------------------------
# 7. The map — embed
# -----------------------------------------------------------------------------
[[sections]]
  type   = "embed"
  url    = "https://snazzymaps.com/embed/123456"   # CHANGE ME — your map ID
  title  = "Map of where we meet"
  height = "600px"
  width  = "90%"
+++
