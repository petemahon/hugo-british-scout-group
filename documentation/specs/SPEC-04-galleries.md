# SPEC-04: Photo Galleries

Read `SPEC-COMMON.md` first.

## Goal

Per-event or per-camp gallery with caption-able images and a
per-gallery cover. Generated as a static grid; clicking opens a
full-size view via per-photo pages (no JavaScript lightbox).

The single feature with the highest residual safeguarding risk in the
roadmap. The build pipeline must enforce consent declarations, and the
default user experience must not encourage Groups to upload identifiable
photos.

Real parallels: 7th Hampton's Flickr links, 38th Rossendale's external
Facebook albums (the pattern we want to replace), Central Brussels'
photo-rich news posts.

## Acceptance criteria

1. A page exists at `/galleries/` listing every gallery, in reverse
   chronological order, with a cover image and item count.
2. Each gallery has its own page at `/galleries/<slug>/` with a CSS
   Grid of thumbnails. Clicking a thumbnail navigates to
   `/galleries/<slug>/<image-slug>/` - a dedicated full-size page.
   The full-size page has prev/next links.
3. The build fails (errorf) if a gallery contains any image but
   `photo_consent = true` is not set in front-matter.
4. The build also fails if `consent_log` is unset - a non-empty single
   string pointing to where the Group has stored consent records.
   Never rendered to the public site; build-time lint only.
5. Hugo image pipeline produces three sizes per image: 320, 640,
   1280px wide WebP. Originals are not deployed.
6. Captions are optional; sidecar `data/galleries/<slug>.toml` lists
   `{file, caption, alt, faces_blurred}` per image.
7. **Video links** (YouTube, Vimeo, Facebook video) are supported via
   an optional `video_links` array - rendered as cards linking out.
   No video files hosted by the site, no embedded players.
8. **Per-photo Open Graph meta** so a parent sharing a single photo
   to grandparents shows the photo as preview.
9. Feature gated by `params.features.galleries` (default OFF).
10. Example site exercises: a gallery with captions, a gallery
    without captions, a gallery with `faces_blurred = true`, a
    gallery with `video_links`, a draft gallery (not built).

## Content layout

```
content/galleries/
├── _index.md
├── 2026-summer-camp/
│   └── _index.md
└── 2026-st-georges-day/
    └── _index.md

assets/galleries/
├── 2026-summer-camp/
│   ├── 001.jpg
│   ├── 002.jpg
│   └── 003.jpg
└── 2026-st-georges-day/
    └── ...

data/galleries/
├── 2026-summer-camp.toml      # captions, optional
└── 2026-st-georges-day.toml
```

## Front-matter schema (per gallery `_index.md`)

| Field | Type | Required | Default | Notes |
| --- | --- | --- | --- | --- |
| `title` | string | yes | - | "Summer Camp 2026" |
| `date` | date | yes | - | Used for sort order |
| `summary` | string | no | "" | Card description |
| `cover` | string | no | first image | Filename in `assets/galleries/<slug>/` |
| `cover_alt` | string | yes if `cover` | - | |
| `photo_consent` | bool | yes | - | Build fails if unset/false |
| `consent_log` | string | yes | - | Single string. Build fails if empty. |
| `sections` | list[string] | no | `[]` | Taxonomy values |
| `event_ref` | string | no | - | Slug of an Events page (SPEC-02) |
| `news_ref` | string | no | - | Slug of a News post (SPEC-01) |
| `note` | string (HTML allowed) | no | - | Header note e.g. "Faces blurred at parents' request" |
| `video_links` | list[block] | no | `[]` | See below |

Each `video_links` block:

```toml
[[video_links]]
  url = "https://www.youtube.com/watch?v=…"
  label = "Cubs scaling the climbing wall (3 min)"
  thumbnail = "video-cubs-climbing.jpg"   # optional, in assets/galleries/<slug>/
```

| Sub-field | Type | Required | Default | Notes |
| --- | --- | --- | --- | --- |
| `url` | string | yes | - | External video URL - YouTube, Vimeo, Facebook video |
| `label` | string | yes | - | |
| `thumbnail` | string | no | - | Optional image in `assets/galleries/<slug>/` |

## Sidecar caption file

`data/galleries/<slug>.toml`:

```toml
[[image]]
  file = "001.jpg"
  caption = "Cubs starting the obstacle course"
  alt = "A line of Cubs running between hay bales"
  faces_blurred = false

[[image]]
  file = "002.jpg"
  caption = ""
  alt = "Camp fire at dusk"
  faces_blurred = false
```

If a sidecar TOML is missing, the gallery still renders with
auto-generated alt text. The implementing partial logs an `info`
notice suggesting Groups add captions for accessibility.

## Layouts to create

| File | Purpose |
| --- | --- |
| `layouts/galleries/list.html` | `/galleries/` index |
| `layouts/galleries/single.html` | `/galleries/<slug>/` grid view |
| `layouts/galleries/photo.html` | `/galleries/<slug>/<image>/` full-size view (with OG meta) |
| `layouts/partials/sections/gallery-strip.html` | Optional home-page block, latest gallery's cover + 5 thumbs |
| `layouts/partials/gallery-thumbnail.html` | |
| `layouts/partials/gallery-photo-nav.html` | Prev/next on photo page |
| `layouts/partials/gallery-video-links.html` | Video link cards |
| `layouts/partials/gallery-photo-og.html` | Open Graph meta block for per-photo pages |

