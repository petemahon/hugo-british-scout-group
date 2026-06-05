# CLAUDE.md

Context for Claude Code working on the **Hugo British Scout Group**
theme. Loaded automatically at the start of every session.

If anything in this file conflicts with `documentation/DECISIONS.md`
or `documentation/SPEC-COMMON.md`, those files win — they are the
authoritative source of truth. This file points at them.

---

## What this project is

A reusable Hugo theme for UK Scout Groups, with first-class support
for **British Scouting Overseas (BSO)** Groups via a dedicated
membership-notice partial. Used in production by `1stadscouts.org`
(consumed via `hugo-adscouts`, a separate repo) and intended for
adoption by other UK Scout Groups — particularly BSO Groups.

- **Licence:** CC BY-SA 4.0 © Peter Mahon. Keep `LICENSE` intact in
  any refactor.
- **Theme name on disk:** `british-scout-group`. Deliberately
  general-purpose — BSO is a first-class feature, not the only use
  case.
- **Repo:** https://github.com/petemahon/hugo-british-scout-group
- **Consuming site (separate repo):**
  https://github.com/petemahon/hugo-adscouts
- **Old Mobirise predecessor (reference only, do not maintain):**
  https://github.com/petemahon/adscouts

---

## Architecture (locked invariants — flag, don't change)

- Hugo extended, **min version 0.156**. The Pages workflow pins
  `0.157.0`.
- `<html lang="en-GB">` is **hardcoded** in `baseof.html`. No locale
  parameter. Adding locale support is a flag-not-change event.
- **No JavaScript dependency anywhere.** Sticky nav, smooth scroll,
  fade-in animations, the events `events-upcoming` block, the
  cancelled-event badge, the dual-time rendering — all pure CSS.
  Adding JS is a flag-not-change event. A native-share feature was
  proposed and explicitly declined for this reason.
- **No backend services, no third-party tracking scripts** (no
  analytics, social embeds, comment systems, payment widgets,
  livechat, tracking font CDNs).
- **Official Scout section logo SVGs** ship in the theme at
  `assets/images/sections/<key>.svg`, downloaded from
  https://scoutsbrand.org.uk by the theme maintainer. Groups do
  NOT override these — brand asset maintenance is centralised.
  **Other visual assets** shipped at theme paths are generic
  placeholders; Groups override at the same path in their site repo.
- **Group-specific values live only in the consuming site's
  `hugo.toml` and `content/`.** Nothing in the theme code may
  reference Abu Dhabi, the BSO Group's name, or any Group's
  specifics. The only Group-specific string anywhere in the theme is
  Peter's name in `LICENSE`.

---

## The spec pack — primary reference

The full feature roadmap and conventions live under `documentation/`.
Read these before changing anything substantial:

| File | When to read |
| --- | --- |
| `documentation/DECISIONS.md` | **Always.** Locked-in choices. Read before suggesting anything that touches palettes, the section types list, BSO, navigation, accessibility, demo data, or the en-GB scope rule. |
| `documentation/SPEC-COMMON.md` | **Always.** Shared conventions every feature spec assumes. Section partial idiom, palette tokens, taxonomies, image pipeline defaults, safeguarding lint pattern, i18n naming, build validation order. |
| `documentation/specs/SPEC-NN-*.md` | When implementing that specific feature. |
| `documentation/D13-SPEC.md` | Reference for the D5–D13 visual redesign sweep — closing deliverable, footer + where-we-meet contract, breaking changes. |

Suggested recommended implementation order is in
`documentation/README.md` (the feature-pack README, distinct from the
top-level `README.md`).

---

## Working preferences (Peter)

These take priority over Claude Code's general defaults:

- **Always confirm design decisions before implementing.** Don't
  assume. Present resolved questions together as a bulk slate rather
  than piecemeal — Peter's working style is decisive bulk
  confirmation.
- **English only, en-GB** for visitor-facing text and documentation
  prose (`colour`, `programme`, `organisation`, `behaviour`,
  `licence`, `centre`, `enrolled`). **Code identifiers — TOML field
  keys, CSS class names, template variables — follow source-code
  conventions and may use US spelling where idiomatic** (`color`,
  `text_color`, `bg`, `bg_muted`). See DECISIONS.md §"en-GB scope".
