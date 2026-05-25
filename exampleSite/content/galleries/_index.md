+++
title       = "Galleries"
description = "Camp write-ups in pictures — what we've been up to across the Group."

# Forces /galleries/ to use list.html — the layout chain for a
# kind=section page would otherwise consider single.html if a cascade
# rule applied. Explicit setting overrides any inherited cascade.
layout = "list"

# The cascade below routes every kind=section descendant
# (i.e. every gallery's /galleries/<slug>/_index.md) to
# layouts/galleries/single.html. Per-photo pages added by the
# content adapter at content/galleries/_content.gotmpl set their
# own layout="photo" so they bypass this cascade. See SPEC-04.
[[cascade]]
  layout = "single"
  [cascade.target]
    kind = "section"
+++
