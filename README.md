<h1 align="center">Hugo British Scout Group</h1>

<p align="center">
  A reusable, palette-driven Hugo theme for UK Scout Group websites —<br>
  with <strong>first-class support for British Scouting Overseas (BSO)</strong>.
</p>

<p align="center">
  Front-matter-driven sections · five Scouts-brand palettes · pure CSS, no JavaScript ·<br>
  no third-party tracking · WCAG 2.2 AA · en-GB throughout.
</p>

<p align="center">
  <a href="https://gohugo.io/installation/"><img alt="Hugo 0.156+ extended" src="https://img.shields.io/badge/Hugo-0.156%2B%20extended-ff4088?logo=hugo&logoColor=white"></a>
  <a href="https://github.com/petemahon/hugo-british-scout-group/actions/workflows/a11y.yml"><img alt="Accessibility CI" src="https://github.com/petemahon/hugo-british-scout-group/actions/workflows/a11y.yml/badge.svg"></a>
  <img alt="WCAG 2.2 AA" src="https://img.shields.io/badge/accessibility-WCAG%202.2%20AA-2e7d32">
  <img alt="Pure CSS — no JavaScript" src="https://img.shields.io/badge/Pure%20CSS-no%20JavaScript-success">
  <img alt="British Scouting Overseas: first-class" src="https://img.shields.io/badge/British%20Scouting%20Overseas-first--class-7413dc">
  <a href="#contributing"><img alt="PRs welcome" src="https://img.shields.io/badge/PRs-welcome-brightgreen"></a>
  <a href="https://creativecommons.org/licenses/by-sa/4.0/"><img alt="Licence: CC BY-SA 4.0" src="https://img.shields.io/badge/licence-CC%20BY--SA%204.0-blue"></a>
  <img alt="Last commit" src="https://img.shields.io/github/last-commit/petemahon/hugo-british-scout-group">
</p>

<p align="center">
  <strong>Live example:</strong> <a href="https://adscouts.org">adscouts.org</a> (Abu Dhabi Scouts)
  · <strong>Minimum Hugo:</strong> 0.156 extended
  · <strong>Licence:</strong> CC BY-SA 4.0 © Peter Mahon
</p>

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
- A **Termly Programme** publisher, **Photo Galleries** with build-time
  consent lints, reusable **Camp Kit Lists** with printable sheets, and
  a **Joining / Waiting-List** page plus a printable **Welcome Pack**.
- **History & Governance** pages (CSS-only timeline, Trustee Board,
  charity-registration footer, and published Trustee Board meeting
  summaries), a **Hall Hire** page, and a **Fundraising & Volunteering**
  area with open-role listings.
- A **BSO Joining Hub** (`/bso/`) for overseas Groups — eligibility,
  moving-in/out pathways, and host-country scouting bodies.
- An **auto-built navigation** (no menu config — driven by your feature
  flags) and **WCAG 2.2 AA accessibility** baked in (skip link, focus
  rings, reduced motion, build-time alt/heading lints, axe-core CI).
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
  id      = "sections"               # the always-on #sections nav anchor
  title   = "Our sections"
  subtitle = "We run programmes for ages 6 to 14 — find the one that fits."

# "Where we meet" is a section-header (the title) immediately followed by
# an embed (the map). Keep the two adjacent — the header titles the map.
[[sections]]
  type    = "section-header"
  id      = "where-we-meet"          # the always-on #where-we-meet nav anchor
  title   = "Where we meet"

