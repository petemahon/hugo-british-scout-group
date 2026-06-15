+++
title = "Home range and InTouch"
intro = "1st Anytown's home range is roughly a 20 km radius around our hut. Trips beyond the home range need an InTouch form filed by the Group Scout Leader - see the summary below."

centre_label   = "Anytown Scout Hut"
radius_km      = 20
radius_label   = "approximately 20 km"

# Optional static map of the home range - a raster image (PNG/JPG/WebP)
# at assets/bso/<filename>, which Hugo resizes. Add your own and set:
#   static_map_image = "home-range.png"
#   static_map_alt   = "Outline map showing the home-range circle around the hut."
# Left unset here: the example ships no map raster, and the page renders
# fine without one (centre/radius summary + InTouch policy below).

intouch_policy_summary = "InTouch is The Scout Association's contact-tracking policy for activities away from the meeting place. We log the activity, the leader-on-call's phone, and the home contact for every camp or trip. Parents receive the on-call number before any away activity."

# Optional link to the Group's own InTouch policy PDF. Left unset here -
# a Group adds it: policy_pdf = "/bso/intouch-policy.pdf" (file in static/).

cross_border_event_note = "Activities outside the home range - particularly cross-border or overnight activities - need a written permission form from each parent in addition to the InTouch record."
+++

This page is gated by `params.bso.show_home_range` in your site's
`hugo.toml`. Default is **false** - most BSO Groups don't need a
formal home-range publication. Flip the param to `true` to surface
the link in the `/bso/` hub.
