+++
# NB: all scalar / inline-array keys MUST come before the [[rates]] and
# [[photos]] array-of-tables — otherwise TOML assigns them to the last
# table block, not the page front-matter.
title = "Hire our hall"
intro = "Our Scout Hut is available for community hire when we're not using it — birthday parties, classes, clubs, small functions and meetings. It's a bright, flexible space with its own kitchen and parking, in the heart of Anytown."

address   = "Anytown Scout Hut, 11 Hut Lane"
postcode  = "AT1 2BC"
map_url   = "https://www.openstreetmap.org/search?query=Anytown"

capacity_seated   = 60
capacity_standing = 90
dimensions        = "12m × 8m"
floor_area_m2     = 96

facilities = ["Kitchen", "Toilets", "Disabled access", "Parking", "Stage", "Wi-Fi"]

deposit      = "£50 refundable damage deposit, returned after inspection"
cleaning_fee = "£20 cleaning fee for parties and catered events"

terms_pdf     = "/hall-hire/terms-and-conditions.pdf"
enquiry_email = "hall@1stanytown.org.uk"
enquiry_phone = "+44 1234 567 890"

availability_note   = "The hall is in use for Scout meetings on weekday evenings during school terms (roughly 17:00–21:30). Daytimes, weekends and holidays are usually free."
priority_disclaimer = true

draft = false

[[rates]]
  name     = "Local resident, hourly"
  amount   = "16"
  currency = "GBP"
  period   = "hour"
  notes    = "Minimum two hours"

[[rates]]
  name     = "Commercial / regular booking, hourly"
  amount   = "24"
  currency = "GBP"
  period   = "hour"

[[rates]]
  name     = "Children's party (Saturday morning, 4 hours)"
  amount   = "80"
  currency = "GBP"
  period   = "session"
  notes    = "Includes setup and clear-up time"

[[rates]]
  name     = "Whole day (community / charity)"
  amount   = "120"
  currency = "GBP"
  period   = "day"

[[photos]]
  src     = "main-hall.jpg"
  alt     = "The main hall laid out with trestle tables and folding chairs, under high white-painted roof trusses, with a serving hatch to the kitchen"
  caption = "The main hall, set out for a meeting"

[[photos]]
  src     = "hall-set-for-event.jpg"
  alt     = "The hall set up for a catered function, with a buffet table of food in the foreground and guests seated at tables behind"
  caption = "Set up for a private function"
+++

We're a registered charity and every penny of hire income goes back
into Scouting for local young people. If you're a community group or
running a not-for-profit event, do ask — we can often be flexible on
the rate.
