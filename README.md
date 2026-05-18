# Hugo British Scout Group

A reusable, palette-driven Hugo theme for UK Scout Group websites,
with first-class support for **British Scouting Overseas (BSO)** Groups.

Front-matter-driven sections. Five Scouts-brand palettes. Pure CSS —
no JavaScript anywhere in the theme. No third-party tracking. en-GB
throughout.

- **Licence:** [CC BY-SA 4.0](https://creativecommons.org/licenses/by-sa/4.0/) © Peter Mahon
- **Minimum Hugo:** 0.156 (extended edition)
- **Live example:** [1stadscouts.org](https://1stadscouts.org) (1st Abu Dhabi Scouts)

---

## Table of contents

- [What you get](#what-you-get)
- [Quick start](#quick-start)
- [Configuration](#configuration)
- [Section types](#section-types)
- [Features in depth](#features-in-depth)
- [Customising](#customising)
- [Design invariants](#design-invariants)
- [Repository layout](#repository-layout)
- [Development](#development)
- [Contributing](#contributing)
- [Licence](#licence)

---

## What you get

A complete single-page Scout Group website driven entirely from
`content/_index.md` and `hugo.toml`. Authors write a TOML list of
`[[sections]]` and the theme renders each one through a partial. No
HTML or CSS authoring needed for a normal Group site.

Out of the box, the theme provides:

- A two-column **hero** with optional scroll-driven intro animation.
- A **Scout sections grid** for Squirrels, Beavers, Cubs, Scouts,
  Explorers, and Network — Groups toggle which sections they run.
- A **Join** section, two-column CTAs, stacked features, embeds, and
  free-form prose blocks.
- A **News & Camp Reports** system with listing, pagination, and
  per-post pages.
- An **Events** system with calendar-import (`.ics`) downloads, a
  Cancelled/Postponed status model, and dual-time rendering for
  overseas Groups.
- A **Network feature band** promoting Scout Network (18–25) on a
  Scouts-Orange brand-anchor background.
- A **BSO membership notice** partial implementing The Scout
  Association's POR 3.2.1.1 wording for Groups operating overseas.
- A **palette showcase** page (`/palettes/`) listing all five palette
  presets for reference.

Everything is opt-in: features default OFF in the theme and are
enabled per-site in `hugo.toml`.

---

## Quick start

You need [Hugo extended](https://gohugo.io/installation/), version
0.156 or newer.

### 1. Create a new Hugo site

```sh
hugo new site mygroup
cd mygroup
git init
```

### 2. Add the theme as a Git submodule

```sh
git submodule add https://github.com/petemahon/hugo-british-scout-group.git \
  themes/british-scout-group
```

### 3. Minimal `hugo.toml`

```toml
baseURL    = "https://1stanytown.example.org/"
title      = "1st Anytown Scouts"
theme      = "british-scout-group"
languageCode = "en-GB"

[params]
  palette         = "classic-purple"      # one of five palette presets
  groupPrefix     = "1st Anytown"          # for the split-h1 hero
  groupSuffix     = "Scouts"
  place           = "Anytown"
  copyrightOwner  = "1st Anytown Scouts"
  copyrightRights = "All Rights Reserved"
  footerBg        = "dark"                 # Scouts Navy footer

[params.scoutSections]
  squirrels = { enable = false }
  beavers   = { enable = true }
  cubs      = { enable = true }
  scouts    = { enable = true }
  explorers = { enable = true }
  network   = { enable = false }           # opt-in; default off

[params.features]
  # Every feature defaults OFF. Enable here only when you have the
  # editorial commitment to maintain the feature. Stale content
  # damages credibility more than no content.
  news            = false
  events          = false
  network_feature = false
```

### 4. Minimal `content/_index.md`

```toml
+++
title = "1st Anytown Scouts"
+++

[[sections]]
  type    = "hero"
  title   = "Skills for life, in Anytown."
  lede    = "We're 1st Anytown Scouts. Adventure, friendship, and learning that lasts a lifetime."

[[sections]]
  type    = "scout-sections"
  id      = "our-sections"
  title   = "Our sections"
  subtitle = "We run programmes for ages 6 to 14 — find the one that fits."

[[sections]]
  type    = "where-we-meet"
  id      = "where-we-meet"
  title   = "Where we meet"
```

### 5. Serve

```sh
hugo serve --buildDrafts=false --buildFuture=false
```

Open <http://localhost:1313>.

### 6. Deploy

The theme makes no assumptions about hosting. GitHub Pages via a
GitHub Actions workflow is the path used by the canonical consuming
site; any static-hosting platform will work.

---

## Configuration

All Group-specific values live in **your site's** `hugo.toml`. Nothing
in the theme code references a specific Group.

### Palette

```toml
[params]
  palette = "classic-purple"
```

Five presets are shipped in `data/palettes.toml`:

| Key                | Primary feel                                     |
| ------------------ | ------------------------------------------------ |
| `classic-purple`   | The Scouts UK core purple (`#7413dc`).           |
| `adventure`        | Scouts Forest Green (`#205b41`).                 |
| `coastal`          | Scouts Navy (`#003982`), for Sea Scouts.         |
| `vibrant`          | Scouts Red (`#ed3f23`), high-contrast.           |
| `network`          | Black-on-orange — for Network-focused Groups.    |

Hex values come from the Scouts Brand Guidelines 2023. The palette
showcase page at `/palettes/` renders all five with their colour
swatches for visual comparison.

### Group identity (for the hero)

The hero splits the site title into three pieces so the optional
intro animation can fly the "prefix" portion up to the nav:

```toml
[params]
  groupPrefix = "1st Anytown"        # the part that flies
  groupSuffix = "Scouts"             # the part that stays
  place       = "Anytown"            # drives the "Skills for life · Anytown" eyebrow
```

Convention: `title == groupPrefix + " " + groupSuffix`. The theme
does not validate this.

### Scout sections

Toggle which age groups your Group runs. Logos ship with the theme —
brand asset maintenance is centralised, Groups do not override them.

```toml
[params.scoutSections]
  squirrels = { enable = false }
  beavers   = { enable = true }
  cubs      = { enable = true }
  scouts    = { enable = true }
  explorers = { enable = true }
  network   = { enable = false }     # opt-in; default off
```

Age ranges and `scouts.org.uk` URLs come from `data/scout_sections.toml`
in the theme and should not be duplicated in your site.

### BSO membership notice

For Groups operating overseas under The Scout Association's POR
3.2.1.1. Configure the host country and the host scouting
association; the wording itself is the canonical POR text.

```toml
[params.bsoMembershipNotice]
  enable                  = true
  hostCountryName         = "the United Arab Emirates"
  hostScoutingAssociation = "Emirates Scout Association"
```

Wording is in `i18n/en.toml` and can be overridden in your site's
own `i18n/en.toml`.

### Feature flags

Every feature is opt-in via `params.features.<name> = true`. Default
OFF. The example site turns every flag on so the demo exercises every
feature; your real Group site should enable only what you intend to
maintain.

```toml
[params.features]
  news            = true       # SPEC-01
  events          = true       # SPEC-02
  network_feature = true       # Network 18–25 brand-anchor band
```

---

## Section types

Canonical list. Adding a new type is fine; renaming or removing one is
a flag-not-change event (the dispatcher in `layouts/_default/list.html`
relies on these keys).

| `type`               | What it renders                                                                    |
| -------------------- | ---------------------------------------------------------------------------------- |
| `hero`               | Two-column hero — eyebrow + split-h1 + lede + buttons + optional photo.            |
| `two-col-cta`        | Two-column band, text one side, single CTA the other.                              |
| `two-col-image-cta`  | Two-column band with an image and a CTA.                                           |
| `section-grid`       | Generic responsive grid of cards.                                                  |
| `stacked-features`   | Numbered or icon-led feature list, stacked vertically.                             |
| `scout-sections`     | The five-section age-group grid (data-driven from `scout_sections.toml`).          |
| `section-header`     | Lightweight band — eyebrow + title + subtitle, no body.                            |
| `embed`              | An `<iframe>` (maps, video, etc.) with bg/padding control.                         |
| `bso-membership`     | Wrapper for the POR 3.2.1.1 notice partial.                                        |
| `palette-showcase`   | Renders all five palettes (used on `/palettes/`).                                  |
| `prose`              | Free-form Markdown content, constrained to a readable width.                       |
| `network-feature`    | The Network 18–25 brand-anchor band on Scouts Orange.                              |
| `events-upcoming`    | Home-page block listing future events with `.ics` downloads (requires `events`).   |
| `news-grid`          | Home-page block listing recent news posts (requires `news`).                       |
| `join` / `where-we-meet` | Stable nav-anchor sections.                                                    |

Each consuming-site section block in `content/_index.md` looks like:

```toml
[[sections]]
  type    = "two-col-image-cta"
  id      = "join"                 # optional anchor
  bg      = "muted"                # bg-muted, primary, secondary, tertiary, accent, dark
  title   = "Join us"
  body    = "Adventure starts here."
  [sections.cta]
    label = "Get in touch"
    url   = "mailto:hello@example.org"
  [sections.image]
    src = "images/join.webp"
    alt = "Beavers learning to tie knots"
```

Per-section fields are documented in each partial's header comment.

---

## Features in depth

### Hero with optional intro animation

The home-page hero splits the h1 into three spans (`groupPrefix`,
em-slot, `groupSuffix`) so an optional scroll-driven animation can
detach the em, fly it to the nav, and cross-fade with the nav-name.

Enable with `params.heroIntro = true`. Requires `groupPrefix +
groupSuffix` to be set. The animation uses CSS `animation-timeline:
scroll()` + `anchor-name` (Baseline 2026, Chrome 115+, Safari 26+).
Pre-baseline browsers and `prefers-reduced-motion: reduce` get the
static hero — no degraded fallback path needed.

### News & Camp Reports (SPEC-01)

A standard Hugo content section under `content/news/`. Set
`params.features.news = true`, then:

```toml
[params.news]
  posts_per_page        = 12
  default_count_on_home = 3
  show_author           = true
  show_reading_time     = false
```

Generates a listing at `/news/`, paginated; a per-post page; and a
`news-grid` home-page block that renders the latest N posts.

### Events with `.ics` download (SPEC-02)

A content section under `content/events/` with three custom output
formats: HTML, per-event `event.ics`, and an aggregate `/events/all.ics`.

```toml
[params.features]
  events = true

[params.events]
  timezone              = "Europe/London"
  show_past_archive     = false
  upcoming_window_days  = 365
  default_count_on_home = 4
```

Event front-matter uses a `status = "active" | "cancelled" | "postponed"`
enum. Cancelled and postponed events emit appropriate VEVENT
`METHOD:CANCEL` / `SEQUENCE` semantics so calendar clients update
correctly.

For BSO Groups, events render in **dual time**: the host-country
local time, with the UK equivalent in parentheses. Drive this by
setting `params.events.timezone` to your local IANA TZ — the theme
computes UK time at render.

### Network feature band

A dedicated home-page band promoting Scout Network (18–25). Renders
on a Scouts-Orange **brand-anchor** background that does not change
when the site palette changes — Network's identity colour is fixed.
The number circles inside the white point cards pick up the site
palette's `--primary`, giving the band a subtle per-Group signature.

```toml
[params.features]
  network_feature = true
```

```toml
[[sections]]
  type = "network-feature"
  id   = "network"
```

That's the minimum. Override the eyebrow, title, intro, CTA, and the
three point cards via front-matter or via `i18n/en.toml`. See
[Customising](#customising) below.

### BSO membership notice

Renders the eligibility statement aligned with POR 3.2.1.1 for
overseas Groups. The notice is a dedicated partial, configured via
`[params.bsoMembershipNotice]` and rendered by including a
`bso-membership` section in `content/_index.md`.

The wording is canonical and should not be reworded without
consulting POR.

---

## Customising

### Wording (i18n)

The theme ships all user-facing strings as Hugo i18n keys in
`i18n/en.toml`. Override in your site's own `i18n/en.toml` to change
any wording — including the Network feature defaults, the BSO notice
text, button labels, and so on.

```toml
# my-site/i18n/en.toml
[networkFeatureHeading]
other = "Aged 18 to 25? You're not done yet."

[networkFeatureCtaHref]
other = "https://www.scouts.org.uk/network/"
```

Hugo merges your i18n file with the theme's; your keys win.

### Visual / CSS

The theme assembles its stylesheet from numbered modules under
`assets/css/`. The pipeline (`resources.Match "css/*.css" |
resources.Concat`) concatenates everything in file-name order, so
adding a new module is a drop-in:

```
00-tokens.css                  Design tokens + brand anchors
01-base.css                    Resets, typography
02-layout.css                  Container, grid, link-decoration sentinels
03-components-buttons.css      .btn, .btn-primary, .btn-ghost, .btn-dark
04-nav.css                     Sticky nav, dropdowns, mobile hamburger
05-components-sect-head.css    .sect-head + .eyebrow shared component
…
10-section-hero.css            Section modules — one per section type
11-section-two-col-cta.css
…
22-section-network-feature.css (D10)
30-footer.css
40-print.css
41-feature-hero-intro.css      (opt-in, gated by body class)
```

To override theme styles in your site, add a `assets/css/99-site.css`
in your site repo — Hugo's resource resolution prefers the site over
the theme, and the pipeline picks it up automatically.

### Brand-anchor tokens

A small set of Scouts-identity colour tokens are fixed across every
palette preset and are not overridden by palette switches:

```css
:root {
  --scouts-orange:       #ff912a;
  --scouts-black:        #0d0d0d;
  --scouts-black-hover:  #2a2a2a;
}
```

Used by sections whose brand identity is colour-anchored (the
Network feature band is always Scouts Orange, regardless of palette).
Do not override these locally without strong justification.

### Inline SVG symbols

The theme exposes a small library of inline SVG `<symbol>` definitions
via `layouts/partials/svg-defs.html`, registered in
`data/svg_symbols.toml`. Reference any registered symbol from a
template with `<svg><use href="#id"/></svg>`.

To add a new symbol:

1. Drop the source SVG anywhere under `/assets/` — convention is
   `assets/svg/<name>.svg` for generic marks and
   `assets/images/sections/<name>.svg` for section badges.
2. Add a row to `data/svg_symbols.toml`:

   ```toml
   [[symbols]]
     id     = "foo"
     source = "svg/foo.svg"     # path relative to /assets/
   ```

3. Reference: `<svg><use href="#foo"/></svg>`.

The partial reads each source's `viewBox` and root-level `fill` so
colour-control behaviour follows the source SVG: marks authored with
`fill="currentColor"` are CSS-controllable; section badges with
hardcoded brand colours stay in brand. Group sites can register
their own symbols by adding entries to the site's own
`data/svg_symbols.toml` — Hugo merges the lists at build time.

### Image overrides

Generic placeholder images (e.g.
`assets/images/volunteer/role-model.webp`) ship at the path that
section partials request. To override, place your own file at the
**same path** in your site repo; Hugo's resource resolution prefers
the site over the theme.

**Exception:** the official Scouts section logo SVGs at
`assets/images/sections/{squirrels,beavers,cubs,scouts,explorers,network}.svg`
are centrally maintained brand assets and should NOT be overridden.
When The Scout Association updates a logo, the theme is updated;
sites pick up the new asset on the next submodule bump.

---

## Design invariants

These are intentional constraints. Departing from them is a
flag-not-change event — open an issue first.

- **`<html lang="en-GB">` is hardcoded** in `baseof.html`. The
  theme is en-GB-only by design; locale is not parameterised.
- **No JavaScript dependency anywhere.** Sticky nav, smooth scroll,
  fade-in animations, mobile-menu hamburger, event status badges,
  dual-time rendering — all pure CSS. An optional hero intro
  animation uses scroll-driven CSS animation (Baseline 2026), not
  JS.
- **No backend services, no third-party tracking.** No analytics,
  no social embeds with trackers, no comment systems, no payment
  widgets, no live-chat, no tracking font CDNs. The only runtime
  third party is Google Fonts (Inter Tight), loaded statically.
- **WCAG 2.2 AA is the floor.** Skip link first-focusable on every
  page; focus rings on every interactive element; `prefers-reduced-motion`
  honoured; colour-contrast audited in CI.
- **Group-specific values live only in `hugo.toml` and `content/`.**
  Nothing in theme code references any specific Group's name,
  address, photos, or copy.

---

## Repository layout

```
hugo-british-scout-group/
├── README.md                      # this file
├── LICENSE                        # CC BY-SA 4.0 © Peter Mahon
├── theme.toml                     # theme metadata for Hugo
├── Makefile                       # make serve | build | roll | clean
├── archetypes/                    # `hugo new` scaffolds
├── assets/
│   ├── css/                       # numbered CSS modules (00–99)
│   ├── svg/                       # source SVGs for inline symbols
│   └── images/                    # generic placeholders + section logos
├── data/
│   ├── palettes.toml              # five palette presets
│   ├── scout_sections.toml        # age groups + scouts.org.uk URLs
│   └── svg_symbols.toml           # inline SVG symbol registry
├── i18n/
│   └── en.toml                    # all user-facing strings
├── layouts/
│   ├── _default/                  # baseof, single, list (dispatcher)
│   ├── index.html                 # home — dispatches to section partials
│   ├── events/                    # listing, single, .ics output formats
│   ├── news/                      # listing, single
│   └── partials/
│       ├── head.html              # meta + CSS pipeline + palette injection
│       ├── header.html            # sticky nav
│       ├── footer.html
│       ├── palette-style.html     # emits chosen palette as CSS vars
│       ├── svg-defs.html          # data-driven inline <symbol> defs
│       ├── bso-membership-notice.html
│       ├── event-*.{html,ics}
│       ├── news-*.html
│       └── sections/              # one partial per [[sections]] type
├── scripts/
│   └── roll-example-dates.py      # demo-roller for exampleSite events
├── exampleSite/                   # demo site + test fixture
│   ├── hugo.toml                  # exercises every feature
│   └── content/
│       ├── _index.md              # home page [[sections]] array
│       ├── news/
│       ├── events/                # with [demo] blocks
│       └── palettes/_index.md
└── documentation/
    ├── README.md                  # spec-pack reading order
    └── specs/
        ├── DECISIONS.md           # locked architectural choices
        ├── SPEC-COMMON.md         # cross-cutting conventions
        └── SPEC-01-news.md … SPEC-12-accessibility.md
```

---

## Development

### Dev loop

From the repo root:

```sh
make serve       # roll example dates forward, then `hugo serve`
make build       # roll example dates forward, then `hugo --minify`
make roll        # just run the date-roller
make clean       # discard the date-roller's in-flight edits
```

All Hugo invocations use `--buildDrafts=false --buildFuture=false`
to match the deploy policy.

### The date-roller

The `exampleSite/` content includes example events with hardcoded
dates. To keep the demo looking fresh against build time,
`scripts/roll-example-dates.py` rewrites `date`, `publishDate` and
`end` for any event whose front-matter has a `[demo]` block:

```toml
[demo]
  target_offset_days = 65    # event happens this many days from now
  publish_lead_days  = 23    # publishDate = now - this many days
```

The committed dates in git are the canonical "last known good"
example dates. The script overwrites them in-flight before every
`hugo serve` and every CI build of the theme's Pages preview. The
working-tree changes the script makes should NOT be committed; run
`make clean` before committing.

**Group sites consuming the theme have no `[demo]` blocks** — real
Group events have real fixed dates, and the script never touches them.

### Testing changes

Run `make serve` and visit:

- `/` — the home page, exercising every section type.
- `/palettes/` — the palette showcase. Switch `params.palette` in
  `exampleSite/hugo.toml` to verify each preset.
- `/news/` — the news listing and per-post pages.
- `/events/` — the events listing and per-event `.ics` downloads.
- `/events/all.ics` — the aggregate calendar feed.

Test print stylesheets via the browser's print preview on each page.

---

## Contributing

Pull requests welcome. Before opening one, please open an issue if
the change touches any of the following — these are intentional
invariants that need a conversation, not a silent flip:

- Locale handling. The theme is en-GB-only by design.
- Adding JavaScript anywhere.
- Adding a sixth named palette preset (vs. editing existing hex
  values to track Scouts brand updates — editing is the expected
  maintenance path).
- Anything that would make the theme depend on a specific Group's
  content or images.
- Anything that would make the theme BSO-specific in code. BSO
  features stay optional add-ons.
- Renaming or removing any canonical section type.
- Renaming the three always-on nav anchors (`#joining`,
  `#our-sections`, `#where-we-meet`).
- The BSO membership notice copy (aligned with POR 3.2.1.1).
- Bumping `theme.toml` `min_version`.
- Adding content from copyrighted Scout brand assets (the official
  section logos live in the theme; other brand assets must come from
  scoutsbrand.org.uk on a per-Group basis).

For everything else: clear commit messages, en-GB in user-facing
strings, no new JS, and please add to the relevant SPEC document
under `documentation/specs/` if the change extends a feature's
contract.

---

## Licence

This work is licensed under the
[Creative Commons Attribution-ShareAlike 4.0 International License](https://creativecommons.org/licenses/by-sa/4.0/)
© Peter Mahon.

You are free to share and adapt the theme for any purpose, including
commercially, provided you give appropriate credit, indicate any
changes, and distribute your contributions under the same licence.

The colour palette presets use hex values published in the Scouts
Brand Guidelines 2023. Hex codes are factual data and are not
themselves copyrightable.

The official Scouts section logos shipped in
`assets/images/sections/` are © The Scout Association. Their
distribution within forks of this theme is permitted only when the
fork is being used to build a website for an actual Scout Group, in
line with The Scout Association's brand asset terms.

The "Inter Tight" typeface is loaded at runtime from Google Fonts
under the SIL Open Font License 1.1.

The author asks (but does not require) that downstream users keep
the `LICENSE` file intact in any forks of the theme repository.
