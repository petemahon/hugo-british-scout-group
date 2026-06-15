+++
# Gallery archetype.
#
# Filename convention:    galleries/<YYYY-event-slug>/_index.md
# Run:                    hugo new galleries/2026-summer-camp/_index.md
#
# Each gallery is a branch bundle (a directory with an `_index.md`).
# Drop image files into assets/galleries/<slug>/ - numeric filenames
# recommended (001.jpg, 002.jpg, …) so authors don't accidentally
# identify a young person by name in a URL.
#
# Per-photo pages at /galleries/<slug>/<image-basename>/ are
# generated automatically by the content adapter at
# content/galleries/_content.gotmpl. You don't write one .md per photo.
#
# SAFEGUARDING - READ BEFORE PUBLISHING.
# This is the highest-risk content type in the theme. The build will
# fail if photo_consent or consent_log are not set. See
# documentation/specs/SPEC-04-galleries.md and SPEC-COMMON §10.

title         = "{{ replace .Name `-` ` ` | title }}"

# The date of the camp / event. Used to sort galleries on /galleries/
# in reverse-chronological order.
date          = {{ .Date }}

# Card description on /galleries/. Optional.
summary       = ""

# Cover image - a filename in assets/galleries/<slug>/. Leave empty to
# fall back to the first image (alphabetical order).
cover         = ""
cover_alt     = ""    # REQUIRED when `cover` is set.

# REQUIRED. Setting to true asserts every identifiable face has signed
# photo consent on file with the Group, OR that faces are obscured /
# blurred. The build fails (errorf) if this is false on a gallery
# that resolves any images. See SPEC-COMMON §10.
photo_consent = false

# REQUIRED. A short note pointing to where the Group has stored
# signed consent records (e.g. "OSM Personal Details > Photo Consent",
# or "Shared Drive > Safeguarding > Photo Consents 2026"). Never
# rendered to the public site - build-time lint only. The build fails
# if this is empty.
consent_log   = ""

# Which Scout section(s) appeared in this gallery. Keys from
# data/scout_sections.toml: squirrels, beavers, cubs, scouts,
# explorers, network. Empty list = Group-wide.
sections      = []

# Optional cross-link to an Events page (SPEC-02) or News post
# (SPEC-01) by slug - produces a "From this event" / "Camp report"
# link on the gallery page when set.
event_ref     = ""
news_ref      = ""

# Optional header note above the grid. HTML allowed.
# Use to explain why faces are blurred, why some images are missing,
# etc. Example: "Faces blurred at parents' request."
note          = ""

# Optional external video links. Renders as cards linking out - no
# embedded players, no hosted video files. YouTube, Vimeo and
# Facebook video URLs are auto-recognised; the platform name shows
# on the card.
#
# [[video_links]]
#   url       = "https://www.youtube.com/watch?v=…"
#   label     = "Cubs scaling the climbing wall (3 min)"
#   thumbnail = "video-cubs-climbing.jpg"   # optional, in assets/galleries/<slug>/

video_links   = []

# Standard Hugo. Set to false to publish.
draft         = true
+++

<!--
Authoring notes:

  1. Drop the photo files into assets/galleries/<slug>/ alongside
     this _index.md's directory (NOT next to this file). Numeric
     filenames recommended: 001.jpg, 002.jpg, …

  2. Optional captions / alt text: create a sidecar at
     data/galleries/<slug>.toml:

        [[image]]
          file          = "001.jpg"
          caption       = "Cubs starting the obstacle course"
          alt           = "A line of Cubs running between hay bales"
          faces_blurred = false

  3. Run `exiftool -all=` over the source images before committing if
     they include GPS or device metadata. The theme does not strip
     EXIF at build time - that's an authoring-side responsibility.

  4. Right to be forgotten: `git rm` the asset + rebuild.
-->