- **Validate builds incrementally.** Don't write a sprawl of
  templates and try to build at the end. The SPEC-COMMON §13 build
  order — data files first, then partial with hardcoded content,
  then dispatcher wiring, then front-matter schema, then CSS, then
  i18n, then example content — is the canonical sequence.
- **No bash in this session.** Claude Code edits files in the
  working tree only; Peter runs `make serve`, `make build`,
  `git diff`, `git commit`, `git push`, and any `gh` commands
  himself. The settings in `.claude/settings.json` enforce this.
- **Handoff format note:** prior chat sessions used `.patch` files
  and tarballs because the chat couldn't touch the working tree.
  That pattern is obsolete under Claude Code — edits land directly
  in files. The SPEC-02 handoff doc that pattern produced has since
  been retired (SPEC-02 is fully shipped). Future handoff documents,
  if needed, should describe state and decisions, not delivery format
  — `D13-SPEC.md` is the current reference shape for that kind of
  closing-deliverable record.

---

## Things to flag, not silently change

Per Peter's working method, these need explicit confirmation before
any change is made:

- Locale handling (the theme is en-GB-only by design).
- Adding JavaScript anywhere in the theme.
- Adding a sixth named palette preset (vs. editing existing hex
  values to track Scouts brand updates — editing is the expected
  maintenance path).
- Anything that would make the theme depend on a specific Group's
  content or images.
- Anything that would make the theme BSO-specific in code (BSO
  features remain optional add-ons, not assumptions).
- Adding content from copyrighted Scout brand assets rather than
  Group materials or scoutsbrand.org.uk downloads.
- Renaming or removing any of the canonical section types listed in
  DECISIONS.md.
- Renaming the three always-on nav anchors (`#join`,
  `#sections`, `#where-we-meet`) — these are part of the
  theme's stable contract. (Reconciled 2026-06-03 from the
  originally-drafted `#joining`/`#our-sections` to the shipped
  home-section IDs.)
- The BSO membership notice copy (aligned with The Scout
  Association's POR 3.2.1.1 — don't reword without flagging).
- Bumping `theme.toml` `min_version`.

---

## Repo layout (orientation)

```
hugo-british-scout-group/
├── CLAUDE.md                      # this file
├── .claude/
│   └── settings.json              # Claude Code permissions
├── theme.toml                     # theme metadata
├── LICENSE                        # CC BY-SA 4.0 © Peter Mahon
├── README.md                      # public-facing theme README
├── Makefile                       # make serve | build | roll | clean
├── archetypes/                    # `hugo new` scaffolds
├── assets/
│   ├── css/theme.css              # all design tokens at the top
│   └── images/                    # generic placeholders only
├── data/
│   ├── palettes.toml              # five palette presets
│   └── scout_sections.toml        # age/section metadata + badge colours
├── i18n/
│   └── en.toml                    # translatable strings
├── layouts/
│   ├── _default/                  # baseof, single, list
│   ├── index.html                 # home — dispatches to section partials
│   ├── events/                    # SPEC-02 — listing, single, .ics
│   ├── news/                      # SPEC-01 — listing, single
│   └── partials/
│       ├── head.html              # meta + CSS pipeline + palette injection
│       ├── header.html            # sticky nav
│       ├── footer.html            # Group's own copyright
│       ├── palette-style.html     # emits chosen palette as CSS vars
│       ├── bso-membership-notice.html
│       ├── event-*.{html,ics}     # SPEC-02 partials
│       ├── news-*.html            # SPEC-01 partials
│       ├── section-badges.html    # shared across content types
│       └── sections/              # one partial per [[sections]] type
├── scripts/
│   └── roll-example-dates.py      # demo-roller for exampleSite events
├── exampleSite/                   # demo site + test fixture
│   ├── hugo.toml
│   ├── assets/                    # placeholder images
│   └── content/
│       ├── _index.md              # home page [[sections]] array
│       ├── news/                  # example news posts
│       ├── events/                # example events (with [demo] blocks)
│       └── palettes/_index.md     # palette reference page
└── documentation/
    ├── DECISIONS.md
    ├── SPEC-COMMON.md
    ├── README.md                  # feature-pack reading order
    ├── D13-SPEC.md                # D5-D13 redesign sweep closing record
    └── specs/
        └── SPEC-01-news.md … SPEC-12-accessibility.md
```

---

## Dev loop (Peter runs these, not Claude Code)

From the repo root:

