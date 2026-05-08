# SPEC-08: Hall Hire / HQ Booking

Read `SPEC-COMMON.md` first.

## Goal

Static informational page advertising the Scout Hut for community
hire: photos, capacity, hourly rates, available facilities, terms &
conditions, and an enquiry email. No booking system, no calendar, no
payment.

The vendor sites (Scout Websites Ltd) charge for an integrated
calendar + payment system; this theme ships the *informational* part
properly. Real parallels: 21st Romsey, 1st Rustington, 1st Lady Bay,
5th Rugby (Newbold), Bathampton.

## Acceptance criteria

1. A page exists at `/hall-hire/` rendering the hall description,
   capacity, dimensions, facilities, rates, T&Cs link, and enquiry
   email.
2. Photos render in a small responsive strip.
3. Rates support multiple categories.
4. The page includes the standard "Scout activities take priority"
   disclaimer.
5. **"Fully booked" banner** when `params.hall_hire.fully_booked = true`,
   styled with `--warning` palette token (see DECISIONS.md). Page
   continues to render — the banner just signals that new enquiries
   aren't being taken.
6. Feature gated by `params.features.hall_hire` (default OFF).
7. Example site exercises: a Group with a single rate, a Group with
   multiple rate tiers, a Group with a deposit + cleaning fee, a
   Group flagged as fully booked.

## Content layout

```
content/hall-hire/
└── _index.md
```

Single page. Multi-hall is out of scope.

## Front-matter schema

| Field | Type | Required | Default | Notes |
| --- | --- | --- | --- | --- |
| `title` | string | no | "Hire our hall" | Page heading |
| `intro` | string (HTML allowed) | yes | — | Description of the hall |
| `address` | string | yes | — | Full street address |
| `postcode` | string | no | — | UK / international format |
| `map_url` | string | no | — | Static map link (OSM or Google) |
| `capacity_seated` | int | no | — | |
| `capacity_standing` | int | no | — | |
| `dimensions` | string | no | — | Free text — "10m × 8m" |
| `floor_area_m2` | int | no | — | Numeric |
| `facilities` | list[string] | no | `[]` | "Kitchen", "Toilets", "Disabled access", "Parking", "Stage", "AV/projector", "Wi-Fi" |
| `rates` | list[block] | yes | — | See below |
| `deposit` | string | no | "" | "£50 refundable damage deposit" |
| `cleaning_fee` | string | no | "" | |
| `terms_pdf` | string | no | — | Path to T&Cs PDF (under `static/`) |
| `terms_url` | string | no | — | Alternative — external T&Cs URL |
| `enquiry_email` | string | yes | — | Generic Group email |
| `enquiry_phone` | string | no | — | Group duty mobile (not personal) |
| `availability_note` | string (HTML allowed) | no | "" | "Not available Monday–Friday 17:00–21:00 during school terms" |
| `priority_disclaimer` | bool | no | true | Renders the "Scout activities take priority" line |
| `photos` | list[block] | no | `[]` | See below |

Each `rates` block:

```toml
[[rates]]
  name      = "Local resident, hourly"
  amount    = "16"
  currency  = "GBP"
  period    = "hour"
  notes     = ""

[[rates]]
  name      = "Birthday party (Saturday morning, 4 hours)"
  amount    = "80"
  currency  = "GBP"
  period    = "session"
  notes     = "Includes setup time"
```

| Sub-field | Type | Required | Default | Notes |
| --- | --- | --- | --- | --- |
| `name` | string | yes | — | |
| `amount` | string | yes | — | Number as string |
| `currency` | string | no | "GBP" | ISO 4217 |
| `period` | string | yes | — | "hour" \| "session" \| "day" \| "weekend" |
| `notes` | string | no | "" | |

Each `photos` block:

```toml
[[photos]]
  src = "main-hall.jpg"
  alt = "Main hall set up for a birthday party"
  caption = "Main hall, capacity 80 standing"
```

| Sub-field | Type | Required | Default | Notes |
| --- | --- | --- | --- | --- |
| `src` | string | yes | — | Filename in `assets/hall-hire/photos/` |
| `alt` | string | yes | — | |
| `caption` | string | no | "" | |

## Layouts to create

| File | Purpose |
| --- | --- |
| `layouts/hall-hire/single.html` | The page itself |
| `layouts/partials/hall-hire-rates.html` | Rate table |
| `layouts/partials/hall-hire-facilities.html` | Facility chips |
| `layouts/partials/hall-hire-photos.html` | Photo strip |
| `layouts/partials/hall-hire-fully-booked.html` | Banner shown when flag set |

## hugo.toml additions

```toml
[params.features]
  hall_hire = false                       # default OFF — opt-in

[params.hall_hire]
  show_currency_symbol = true
  fully_booked = false                    # set true to render the banner
```

## Asset paths

- `assets/hall-hire/photos/<filename>.jpg` — processed by Hugo image
  pipeline.
- `static/hall-hire/terms-and-conditions.pdf` — T&Cs.
- Theme ships placeholder photos at
  `assets/hall-hire/_placeholder/main-hall.jpg`.

## CSS-only baseline

- Two-column layout on wide screens: photo strip left, rates/facts
  right. Stacks single-column below 768px.
- Photo strip: horizontal scroll (CSS overflow), no JS carousel.
- Rate table: `<table>` styled cleanly.
- Facility chips: pill list styled like section badges.
- Fully-booked banner: full-width, `var(--warning)` background, sits
  at top of page above `intro`.
- Print stylesheet: hide nav, force one-column, T&Cs link rendered
  as full URL.

## BSO notes

Most BSO Groups don't own their meeting venue. The feature flag
defaults OFF. No BSO-specific behaviour.

## Safeguarding & GDPR

- No data collection. Email-only enquiry pattern.
- `enquiry_email` should be a generic Group email, not personal.
- `enquiry_phone` should be the Group duty mobile, not personal.
- T&Cs PDF: Groups ensure their template covers GDPR for hirer data.
- Don't include photos that show identifiable young people. Recommend
  adult-only or empty-hall photos.

## Decided

| Q | Decision |
| --- | --- |
| Q8.1 | **Yes** — fully-booked banner via `params.hall_hire.fully_booked = true`. Reuses `--warning` palette token. |
| Q8.2 | **No** — multi-hall support deferred. Single-hall v1; multi-hall Groups can add a second listing in the `intro`. |
| Q8.3 | **Neutral** rate labelling — numbers as plain strings, Groups annotate in `notes`. |
| Q8.4 | **Link only** for map. Static-map embed needs API keys / tile services. |

## Out of scope (cross-references)

- Online payments.
- Booking calendar.
- Per-event hire history.
- Hire enquiry tracking.
- Insurance certificates / risk assessment downloads — Groups can
  add as ad-hoc Markdown links in the `intro`.

## Implementation order

1. Schema, `archetypes/hall-hire.md`.
2. `layouts/hall-hire/single.html` with hardcoded fields.
3. Replace with front-matter-driven content.
4. `layouts/partials/hall-hire-rates.html` with currency rendering
   (reusing `data/currencies.toml` from SPEC-06).
5. `layouts/partials/hall-hire-facilities.html` chips.
6. `layouts/partials/hall-hire-photos.html` strip.
7. `layouts/partials/hall-hire-fully-booked.html` banner.
8. CSS — two-column, photo strip, banner, print stylesheet.
9. README, screenshot.