[[sections]]
  type    = "embed"
  url     = "https://snazzymaps.com/embed/123456"   # CHANGE ME — your map
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
  news              = true     # /news/ listing + camp reports
  events            = true     # /events/ with .ics calendar downloads
  programme         = true     # termly programmes
  galleries         = true     # photo galleries with consent lints
  kit_lists         = true     # camp kit lists + printable sheets
  joining           = true     # /join/ page + waiting lists
  welcome_pack      = true     # /welcome-pack/ content section
  history           = true     # /about/history/
  governance        = true     # /about/governance/ + charity footer
  trustee_minutes   = true     # /about/minutes/ Trustee Board summaries
  fundraising       = true     # /support-us/ + volunteer roles
  hall_hire         = true     # /hall-hire/
  bso_hub           = true     # /bso/ joining hub (BSO Groups only)
  network_feature   = true     # Network 18–25 brand-anchor band
  volunteer_feature = true     # "Register to volunteer." brand-anchor band
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
| `volunteer-feature`  | The "Register to volunteer." brand-anchor band on Scouts Purple.                   |
| `events-upcoming`    | Home-page block listing future events with `.ics` downloads (requires `events`).   |
| `news-grid`          | Home-page block listing recent news posts (requires `news`).                       |
| `gallery-strip`      | Home-page block — latest gallery's cover plus a short row of thumbs (requires `galleries`). |
| `programme-current`  | Home-page block — collapsible "this term's programme" per section (requires `programme`). Opt-in: ships disabled by default. |
| `volunteer-recruitment-banner` | Home-page band linking to open volunteer roles — renders **only** when a role is open (requires `fundraising`). |
| `join`               | The Join Us nav-anchor section (`id="join"` → `#join`).                            |

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

### News & Camp Reports

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

### Events with `.ics` download

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

### Termly Programme

A content section under `content/programme/` for publishing one
sanitised, public-friendly summary per section per term. Each programme
lists weekly meetings with **Skills for Life theme chips** sourced from
`data/programme_themes.toml`. Encourages curriculum balance and
surfaces it for District audit (POR 9.1.2.1).

```toml
[params.features]
  programme = true

[params.programme]
  keep_archive                  = false           # show past terms?
  default_density               = "themes_only"   # "themes_only" | "full"
  show_district_approved_badge  = true
  show_theme_chips              = true
```

Scaffold a new programme with:

```sh
hugo new programme/cubs-summer-2026.md
```

The archetype carries safeguarding guidance in its comment header:
public programmes must not name young people, must not name external
visitors without consent, and must not include addresses for activities
at private venues. **Default density is `themes_only`** (no notes
column) for that reason; switch to `density = "full"` only when every
notes value has been reviewed.

