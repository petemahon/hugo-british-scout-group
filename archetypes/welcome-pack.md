+++
# Welcome Pack chapter archetype.
#
# Filename convention:    <chapter-slug>.md (no date prefix)
# Example:                content/welcome-pack/about.md
# Run:                    hugo new welcome-pack/about.md
#
# Chapters render in the cover-page nav and the print view ordered by
# `weight` (low → high), falling back to filename order. The five
# starter chapters in the example site use weights 10, 20, 30, 40, 50
# to leave room for inserts without renumbering.

title         = "{{ replace .Name "-" " " | title }}"
weight        = 10                  # cover-page nav + print view order

# Optional intro image — relative to assets/welcome-pack/. Hugo's image
# pipeline produces resized WebP variants. Leave empty for no image.
intro_image   = ""
intro_alt     = ""                  # required if intro_image is set

# Standard Hugo. Set to false to publish.
draft         = true
+++

Write the chapter in Markdown.

Keep chapters short and scannable. Parents skim Welcome Packs; they
don't read them cover-to-cover. Headings (##), short paragraphs, and
the occasional bullet list serve them best.

Don't put forms or anything that asks for personal data on these
pages — Welcome Pack is read-only by design (see SPEC-COMMON §10).
Hardcopy forms (medical, photo consent) are referenced as
"completed at first night" and linked to placeholder PDFs the Group
provides under /static/welcome-pack/.