```sh
make serve   # roll example dates forward, then `hugo serve`
make build   # roll example dates forward, then `hugo --minify`
make roll    # just run the date-roller
make clean   # discard the date-roller's in-flight edits
```

`make clean` runs `git checkout -- exampleSite/content/events/`,
reverting the demo-roller's working-tree changes. Run it before any
commit that should not include rolled dates.

If running from inside `exampleSite/` (e.g. after editing in place):

```sh
make -C .. clean && hugo serve --buildDrafts=false --buildFuture=false
```

Both `--buildDrafts=false` and `--buildFuture=false` match the deploy
policy. The events feature relies on `publishDate` (always past after
the roller has run), not `date`, to clear `--buildFuture=false`.

---

## Current state snapshot (June 2026)

- **D5–D13 visual redesign sweep:** shipped. Closing deliverable
  documented in `documentation/D13-SPEC.md`.
- **SPEC-01 News:** shipped.
- **SPEC-02 Events:** shipped (past archive gated by
  `params.events.show_past_archive`).
- **SPEC-03 Termly Programme:** shipped. `data/programme_themes.toml`
  ships an illustrative Skills-for-Life chip list with a TODO header
  to reconcile against `scouts.org.uk/programme-planner/` before
  going live. Q3.1 was revised 2026-05-21 to wire the
  `programme-current` home block into the example site.
- **SPEC-04 Galleries:** shipped. `/galleries/` listing + per-gallery
  grid + per-photo full-size pages with prev/next and per-photo Open
  Graph. Per-photo pages are generated by a **content adapter** at
  `content/galleries/_content.gotmpl` (theme-shipped, inherited by
  consuming sites) that scans `assets/galleries/<slug>/` — no per-photo
  `.md` bookkeeping. Build-time consent lints (`photo_consent`,
  `consent_log`) errorf; optional caption sidecars at
  `data/galleries/<slug>.toml`; `video_links` render as out-links (no
  embedded players). Surfaced on the home page via the `gallery-strip`
  section. Two adapter bugs were fixed on 2026-06-01: `.AddPage` `path`
  is **section-relative** (was double-prefixed `galleries/`, detaching
  photo pages from their section), and `layout` must be a **top-level**
  AddPage key (was buried in `params`, so photo pages fell back to the
  grid template). See [[hugo-content-adapter-addpage-gotchas]].
- **SPEC-05 Kit Lists:** shipped. `/kit-lists/` index grouped by
  section + per-list on-screen view + a per-list printable checkbox
  sheet at `/kit-lists/<slug>/print.html` via a `KitListPrint` custom
  output format (declared in `exampleSite/hugo.toml`, enabled by a
  `[cascade]` in `content/kit-lists/_index.md` — consuming sites must
  copy both, like `WelcomePackPrint`). Lists are structured
  front-matter (`[[categories]]` / `[[categories.items]]` with
  `name`/`quantity`/`alternative`), rendered by the `mode`-driven
  `kit-list-categories` + `kit-list-item` partials shared by both
  views. Opt-in mobile-phone-policy block (neutral i18n default copy,
  no external attribution), BSO `cross_border_notes`, and
  `non_essential`. Starter pack ships nine lists incl. desert-climate
  variants. **Event integration (touched shipped SPEC-02):**
  `kit_list_ref` + `additional_kit` added to `archetypes/events.md`
  and `layouts/events/single.html` (the "Kit list for this camp →"
  strip); a `kit-list` shortcode transcludes a list inline and appends
  the host page's `additional_kit`. Surfaced from
  the events listing page and the Welcome Pack joining chapter; the
  main-nav entry is deferred to SPEC-11 (under "What we do").
- **SPEC-06 Joining & Welcome Pack:** shipped. `/join/` cards + FAQ
  + BSO branch; `/welcome-pack/` content section with 5 starter
  chapters and a `WelcomePackPrint` custom output format generating
  `/welcome-pack/print.html`. Introduced `--status-{open,waiting,closed}`
  palette tokens and a `.btn-waiting` button class (amber, matches
  the waiting-list badge). `bso-membership-notice` is rendered
  exactly once site-wide — on `/join/` — per the 2026-05-21
  consolidation decision.