## hugo.toml additions

```toml
[params.features]
  galleries = false                       # default OFF - opt-in

[params.galleries]
  thumbs_per_row     = 4                  # layout hint, CSS handles responsive
  show_captions      = true
  show_consent_link  = true               # link to /policies/photo-consent/ in gallery footer
  consent_policy_url = "/policies/photo-consent/"
```

## Asset paths

- `assets/galleries/<slug>/*.jpg|png|webp` - source files, processed
  by Hugo image pipeline.
- Placeholder gallery shipped with theme at
  `assets/galleries/_placeholder/`.
- Recommend (don't enforce) that Groups EXIF-strip before commit. The
  archetype README links to `exiftool -all=` instructions.

## CSS-only baseline

- Grid: CSS Grid with `auto-fit, minmax(220px, 1fr)`.
- Thumbnails are anchors to per-photo pages.
- Photo page uses `max-width: 90vmin` and centres.
- Video link cards: same card aesthetic as gallery thumbnails, with
  an external-link icon and platform indicator (YouTube/Vimeo/etc.
  inferred from URL host).

## Time-based pruning (documented, not built)

Galleries from many years ago can become a maintenance and
safeguarding burden. Time-based pruning is **not built into the
theme** but the README documents how to enable it as a GitHub Actions
cron, with a prominent warning:

> **Warning.** A scheduled-prune cron will continue removing content
> over time even if you forget about it. If your repo has no recent
> commits and the cron is still scheduled, it will eventually prune
> everything. Treat as opt-in only, with reminders in your Group's
> calendar to review.

Sample cron pattern (in README):

```yaml
# .github/workflows/prune-galleries.yml - OPT-IN, READ THE WARNING
name: Prune galleries older than N years
on:
  schedule:
    - cron: "0 3 1 * *"   # 03:00 on the 1st of each month
  workflow_dispatch:
jobs:
  prune:
    # ... finds galleries with date older than N years and git rm's them
    # ... opens a PR rather than committing direct, so a human reviews
```

Recommend the workflow opens a PR (not a direct commit) so a human
reviews each prune. Documented in the feature README, not implemented
in the theme.

## BSO notes

General-purpose. BSO Groups often have international audiences
(grandparents in UK), so per-photo page URL stability is helpful. No
BSO-specific gating.

## Safeguarding & GDPR - critical

This feature is the largest GDPR/safeguarding surface in the roadmap.

1. Mandatory `photo_consent` field. Build fails if missing.
2. Mandatory `consent_log` field. Records *where* signed consent is
   stored; never rendered publicly.
3. Caption tone. Archetype comment header warns against identifying
   young people by name.
4. Image filenames numeric (`001.jpg`, `002.jpg`).
5. All images must be the Group's own. No stock photos that look like
   specific named children.
6. Right to be forgotten: `git rm` of the asset + rebuild.
7. EXIF metadata: recommend Groups strip before commit. Documented
   responsibility, not built.
8. A `consent-policy.md` page is shipped in `exampleSite/content/policies/`
   as a starter Groups can edit.

## Decided

| Q | Decision |
| --- | --- |
| Q4.1 | **Video links only** - gallery supports `video_links` array of external URLs (YouTube, Vimeo, Facebook video). No video file hosting. No embedded players. |
| Q4.2 | **Don't auto-prune.** Document the cron pattern in the README with the explicit warning that a forgotten cron will keep pruning. Opt-in for large Groups posting frequently. |
| Q4.3 | **`cover_alt` required when `cover` is set** (current schema). Not all-galleries, but enforced for any explicitly named cover. |
| Q4.4 | **Single string** for `consent_log`. Concatenate manually if multi-line. |
| Q4.5 | **Yes** - per-photo Open Graph meta. Pure-static, free, materially better when shared. |

## Out of scope (cross-references)

- Inline photos within News posts - those use Hugo's render hooks,
  not this feature.
- Live event photo streams.
- User-uploaded photos.
- Photo competitions.
- Comments/likes on photos.
- Search across galleries by face/name.
- Auto-pruning (documented as cron, not built).

## Implementation order

1. Schema, `archetypes/galleries.md` with consent warnings prominent.
2. Build `layouts/galleries/single.html` with hardcoded image list,
   no captions, no consent enforcement yet.
3. Add the consent and consent_log lints (errorf if missing).
4. Add captions sidecar mechanism - `data/galleries/<slug>.toml`.
5. Build `layouts/galleries/photo.html` with prev/next.
6. Build `layouts/galleries/list.html`.
7. Add `gallery-strip` home-page partial.
8. CSS for grid + photo page.
9. Open Graph meta on the photo page.
10. Video links partial.
11. Ship the `policies/photo-consent.md` example.
12. README section: safeguarding checklist + the optional pruning
    cron pattern with warnings.
