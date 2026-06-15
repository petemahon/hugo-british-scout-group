+++
# News post archetype.
#
# Filename convention:    YYYY-MM-DD-kebab-case-title.md
# Example:                content/news/2026-04-19-st-georges-day.md
# Run:                    hugo new news/2026-04-19-st-georges-day.md
#
# The date prefix in the filename is part of the URL (/news/<slug>/) per
# DECISIONS.md (flat URLs, no year nesting). It is NOT auto-stripped from
# the title - edit the title below to read naturally.

title         = "{{ replace (replaceRE `^[0-9]{4}-[0-9]{2}-[0-9]{2}-` `` .Name) `-` ` ` | title }}"

# Set to the date of the event/activity the post is about. Posts dated in
# the future are excluded from the build, so backdating publishes
# immediately. Use ISO-8601 (YYYY-MM-DD or full RFC 3339).
date          = {{ .Date }}

# A short summary used on cards and as the meta description. If left
# empty, Hugo falls back to the first ~30 words of the body.
summary       = ""

# Which Scout section(s) this post relates to. Use one or more keys from
# data/scout_sections.toml: squirrels, beavers, cubs, scouts, explorers,
# network. Empty list = post applies across the whole Group.
#
# Section badges on news cards take their colour from these values.
sections      = []

# Cover image - relative to assets/news/<slug>/. Hugo accepts JPG, WebP,
# or PNG; the build pipeline produces resized WebP variants automatically,
# so authors don't need to convert. Leave empty to render no cover image.
cover_image   = ""
cover_alt     = ""    # required if cover_image is set; describe the photo

# Author byline - free text. Recommended: leader nickname or role
# ("Akela", "GSL", "Cub Leader") rather than a personal name. Avoid using
# full names of young people. Leave empty to omit the byline.
author        = ""

# REQUIRED if any image is referenced (cover OR inline in the body).
# Setting to true asserts every identifiable face has signed photo
# consent on file with the Group, OR that faces are obscured. The build
# fails (errorf) if an image is referenced but this is not true.
# See SPEC-COMMON §10.
photo_consent = false

# Standard Hugo. Set to false to publish.
draft         = true
+++

Write your post here in Markdown.

<!--
Inline images: drop them in the same folder as the post (under
assets/news/<slug>/) and reference them like:

  ![Cubs at the Cooking Cup](photo-1.jpg "Optional caption")

Hugo's image render pipeline will resize and convert them to WebP.
Keep filenames descriptive - they appear in the resulting image URLs.
-->