- **SPEC-07 History & Governance:** shipped. `/about/history/`
  (long-form Markdown + CSS-only timeline from
  `data/history_timeline.toml`, `timeline_position` sidebar/top/bottom)
  and `/about/governance/` (charity registration, AGM, Trustee Board
  from `data/trustees.toml`, link to the reports archive). Reports
  archive at `/about/reports/` lists `data/reports.toml` (PDFs in
  `static/about/reports/`) with a build **warning** for any PDF not in
  the manifest. **Charity-info footer** (`charity-info.html`) renders in
  every non-printing footer (hidden in print) only when
  `features.governance` AND `[params.governance].show_in_footer` AND a
  charity number are set — **revised Q7.1:** a charity number never
  surfaces without a governance page, though a governance page may run
  with none. `charity_secondary_*` supports a dual jurisdiction (e.g.
  a Belgian ASBL). Theme ships `data/trustees.toml` + `data/reports.toml`
  **empty**; the example's data lives in **`exampleSite/data/`** (the
  first project-level data dir — note Hugo's watcher needs a server
  restart to pick up a newly-created data dir). All theme data reads use
  `hugo.Data` (NOT `site.Data`, deprecated in 0.156). See
  [[hugo-data-accessor-and-project-data]].
- **SPEC-10 BSO Joining Hub:** shipped. `/bso/` hub plus five
  sub-pages (eligibility, moving-in, moving-out, host-scouting,
  optional home-range). Master switch is **`[params.bso].enabled`**,
  not a scalar `bso = true` (the two collide in TOML). Theme ships
  per-ISO host-country alternatives data for NL, BE, FR, DE, ES, AE,
  SG, US. `data/sections_status.toml` ships as a host-country-generic
  STARTER (uses "the host country" phrasing); the concrete UAE
  configuration lives in `exampleSite/hugo.toml` only.
- **SPEC-09 Fundraising & Volunteering:** shipped. `/support-us/`
  fundraising page (URL-only external giving links, activities, inline
  `annual_budget` block using `data/currencies.toml`, optional Gift Aid
  PDF) + `/support-us/volunteer-roles/` (per-role pages, `remote`
  "Remote OK" badge, `closes`-date + soft-disable filtering). The
  soft-disable flag is **`role_open`** (NOT `published` — Hugo reserves
  `published` as a date field). `partials/volunteer-roles-open.html` is
  the single source of truth for "open"; the conditional
  `volunteer-recruitment-banner` home section and (later) the nav link
  both read it. The Join card + volunteer-feature CTAs now point at
  `/support-us/volunteer-roles/`. **AC4's "We're recruiting" nav link
  is deferred to SPEC-11** (which rebuilds the nav and now documents
  ownership); `[params.volunteer_roles]` ships now for config
  stability. See [[hugo-front-matter-reserved-fields-and-context]].
- **SPEC-08 Hall Hire:** shipped. Single informational page at
  `/hall-hire/` — intro, address (+ link-only `map_url`),
  capacity/dimensions, facility chips, multi-tier rate table (currency
  from `data/currencies.toml`), deposit + cleaning fee, availability
  note, "Scout activities take priority" disclaimer, T&Cs PDF link, and
  an **email-only** enquiry CTA (no booking/calendar/payment). Photos
  (`assets/hall-hire/photos/`, empty-hall/adult-only only) render in a
  CSS-only strip, resized to WebP. `params.hall_hire.fully_booked = true`
  shows a `--warning` banner; page still renders.
- **SPEC-11 Navigation:** shipped. Auto-built hierarchical nav from
  `params.features.*` (no `[[menu.main]]` — removed from the example).
  Five locked top-level groups (Join Us · Our Sections · What we do ·
  Get Involved · About) with smart-collapse (1 child → direct link) and
  empty-group removal. Built by `partials/header-nav-tree.html` (returns
  the tree) + `header-nav.html` (desktop dropdowns, hover/`:focus-within`)
  + `header-nav-mobile.html` (`<details>` accordion drawer) +
  `header-nav-collapse.html` (smart-collapse helper); `header.html`
  builds the tree once and feeds both renderers. Pure CSS. Owns the
  conditional "We're recruiting" flag (reads `volunteer-roles-open.html`).
  Per-entry hide via `[params.nav].show_*`. Content pages get fixed-nav
  clearance via a `body.is-home` class + `--nav-clear` (the home hero
  stays full-bleed). Always-on anchors: `#join`, `#sections`,
  `#where-we-meet`. See [[hugo-partial-return-and-details-accordion]].