**Theme chips** are coloured pills next to each meeting title.
Eight default themes blend the Skills for Life curriculum areas with
the four top-line outcome statements; their `palette` token resolves
under the active site palette so chips re-tint when the palette
changes. The list in `data/programme_themes.toml` should be reconciled
against [scouts.org.uk/programme-planner](https://www.scouts.org.uk/programme-planner/)
before a Group goes live.

**Print stylesheet** ships in the theme — parents press Ctrl/Cmd+P on
a programme page to get a one-sheet A4 plan with chrome stripped,
chips outlined in monochrome, and the weeks table edge-to-edge.

**Optional home-page block.** A `programme-current` section type
renders the current term as a list of collapsible `<details>` panels.
**It's NOT in the example site's home page by default** —
opt in by pasting this into your `content/_index.md`:

```toml
[[sections]]
  type      = "programme-current"
  id        = "this-term"
  align     = "left"
  eyebrow   = "This term"
  title     = "What we're doing right now"
  bg        = "muted"
  density   = "themes_only"          # overrides per-programme density
  show_more = true                   # render "View all programmes →" button
  # sections = ["beavers", "cubs"]   # optional filter; empty = all sections
```

### Photo Galleries

A `/galleries/` content section for camp and event photo galleries.
The highest residual safeguarding surface in the roadmap — the build
fails (`errorf`) on any gallery that resolves images without
`photo_consent = true` and a non-empty `consent_log` in front-matter.
Both lints are build-time only; the consent log is never rendered.

```toml
[params.features]
  galleries = true

[params.galleries]
  thumbs_per_row     = 4
  show_captions      = true
  show_consent_link  = true
  consent_policy_url = "/policies/photo-consent/"
```

Scaffold a new gallery with:

```sh
hugo new galleries/2026-summer-camp/_index.md
```

Then drop the photo files into `assets/galleries/2026-summer-camp/`.
**No `.md` bookkeeping per photo** — a Hugo *content adapter* at
`content/galleries/_content.gotmpl` walks each gallery's asset
directory and registers one virtual `Page` per image at
`/galleries/<slug>/<image-basename>/`. Add a JPG to the directory
and it appears at the next rebuild.

**Captions and alt text** live in an optional sidecar at
`data/galleries/<slug>.toml`:

```toml
[[image]]
  file          = "001.jpg"
  caption       = "Cubs starting the obstacle course"
  alt           = "A line of Cubs running between hay bales"
  faces_blurred = false
```

Missing sidecar still builds — Hugo emits an `info`-level notice
encouraging captions for accessibility. Setting `faces_blurred = true`
surfaces a small "Faces obscured" pill on the thumbnail.

**Per-photo Open Graph meta.** Each `/galleries/<slug>/<image>/` page
emits its own `og:image` (the 1280w WebP resize), `og:title` (gallery
title plus caption), and `og:description` (the image alt text). A
parent sharing a single photo with grandparents shows that photo as
the preview, not the home page hero.

**Video links** are external-only — the gallery's front-matter accepts
a `[[video_links]]` array of `{url, label, thumbnail?}` blocks that
render as outbound cards. **No video files are hosted by the theme
and no players are embedded** (YouTube, Vimeo, Facebook video URLs
are recognised and labelled accordingly).

**Time-based pruning is documented, not built.** Galleries from many
years ago can become a maintenance and safeguarding burden. A GitHub
Actions cron can prune galleries older than N years, but the theme
deliberately doesn't ship one — a forgotten cron will keep pruning.
The opt-in pattern, with the explicit warning:

> **Warning.** A scheduled-prune cron will continue removing content
> over time even if you forget about it. If your repo has no recent
> commits and the cron is still scheduled, it will eventually prune
> everything. Treat as opt-in only, with a calendar reminder to review.

```yaml
# .github/workflows/prune-galleries.yml — OPT-IN, READ THE WARNING
name: Prune galleries older than 3 years
on:
  schedule:
    - cron: "0 3 1 * *"   # 03:00 on the 1st of each month
  workflow_dispatch:
permissions:
  contents: write
  pull-requests: write
jobs:
  prune:
    runs-on: ubuntu-latest
    env:
      GH_TOKEN: ${{ github.token }}     # auth for the built-in `gh` CLI
    steps:
      - uses: actions/checkout@v4
      - name: Prune galleries older than 3 years and open a PR
        run: |
          cutoff=$(date -d "3 years ago" +%Y-%m-%d)
          find content/galleries -mindepth 1 -maxdepth 1 -type d | while read d; do
            date=$(grep -m1 '^date' "$d/_index.md" | sed -E 's/.*= *//' | tr -d '"')
            if [[ "$date" < "$cutoff" ]]; then
              slug=$(basename "$d")
              git rm -r "$d"
              git rm -rf "assets/galleries/$slug" 2>/dev/null || true
              git rm "data/galleries/$slug.toml" 2>/dev/null || true
            fi
          done

          # Nothing staged → nothing aged out. Exit quietly.
          git diff --cached --quiet && { echo "No galleries to prune."; exit 0; }

          branch="chore/prune-galleries-${{ github.run_id }}"
          git config user.name  "github-actions[bot]"
          git config user.email "41898282+github-actions[bot]@users.noreply.github.com"
          git switch -c "$branch"
          git commit -m "chore: prune galleries older than 3 years"
          git push -u origin "$branch"

          # GitHub's own CLI — preinstalled on the runner, no third-party Action.
          gh pr create \
            --base main \
            --head "$branch" \
            --title "Prune galleries older than 3 years" \
            --body "Automated prune. **Review the diff before merging.** Monthly cron — set a calendar reminder to review, so a forgotten cron does not silently prune everything."
```

The workflow opens a PR with GitHub's built-in `gh` CLI (no third-party
Action) rather than committing directly — a human must review and merge
each prune, and it does nothing on runs where no gallery has aged out.

**Safeguarding checklist** when publishing a gallery:

1. Every identifiable face has signed consent on file, OR every face
   is obscured.
2. `photo_consent = true` is set in the gallery's `_index.md`.
3. `consent_log` points to where the signed records are kept (OSM,
   a shared drive folder, etc.).
4. Image filenames are numeric (`001.jpg`) — never a young person's
   name.
5. Captions do not name young people.
6. Source JPGs have been EXIF-stripped (`exiftool -all=`) to remove
   GPS and device metadata before commit.
7. The `consent-policy.md` page on the site documents the Group's
   approach to handling photos.

### Camp Kit Lists

