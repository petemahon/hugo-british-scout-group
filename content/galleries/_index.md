+++
# Theme-shipped /galleries/ branch bundle. Hugo merges theme content
# with site content - a consuming Group that doesn't create its own
# content/galleries/_index.md inherits this one. A Group that wants
# a custom listing title or intro overrides this file at the same
# path in their site repo; the cascade block below MUST be preserved
# in any override or sub-gallery pages will not render correctly.

title       = "Galleries"
description = "Photo galleries from camps, parades and meetings."

# Forces /galleries/ itself to use list.html - the layout chain for a
# kind=section page would otherwise consider single.html if a cascade
# rule applied. Belt-and-braces: explicit overrides any inherited
# cascade.
layout = "list"

# Cascade: every kind=section descendant (i.e. each gallery's
# /galleries/<slug>/_index.md) picks up `layout = "single"`, which
# routes Hugo's template lookup to layouts/galleries/single.html
# (the per-gallery grid view). Per-photo pages added by the
# content adapter at content/galleries/_content.gotmpl are kind=page
# and set their own `layout = "photo"`, so the cascade does not
# fire on them. See documentation/specs/SPEC-04-galleries.md.
[[cascade]]
  layout = "single"
  [cascade.target]
    kind = "section"
+++
