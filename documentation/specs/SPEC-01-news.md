# SPEC-01: News & Camp Reports

Read `SPEC-COMMON.md` first.

## Goal

A dated post type for short informational updates: camp write-ups, badge
presentations, "Squirrels start in September", section milestones. Renders
as a reverse-chronological listing plus per-post pages, with optional
excerpts on the home page.

The single biggest informational uplift identified in research. Real
parallels: 23rd Manchester (`/cubs-our-camp-blog/`), 7th Hampton
(WordPress, with category routing per section), 5th Hucknall.

## Acceptance criteria

1. A new page exists at `/news/` listing every post in reverse
   chronological order. Pagination after 12 posts.
2. Each post has its own page at `/news/<slug>/` with a cover image,
   title, date, author byline, body, and a list of section badges.
3. Home page can show the latest *N* posts via a new section type,
   `news-grid`, with *N* configurable.
4. Listing page is filterable by section taxonomy: `/news/sections/cubs/`
   etc., using Hugo's built-in taxonomy routing.
5. Build fails (errorf) if a post has any `assets/news/<slug>/*` image
   reference but no `photo_consent = true` in front-matter.
6. Feature is fully gated by `params.features.news` (defaulting OFF).
   With it off, no listing page renders, no home-page block renders,
   and no taxonomy pages render.
7. The example site exercises: a post with cover image, a post with no
   cover, a post tagged across multiple sections, a draft post, a
   future-dated post (which must not appear).

## Content layout

```
content/news/
├── _index.md                                # listing page metadata
├── 2026-04-19-st-georges-day.md             # individual posts
├── 2026-03-30-cubs-cooking-cup.md
└── 2026-02-15-squirrels-launch.md
```

Slug convention: `YYYY-MM-DD-kebab-case-title.md`. Hugo derives
`/news/2026-04-19-st-georges-day/`. URLs are flat (no year nesting) —
see DECISIONS.md.

## Front-matter schema (per post)

| Field | Type | Required | Default | Notes |
| --- | --- | --- | --- | --- |
| `title` | string | yes | — | Post title, plain text |
| `date` | datetime | yes | — | ISO-8601. Posts with `date > now` are not built. |
| `summary` | string | no | first 30 words of body | Used on cards and meta description |
| `sections` | list[string] | no | `[]` | Taxonomy values from `data/scout_sections.toml` |
| `cover_image` | string | no | — | Path under `assets/news/<slug>/` |
| `cover_alt` | string | yes if `cover_image` | — | Required when image present |
| `author` | string | no | "" | Free text — leader nickname e.g. "Akela" |
| `photo_consent` | bool | yes if any image referenced | — | Build fails if missing |
| `draft` | bool | no | `false` | Standard Hugo |

`_index.md` for the listing page:

| Field | Type | Required | Default | Notes |
| --- | --- | --- | --- | --- |
| `title` | string | no | "News" | Listing page heading |
| `description` | string | no | — | Renders below heading |
| `posts_per_page` | int | no | 12 | Hugo pagination |

## Section partial: `news-grid`

Renders on the home page (or any page) when listed in `[[sections]]`:

```toml
[[sections]]
  type      = "news-grid"
  id        = "news"
  title     = "Latest news"
  subtitle  = "What we've been up to"   # optional
  count     = 3                          # default 3, max 12
  show_more = true                       # link to /news/
  bg        = "muted"                    # see SPEC-COMMON §6
```

Renders three cards (or `count`) with cover image, title, date,
summary, section badges. "View all news" link if `show_more` is true.

## Layouts to create

| File | Purpose |
| --- | --- |
| `layouts/news/list.html` | `/news/` listing route |
| `layouts/news/single.html` | `/news/<slug>/` post route |
| `layouts/news/term.html` | `/news/sections/cubs/` etc. (Hugo taxonomy term page) |
| `layouts/partials/sections/news-grid.html` | Home-page block |
| `layouts/partials/news-card.html` | Reusable card markup |
| `layouts/partials/news-meta.html` | Author + date + sections row |

## hugo.toml additions

```toml
[params.features]
  news = false                           # default OFF — opt-in per DECISIONS.md

[params.news]
  posts_per_page    = 12
  default_count_on_home = 3
  show_author       = true
  show_reading_time = false              # pure-Hugo, no JS

[taxonomies]
  section = "sections"                   # see SPEC-COMMON §8
```

## Asset paths

- `assets/news/<slug>/cover.jpg` (or .webp, .png — Hugo pipeline accepts)
- Inline images for the post body: `assets/news/<slug>/photo-1.jpg`,
  referenced from Markdown via Hugo's image render hook.
- Theme ships a generic placeholder cover at
  `assets/news/_placeholder/cover.jpg`.

## CSS-only baseline

- Card grid: CSS Grid, `grid-template-columns: repeat(auto-fit, minmax(300px, 1fr))`.
- Hover transitions on cards: `:hover` only.
- Section badges: pill-shaped, colour from `data/scout_sections.toml`
  `colour` field (see DECISIONS.md for the six section hex values).
- Pagination: pure-HTML next/prev links generated by Hugo's `Paginator`.
- Reading time (optional, off by default): computed in template via
  `mul .ReadingTime 1`.

## BSO notes

General-purpose. No BSO-specific behaviour. BSO Groups will use this
feature like any other Group.

## Safeguarding & GDPR

- `photo_consent = true` is the canonical lint (see SPEC-COMMON §10).
- Recommend in archetype field comments that authors avoid
  identifiable names; the partial does not enforce.
- Author byline takes free-text — recommend leader nickname
  ("Akela", "GSL", "Cub Leader") rather than full personal name.
- No comments section.

## Decided

| Q | Decision |
| --- | --- |
| Q1.1 | **Yes** — add `colour` field to `data/scout_sections.toml`. Values per DECISIONS.md (challenge-badge outer-ring colours, brand-book where Peter named without hex). |
| Q1.2 | **No** — no separate `tags` taxonomy in v1. `sections` is the only taxonomy. |
| Q1.3 | **Flat URLs** — `/news/<slug>/`, no year nesting. |

## Out of scope (cross-references)

- Calendar feed of news → no, `.ics` is in SPEC-02 (Events).
- Photo galleries embedded in posts → no, full galleries are SPEC-04;
  inline images via Hugo render hooks are fine.
- AGM reports as news posts → no, governance docs are SPEC-07.

## Implementation order

1. Add `colour` field to `data/scout_sections.toml` for all six
   section keys (per DECISIONS.md).
2. Create `archetypes/news.md` so `hugo new news/...` works.
3. Create `layouts/news/list.html` with hardcoded data; build, verify
   route exists.
4. Create `layouts/news/single.html` for individual posts; build.
5. Create three example posts under `exampleSite/content/news/` and
   confirm rendering.
6. Create `layouts/partials/sections/news-grid.html` and wire into
   the section dispatcher in `layouts/index.html`.
7. Add a `news-grid` block to `exampleSite/content/_index.md`.
8. Add CSS under `/* ----- s-news ----- */` banner.
9. Implement the `photo_consent` errorf check.
10. Add `term.html` for taxonomy pages.
11. Add i18n strings (`newsHeading`, `newsByLine`, `newsReadMore`,
    `newsViewAll`, `newsNoPosts`, `newsSectionBadge`).
12. Add README section, screenshot, build clean.