Reusable, versioned kit lists at `/kit-lists/`, grouped by section.
Each list (`content/kit-lists/<slug>.md`) is **structured front-matter**
— one or more `[[categories]]`, each with `[[categories.items]]` records
carrying `name`, `quantity` (default 1) and a free-text `alternative`.
Both views render from this one source:

- **On-screen** at `/kit-lists/<slug>/` — categorised rows, a `×N`
  quantity badge where quantity > 1, the alternative in muted text.
- **Printable checkbox sheet** at `/kit-lists/<slug>/print.html` — a
  self-contained document (no site chrome) with a checkbox per item, a
  "Name: ___" line and a version/reviewed footer, for "Print → Save as
  PDF".

The print view is a custom Hugo output format (`KitListPrint`) defined
in `exampleSite/hugo.toml` and enabled on every kit-list page via a
`[cascade]` in `content/kit-lists/_index.md` (`outputs = ["html",
"KitListPrint"]`). The print template
(`layouts/kit-lists/single.kitlistprint.html`) does not extend
`baseof.html`. **A consuming site must copy both the `KitListPrint`
output-format block and the cascade** — the same opt-in pattern as the
Welcome Pack's `WelcomePackPrint`.

Optional per-list extras: a **mobile-phone-policy** block (`phone_policy
= true`, or the `[params.kit_lists].show_phone_policy_default` site
default; copy comes from `[params.kit_lists].default_phone_policy_text`
or the theme's neutral i18n default), **BSO `cross_border_notes`**
(passport, GHIC/insurance, currency, adapters), and a **"please leave at
home"** list (`non_essential`). The starter pack ships nine lists —
Cubs/Scouts weekend and summer, an Explorers expedition, plus
desert-climate variants — as **content the Group edits**, not theme code.

**Event integration.** An event with `kit_list_ref =
"<slug>"` renders a "Kit list for this camp → …" link, and its free-text
`additional_kit` shows alongside as a per-event note. To embed the full
list inline in an event (or any page) body, use the shortcode:

```
{{< kit-list "cubs-weekend" >}}
```

When transcluded this way, the host page's `additional_kit` is appended
under the list.

```sh
hugo new kit-lists/cubs-weekend.md
```

> **Related tool — managing the Group's own kit.** The theme's kit lists
> are the parent-facing side: what to *pack* for a camp. For tracking the
> Group's *own* equipment and quartermaster stock — inventory, uniform
> allocation, kit bookings and repair tracking — a good free option is
> **[Wogglebox](https://wogglebox.app)**. It's web-based, designed to work
> alongside Online Scout Manager (OSM) rather than replace it, and imports
> from CSV, Excel or OSM exports; its free tier suits most small-to-medium
> Groups. (An independent recommendation — not affiliated with this theme.)
>
> If your Group uses Wogglebox, display a **"We use Wogglebox" badge** near
> the home-page footer and on the kit-lists page by setting
> `[params.wogglebox] enabled = true`. The badge image is **self-hosted**
> (`assets/images/wogglebox/`) so no third-party request fires on page load;
> the badge's `utm_*` link only fires on click. Override the click-through
> with `[params.wogglebox] url = "..."`.

### Joining & Waiting List

A structured `/join/` page generated from a single Markdown file
(`content/join/_index.md`) plus a data file
(`data/sections_status.toml`) — one card per pack, showing current
status (Open / Waiting list / Not running), age range, meeting night,
fee, and a CTA into either OSM or `mailto:`. Multi-pack support is
built in: a section with two Packs renders two cards.

```toml
[params.features]
  joining      = true
  welcome_pack = true

[params.joining]
  show_currency       = true
  card_layout         = "grid"          # "grid" | "stacked"
  show_volunteer_link = true            # bridge to the volunteer roles

[params.welcome_pack]
  print_route = true                    # generate /welcome-pack/print.html
```

Each pack's status uses one of three new palette-token-driven badges:

- `--status-open` — confident green, "ready to enrol"
- `--status-waiting` — deeper amber than `--postponed` so an event
  card and a joining card never read as the same state at a glance
- `--status-closed` — neutral grey ("section not running this term"
  is informational, not a warning)

Token values are uniform across every palette preset — status
semantics shouldn't shift with the site's house colours.

**Multi-pack data pattern.** Each section key in
`data/sections_status.toml` is an *array* of pack records. Single-pack
groups have one entry per section; multi-pack groups add more. The
`pack_name` field renders only when populated, so single-pack entries
can leave it empty.

```toml
[[cubs]]
  pack_name     = "Wednesday Pack"
  status        = "open"
  meeting_night = "Wednesday"
  …

[[cubs]]
  pack_name     = "Friday Pack"
  status        = "waiting"
  meeting_night = "Friday"
  …
```

**Fees and currencies.** Fee values are plain numbers; the symbol is
looked up from `data/currencies.toml` by ISO 4217 code. The theme
ships GBP plus the BSO-common host-country currencies (EUR, USD, AED,
CHF, SGD, HKD); Groups in other host countries add their own currency
to a site-side `data/currencies.toml` and Hugo merges the lists.

**FAQ accordion.** Add Markdown files under `content/join/faq/*.md`
— each `title` is the question, the body is the answer. They render
inline on `/join/` as a `<details>`/`<summary>` accordion (pure CSS,
forced open by the print stylesheet). FAQ files are kept out of the
route tree by `_build.render = "never"` in their front-matter.

**No forms on the static site.** Acceptance criterion: every CTA is
either a `mailto:` or an external OSM URL — never a form that POSTs
from the site. Build emits a warning if a `status = "waiting"` pack
has no `waiting_url` AND no `contact_email` AND the page has no
fallback (`osm_waiting_list_url`, `enquiry_email`).

**BSO branch.** When `[params.bso].enabled = true`, the
`bso-membership-notice` partial renders above the cards plus a
per-page eligibility summary; each pack card with `bso_language` or
`bso_nationality_note` populated renders those fields as a small
in-card note. The example site ships BSO fields populated but a Group
can default `enabled = false`; flip the switch to exercise the BSO
render path end-to-end.

### Welcome Pack

A Hugo content section at `/welcome-pack/` with a cover page, a set
of editable Markdown chapters (`about`, `sections`, `joining`,
`safeguarding`, `calendar` in the starter pack), per-chapter
navigation, and a concatenated print view at `/welcome-pack/print.html`
that renders every chapter into a single self-contained HTML
document for "Print → Save as PDF".

The print view is a custom Hugo output format (`WelcomePackPrint`)
defined in `exampleSite/hugo.toml` and enabled per-section via the
`outputs` array in `content/welcome-pack/_index.md`. The print
template (`layouts/welcome-pack/list.welcomepackprint.html`) does not
extend `baseof.html` — it emits its own `<html>` document with no
site chrome.

The five starter chapters are **content** the Group edits, not theme
code. The theme owns the cover page, the chapter nav, the per-chapter
single template and the print view; the words in each chapter belong
to the consuming site.

```sh
hugo new welcome-pack/about.md
```

### Group History & Governance

Two independently-gated pages under `/about/`:

- **`/about/history/`** (`params.features.history`) — a long-form
  Markdown history with an optional CSS-only timeline driven by
  `data/history_timeline.toml`. `timeline_position` places it as a
  `sidebar` (two columns on wide screens), `top`, or `bottom`. A cover
  image triggers the photo-consent lint.
- **`/about/governance/`** (`params.features.governance`) — charity
  registration, AGM details, the Trustee Board (`data/trustees.toml` —
  names only, no contact details), and a link to the reports archive.

**Reports archive** at `/about/reports/` lists Trustees' Annual Reports
and AGM minutes from a `data/reports.toml` manifest, with the PDFs in
`static/about/reports/`. The build **warns** about any PDF in that
folder not listed in the manifest, so the two can't drift apart.

**Charity-info footer.** When `params.features.governance` is on, a
charity number is configured, and `[params.governance].show_in_footer`
is true, a small charity-registration line renders in every
non-printing footer (hidden in print). A charity number never appears
without a governance page, but a governance page can run with no
charity listed at all. Most BSO Groups operate under British Scouting
Overseas' England & Wales registration (charity **1151702**) rather
than registering separately, and simply set `charity_number =
"1151702"`. A Group that is *also* a host-country legal entity (e.g.
1st Brussels is a Belgian ASBL) can add the `charity_secondary_*`
block for the second jurisdiction.

The theme ships `data/trustees.toml` and `data/reports.toml` **empty**
(comment-rich) — no placeholder names, no placeholder documents.

```sh
hugo new about/history.md
hugo new about/governance.md
```

**Trustee Board meeting summaries.** With `params.features.trustee_minutes`
on (alongside `governance`), an archive at `/about/minutes/` publishes short,
**public, redacted summaries** of board decisions — never the full minutes,
which stay private (the no-backend, no-login design means anything rendered
is fully public). Each summary is a Markdown file in `content/about/minutes/`
that renders only when marked `approved = true`, so nothing publishes by
accident. A universal, all-levels (Group / District / County · Area · Region)
authoring template ships at
`documentation/templates/trustee-minutes-template.md` for boards to write
their full minutes privately. The governance page cross-links the archive.

```sh
hugo new about/minutes/2026-03-board.md
```

### Fundraising & Volunteering

Gated by `params.features.fundraising`. Two linked areas under
`/support-us/`:

- **`/support-us/`** — a fundraising page: an intro, URL-only links to
  external giving platforms (no logos — copyright), recurring
  fundraising activities, an optional Gift Aid PDF link, and an
  optional high-level `annual_budget` block (currency from
  `data/currencies.toml`, with a cross-link to the reports
  archive).
- **`/support-us/volunteer-roles/`** — open vacancies as cards, each
  linking to a per-role page (`/support-us/volunteer-roles/<slug>/`). A
  role is **open** when `role_open` isn't false and its `closes` date
  hasn't passed; closed/retired roles drop off the listing and their
  page shows a "no longer open" notice. `remote = true` adds a
  **"Remote OK"** badge — relevant for BSO Groups recruiting UK-based
  remote volunteers (per-role, not site-wide). DBS is stated, never
  collected (the archetype documents the residency-since-age-10 nuance).

A new **`volunteer-recruitment-banner`** home section renders **only
when at least one role is open** (and `features.fundraising` is on),
linking to the roles page; when nothing's open it outputs nothing and
the page flows past. Both the banner and the nav link read the same
`partials/volunteer-roles-open.html`, so they can't disagree.

The **conditional "We're recruiting" nav link** appears automatically
whenever a role is open; the homepage banner is the other entry point.
Both read the same source, so they can't disagree.

```sh
hugo new support-us/_index.md
hugo new support-us/volunteer-roles/treasurer.md
```

### Hall Hire

Gated by `params.features.hall_hire`. A single informational page at
`/hall-hire/` advertising the Scout Hut for community hire — intro,
address (+ link-only map), capacity/dimensions, facility chips, a rate
table (multiple tiers, currency from `data/currencies.toml`), optional
deposit + cleaning fee, an availability note, a "Scout activities take
priority" disclaimer, a T&Cs PDF link, and an **email-only** enquiry
CTA. No booking system, calendar, or payment — by design.

Photos render in a CSS-only horizontal strip (`assets/hall-hire/photos/`,
resized to WebP at build). **Use empty-hall or adult-only photos — no
identifiable young people** (safeguarding). Set
`params.hall_hire.fully_booked = true` to show a `--warning` banner that
signals new enquiries are paused; the page still renders in full.

```sh
hugo new hall-hire/_index.md
```

### BSO Joining Hub

A BSO-only content section at `/bso/` covering joining eligibility,
moving-in/moving-out pathways, and the WOSM-recognised scouting
bodies of the host country. Builds on the existing
`bso-membership-notice` partial and the joining cards (which
cross-link to `/bso/eligibility/` for the per-pack `bso_nationality_note`).

```toml
[params.features]
  bso_hub = true                        # opt-in even when bso.enabled = true

[params.bso]
  enabled                = true         # site-level master switch
  host_country_iso       = "ae"         # ISO 3166-1 alpha-2 (lowercase)
  host_country_name      = "the United Arab Emirates"
  host_association       = "Emirates Scout Association"
  show_home_range        = false
  show_host_alternatives = true
  district               = "Middle East and Asia"
  district_url           = "https://www.britishscoutingoverseas.org.uk/"
  bso_area_url           = "https://www.britishscoutingoverseas.org.uk/"
```

**End-to-end gating.** With `bso.enabled = false` *or* `bso_hub = false`,
none of the `/bso/` pages render: the hub list page is empty, and
the joining cards' `/bso/eligibility/` link target becomes
a 404. Groups that aren't BSO leave the master switch off and never
encounter the feature.

**Host-country alternatives data.** `data/bso/alternatives/<iso>.toml`
holds the WOSM-recognised scouting bodies of each host country.
The theme ships starter data for **NL, BE, FR, DE, ES, AE, SG, US**
— the eight host countries with the largest BSO presence. Groups
in other countries add their own file under the same path; Hugo
merges site-side data files with theme-side ones.

**Default-visible POR reference.** Each eligibility page's
`por_reference_visible` field defaults `true`. The rationale (Q10.6):
this isn't for people who are already part of BSO — it's a firm
policy nod for those who are actively trying to bypass POR 3.2.1.1
as a host-country national. Per-Group toggle to hide.

**BSO links footer.** Every `/bso/*` page wears a small in-content
footer linking to BSO Area and the Group's BSO District (above the
standard site footer). Rendered by `bso-links-footer.html`,
configurable via `[params.bso].district` / `district_url` /
`bso_area_url`. Hides cleanly when none of those are set.

**Home-range (optional).** When `[params.bso].show_home_range = true`,
`/bso/home-range/` renders a static map image (Group ships their
own under `assets/bso/home-range.png`) plus an InTouch policy
summary. Default `false` — most BSO Groups don't need a formal
home-range publication.

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

### Volunteer recruitment section

A dedicated home-page band promoting adult volunteer recruitment.
Renders on a Scouts-Purple **brand-anchor** background that does
not change when the site palette changes — volunteer recruitment is
a national Scouts UK campaign with consistent purple branding. The
eyebrow and CTA are Scouts Yellow, mirroring the canonical brand-
poster pairing.

```toml
[params.features]
  volunteer_feature = true
```

```toml
[[sections]]
  type    = "volunteer-feature"
  id      = "volunteer"
  variant = "role-model"   # or "stat-yellow"
```

Two poster variants ship: `role-model` (purple poster, centred
white fleur, "You look like a role model." headline — the canonical
Scouts brand-poster styling) and `stat-yellow` (yellow poster, the
campaign's 27% / 49% volunteering statistic). Override the eyebrow,
heading, body paragraphs, network note, CTA and per-variant poster
copy via front-matter or via `i18n/en.toml`. See
[Customising](#customising) below.

The section uses CSS container queries for poster typography
scaling (Baseline 2024) and emits only the chosen variant's markup
at render time. No JavaScript.

### BSO membership notice

Renders the eligibility statement aligned with POR 3.2.1.1 for
overseas Groups. The notice is a dedicated partial, configured via
`[params.bsoMembershipNotice]` and rendered by including a
`bso-membership` section in `content/_index.md`.

The wording is canonical and should not be reworded without
consulting POR.

### Navigation

The site nav is **auto-built from your feature flags** — there is no
`[[menu.main]]` to maintain. Turn a feature on and its entry appears;
turn it off and it's gone. Five top-level groups render in a fixed,
theme-owned order: **Join Us · Our Sections · What we do · Get Involved
· About**. The theme handles:

- **Smart collapse** — a group with one enabled child becomes a direct
  top-level link (no dropdown); a group with no enabled children
  disappears entirely.
- **Always-on entries** — Join Us, Our Sections, and Where we meet are
  always present (falling back to the `#join`, `#sections`,
  `#where-we-meet` home anchors).
- **Active state** — `aria-current="page"` on the current link,
  `aria-current="true"` on its ancestor top-level entry.
- **Desktop** dropdowns open on hover (pointer devices) and keyboard
  `:focus-within`; **mobile** collapses to a checkbox-hack drawer where
  each group is a `<details>` **accordion**. Pure CSS, no JavaScript.
- The **"We're recruiting"** flag appears on the Volunteer-roles entry
  when a role is open.

Customise labels via the `nav*` i18n keys; hide a specific entry without
disabling its feature via `[params.nav].show_*` (all default `true`).
Order and hierarchy are owned by the theme and not Group-configurable.

```toml
# No menu config needed. Optionally:
[params.nav]
  show_what_we_do = false   # hide a group from the auto-nav
```

### Accessibility

Every page the theme renders targets **WCAG 2.2 AA** out of the box —
there is no flag and nothing to switch on. Publishing this theme should
not require additional accessibility work.

- **Skip link** — a "Skip to main content" link is the first focusable
  element on every page (hidden until focused), jumping to the
  `<main id="main">` landmark. Relabel via the `a11ySkipToContent`
  i18n key.
- **Landmarks** — `<header>`, `<nav aria-label>`, `<main>` and
  `<footer>` on every page.
- **Visible focus** — a consistent 2px focus ring on every interactive
  element via `:focus-visible`, coloured by the new `--focus-ring`
  palette token (per palette in `data/palettes.toml`, falling back to
  `--primary`). Every focusable control shows a visible indicator —
  including the keyboard-operable mobile-nav drawer.
- **Reduced motion** — all animation, transition and smooth scrolling
  is neutralised under `prefers-reduced-motion: reduce`.
- **Build-time lints** — the build fails if any editorial image is set
  without non-empty `alt` text (`partials/audit-image.html`), or if a
  page's body Markdown introduces a second `<h1>` (start body headings
  at `## `; the page title is the only `<h1>`).
- **CI checks** — `.github/workflows/a11y.yml` runs a palette
  colour-contrast audit (`tools/audit-contrast.mjs`) and an
  `@axe-core/cli` WCAG scan of the rendered example site. A site
  consuming the theme can copy the same two steps into its own deploy
  workflow.

If you add a new image-bearing content type, call `audit-image.html`
for it; if you add a section partial, start its headings at `<h2>`.
See the accessibility notes in `documentation/`.

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
01-reset.css                   Resets, typography
02-layout.css                  Container, grid, link-decoration sentinels
03-components-buttons.css      .btn, .btn-primary, .btn-ghost, .btn-dark
04-nav.css                     Sticky nav, dropdowns, mobile drawer
05-components-sect-head.css    .sect-head + .eyebrow shared component
06-components-article.css      Prose/article typography
07-a11y.css                    Skip link, focus ring, sr-only, reduced motion
…
10-section-hero.css            Section modules — one per section type
11-section-two-col-cta.css
…
22-section-network-feature.css Network 18–25 brand-anchor band
23-section-volunteer-feature.css Volunteer brand-anchor band
24-section-bso-membership.css  BSO membership notice
30-footer.css                  Footer
31-back-to-top.css
32-page-load-fade.css          (reveal fade-in; honours reduced motion)
33-wogglebox-badge.css         (opt-in "We use Wogglebox" partner badge)
40-section-news.css            News & camp reports
41-feature-hero-intro.css      (opt-in, gated by body class)
50-section-programme.css       Termly programme
51-section-joining.css         Joining & waiting list
52-section-welcome-pack.css    Welcome pack
53-section-bso-hub.css         BSO joining hub
54-section-galleries.css       Photo galleries
55-section-kit-lists.css       Camp kit lists
56-section-about.css           History, governance & minutes
57-section-support-us.css      Fundraising & volunteering
58-section-hall-hire.css       Hall hire
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
  third party is Google Fonts (Manrope + Nunito Sans), loaded statically.
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
├── .github/
│   └── workflows/a11y.yml         # contrast + axe-core WCAG CI
├── tools/
│   └── audit-contrast.mjs         # palette contrast audit, run in CI
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
└── documentation/                # design & contributor notes
    ├── DECISIONS.md               # locked architectural choices
    ├── README.md                  # reading order for the design docs
    └── …                          # per-feature design notes + conventions
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
- Renaming the three always-on nav anchors (`#join`,
  `#sections`, `#where-we-meet`).
- The BSO membership notice copy (aligned with POR 3.2.1.1).
- Bumping `theme.toml` `min_version`.
- Adding content from copyrighted Scout brand assets (the official
  section logos live in the theme; other brand assets must come from
  scoutsbrand.org.uk on a per-Group basis).

For everything else: clear commit messages, en-GB in user-facing
strings, no new JS, and please update the relevant design doc under
`documentation/` if the change extends a feature's contract.

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

The "Manrope" and "Nunito Sans" typefaces are loaded at runtime from
Google Fonts under the SIL Open Font License 1.1.

The author asks (but does not require) that downstream users keep
the `LICENSE` file intact in any forks of the theme repository.
