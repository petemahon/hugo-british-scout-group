+++
# Fundraising / "Support us" page archetype. SPEC-09.
#
# This is the section root: content/support-us/_index.md, rendered at
# /support-us/ by layouts/support-us/list.html. The volunteer-roles
# sub-section lives under it (see archetypes/volunteer-role.md).
#
# Create with:  hugo new support-us/_index.md

title = "Support us"

# Why the Group needs support — required, HTML allowed.
intro = ""

# External giving links — URLs only (no logos; copyright). Any you
# leave blank is omitted. donate_url is the primary CTA.
# donate_url          = "https://..."
# donate_label        = "Donate"
# easyfundraising_url = "https://www.easyfundraising.org.uk/causes/..."
# amazon_smile_url    = ""
# localgiving_url     = ""
# justgiving_url      = "https://www.justgiving.com/..."
# stewardship_url     = ""

# Optional Gift Aid declaration PDF (in static/support-us/).
# giftaid_pdf = "/support-us/giftaid-declaration.pdf"

# Recurring fundraising activities — repeat the block per activity.
[[fundraising_activities]]
  name          = "Christmas Post"
  when          = "December every year"
  detail        = "Volunteers deliver Christmas cards across the area. Proceeds fund camp subsidies."
  contact_email = ""               # optional

# Optional high-level budget transparency block (set once a year).
# Numbers as strings; currency is an ISO code from data/currencies.toml.
# [annual_budget]
#   income         = "12000"
#   expenditure    = "11500"
#   currency       = "GBP"
#   year           = "2024-25"
#   reserves_label = "We aim to keep three months of operating costs in reserves."
#   reports_link   = "/about/reports/"   # cross-link to SPEC-07 governance

draft = true
+++

Optional Markdown body — renders above the activities. Put hire-it
offers, Scout-shop links, or a thank-you to supporters here.