- **SPEC-12 Accessibility:** shipped. The final cross-cutting WCAG 2.2
  AA hardening pass. Skip link (`.skip-link`, first `<body>` child,
  targets `<main id="main">`) + `a11ySkipToContent` i18n. New
  `--focus-ring` palette token (per palette in `data/palettes.toml`,
  emitted by `palette-style.html`, fallback `--primary`); `vibrant`
  overrides to Scouts Purple `#7413dc` since Scouts Red on white is
  only ~3.9:1. New `07-a11y.css` banner: global `:focus-visible` ring
  (**no `outline:none` anywhere**), `.skip-link`, `.sr-only`, and a
  global `prefers-reduced-motion` kill-switch. Two build-time lints:
  `partials/audit-headings.html` (errorf if a page's `.Content` body
  renders an `<h1>` — the page title is the only permitted `<h1>`) and
  `partials/audit-image.html` (shared single-source alt lint; news /
  galleries / history / hall-hire call it — the old inline news lint
  was refactored to it). Heading contract documented in
  **SPEC-COMMON §17**. Contrast audited in CI by dependency-free
  `tools/audit-contrast.mjs` (declared pairs only; `text_on_<accent>`
  tokens judged at the 3.0:1 large-text bar since they only label bold
  chrome). Theme-repo `.github/workflows/a11y.yml` runs the contrast
  audit (push + PR) and `@axe-core/cli` (PR only) over one page per
  template family — it creates the `exampleSite/themes/british-scout-group`
  symlink, rolls demo dates, then builds with Hugo 0.157.0. Heading
  audit was **downgraded** from the spec's brittle per-partial
  `audit-claim` running-list to this reliable body-scan subset
  (decided 2026-06-04, all four SPEC-12 Q-slate recommendations
  accepted). A follow-up **full audit (2026-06-04)** then: (a) fixed the
  **mobile-nav keyboard gap** — the SPEC-11 burger checkbox was
  `tabindex="-1" aria-hidden` (drawer pointer-only); it's now a
  visually-hidden but **focusable** named control, burger is an
  `aria-hidden` proxy, closed drawer uses `visibility:hidden`, checkbox
  is `display:none` ≥960px, and the focus ring is **relocated** to the
  burger (the theme's one deliberate `outline:none` — focus moved, not
  removed); (b) added the alt lint to **welcome-pack** `intro_image`,
  **bso-home-range** `static_map_image`, and the **two-col-image-cta** /
  **stacked-features** CTA partials (so the alt audit is truly uniform);
  (c) added `tabindex="-1"` to `<main>` so the skip link moves focus, not
  just scroll; (d) corrected the §17 contract — the home-only **hero is
  the one section partial that emits `<h1>`** (the home page's title);
  (e) added `bg_muted` pairs to the contrast script. **All roadmap specs
  (01–12) now shipped.**

---

## Quick conventions cheat-sheet

These are the things you'll bump into constantly:

- **Feature flag:** every feature is opt-in via
  `params.features.<name> = true` in `hugo.toml`. Default OFF. The
  `exampleSite/hugo.toml` sets every flag to `true`.
- **Section partial idiom:** see SPEC-COMMON §3. Comment-block
  header, `id` / `title` / `bg` / `title_color` params, render
  inside `<section class="section s-<name> ...">`.
- **Image pipeline:** see SPEC-COMMON §5. WebP at 640/1280/1920,
  `loading="lazy"`, missing-asset `errorf` not silent.
- **Palette tokens:** see SPEC-COMMON §6. Never hardcode hex.
- **Section-badge colours:** `data/scout_sections.toml`, fields
  `color` and `text_color` (US-spelled keys). Six sections:
  Squirrels `#25B755`, Beavers `#003982`, Cubs `#F7EF27`, Scouts
  `#E22E12`, Explorers `#088486`, Network `#000000`.
- **Photo-consent lint:** mandatory on every content type that may
  carry images of identifiable young people. SPEC-COMMON §10.
- **Licence header on new layouts:** SPEC-COMMON §16. Not optional.
- **Demo-roller `[demo]` blocks:** theme-repo only, in
  `exampleSite/content/events/*.md`. Group sites have no `[demo]`
  blocks. See DECISIONS.md §"Demo data".
- **`exampleSite/content/_index.md` adjacency rule:** the
  `where-we-meet` section-header acts as the title for the `embed`
  (map) section immediately following it — keep these two sections
  adjacent in the `[[sections]]` list. Don't insert news-grid,
  events-upcoming, etc. between them.
