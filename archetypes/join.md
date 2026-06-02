+++
# Joining page archetype. Use ONCE per site, as content/join/_index.md.
# See SPEC-06 for the full feature spec.
#
# The cards rendered on /join/ come from data/sections_status.toml in
# your site repo — that's where each section/pack's status, meeting
# night, fee and contact are managed. This file just controls the
# page's top matter and the bridge links.

title             = "Join us"

# Optional intro paragraph(s) below the page heading. HTML allowed —
# you can wrap key phrases in <strong> or link out to external pages.
# Leave empty for a heading-only top matter.
intro             = ""

# Link to your Welcome Pack — either the on-site Hugo section (default
# below) or an external URL if you maintain it elsewhere. Set to "" to
# suppress the link entirely.
welcome_pack_url   = "/welcome-pack/"
welcome_pack_label = "Read our Welcome Pack"

# OSM waiting-list URL, when your Group uses OSM. If set, this is the
# default destination for any pack whose status="waiting" and whose own
# `waiting_url` in data/sections_status.toml is empty. Leave empty if
# you'd rather route everyone to per-pack contact_email values.
osm_waiting_list_url = ""

# Generic Group enquiry email. Used as the fallback contact when a
# pack has no contact_email of its own. Encouraged but optional.
enquiry_email     = ""

# Volunteer-recruitment bridge into SPEC-09. The link target is the
# volunteer page; the label here is the call to parents.
volunteer_link_text = "We need you too"

# BSO Groups only — a short eligibility blurb that renders above the
# cards (between the bso-membership notice and the grid). HTML allowed.
# Ignored when site.Params.bso.enabled is false.
bso_eligibility_summary = ""
+++

Optional opening paragraph beneath the heading. Use this if you'd
rather author the intro as Markdown body content than via the `intro`
front-matter field above. Either works; one or the other, not both.
