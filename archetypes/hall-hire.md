+++
# Hall hire / HQ booking page archetype. SPEC-08.
#
# Single informational page - no booking system, no calendar, no
# payment. Create with:  hugo new hall-hire/_index.md
# Renders at /hall-hire/ via layouts/hall-hire/list.html.

title = "Hire our hall"

# Required - describe the hall (HTML allowed).
intro = ""

address  = ""
# postcode = ""
# map_url  = "https://www.openstreetmap.org/?mlat=..&mlon=.."   # link only (Q8.4)

# capacity_seated   = 60
# capacity_standing = 80
# dimensions        = "10m × 8m"
# floor_area_m2     = 80

# Facility chips - free strings.
facilities = ["Kitchen", "Toilets", "Disabled access", "Parking"]

# Rates - repeat per tier. amount is a string; currency is an ISO code
# from data/currencies.toml; period is hour|session|day|weekend.
[[rates]]
  name     = "Local resident, hourly"
  amount   = "16"
  currency = "GBP"
  period   = "hour"
  notes    = ""

# deposit      = "£50 refundable damage deposit"
# cleaning_fee = "£20 cleaning fee for parties"

# Terms & conditions - a PDF in static/hall-hire/, OR an external URL.
# terms_pdf = "/hall-hire/terms-and-conditions.pdf"
# terms_url = ""

enquiry_email = "hall@example.org"   # required - generic Group inbox
# enquiry_phone = "+44 ..."          # Group duty mobile, NOT personal

# availability_note   = "Not available weekday evenings during school terms."
priority_disclaimer = true           # "Scout activities take priority"

# Photos - empty-hall or adult-only only (NO identifiable young people).
# Source files (any raster) live in assets/hall-hire/photos/; Hugo
# resizes them to WebP at build.
# [[photos]]
#   src     = "main-hall.jpg"
#   alt     = "The main hall set out with tables and chairs"
#   caption = "Main hall, seats 60"

draft = true
+++

Optional Markdown body - renders below the intro. Add insurance /
risk-assessment links or a second hall here if needed (multi-hall is
out of scope; describe it inline).
